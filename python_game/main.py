"""
Die Again: Troll Game Ever - Python Edition (Pygame-CE)
A hilarious 2D troll puzzle platformer inspired by Level Devil.
"""

import sys
import os
import json
import math
import random
import pygame

# Initialize pygame
pygame.init()
pygame.mixer.init()

# Constants
VIEW_W, VIEW_H = 800, 450
FPS = 60

# Physics constants
MOVE_SPEED = 240.0
JUMP_FORCE = 520.0
GRAVITY_ACCEL = 1350.0
MAX_FALL_SPEED = 750.0
NORMAL_FRICTION = 0.72
ICE_FRICTION = 0.985
AIR_FRICTION = 0.88


class SoundManager:
    def __init__(self, audio_dir):
        self.muted = False
        self.sounds = {}
        for name in ['jump', 'death', 'troll', 'trap', 'door', 'win']:
            path = os.path.join(audio_dir, f"{name}.wav")
            if os.path.exists(path):
                try:
                    self.sounds[name] = pygame.mixer.Sound(path)
                except Exception as e:
                    print(f"Error loading {path}: {e}")

    def play(self, name, volume=0.5):
        if not self.muted and name in self.sounds:
            snd = self.sounds[name]
            snd.set_volume(volume)
            snd.play()

    def toggle_mute(self):
        self.muted = not self.muted
        return self.muted


class FloatingText:
    def __init__(self, text, x, y, color=(255, 200, 40)):
        self.text = text
        self.x = x
        self.y = y
        self.color = color
        self.vy = -35.0
        self.lifetime = 1.8
        self.timer = 0.0

    def update(self, dt):
        self.y += self.vy * dt
        self.timer += dt
        return self.timer < self.lifetime

    def draw(self, surface, font, cam_offset):
        alpha = max(0, min(255, int(255 * (1.0 - (self.timer / self.lifetime)))))
        txt_surf = font.render(self.text, True, self.color)
        txt_surf.set_alpha(alpha)
        # Shadow
        shadow_surf = font.render(self.text, True, (0, 0, 0))
        shadow_surf.set_alpha(int(alpha * 0.7))
        rect = txt_surf.get_rect(center=(int(self.x + cam_offset[0]), int(self.y + cam_offset[1])))
        surface.blit(shadow_surf, (rect.x + 2, rect.y + 2))
        surface.blit(txt_surf, rect)


class Player:
    def __init__(self, x, y):
        self.w = 24
        self.h = 26
        self.x = float(x)
        self.y = float(y)
        self.vx = 0.0
        self.vy = 0.0
        self.is_grounded = False
        self.facing_dir = 1
        self.is_dead = False
        self.shocked_timer = 0.0
        self.coyote_timer = 0.0
        self.jump_buffer_timer = 0.0
        self.gravity_dir = 1  # 1 = normal down, -1 = up
        self.inverted_controls = False
        self.is_on_ice = False
        self.scale_x = 1.0
        self.scale_y = 1.0
        self.blink_timer = 2.0
        self.is_blinking = False
        # Abilities: Double Jump & Air Dash
        self.max_jumps = 2
        self.jumps_left = 2
        self.can_dash = True
        self.is_dashing = False
        self.dash_timer = 0.0
        self.dash_cooldown = 0.0
        self.ghost_trails = []

    @property
    def rect(self):
        return pygame.Rect(int(self.x), int(self.y), self.w, self.h)

    def respawn(self, x, y, gravity_dir=1):
        self.x = float(x)
        self.y = float(y)
        self.vx = 0.0
        self.vy = 0.0
        self.is_grounded = False
        self.facing_dir = 1
        self.is_dead = False
        self.shocked_timer = 0.0
        self.coyote_timer = 0.0
        self.jump_buffer_timer = 0.0
        self.gravity_dir = gravity_dir
        self.inverted_controls = False
        self.is_on_ice = False
        self.scale_x = 1.0
        self.scale_y = 1.0
        self.max_jumps = 2
        self.jumps_left = 2
        self.can_dash = True
        self.is_dashing = False
        self.dash_timer = 0.0
        self.dash_cooldown = 0.0
        self.ghost_trails.clear()

    def update(self, dt, input_left, input_right, jump_pressed, jump_released, dash_pressed, blocks, sounds):
        if self.is_dead:
            return False, False

        jumped = False
        landed = False

        # Timers
        if self.shocked_timer > 0:
            self.shocked_timer -= dt
        if self.coyote_timer > 0:
            self.coyote_timer -= dt
        if self.jump_buffer_timer > 0:
            self.jump_buffer_timer -= dt
        if self.dash_cooldown > 0:
            self.dash_cooldown -= dt

        self.blink_timer -= dt
        if self.blink_timer <= 0:
            if self.is_blinking:
                self.is_blinking = False
                self.blink_timer = random.uniform(2.0, 4.0)
            else:
                self.is_blinking = True
                self.blink_timer = 0.12

        # Inverted controls troll
        if self.inverted_controls:
            input_left, input_right = input_right, input_left

        # Dash Trigger
        if dash_pressed and self.can_dash and self.dash_cooldown <= 0 and not self.is_dashing:
            self.is_dashing = True
            self.dash_timer = 0.16
            self.dash_cooldown = 0.45
            self.can_dash = False
            self.scale_x = 1.5
            self.scale_y = 0.65
            self.vx = 540.0 * self.facing_dir
            self.vy = 0.0
            sounds.play('dash')

        if self.is_dashing:
            self.dash_timer -= dt
            self.vx = 540.0 * self.facing_dir
            self.vy = 0.0
            self.ghost_trails.append({
                'x': self.x, 'y': self.y, 'w': self.w, 'h': self.h,
                'alpha': 200, 'color': (60, 220, 255)
            })
            if self.dash_timer <= 0:
                self.is_dashing = False
                self.vx = MOVE_SPEED * self.facing_dir * 0.8
        else:
            # Horizontal movement
            target_vx = 0.0
            if input_left:
                target_vx -= MOVE_SPEED
                self.facing_dir = -1
            if input_right:
                target_vx += MOVE_SPEED
                self.facing_dir = 1

            friction = ICE_FRICTION if self.is_on_ice else (NORMAL_FRICTION if self.is_grounded else AIR_FRICTION)
            if target_vx != 0:
                accel = 0.08 if self.is_on_ice else 0.45
                self.vx += (target_vx - self.vx) * accel
            else:
                self.vx *= friction
                if abs(self.vx) < 2:
                    self.vx = 0

            if jump_pressed:
                self.jump_buffer_timer = 0.12

            # Jump & Double Jump
            can_jump = self.is_grounded or self.coyote_timer > 0
            if self.jump_buffer_timer > 0:
                if can_jump:
                    self.vy = -JUMP_FORCE * self.gravity_dir
                    self.is_grounded = False
                    self.coyote_timer = 0
                    self.jump_buffer_timer = 0
                    self.jumps_left = self.max_jumps - 1
                    self.scale_x = 0.75
                    self.scale_y = 1.35
                    sounds.play('jump')
                    jumped = True
                elif self.jumps_left > 0:
                    self.vy = -JUMP_FORCE * 0.95 * self.gravity_dir
                    self.jumps_left -= 1
                    self.jump_buffer_timer = 0
                    self.scale_x = 0.70
                    self.scale_y = 1.40
                    sounds.play('jump')
                    self.ghost_trails.append({
                        'x': self.x, 'y': self.y, 'w': self.w, 'h': self.h,
                        'alpha': 220, 'color': (255, 200, 40)
                    })
                    jumped = True

            # Variable jump cut
            if jump_released:
                if self.gravity_dir == 1 and self.vy < -150:
                    self.vy *= 0.45
                elif self.gravity_dir == -1 and self.vy > 150:
                    self.vy *= 0.45

            # Gravity
            self.vy += GRAVITY_ACCEL * self.gravity_dir * dt
            if self.gravity_dir == 1 and self.vy > MAX_FALL_SPEED:
                self.vy = MAX_FALL_SPEED
            elif self.gravity_dir == -1 and self.vy < -MAX_FALL_SPEED:
                self.vy = -MAX_FALL_SPEED

        # X collision
        self.x += self.vx * dt
        p_rect = self.rect
        for b in blocks:
            if b.type == 'fake' or (b.type == 'invisible' and not b.revealed):
                continue
            if p_rect.colliderect(b.rect):
                if self.vx > 0:
                    self.x = b.rect.left - self.w
                    self.vx = 0
                elif self.vx < 0:
                    self.x = b.rect.right
                    self.vx = 0
                p_rect = self.rect

        # Y collision
        was_grounded = self.is_grounded
        self.is_grounded = False
        self.x = round(self.x, 2)
        self.y += self.vy * dt
        p_rect = self.rect

        for b in blocks:
            if b.type == 'fake' or (b.type == 'invisible' and not b.revealed):
                continue
            if p_rect.colliderect(b.rect):
                if self.gravity_dir == 1:
                    if self.vy > 0:
                        self.y = b.rect.top - self.h
                        self.vy = 0
                        self.is_grounded = True
                        self.jumps_left = self.max_jumps
                        self.can_dash = True
                        self.coyote_timer = 0.10
                        if not was_grounded:
                            landed = True
                            self.scale_x = 1.25
                            self.scale_y = 0.75
                        if b.type == 'crumble' and not b.is_falling and b.shake_timer <= 0:
                            b.shake_timer = 0.35
                            sounds.play('trap')
                        elif b.type == 'bouncy':
                            self.vy = -JUMP_FORCE * 1.35
                            self.is_grounded = False
                            self.jumps_left = self.max_jumps
                            self.scale_x = 0.65
                            self.scale_y = 1.4
                            sounds.play('jump')
                    elif self.vy < 0:
                        self.y = b.rect.bottom
                        self.vy = 0
                else:
                    if self.vy < 0:
                        self.y = b.rect.bottom
                        self.vy = 0
                        self.is_grounded = True
                        self.jumps_left = self.max_jumps
                        self.can_dash = True
                        self.coyote_timer = 0.10
                        if not was_grounded:
                            landed = True
                            self.scale_x = 1.25
                            self.scale_y = 0.75
                        if b.type == 'crumble' and not b.is_falling and b.shake_timer <= 0:
                            b.shake_timer = 0.35
                            sounds.play('trap')
                    elif self.vy > 0:
                        self.y = b.rect.top - self.h
                        self.vy = 0
                p_rect = self.rect

        # Smooth scale return
        self.scale_x += (1.0 - self.scale_x) * min(1.0, dt * 10.0)
        self.scale_y += (1.0 - self.scale_y) * min(1.0, dt * 10.0)

        # Update ghost trails
        for gt in self.ghost_trails:
            gt['alpha'] -= dt * 650.0
        self.ghost_trails = [gt for gt in self.ghost_trails if gt['alpha'] > 0]

        return jumped, landed

    def draw(self, surface, cam_offset):
        if self.is_dead:
            return

        # Draw Ghost Trails
        for gt in self.ghost_trails:
            g_surf = pygame.Surface((int(gt['w']), int(gt['h'])), pygame.SRCALPHA)
            g_col = (*gt['color'], max(0, min(255, int(gt['alpha']))))
            pygame.draw.rect(g_surf, g_col, pygame.Rect(0, 0, int(gt['w']), int(gt['h'])), border_radius=4)
            surface.blit(g_surf, (int(gt['x'] + cam_offset[0]), int(gt['y'] + cam_offset[1])))

        cx = self.x + self.w / 2.0 + cam_offset[0]
        cy = self.y + self.h / 2.0 + cam_offset[1]
        hw = (self.w / 2.0) * self.scale_x
        hh = (self.h / 2.0) * self.scale_y

        body_rect = pygame.Rect(int(cx - hw), int(cy - hh), int(hw * 2), int(hh * 2))
        body_col = (100, 240, 255) if self.is_dashing else (250, 204, 21)
        border_col = (30, 160, 220) if self.is_dashing else (217, 165, 12)
        pygame.draw.rect(surface, body_col, body_rect, border_radius=4)
        pygame.draw.rect(surface, border_col, body_rect, width=2, border_radius=4)

        # Eyes
        eye_ox = cx + (4 * self.facing_dir)
        eye_y = cy - (3 if self.gravity_dir == 1 else -3)

        if self.shocked_timer > 0:
            # Shocked O_O expression!
            pygame.draw.circle(surface, (255, 255, 255), (int(eye_ox - 5), int(eye_y)), 5)
            pygame.draw.circle(surface, (255, 255, 255), (int(eye_ox + 5), int(eye_y)), 5)
            pygame.draw.circle(surface, (0, 0, 0), (int(eye_ox - 5 + self.facing_dir), int(eye_y)), 2)
            pygame.draw.circle(surface, (0, 0, 0), (int(eye_ox + 5 + self.facing_dir), int(eye_y)), 2)
            pygame.draw.circle(surface, (60, 20, 20), (int(eye_ox), int(eye_y + (5 * self.gravity_dir))), 3)
        elif self.is_blinking:
            # Blinking line eyes
            pygame.draw.line(surface, (0, 0, 0), (eye_ox - 6, eye_y), (eye_ox - 2, eye_y), 2)
            pygame.draw.line(surface, (0, 0, 0), (eye_ox + 2, eye_y), (eye_ox + 6, eye_y), 2)
        else:
            # Cute normal eyes
            pygame.draw.circle(surface, (255, 255, 255), (int(eye_ox - 4), int(eye_y)), 4)
            pygame.draw.circle(surface, (255, 255, 255), (int(eye_ox + 4), int(eye_y)), 4)
            pygame.draw.circle(surface, (0, 0, 0), (int(eye_ox - 4 + self.facing_dir * 1.5), int(eye_y)), 2)
            pygame.draw.circle(surface, (0, 0, 0), (int(eye_ox + 4 + self.facing_dir * 1.5), int(eye_y)), 2)


class Block:
    def __init__(self, data, theme):
        self.id = data.get('id', '')
        self.type = data.get('type', 'solid')
        self.x = float(data.get('x', 0))
        self.y = float(data.get('y', 0))
        self.w = float(data.get('w', 80))
        self.h = float(data.get('h', 40))
        self.initial_x = self.x
        self.initial_y = self.y
        self.vy = 0.0
        self.is_falling = False
        self.shake_timer = 0.0
        self.revealed = (self.type != 'invisible')
        self.base_color = self.parse_color(theme.get('blockBase', '#1f1035'))
        self.top_color = self.parse_color(theme.get('blockTop', '#c084fc'))

    def parse_color(self, hex_str):
        hex_str = hex_str.lstrip('#')
        if len(hex_str) == 6:
            return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))
        return (30, 20, 50)

    @property
    def rect(self):
        return pygame.Rect(int(self.x), int(self.y), int(self.w), int(self.h))

    def reset(self):
        self.x = self.initial_x
        self.y = self.initial_y
        self.vy = 0.0
        self.is_falling = False
        self.shake_timer = 0.0
        self.revealed = (self.type != 'invisible')

    def update(self, dt, player, sounds, cam):
        if self.shake_timer > 0:
            self.shake_timer -= dt
            self.x = self.initial_x
            if self.shake_timer <= 0:
                self.is_falling = True
                self.x = self.initial_x

        if self.is_falling and self.shake_timer <= 0:
            self.vy += 1200.0 * dt
            self.y += self.vy * dt

            # Squash check
            if not player.is_dead and self.vy > 100:
                if self.rect.colliderect(player.rect):
                    player.is_dead = True
                    sounds.play('death')
                    cam.shake(14.0)

    def draw(self, surface, cam_offset):
        if self.type == 'invisible' and not self.revealed:
            return
        rx = int(self.x + cam_offset[0])
        ry = int(self.y + cam_offset[1])
        r = pygame.Rect(rx, ry, int(self.w), int(self.h))

        if self.type == 'bouncy':
            pygame.draw.rect(surface, (15, 60, 90), r)
            pygame.draw.rect(surface, (50, 220, 240), r, 2)
            pygame.draw.line(surface, (50, 220, 240), (rx + 4, ry + 4), (rx + self.w - 4, ry + 4), 3)
        elif self.type == 'ice':
            pygame.draw.rect(surface, (40, 80, 120), r)
            pygame.draw.rect(surface, (160, 220, 255), r, 2)
            pygame.draw.line(surface, (200, 240, 255), (rx, ry + 2), (rx + self.w, ry + 2), 3)
        elif self.type == 'crumble':
            col = (230, 130, 50) if self.shake_timer > 0 else (180, 90, 30)
            pygame.draw.rect(surface, col, r)
            pygame.draw.rect(surface, (255, 160, 60), r, 1)
        else:
            pygame.draw.rect(surface, self.base_color, r)
            pygame.draw.rect(surface, self.top_color, r, 1)
            if self.h > 6:
                pygame.draw.rect(surface, self.top_color, pygame.Rect(rx, ry, int(self.w), 4))


class Spike:
    def __init__(self, data, theme):
        self.id = data.get('id', '')
        self.direction = data.get('direction', 'up')
        self.x = float(data.get('x', 0))
        self.y = float(data.get('y', 0))
        self.w = float(data.get('w', 24))
        self.h = float(data.get('h', 24))
        self.initial_x = self.x
        self.initial_y = self.y
        self.jumps_with_player = bool(data.get('jumpsWithPlayer', False))
        self.hidden = bool(data.get('hidden', False))
        self.is_moving = False
        self.vy = 0.0
        hex_col = theme.get('spikeColor', '#f43f5e').lstrip('#')
        self.color = tuple(int(hex_col[i:i+2], 16) for i in (0, 2, 4)) if len(hex_col) == 6 else (244, 63, 94)

    @property
    def fair_rect(self):
        inset_x = self.w * 0.2
        inset_y = self.h * 0.2
        return pygame.Rect(
            int(self.x + inset_x),
            int(self.y + (inset_y * 1.5 if self.direction == 'up' else 0)),
            int(self.w - inset_x * 2),
            int(self.h - inset_y * 1.5)
        )

    def reset(self):
        self.x = self.initial_x
        self.y = self.initial_y
        self.vy = 0.0
        self.is_moving = False

    def jump(self, force=480.0):
        self.is_moving = True
        self.vy = -force

    def pop_up(self, speed=-350.0):
        self.hidden = False
        self.is_moving = True
        self.vy = speed

    def update(self, dt):
        if self.is_moving:
            self.vy += 1100.0 * dt
            self.y += self.vy * dt
            if self.direction == 'up' and self.y >= self.initial_y:
                self.y = self.initial_y
                self.vy = 0.0
                self.is_moving = False

    def draw(self, surface, cam_offset):
        if self.hidden:
            return
        rx = self.x + cam_offset[0]
        ry = self.y + cam_offset[1]
        count = max(1, int(self.w / 24.0))
        step_w = self.w / float(count)

        for i in range(count):
            x0 = rx + i * step_w
            x1 = rx + (i + 1) * step_w
            xm = (x0 + x1) / 2.0
            if self.direction == 'up':
                pts = [(x0, ry + self.h), (xm, ry), (x1, ry + self.h)]
            elif self.direction == 'down':
                pts = [(x0, ry), (xm, ry + self.h), (x1, ry)]
            elif self.direction == 'left':
                pts = [(rx + self.w, ry), (rx, ry + self.h / 2.0), (rx + self.w, ry + self.h)]
            else:
                pts = [(rx, ry), (rx + self.w, ry + self.h / 2.0), (rx, ry + self.h)]

            pygame.draw.polygon(surface, self.color, pts)
            pygame.draw.polygon(surface, (255, 255, 255), pts, 1)


class Door:
    def __init__(self, data):
        self.x = float(data.get('x', 700))
        self.y = float(data.get('y', 336))
        self.w = float(data.get('w', 32))
        self.h = float(data.get('h', 44))
        self.initial_x = self.x
        self.initial_y = self.y
        self.is_fake = False
        self.is_fleeing = False
        self.target_x = 0.0
        self.flee_speed = 380.0
        self.is_rocket = False
        self.rocket_vy = 0.0
        self.rocket_target = None
        self.pulse = 0.0

    @property
    def rect(self):
        return pygame.Rect(int(self.x), int(self.y), int(self.w), int(self.h))

    def reset(self):
        self.x = self.initial_x
        self.y = self.initial_y
        self.is_fake = False
        self.fake_timer = 0.0
        self.is_fleeing = False
        self.is_rocket = False
        self.rocket_vy = 0.0

    def flee_to(self, target_x, speed=380.0):
        self.is_fleeing = True
        self.target_x = target_x
        self.flee_speed = speed

    def launch_rocket(self, new_x, new_y):
        self.is_rocket = True
        self.rocket_vy = -700.0
        self.rocket_target = (new_x, new_y)

    def reveal_fake(self, real_x, real_y):
        self.is_fake = True
        self.fake_timer = 0.8
        self.real_door_pos = (real_x, real_y)

    def update(self, dt, sounds):
        self.pulse += dt * 6.0
        if self.is_fake and hasattr(self, 'fake_timer') and self.fake_timer > 0:
            self.fake_timer -= dt
            if self.fake_timer <= 0:
                self.x = self.real_door_pos[0]
                self.y = self.real_door_pos[1]
                self.is_fake = False
                sounds.play('door')

        if self.is_fleeing:
            dx = self.target_x - self.x
            if abs(dx) > 4:
                self.x += math.copysign(min(abs(dx), self.flee_speed * dt), dx)
            else:
                self.is_fleeing = False

        if self.is_rocket:
            self.y += self.rocket_vy * dt
            if self.y < -100 and self.rocket_target:
                self.x = self.rocket_target[0]
                self.rocket_vy = 300.0
            if self.rocket_target and self.rocket_vy > 0 and self.y >= self.rocket_target[1]:
                self.y = self.rocket_target[1]
                self.is_rocket = False
                sounds.play('door')

    def draw(self, surface, cam_offset):
        rx = int(self.x + cam_offset[0])
        ry = int(self.y + cam_offset[1])
        r = pygame.Rect(rx, ry, int(self.w), int(self.h))

        # Frame
        frame_col = (255, 60, 60) if self.is_fake else (250, 204, 21)
        pygame.draw.rect(surface, frame_col, r, width=3, border_radius=3)
        inner_r = pygame.Rect(rx + 3, ry + 3, int(self.w - 6), int(self.h - 6))

        if self.is_fake:
            pygame.draw.line(surface, (255, 60, 60), (rx + 4, ry + 4), (rx + self.w - 4, ry + self.h - 4), 3)
            pygame.draw.line(surface, (255, 60, 60), (rx + self.w - 4, ry + 4), (rx + 4, ry + self.h - 4), 3)

        # Glowing swirl portal
        glow = 0.5 + 0.5 * math.sin(self.pulse)
        portal_col = (
            int(230 * (1 - glow) + 50 * glow),
            int(70 * (1 - glow) + 190 * glow),
            int(150 * (1 - glow) + 250 * glow)
        )
        pygame.draw.rect(surface, portal_col, inner_r, border_radius=2)
        cx, cy = rx + self.w / 2.0, ry + self.h / 2.0
        rr = int((self.w * 0.3) * (0.8 + 0.2 * math.sin(self.pulse * 1.3)))
        pygame.draw.circle(surface, (255, 255, 255), (int(cx), int(cy)), rr, 1)


class Camera:
    def __init__(self):
        self.offset = [0.0, 0.0]

    def shake(self, amount):
        # Vibration effect removed as requested
        pass

    def update(self, dt):
        self.offset = [0.0, 0.0]


class Game:
    def __init__(self):
        self.screen = pygame.display.set_mode((VIEW_W, VIEW_H), pygame.RESIZABLE | pygame.SCALED)
        pygame.display.set_caption("Die Again: Troll Game Ever")
        self.clock = pygame.time.Clock()
        self.font = pygame.font.SysFont("Courier New", 15, bold=True)
        self.title_font = pygame.font.SysFont("Arial", 16, bold=True)
        self.large_font = pygame.font.SysFont("Arial", 28, bold=True)

        base_dir = os.path.dirname(os.path.abspath(__file__))
        self.sounds = SoundManager(os.path.join(base_dir, 'audio'))
        self.camera = Camera()
        self.floating_texts = []

        # Load levels
        levels_path = os.path.join(base_dir, 'data', 'levels.json')
        with open(levels_path, 'r', encoding='utf-8') as f:
            self.levels_data = json.load(f)

        self.current_level_idx = 0
        self.deaths_count = 0
        self.show_hint = False
        self.show_level_select = False
        self.executed_triggers = set()
        self.respawn_timer = 0.0

        self.load_level(0)

    def load_level(self, idx):
        self.current_level_idx = max(0, min(len(self.levels_data) - 1, idx))
        self.lvl = self.levels_data[self.current_level_idx]
        theme = self.lvl.get('theme', {})

        sky_hex = theme.get('skyTop', '#0d091a').lstrip('#')
        self.sky_color = tuple(int(sky_hex[i:i+2], 16) for i in (0, 2, 4)) if len(sky_hex) == 6 else (13, 9, 26)

        pstart = self.lvl.get('playerStart', {'x': 70, 'y': 350})
        grav_dir = self.lvl.get('gravityDirection', 1)
        self.player = Player(pstart['x'], pstart['y'])
        self.player.gravity_dir = grav_dir
        self.player.is_on_ice = bool(self.lvl.get('icePhysics', False))

        self.blocks = [Block(b, theme) for b in self.lvl.get('blocks', [])]
        self.spikes = [Spike(s, theme) for s in self.lvl.get('spikes', [])]
        self.door = Door(self.lvl.get('door', {}))
        self.triggers = self.lvl.get('triggers', [])
        self.executed_triggers.clear()
        self.floating_texts.clear()
        self.respawn_timer = 0.0

    def restart_level(self):
        pstart = self.lvl.get('playerStart', {'x': 70, 'y': 350})
        grav_dir = self.lvl.get('gravityDirection', 1)
        self.player.respawn(pstart['x'], pstart['y'], grav_dir)
        self.player.is_on_ice = bool(self.lvl.get('icePhysics', False))
        for b in self.blocks:
            b.reset()
        for s in self.spikes:
            s.reset()
        self.door.reset()
        self.executed_triggers.clear()
        self.respawn_timer = 0.0

    def spawn_floating_text(self, text, x, y, color=(255, 200, 40)):
        self.floating_texts.append(FloatingText(text, x, y, color))

    def check_triggers(self, just_jumped):
        if self.player.is_dead:
            return

        for trig in self.triggers:
            tid = trig.get('id', '')
            if tid in self.executed_triggers:
                continue

            cond = trig.get('condition', '')
            params = trig.get('params', {})
            should_fire = False

            if cond == 'player_x_gt' and self.player.x > params.get('x', 0):
                should_fire = True
            elif cond == 'player_x_lt' and self.player.x < params.get('x', 0):
                should_fire = True
            elif cond == 'distance_to_door':
                dist = math.hypot((self.door.x + self.door.w/2) - (self.player.x + self.player.w/2),
                                  (self.door.y + self.door.h/2) - (self.player.y + self.player.h/2))
                if dist < params.get('distance', 100):
                    should_fire = True
            elif cond == 'player_jump' and just_jumped:
                min_x = params.get('minX')
                max_x = params.get('maxX')
                in_b = True
                if min_x is not None and self.player.x < min_x:
                    in_b = False
                if max_x is not None and self.player.x > max_x:
                    in_b = False
                if in_b:
                    should_fire = True

            if should_fire:
                self.executed_triggers.add(tid)
                self.execute_action(trig)

    def execute_action(self, trig):
        act = trig.get('action', '')
        p = trig.get('params', {})
        self.player.shocked_timer = 0.6

        if act == 'drop_blocks':
            bids = p.get('blockIds', [])
            delay = p.get('delay', 0.15)
            for b in self.blocks:
                if b.id in bids:
                    b.shake_timer = delay
            self.sounds.play('trap')
            self.camera.shake(6.0)

        elif act == 'raise_spikes':
            sids = p.get('spikeIds', [])
            speed = p.get('speed', -350.0)
            for s in self.spikes:
                if s.id in sids:
                    s.pop_up(speed)
            self.sounds.play('troll')
            self.camera.shake(8.0)

        elif act == 'flee_door':
            tx = p.get('targetX', self.door.x + 220)
            spd = p.get('speed', 380)
            msg = p.get('message', 'BYE! 💨')
            self.door.flee_to(tx, spd)
            self.sounds.play('troll')
            self.spawn_floating_text(msg, self.door.x, self.door.y - 20)

        elif act == 'jump_spikes':
            sids = p.get('spikeIds', [])
            force = p.get('force', 480)
            for s in self.spikes:
                if s.id in sids:
                    s.jump(force)
            self.sounds.play('jump')

        elif act == 'crush_ceiling':
            bids = p.get('blockIds', [])
            spd = p.get('speed', 500)
            for b in self.blocks:
                if b.id in bids:
                    b.is_falling = True
                    b.vy = spd
            self.sounds.play('trap')
            self.camera.shake(12.0)
            self.spawn_floating_text("CRUSH! 💥", self.player.x, self.player.y - 30, (255, 60, 60))

        elif act == 'flip_gravity':
            self.player.gravity_dir = -self.player.gravity_dir
            self.sounds.play('troll')
            self.camera.shake(10.0)
            self.spawn_floating_text("GRAVITY FLIPPED! 🙃", self.player.x, self.player.y - 30, (180, 100, 255))

        elif act == 'invert_controls':
            self.player.inverted_controls = not self.player.inverted_controls
            self.sounds.play('troll')
            self.camera.shake(8.0)
            self.spawn_floating_text("CONTROLS INVERTED! 🔄", self.player.x, self.player.y - 30, (255, 140, 40))

        elif act == 'fake_door_reveal':
            rx = p.get('realDoorX', self.door.x)
            ry = p.get('realDoorY', self.door.y)
            self.door.reveal_fake(rx, ry)
            self.sounds.play('troll')
            self.spawn_floating_text("SIKE! 😂", self.door.x, self.door.y - 25, (255, 60, 60))

        elif act == 'rocket_door':
            nx = p.get('newX', self.door.x)
            ny = p.get('newY', self.door.y)
            self.door.launch_rocket(nx, ny)
            self.sounds.play('troll')
            self.camera.shake(14.0)
            self.spawn_floating_text("TO THE MOON! 🚀", self.door.x, self.door.y - 20, (60, 200, 255))

        elif act == 'troll_message':
            self.sounds.play('troll')
            self.spawn_floating_text(p.get('text', 'LOL! 😈'), self.player.x, self.player.y - 30)

        elif act == 'shake_camera':
            self.camera.shake(p.get('intensity', 15.0))
            self.sounds.play('trap')

    def run(self):
        running = True
        while running:
            dt = min(0.05, self.clock.tick(FPS) / 1000.0)
            jump_pressed = False
            jump_released = False
            dash_pressed = False

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    if event.key in (pygame.K_SPACE, pygame.K_w, pygame.K_UP):
                        jump_pressed = True
                    elif event.key in (pygame.K_LSHIFT, pygame.K_RSHIFT, pygame.K_j):
                        dash_pressed = True
                    elif event.key == pygame.K_r:
                        self.restart_level()
                    elif event.key == pygame.K_h:
                        self.show_hint = not self.show_hint
                    elif event.key == pygame.K_m:
                        self.sounds.toggle_mute()
                    elif event.key == pygame.K_l:
                        self.show_level_select = not self.show_level_select
                    elif event.key == pygame.K_ESCAPE:
                        self.show_level_select = False
                elif event.type == pygame.KEYUP:
                    if event.key in (pygame.K_SPACE, pygame.K_w, pygame.K_UP):
                        jump_released = True
                elif event.type == pygame.MOUSEBUTTONDOWN and self.show_level_select:
                    mx, my = pygame.mouse.get_pos()
                    # Click inside level grid
                    cols = 16
                    btn_w, btn_h = 40, 28
                    start_x = 40
                    start_y = 70
                    for i in range(min(128, len(self.levels_data))):
                        bx = start_x + (i % cols) * (btn_w + 5)
                        by = start_y + (i // cols) * (btn_h + 5)
                        if pygame.Rect(bx, by, btn_w, btn_h).collidepoint(mx, my):
                            self.show_level_select = False
                            self.load_level(i)
                            break

            keys = pygame.key.get_pressed()
            in_left = keys[pygame.K_a] or keys[pygame.K_LEFT]
            in_right = keys[pygame.K_d] or keys[pygame.K_RIGHT]

            if not self.show_level_select:
                # Update player
                jumped, landed = self.player.update(
                    dt, in_left, in_right, jump_pressed, jump_released, dash_pressed, self.blocks, self.sounds
                )

                # Camera shake
                self.camera.update(dt)

                # Troll triggers
                self.check_triggers(jumped)

                # Update blocks & spikes & door
                for b in self.blocks:
                    b.update(dt, self.player, self.sounds, self.camera)
                for s in self.spikes:
                    s.update(dt)
                    if not self.player.is_dead and not s.hidden and self.player.rect.colliderect(s.fair_rect):
                        self.player.is_dead = True
                        self.sounds.play('death')
                        self.camera.shake(14.0)

                self.door.update(dt, self.sounds)

                # Check off-screen
                if not self.player.is_dead and (self.player.y > 520 or self.player.y < -150):
                    self.player.is_dead = True
                    self.sounds.play('death')
                    self.camera.shake(14.0)

                # Death handling
                if self.player.is_dead:
                    self.respawn_timer += dt
                    if self.respawn_timer >= 0.32:
                        self.deaths_count += 1
                        self.restart_level()

                # Win handling
                if not self.player.is_dead and self.player.rect.colliderect(self.door.rect):
                    if not self.door.is_fake and not self.door.is_fleeing:
                        self.sounds.play('win')
                        self.spawn_floating_text("LEVEL CLEAR! 🎉", self.door.x, self.door.y - 30, (50, 240, 100))
                        pygame.display.flip()
                        pygame.time.delay(600)
                        if self.current_level_idx + 1 < len(self.levels_data):
                            self.load_level(self.current_level_idx + 1)
                        else:
                            self.spawn_floating_text("YOU BEAT THE ENTIRE GAME! 🏆", 400, 200)

                # Floating texts
                self.floating_texts = [ft for ft in self.floating_texts if ft.update(dt)]

            # RENDER
            self.screen.fill(self.sky_color)

            # Draw level objects
            for b in self.blocks:
                b.draw(self.screen, self.camera.offset)
            for s in self.spikes:
                s.draw(self.screen, self.camera.offset)
            self.door.draw(self.screen, self.camera.offset)
            self.player.draw(self.screen, self.camera.offset)

            for ft in self.floating_texts:
                ft.draw(self.screen, self.font, self.camera.offset)

            # HUD
            title_str = f"{self.lvl.get('title', '')} — {self.lvl.get('subtitle', '')}"
            t_surf = self.title_font.render(title_str, True, (255, 255, 255))
            self.screen.blit(t_surf, (16, 12))

            d_surf = self.title_font.render(f"💀 {self.deaths_count}", True, (255, 100, 100))
            self.screen.blit(d_surf, (VIEW_W - 240, 12))

            help_surf = self.font.render("[Shift/J] Dash  [R]estart  [H]int  [L]evels", True, (180, 180, 200))
            self.screen.blit(help_surf, (VIEW_W - 320, 32))

            if self.show_hint:
                hint_str = self.lvl.get('hint', self.lvl.get('initialHint', 'No hint.'))
                h_box = pygame.Rect(50, 60, VIEW_W - 100, 48)
                pygame.draw.rect(self.screen, (20, 20, 35), h_box, border_radius=6)
                pygame.draw.rect(self.screen, (255, 200, 60), h_box, width=2, border_radius=6)
                h_surf = self.font.render(hint_str[:85], True, (255, 220, 100))
                self.screen.blit(h_surf, (60, 74))

            if self.show_level_select:
                overlay = pygame.Surface((VIEW_W, VIEW_H), pygame.SRCALPHA)
                overlay.fill((0, 0, 0, 220))
                self.screen.blit(overlay, (0, 0))

                head_surf = self.large_font.render("SELECT LEVEL", True, (255, 255, 255))
                self.screen.blit(head_surf, (VIEW_W // 2 - head_surf.get_width() // 2, 25))

                cols = 16
                btn_w, btn_h = 40, 28
                start_x = 40
                start_y = 70
                for i in range(min(128, len(self.levels_data))):
                    bx = start_x + (i % cols) * (btn_w + 5)
                    by = start_y + (i // cols) * (btn_h + 5)
                    r = pygame.Rect(bx, by, btn_w, btn_h)
                    col = (80, 160, 255) if i == self.current_level_idx else (40, 40, 60)
                    pygame.draw.rect(self.screen, col, r, border_radius=4)
                    num_surf = self.font.render(str(i + 1), True, (255, 255, 255))
                    self.screen.blit(num_surf, (bx + (btn_w - num_surf.get_width()) // 2, by + 6))

            pygame.display.flip()

        pygame.quit()
        sys.exit()


if __name__ == '__main__':
    game = Game()
    game.run()
