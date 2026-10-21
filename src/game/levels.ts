import type { LevelData, LevelTheme, Block, Spike, Door, TrollTrigger } from './types';

export const THEMES: Record<string, LevelTheme> = {
  cyber_neon: {
    name: "Cyber Neon",
    skyTop: "#0d091a",
    skyBottom: "#290c3d",
    gridColor: "rgba(236, 72, 153, 0.14)",
    blockBase: "#1f1035",
    blockTop: "#c084fc",
    spikeColor: "#f43f5e",
    spikeGlow: "#fb7185",
    doorFrame: "#facc15",
    doorPortalStart: "#ec4899",
    doorPortalEnd: "#38bdf8",
    ambientDustColor: "#c084fc"
  },
  sunset_inferno: {
    name: "Sunset Inferno",
    skyTop: "#1c070b",
    skyBottom: "#4a1208",
    gridColor: "rgba(249, 115, 22, 0.14)",
    blockBase: "#2e0f0c",
    blockTop: "#fb923c",
    spikeColor: "#ef4444",
    spikeGlow: "#f87171",
    doorFrame: "#fbbf24",
    doorPortalStart: "#f97316",
    doorPortalEnd: "#e11d48",
    ambientDustColor: "#fb923c"
  },
  emerald_matrix: {
    name: "Emerald Matrix",
    skyTop: "#011c15",
    skyBottom: "#04382b",
    gridColor: "rgba(16, 185, 129, 0.14)",
    blockBase: "#032e23",
    blockTop: "#34d399",
    spikeColor: "#f59e0b",
    spikeGlow: "#fde047",
    doorFrame: "#34d399",
    doorPortalStart: "#10b981",
    doorPortalEnd: "#06b6d4",
    ambientDustColor: "#34d399"
  },
  electric_ocean: {
    name: "Electric Ocean",
    skyTop: "#051f33",
    skyBottom: "#093856",
    gridColor: "rgba(56, 189, 248, 0.14)",
    blockBase: "#0b253d",
    blockTop: "#38bdf8",
    spikeColor: "#ec4899",
    spikeGlow: "#f472b6",
    doorFrame: "#38bdf8",
    doorPortalStart: "#0ea5e9",
    doorPortalEnd: "#a855f7",
    ambientDustColor: "#38bdf8"
  },
  candy_pop: {
    name: "Candy Pop",
    skyTop: "#1e092b",
    skyBottom: "#3f0d36",
    gridColor: "rgba(244, 63, 94, 0.14)",
    blockBase: "#2f0d36",
    blockTop: "#f472b6",
    spikeColor: "#fbbf24",
    spikeGlow: "#fde047",
    doorFrame: "#f43f5e",
    doorPortalStart: "#ec4899",
    doorPortalEnd: "#8b5cf6",
    ambientDustColor: "#f472b6"
  },
  toxic_wasteland: {
    name: "Toxic Wasteland",
    skyTop: "#081c0e",
    skyBottom: "#1f3b14",
    gridColor: "rgba(132, 204, 22, 0.14)",
    blockBase: "#14290e",
    blockTop: "#84cc16",
    spikeColor: "#a855f7",
    spikeGlow: "#c084fc",
    doorFrame: "#84cc16",
    doorPortalStart: "#a855f7",
    doorPortalEnd: "#22c55e",
    ambientDustColor: "#84cc16"
  },
  volcanic_core: {
    name: "Volcanic Core",
    skyTop: "#1a0404",
    skyBottom: "#3d0a0a",
    gridColor: "rgba(239, 68, 68, 0.14)",
    blockBase: "#2b0808",
    blockTop: "#ef4444",
    spikeColor: "#f97316",
    spikeGlow: "#fdba74",
    doorFrame: "#f97316",
    doorPortalStart: "#ef4444",
    doorPortalEnd: "#eab308",
    ambientDustColor: "#ef4444"
  },
  arctic_chill: {
    name: "Arctic Chill",
    skyTop: "#05131f",
    skyBottom: "#0b263b",
    gridColor: "rgba(103, 232, 249, 0.14)",
    blockBase: "#0c283d",
    blockTop: "#67e8f9",
    spikeColor: "#38bdf8",
    spikeGlow: "#bae6fd",
    doorFrame: "#67e8f9",
    doorPortalStart: "#0284c7",
    doorPortalEnd: "#e0f2fe",
    ambientDustColor: "#67e8f9"
  },
  royal_amethyst: {
    name: "Royal Amethyst",
    skyTop: "#130826",
    skyBottom: "#271147",
    gridColor: "rgba(192, 132, 252, 0.14)",
    blockBase: "#240f42",
    blockTop: "#a855f7",
    spikeColor: "#facc15",
    spikeGlow: "#fde047",
    doorFrame: "#facc15",
    doorPortalStart: "#9333ea",
    doorPortalEnd: "#fbbf24",
    ambientDustColor: "#c084fc"
  },
  blood_moon: {
    name: "Blood Moon",
    skyTop: "#120207",
    skyBottom: "#2e0613",
    gridColor: "rgba(244, 63, 94, 0.14)",
    blockBase: "#260611",
    blockTop: "#f472b6",
    spikeColor: "#fb7185",
    spikeGlow: "#fda4af",
    doorFrame: "#f43f5e",
    doorPortalStart: "#be123c",
    doorPortalEnd: "#fda4af",
    ambientDustColor: "#f43f5e"
  },
  kill_screen: {
    name: "8-Bit Glitch",
    skyTop: "#15001c",
    skyBottom: "#350033",
    gridColor: "rgba(255, 0, 128, 0.25)",
    blockBase: "#220025",
    blockTop: "#ff007f",
    spikeColor: "#00ffff",
    spikeGlow: "#70ffff",
    doorFrame: "#ffff00",
    doorPortalStart: "#ff0055",
    doorPortalEnd: "#00ffcc",
    ambientDustColor: "#ff00cc"
  }
};

export const THEME_LIST: LevelTheme[] = [
  THEMES.cyber_neon,
  THEMES.sunset_inferno,
  THEMES.emerald_matrix,
  THEMES.candy_pop,
  THEMES.electric_ocean,
  THEMES.toxic_wasteland,
  THEMES.volcanic_core,
  THEMES.arctic_chill,
  THEMES.royal_amethyst,
  THEMES.blood_moon
];

export const ENTRANCE_TEST_LEVEL: LevelData = {
  id: 0,
  title: "ENTRANCE TEST",
  subtitle: "Trial of Agony | 99.9% Fail",
  theme: {
    name: "Obsidian Trial",
    skyTop: "#0a0110",
    skyBottom: "#20032b",
    gridColor: "rgba(244, 63, 94, 0.16)",
    blockBase: "#14031a",
    blockTop: "#f43f5e",
    spikeColor: "#ef4444",
    spikeGlow: "#ff0055",
    doorFrame: "#fbbf24",
    doorPortalStart: "#f43f5e",
    doorPortalEnd: "#fbbf24",
    ambientDustColor: "#f43f5e"
  },
  width: 800,
  height: 450,
  playerStart: { x: 40, y: 350 },
  door: {
    x: 565,
    y: 336,
    w: 32,
    h: 44,
    initialX: 565,
    initialY: 336
  },
  blocks: [
    // 1. Starting platform
    { id: 'b0_start', type: 'solid', x: 0, y: 380, w: 140, h: 70, initialX: 0, initialY: 380 },
    // Invisible ceiling bonker over gap 1 (catches over-eager high hops)
    { id: 'b0_ceil_bonk', type: 'invisible', x: 145, y: 240, w: 45, h: 25, initialX: 145, initialY: 240 },
    // 2. Island 1 (solid tip + crumble trap)
    { id: 'b0_mid1_solid', type: 'solid', x: 200, y: 380, w: 35, h: 70, initialX: 200, initialY: 380 },
    { id: 'b0_mid1_crumb', type: 'crumble', x: 235, y: 380, w: 65, h: 70, initialX: 235, initialY: 380 },
    // 3. Island 2 (Guillotine & leaping spike corridor)
    { id: 'b0_mid2', type: 'solid', x: 360, y: 380, w: 130, h: 70, initialX: 360, initialY: 380 },
    { id: 'b0_crush', type: 'solid', x: 375, y: 110, w: 55, h: 50, initialX: 375, initialY: 110, color: '#e11d48' },
    // 4. Island 3 (The decoy door island)
    { id: 'b0_mid3', type: 'solid', x: 540, y: 380, w: 100, h: 70, initialX: 540, initialY: 380 },
    // 5. Final high pillar (True exit perch)
    { id: 'b0_pillar', type: 'solid', x: 710, y: 300, w: 80, h: 150, initialX: 710, initialY: 300 }
  ],
  spikes: [
    // Pit 1 spikes (gap 140..200)
    { id: 's0_pit1', direction: 'up', x: 158, y: 426, w: 24, h: 24, initialX: 158, initialY: 426 },
    // Pit 2 spikes (gap 300..360)
    { id: 's0_pit2', direction: 'up', x: 322, y: 426, w: 24, h: 24, initialX: 322, initialY: 426 },
    // Island 2 leaping spike
    { id: 's0_leap', direction: 'up', x: 440, y: 356, w: 24, h: 24, initialX: 440, initialY: 356, jumpsWithPlayer: true },
    // Pit 3 spikes (gap 490..540)
    { id: 's0_pit3', direction: 'up', x: 505, y: 426, w: 24, h: 24, initialX: 505, initialY: 426 },
    // Pit 4 spikes (gap 640..710)
    { id: 's0_pit4_1', direction: 'up', x: 652, y: 426, w: 24, h: 24, initialX: 652, initialY: 426 },
    { id: 's0_pit4_2', direction: 'up', x: 682, y: 426, w: 24, h: 24, initialX: 682, initialY: 426 }
  ],
  triggers: [
    // Guillotine ceiling drops when jumping in corridor
    {
      id: 't0_crush',
      condition: 'player_jump',
      action: 'crush_ceiling',
      params: { minX: 350, maxX: 430, blockIds: ['b0_crush'], speed: 650 }
    },
    // Leaping spike jumps when hopping near it
    {
      id: 't0_leap',
      condition: 'player_jump',
      action: 'jump_spikes',
      params: { minX: 390, maxX: 470, spikeIds: ['s0_leap'], force: 490 }
    },
    // Decoy door reveals sike and relocates to final pillar!
    {
      id: 't0_fake',
      condition: 'distance_to_door',
      action: 'fake_door_reveal',
      params: { distance: 80, realDoorX: 735, realDoorY: 256 }
    }
  ],
  gravityDirection: 1,
  icePhysics: false,
  darkRoom: false,
  initialHint: "ENTRANCE TEST: Prove you have what it takes to enter the 256 chambers.",
  hint: "Tactical Clue: Leap low over gap 1 to dodge the ceiling block, run quickly off the crumble floor, bait the leaping spike, beware the decoy door, and leap to the true pillar!"
};

const BASE_LEVELS: LevelData[] = [
  // LEVEL 1: First Steps
  {
    id: 1,
    title: "Level 1",
    subtitle: "Just a normal walk",
    theme: THEMES.cyber_neon,
    width: 800,
    height: 450,
    playerStart: { x: 70, y: 350 },
    door: {
      x: 700,
      y: 336,
      w: 32,
      h: 44,
      initialX: 700,
      initialY: 336
    },
    blocks: [
      { id: 'b_ground_left', type: 'solid', x: 0, y: 380, w: 550, h: 70, initialX: 0, initialY: 380 },
      { id: 'b_drop_1', type: 'solid', x: 550, y: 380, w: 90, h: 70, initialX: 550, initialY: 380 },
      { id: 'b_ground_door', type: 'solid', x: 640, y: 380, w: 160, h: 70, initialX: 640, initialY: 380 }
    ],
    spikes: [
      { id: 's_pit_1', direction: 'up', x: 560, y: 426, w: 24, h: 24, initialX: 560, initialY: 426 },
      { id: 's_pit_2', direction: 'up', x: 590, y: 426, w: 24, h: 24, initialX: 590, initialY: 426 },
      { id: 's_pit_3', direction: 'up', x: 615, y: 426, w: 24, h: 24, initialX: 615, initialY: 426 }
    ],
    triggers: [
      {
        id: 't_drop_floor',
        condition: 'player_x_gt',
        action: 'drop_blocks',
        params: { x: 480, blockIds: ['b_drop_1'], delay: 0.1 }
      }
    ],
    gravityDirection: 1,
    initialHint: "Walk right to enter the door",
    hint: "The ground right before the exit door drops as you cross x:480! Jump early from the left platform across the opening."
  },

  // LEVEL 2: Collapsing Bridge
  {
    id: 2,
    title: "Level 2",
    subtitle: "Don't look down",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 336,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 336
    },
    blocks: [
      { id: 'b2_left', type: 'solid', x: 0, y: 380, w: 160, h: 70, initialX: 0, initialY: 380 },
      { id: 'b2_c1', type: 'crumble', x: 190, y: 380, w: 80, h: 70, initialX: 190, initialY: 380 },
      { id: 'b2_c2', type: 'crumble', x: 300, y: 380, w: 80, h: 70, initialX: 300, initialY: 380 },
      { id: 'b2_c3', type: 'crumble', x: 410, y: 380, w: 80, h: 70, initialX: 410, initialY: 380 },
      { id: 'b2_c4', type: 'crumble', x: 520, y: 380, w: 80, h: 70, initialX: 520, initialY: 380 },
      { id: 'b2_right', type: 'solid', x: 630, y: 380, w: 170, h: 70, initialX: 630, initialY: 380 }
    ],
    spikes: [
      { id: 's2_1', direction: 'up', x: 190, y: 426, w: 24, h: 24, initialX: 190, initialY: 426 },
      { id: 's2_2', direction: 'up', x: 260, y: 426, w: 24, h: 24, initialX: 260, initialY: 426 },
      { id: 's2_3', direction: 'up', x: 340, y: 426, w: 24, h: 24, initialX: 340, initialY: 426 },
      { id: 's2_4', direction: 'up', x: 430, y: 426, w: 24, h: 24, initialX: 430, initialY: 426 },
      { id: 's2_5', direction: 'up', x: 520, y: 426, w: 24, h: 24, initialX: 520, initialY: 426 }
    ],
    triggers: [
      {
        id: 't2_collapse',
        condition: 'player_x_gt',
        action: 'drop_blocks',
        params: { x: 320, blockIds: ['b2_c2', 'b2_c3'], delay: 0.15 }
      }
    ],
    gravityDirection: 1,
    initialHint: "A stable bridge... or is it?",
    hint: "Every orange platform will crumble instantly upon touch. Keep sprinting and hop continuously across the bridge without stopping!"
  },

  // LEVEL 3: Jumping Spikes
  {
    id: 3,
    title: "Level 3",
    subtitle: "Copycats",
    width: 800,
    height: 450,
    playerStart: { x: 80, y: 350 },
    door: {
      x: 710,
      y: 336,
      w: 32,
      h: 44,
      initialX: 710,
      initialY: 336
    },
    blocks: [
      { id: 'b3_ground', type: 'solid', x: 0, y: 380, w: 800, h: 70, initialX: 0, initialY: 380 }
    ],
    spikes: [
      { id: 's3_1', direction: 'up', x: 380, y: 356, w: 24, h: 24, initialX: 380, initialY: 356, jumpsWithPlayer: true },
      { id: 's3_2', direction: 'up', x: 410, y: 356, w: 24, h: 24, initialX: 410, initialY: 356, jumpsWithPlayer: true },
      { id: 's3_3', direction: 'up', x: 440, y: 356, w: 24, h: 24, initialX: 440, initialY: 356, jumpsWithPlayer: true }
    ],
    triggers: [
      {
        id: 't3_jump',
        condition: 'player_jump',
        action: 'jump_spikes',
        params: { minX: 250, maxX: 500, spikeIds: ['s3_1', 's3_2', 's3_3'], force: 480 }
      }
    ],
    gravityDirection: 1,
    initialHint: "Jump over the spikes... if they let you",
    hint: "These spikes copy your jump! Bait them by jumping from far away (x:260), then walk underneath while they are up in the air!"
  },

  // LEVEL 4: Shy Door
  {
    id: 4,
    title: "Level 4",
    subtitle: "Where are you going?",
    width: 800,
    height: 450,
    playerStart: { x: 70, y: 350 },
    door: {
      x: 520,
      y: 336,
      w: 32,
      h: 44,
      initialX: 520,
      initialY: 336
    },
    blocks: [
      { id: 'b4_ground', type: 'solid', x: 0, y: 380, w: 800, h: 70, initialX: 0, initialY: 380 },
      { id: 'b4_wall_left', type: 'solid', x: 0, y: 0, w: 30, h: 380, initialX: 0, initialY: 0 },
      { id: 'b4_wall_right', type: 'solid', x: 770, y: 0, w: 30, h: 380, initialX: 770, initialY: 0 }
    ],
    spikes: [
      { id: 's4_1', direction: 'up', x: 300, y: 356, w: 24, h: 24, initialX: 300, initialY: 356 }
    ],
    triggers: [
      {
        id: 't4_flee1',
        condition: 'distance_to_door',
        action: 'flee_door',
        params: { distance: 130, targetX: 720, speed: 400, message: "NOPE! 🏃‍♂️" }
      },
      {
        id: 't4_flee2',
        condition: 'player_x_gt',
        action: 'flee_door',
        params: { x: 620, targetX: 100, speed: 450, message: "SIKE! 👋" }
      }
    ],
    gravityDirection: 1,
    initialHint: "The door is playing hard to get",
    hint: "The door flees right, and then runs all the way back to the left wall (x:100). Chase it right, then turn around to catch it on the left!"
  },

  // LEVEL 5: Ceiling Smash
  {
    id: 5,
    title: "Level 5",
    subtitle: "Watch your head",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 336,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 336
    },
    blocks: [
      { id: 'b5_ground', type: 'solid', x: 0, y: 380, w: 800, h: 70, initialX: 0, initialY: 380 },
      { id: 'b5_ceil_left', type: 'solid', x: 0, y: 0, w: 200, h: 60, initialX: 0, initialY: 0 },
      { id: 'b5_ceil_trap', type: 'solid', x: 220, y: 0, w: 360, h: 90, initialX: 220, initialY: 0 },
      { id: 'b5_ceil_right', type: 'solid', x: 600, y: 0, w: 200, h: 60, initialX: 600, initialY: 0 }
    ],
    spikes: [
      { id: 's5_down1', direction: 'down', x: 250, y: 90, w: 24, h: 24, initialX: 250, initialY: 90 },
      { id: 's5_down2', direction: 'down', x: 340, y: 90, w: 24, h: 24, initialX: 340, initialY: 90 },
      { id: 's5_down3', direction: 'down', x: 440, y: 90, w: 24, h: 24, initialX: 440, initialY: 90 }
    ],
    triggers: [
      {
        id: 't5_jump_crush',
        condition: 'player_jump',
        action: 'crush_ceiling',
        params: { minX: 200, maxX: 580, blockIds: ['b5_ceil_trap'], speed: 650 }
      }
    ],
    gravityDirection: 1,
    initialHint: "Maybe you shouldn't jump here...",
    hint: "DO NOT JUMP in the middle hallway! Jumping triggers the crushing ceiling to smash down. Simply walk on the floor to the exit."
  },

  // LEVEL 6: The Fake Exit
  {
    id: 6,
    title: "Level 6",
    subtitle: "Too good to be true",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 400,
      y: 336,
      w: 32,
      h: 44,
      initialX: 400,
      initialY: 336
    },
    blocks: [
      { id: 'b6_ground', type: 'solid', x: 0, y: 380, w: 800, h: 70, initialX: 0, initialY: 380 },
      { id: 'b6_high_plat', type: 'solid', x: 140, y: 300, w: 120, h: 24, initialX: 140, initialY: 300 }
    ],
    spikes: [],
    triggers: [
      {
        id: 't6_fake_door',
        condition: 'distance_to_door',
        action: 'fake_door_reveal',
        params: { distance: 45, realDoorX: 95, realDoorY: 176 }
      }
    ],
    gravityDirection: 1,
    initialHint: "That was easy... wait a minute",
    hint: "Jump right onto the raised ledge, then touch the center door. Return to the ledge and jump left into the real portal!"
  },

  // LEVEL 7: Upside Down
  {
    id: 7,
    title: "Level 7",
    subtitle: "Gravity has left the chat",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 70,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 70
    },
    blocks: [
      { id: 'b7_floor', type: 'solid', x: 0, y: 380, w: 800, h: 70, initialX: 0, initialY: 380 },
      { id: 'b7_ceil', type: 'solid', x: 0, y: 0, w: 800, h: 70, initialX: 0, initialY: 0 }
    ],
    spikes: [
      { id: 's7_c1', direction: 'down', x: 480, y: 70, w: 24, h: 24, initialX: 480, initialY: 70 },
      { id: 's7_c2', direction: 'down', x: 510, y: 70, w: 24, h: 24, initialX: 510, initialY: 70 }
    ],
    triggers: [
      {
        id: 't7_flip',
        condition: 'player_x_gt',
        action: 'flip_gravity',
        params: { x: 320 }
      }
    ],
    gravityDirection: 1,
    initialHint: "Keep your feet on the... ceiling?",
    hint: "Crossing x:320 flips gravity to the ceiling! Once on the ceiling, jump downwards to dodge the hanging spikes at x:480."
  },

  // LEVEL 8: Brain Glitch
  {
    id: 8,
    title: "Level 8",
    subtitle: "Brain lag",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 336,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 336
    },
    blocks: [
      { id: 'b8_ground_1', type: 'solid', x: 0, y: 380, w: 320, h: 70, initialX: 0, initialY: 380 },
      { id: 'b8_plat_mid', type: 'solid', x: 380, y: 340, w: 100, h: 30, initialX: 380, initialY: 340 },
      { id: 'b8_ground_2', type: 'solid', x: 540, y: 380, w: 260, h: 70, initialX: 540, initialY: 380 }
    ],
    spikes: [
      { id: 's8_1', direction: 'up', x: 320, y: 426, w: 24, h: 24, initialX: 320, initialY: 426 },
      { id: 's8_2', direction: 'up', x: 490, y: 426, w: 24, h: 24, initialX: 490, initialY: 426 }
    ],
    triggers: [
      {
        id: 't8_invert',
        condition: 'player_x_gt',
        action: 'invert_controls',
        params: { x: 280 }
      }
    ],
    gravityDirection: 1,
    initialHint: "Your keyboard might feel weird soon",
    hint: "At x:280, left & right arrow keys are flipped! Press LEFT to move right and safely leap across the middle stone island."
  },

  // LEVEL 9: Ghost Bridge
  {
    id: 9,
    title: "Level 9",
    subtitle: "Seeing is not believing",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 336,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 336
    },
    blocks: [
      { id: 'b9_start', type: 'solid', x: 0, y: 380, w: 180, h: 70, initialX: 0, initialY: 380 },
      { id: 'b9_fake', type: 'fake', x: 260, y: 360, w: 110, h: 25, initialX: 260, initialY: 360, color: '#334155' },
      { id: 'b9_invis1', type: 'invisible', x: 240, y: 395, w: 130, h: 25, initialX: 240, initialY: 395, visible: false },
      { id: 'b9_invis2', type: 'invisible', x: 420, y: 370, w: 130, h: 25, initialX: 420, initialY: 370, visible: false },
      { id: 'b9_end', type: 'solid', x: 620, y: 380, w: 180, h: 70, initialX: 620, initialY: 380 }
    ],
    spikes: [
      { id: 's9_1', direction: 'up', x: 190, y: 426, w: 24, h: 24, initialX: 190, initialY: 426 },
      { id: 's9_2', direction: 'up', x: 380, y: 426, w: 24, h: 24, initialX: 380, initialY: 426 },
      { id: 's9_3', direction: 'up', x: 560, y: 426, w: 24, h: 24, initialX: 560, initialY: 426 }
    ],
    triggers: [
      {
        id: 't9_hint',
        condition: 'player_x_gt',
        action: 'troll_message',
        params: { x: 140, text: "Trust the invisible path! 👻", color: '#38bdf8' }
      }
    ],
    gravityDirection: 1,
    initialHint: "The solid platform is a lie",
    hint: "The upper platform at x:260 is fake and you will fall through. Land directly onto the invisible ledge slightly lower down!"
  },

  // LEVEL 10: Rocket Door
  {
    id: 10,
    title: "Level 10",
    subtitle: "To infinity and beyond",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 700,
      y: 336,
      w: 32,
      h: 44,
      initialX: 700,
      initialY: 336
    },
    blocks: [
      { id: 'b10_ground', type: 'solid', x: 0, y: 380, w: 800, h: 70, initialX: 0, initialY: 380 },
      { id: 'b10_pillar', type: 'solid', x: 180, y: 260, w: 70, h: 120, initialX: 180, initialY: 260 }
    ],
    spikes: [
      { id: 's10_1', direction: 'up', x: 320, y: 356, w: 24, h: 24, initialX: 320, initialY: 356 },
      { id: 's10_2', direction: 'up', x: 450, y: 356, w: 24, h: 24, initialX: 450, initialY: 356 }
    ],
    triggers: [
      {
        id: 't10_rocket',
        condition: 'distance_to_door',
        action: 'rocket_door',
        params: { distance: 90, newX: 200, newY: 216 }
      }
    ],
    gravityDirection: 1,
    initialHint: "Reach the launchpad",
    hint: "Approaching the door launches it like a rocket. It lands on top of the left stone pillar at x:200. Jump on top of the pillar to enter!"
  },

  // LEVEL 11: Slippery Ice Rush
  {
    id: 11,
    title: "Level 11",
    subtitle: "Ice, ice, baby",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 336,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 336
    },
    blocks: [
      { id: 'b11_start', type: 'solid', x: 0, y: 380, w: 120, h: 70, initialX: 0, initialY: 380 },
      { id: 'b11_ice', type: 'ice', x: 120, y: 380, w: 560, h: 70, initialX: 120, initialY: 380, color: '#38bdf8' },
      { id: 'b11_end', type: 'solid', x: 680, y: 380, w: 120, h: 70, initialX: 680, initialY: 380 }
    ],
    spikes: [
      { id: 's11_pop', direction: 'up', x: 640, y: 356, w: 24, h: 24, initialX: 640, initialY: 356, hidden: true }
    ],
    triggers: [
      {
        id: 't11_spike_pop',
        condition: 'player_x_gt',
        action: 'raise_spikes',
        params: { x: 500, spikeIds: ['s11_pop'], speed: -450 }
      }
    ],
    gravityDirection: 1,
    icePhysics: true,
    initialHint: "Zero friction! Brake early!",
    hint: "You are on frictionless ice and a hidden spike will thrust upward at x:640. Jump before the end of the ice track to clear the pop-up spike!"
  },

  // LEVEL 12: Falling Stalactites
  {
    id: 12,
    title: "Level 12",
    subtitle: "Watch above",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 336,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 336
    },
    blocks: [
      { id: 'b12_ground', type: 'solid', x: 0, y: 380, w: 800, h: 70, initialX: 0, initialY: 380 },
      { id: 'b12_ceil', type: 'solid', x: 0, y: 0, w: 800, h: 50, initialX: 0, initialY: 0 },
      { id: 'b12_rock1', type: 'solid', x: 260, y: 50, w: 40, h: 40, initialX: 260, initialY: 50, color: '#64748b' },
      { id: 'b12_rock2', type: 'solid', x: 420, y: 50, w: 40, h: 40, initialX: 420, initialY: 50, color: '#64748b' },
      { id: 'b12_rock3', type: 'solid', x: 580, y: 50, w: 40, h: 40, initialX: 580, initialY: 50, color: '#64748b' }
    ],
    spikes: [],
    triggers: [
      {
        id: 't12_drop1',
        condition: 'player_x_gt',
        action: 'drop_blocks',
        params: { x: 210, blockIds: ['b12_rock1'], delay: 0.1 }
      },
      {
        id: 't12_drop2',
        condition: 'player_x_gt',
        action: 'drop_blocks',
        params: { x: 370, blockIds: ['b12_rock2'], delay: 0.1 }
      },
      {
        id: 't12_drop3',
        condition: 'player_x_gt',
        action: 'drop_blocks',
        params: { x: 530, blockIds: ['b12_rock3'], delay: 0.1 }
      }
    ],
    gravityDirection: 1,
    initialHint: "The ceiling is crumbling",
    hint: "Ceiling boulders fall at x:210, x:370, and x:530. Inch forward to trigger each drop, step back, and then walk past safely."
  },

  // LEVEL 13: Bouncy Trap
  {
    id: 13,
    title: "Level 13",
    subtitle: "High voltage trampoline",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 200,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 200
    },
    blocks: [
      { id: 'b13_start', type: 'solid', x: 0, y: 380, w: 160, h: 70, initialX: 0, initialY: 380 },
      { id: 'b13_bounce', type: 'bouncy', x: 260, y: 370, w: 80, h: 20, initialX: 260, initialY: 370, color: '#ec4899' },
      { id: 'b13_ceil', type: 'solid', x: 230, y: 0, w: 140, h: 50, initialX: 230, initialY: 0 },
      { id: 'b13_dest', type: 'solid', x: 660, y: 244, w: 140, h: 200, initialX: 660, initialY: 244 }
    ],
    spikes: [
      { id: 's13_c1', direction: 'down', x: 270, y: 50, w: 24, h: 24, initialX: 270, initialY: 50 },
      { id: 's13_c2', direction: 'down', x: 300, y: 50, w: 24, h: 24, initialX: 300, initialY: 50 }
    ],
    triggers: [
      {
        id: 't13_msg',
        condition: 'player_x_gt',
        action: 'troll_message',
        params: { x: 220, text: "Steer to the right! ↗️", color: '#ec4899' }
      }
    ],
    gravityDirection: 1,
    initialHint: "Air-strafe right after bouncing!",
    hint: "Ceiling spikes sit straight above the bouncy trampoline. The second you hit the trampoline, steer HARD RIGHT in mid-air toward the high ledge!"
  },

  // LEVEL 14: Dark Room Flashlight
  {
    id: 14,
    title: "Level 14",
    subtitle: "Lights out",
    width: 800,
    height: 450,
    playerStart: { x: 60, y: 350 },
    door: {
      x: 720,
      y: 336,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 336
    },
    blocks: [
      { id: 'b14_ground', type: 'solid', x: 0, y: 380, w: 800, h: 70, initialX: 0, initialY: 380 },
      { id: 'b14_step1', type: 'solid', x: 250, y: 320, w: 70, h: 60, initialX: 250, initialY: 320 },
      { id: 'b14_step2', type: 'solid', x: 450, y: 270, w: 70, h: 110, initialX: 450, initialY: 270 }
    ],
    spikes: [
      { id: 's14_1', direction: 'up', x: 340, y: 356, w: 24, h: 24, initialX: 340, initialY: 356 },
      { id: 's14_2', direction: 'up', x: 550, y: 356, w: 24, h: 24, initialX: 550, initialY: 356 }
    ],
    triggers: [
      {
        id: 't14_msg',
        condition: 'player_x_gt',
        action: 'troll_message',
        params: { x: 180, text: "Watch your step in the dark! 🔦", color: '#facc15' }
      }
    ],
    gravityDirection: 1,
    darkRoom: true,
    initialHint: "Use your flashlight carefully",
    hint: "In the dark, floor spikes lurk at x:340 and x:550. Jump onto the elevated platforms at x:250 and x:450 to pass over them safely."
  },

  // LEVEL 15: The Ultimate Troll Marathon
  {
    id: 15,
    title: "Level 15",
    subtitle: "The Final Gauntlet",
    width: 800,
    height: 450,
    playerStart: { x: 50, y: 350 },
    door: {
      x: 720,
      y: 336,
      w: 32,
      h: 44,
      initialX: 720,
      initialY: 336
    },
    blocks: [
      { id: 'b15_s1', type: 'solid', x: 0, y: 380, w: 140, h: 70, initialX: 0, initialY: 380 },
      { id: 'b15_drop1', type: 'solid', x: 140, y: 380, w: 80, h: 70, initialX: 140, initialY: 380 },
      { id: 'b15_s2', type: 'solid', x: 260, y: 380, w: 120, h: 70, initialX: 260, initialY: 380 },
      { id: 'b15_s3', type: 'solid', x: 420, y: 380, w: 160, h: 70, initialX: 420, initialY: 380 },
      { id: 'b15_ceil_trap', type: 'solid', x: 420, y: 0, w: 160, h: 80, initialX: 420, initialY: 0 },
      { id: 'b15_end', type: 'solid', x: 620, y: 380, w: 180, h: 70, initialX: 620, initialY: 380 }
    ],
    spikes: [
      { id: 's15_pit1', direction: 'up', x: 150, y: 426, w: 24, h: 24, initialX: 150, initialY: 426 },
      { id: 's15_jump', direction: 'up', x: 310, y: 356, w: 24, h: 24, initialX: 310, initialY: 356, jumpsWithPlayer: true },
      { id: 's15_pit2', direction: 'up', x: 590, y: 426, w: 24, h: 24, initialX: 590, initialY: 426 }
    ],
    triggers: [
      {
        id: 't15_drop',
        condition: 'player_x_gt',
        action: 'drop_blocks',
        params: { x: 100, blockIds: ['b15_drop1'], delay: 0.1 }
      },
      {
        id: 't15_jump',
        condition: 'player_jump',
        action: 'jump_spikes',
        params: { minX: 240, maxX: 380, spikeIds: ['s15_jump'], force: 460 }
      },
      {
        id: 't15_crush',
        condition: 'player_jump',
        action: 'crush_ceiling',
        params: { minX: 410, maxX: 560, blockIds: ['b15_ceil_trap'], speed: 600 }
      },
      {
        id: 't15_door',
        condition: 'distance_to_door',
        action: 'flee_door',
        params: { distance: 100, targetX: 750, speed: 200, message: "ONE LAST STEP! 🏆" }
      }
    ],
    gravityDirection: 1,
    initialHint: "Everything you've learned. Do not panic.",
    hint: "Jump early across the dropping ground, trigger the jumping spike by hopping in place, walk without jumping under the ceiling, and corner the door!"
  }
];

export function getDifficultyMultiplier(id: number): string {
  if (id === 1) return '1x';
  if (id === 2) return '10x';
  if (id === 3) return '100x';
  if (id === 4) return '1,000x';
  if (id === 5) return '10,000x';
  if (id === 6) return '100,000x';
  if (id === 7) return '1,000,000x';
  return `10^${id - 1}x`;
}

function createPRNG(seed: number) {
  let s = seed >>> 0;
  return {
    next(): number {
      s = (s * 1664525 + 1013904223) >>> 0;
      return s / 4294967296;
    },
    range(min: number, max: number): number {
      return min + this.next() * (max - min);
    },
    rangeInt(min: number, max: number): number {
      return Math.floor(this.range(min, max + 1));
    },
    choice<T>(items: T[]): T {
      return items[Math.floor(this.next() * items.length)];
    }
  };
}

const TITLE_PREFIXES = [
  "The Phantom", "Abyssal", "Quantum", "Hyper", "Vortex", "Shattered", "Glacial", "Infernal", "Subzero", "Titanium",
  "Fractured", "Binary", "Neural", "Cyber", "Spectral", "Cosmic", "Obsidian", "Echoing", "Galvanic", "Gravitational",
  "Labyrinth of", "Crystalline", "Velocity", "Temporal", "Shadow", "Magnetic", "Prismatic", "Oblivion", "Kinetic", "Apex"
];

const TITLE_NOUNS = [
  "Chasm", "Ascent", "Precipice", "Crucible", "Corridor", "Ledge", "Gauntlet", "Monolith", "Catapult", "Abyss",
  "Highway", "Pillars", "Skyway", "Terraces", "Vault", "Runway", "Domain", "Passage", "Horizon", "Bastion",
  "Spires", "Plateau", "Sanctum", "Nexus", "Circuit", "Threshold", "Trial", "Enigma", "Parallax", "Divide"
];

// Generates mathematically verified platform sequences where EVERY gap is between 38px and 75px
function generatePlatformChain(
  startX: number,
  endX: number,
  count: number,
  prng: ReturnType<typeof createPRNG>,
  yPattern: 'ascent' | 'descent' | 'waves' | 'flat' | 'random',
  groundY: number = 380
): Array<{ x: number; y: number; w: number; h: number }> {
  const totalSpan = endX - startX;
  const numGaps = count + 1;
  const gaps: number[] = [];
  let gapSum = 0;
  for (let i = 0; i < numGaps; i++) {
    const g = prng.rangeInt(42, 65);
    gaps.push(g);
    gapSum += g;
  }

  let remainingW = totalSpan - gapSum;
  const rawW = Math.floor(remainingW / count);
  const widths: number[] = [];
  for (let i = 0; i < count; i++) {
    const variance = prng.rangeInt(-5, 5);
    const w = Math.max(55, rawW + variance);
    widths.push(w);
  }
  const currentTotal = widths.reduce((a, b) => a + b, 0) + gaps.reduce((a, b) => a + b, 0);
  const diff = totalSpan - currentTotal;
  gaps[numGaps - 1] += diff;

  if (gaps[numGaps - 1] > 75) {
    const excess = gaps[numGaps - 1] - 65;
    widths[count - 1] += excess;
    gaps[numGaps - 1] = 65;
  } else if (gaps[numGaps - 1] < 38) {
    const deficit = 42 - gaps[numGaps - 1];
    widths[count - 1] -= deficit;
    gaps[numGaps - 1] = 42;
  }

  // Determine heights with guaranteed safety clamping [260, 380]
  const heights: number[] = [];
  if (yPattern === 'flat') {
    for (let i = 0; i < count; i++) heights.push(groundY);
  } else if (yPattern === 'ascent') {
    let curY = groundY;
    for (let i = 0; i < count; i++) {
      curY -= prng.rangeInt(24, 34);
      heights.push(Math.max(260, curY));
    }
  } else if (yPattern === 'descent') {
    let curY = groundY - 26 * count;
    for (let i = 0; i < count; i++) {
      curY += prng.rangeInt(22, 30);
      heights.push(Math.min(380, Math.max(260, curY)));
    }
  } else if (yPattern === 'waves') {
    for (let i = 0; i < count; i++) {
      heights.push(i % 2 === 0 ? groundY - prng.rangeInt(40, 52) : groundY - prng.rangeInt(10, 20));
    }
  } else {
    // random
    let prevY = groundY - 20;
    for (let i = 0; i < count; i++) {
      const step = prng.rangeInt(-25, 25);
      const newY = Math.max(270, Math.min(380, prevY + step));
      heights.push(newY);
      prevY = newY;
    }
  }

  const result: Array<{ x: number; y: number; w: number; h: number }> = [];
  let curX = startX;
  for (let i = 0; i < count; i++) {
    curX += gaps[i];
    result.push({
      x: curX,
      y: heights[i],
      w: widths[i],
      h: 25
    });
    curX += widths[i];
  }

  return result;
}

export function generateProceduralLevel(id: number): LevelData {
  if (id === 256) {
    // Grand Finale Kill Screen
    const groundY = 380;
    const blocks: Block[] = [
      { id: `b256_start`, type: 'solid', x: 0, y: groundY, w: 130, h: 70, initialX: 0, initialY: groundY },
      { id: `b256_floor1`, type: 'crumble', x: 170, y: 360, w: 75, h: 25, initialX: 170, initialY: 360 },
      { id: `b256_floor2`, type: 'ice', x: 285, y: 335, w: 75, h: 25, initialX: 285, initialY: 335 },
      { id: `b256_floor3`, type: 'invisible', x: 400, y: 310, w: 75, h: 25, initialX: 400, initialY: 310 },
      { id: `b256_floor4`, type: 'crumble', x: 515, y: 330, w: 75, h: 25, initialX: 515, initialY: 330 },
      { id: `b256_end`, type: 'solid', x: 670, y: groundY, w: 130, h: 70, initialX: 670, initialY: groundY },
      { id: `b256_ceil`, type: 'solid', x: 310, y: -20, w: 180, h: 100, initialX: 310, initialY: -20 }
    ];
    const spikes: Spike[] = [
      { id: `s256_boss1`, direction: 'up', x: 305, y: 311, w: 24, h: 24, initialX: 305, initialY: 311, jumpsWithPlayer: true },
      { id: `s256_boss2`, direction: 'up', x: 535, y: 306, w: 24, h: 24, initialX: 535, initialY: 306, jumpsWithPlayer: true },
      { id: `s256_pit1`, direction: 'up', x: 230, y: 426, w: 24, h: 24, initialX: 230, initialY: 426 },
      { id: `s256_pit2`, direction: 'up', x: 360, y: 426, w: 24, h: 24, initialX: 360, initialY: 426 },
      { id: `s256_pit3`, direction: 'up', x: 610, y: 426, w: 24, h: 24, initialX: 610, initialY: 426 }
    ];
    const triggers: TrollTrigger[] = [
      { id: `t256_crush`, condition: 'player_x_gt', action: 'crush_ceiling', params: { x: 270, blockIds: [`b256_ceil`], speed: 999 } },
      { id: `t256_ctrl`, condition: 'player_x_gt', action: 'invert_controls', params: { x: 320, duration: 6, message: "SYSTEM GLITCH: CONTROLS FLIPPED! ⚠️" } },
      { id: `t256_door`, condition: 'distance_to_door', action: 'flee_door', params: { distance: 110, targetX: 750, speed: 450, message: "FINAL TROLL! 🏆" } }
    ];
    const door: Door = { x: 700, y: 336, w: 32, h: 44, initialX: 700, initialY: 336 };
    return {
      id: 256,
      title: "Level 256",
      subtitle: "THE 8-BIT OVERFLOW KILL SCREEN | 10^255x Harder",
      theme: THEMES.kill_screen,
      width: 800,
      height: 450,
      playerStart: { x: 50, y: 350 },
      door,
      blocks,
      spikes,
      triggers,
      gravityDirection: 1,
      initialHint: "THE FINAL 256th TRIAL. ONLY FOR INTELIGENT PERSON.",
      hint: "GRAND 256th TRIAL CLUE: Controls invert at x:320, ceiling slams at 999px/s, and the door flees! Sprint across the crumble, land on the invisible platform at x:400, reverse your inputs instantly, and chase the door into the exit portal!"
    };
  }

  const prng = createPRNG(id * 10007 + 7919);
  const mult = getDifficultyMultiplier(id);

  // Unique theme and title
  const theme = THEME_LIST[(id + prng.rangeInt(0, 4)) % THEME_LIST.length];
  const pIdx = (id - 16 + prng.rangeInt(0, TITLE_PREFIXES.length - 1)) % TITLE_PREFIXES.length;
  const nIdx = (Math.floor((id - 16) / TITLE_PREFIXES.length) + pIdx + prng.rangeInt(1, 5)) % TITLE_NOUNS.length;
  const titleName = `${TITLE_PREFIXES[pIdx]} ${TITLE_NOUNS[nIdx]}`;
  const subtitle = `${titleName} | ${mult} Harder`;

  // Difficulty scaling factors
  const trapDelay = Math.max(0.12, +(0.28 * Math.pow(0.985, id - 15)).toFixed(3));
  const crushSpeed = Math.min(950, Math.round(500 + (id - 15) * 1.8 + prng.range(-20, 20)));
  const spikeJumpForce = Math.min(560, Math.round(440 + (id - 15) * 0.5 + prng.range(-15, 15)));
  const doorFleeSpeed = Math.min(480, Math.round(260 + (id - 15) * 0.9 + prng.range(-15, 15)));

  // 20 distinct topological families
  const family = (id - 16) % 20;
  const isGravityInverted = family === 4;
  const isIce = family === 5 || (id % 11 === 0);
  const isDark = id % 17 === 0;

  const width = 800;
  const height = 450;
  const groundY = 380;
  const playerStartY = isGravityInverted ? 100 : 350;

  const blocks: Block[] = [];
  const spikes: Spike[] = [];
  const triggers: TrollTrigger[] = [];
  let hintText = "";

  // Common pit spikes generator
  const addPitSpikes = (gapStarts: number[], gapEnds: number[]) => {
    for (let i = 0; i < gapStarts.length; i++) {
      const gStart = gapStarts[i];
      const gEnd = gapEnds[i];
      if (gEnd - gStart >= 40) {
        const mid = (gStart + gEnd) / 2;
        spikes.push({
          id: `s${id}_pit_${i}`,
          direction: 'up',
          x: Math.round(mid - 12),
          y: 426,
          w: 24,
          h: 24,
          initialX: Math.round(mid - 12),
          initialY: 426
        });
      }
    }
  };

  // Base starting platform
  const startW = prng.rangeInt(115, 135);
  blocks.push({
    id: `b${id}_start`,
    type: 'solid',
    x: 0,
    y: isGravityInverted ? 0 : groundY,
    w: startW,
    h: 70,
    initialX: 0,
    initialY: isGravityInverted ? 0 : groundY
  });

  // End goal platform (default)
  const endW = prng.rangeInt(115, 135);
  const endX = 800 - endW;
  let endY = isGravityInverted ? 0 : groundY;

  let doorX = endX + prng.rangeInt(30, 45);
  let doorY = isGravityInverted ? 70 : endY - 44;

  switch (family) {
    case 0: { // Staircase Ascent
      const stepCount = prng.rangeInt(3, 4);
      const chain = generatePlatformChain(startW, endX, stepCount, prng, 'ascent', groundY);
      const gaps: number[] = [startW];
      const gapEnds: number[] = [chain[0].x];

      for (let s = 0; s < chain.length; s++) {
        const p = chain[s];
        const bType: BlockType = s === 1 && prng.next() > 0.5 ? 'crumble' : 'solid';
        blocks.push({
          id: `b${id}_step_${s}`,
          type: bType,
          x: p.x,
          y: p.y,
          w: p.w,
          h: 25,
          initialX: p.x,
          initialY: p.y
        });
        if (s < chain.length - 1) {
          gaps.push(p.x + p.w);
          gapEnds.push(chain[s + 1].x);
        }
      }
      gaps.push(chain[chain.length - 1].x + chain[chain.length - 1].w);
      gapEnds.push(endX);

      // Final step to end platform
      endY = chain[chain.length - 1].y;
      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: endY,
        w: endW,
        h: groundY + 70 - endY,
        initialX: endX,
        initialY: endY
      });
      doorY = endY - 44;

      addPitSpikes(gaps, gapEnds);

      // Hazard: jumping spike on penultimate step
      const midStep = blocks[Math.floor(stepCount / 2)];
      spikes.push({
        id: `s${id}_asc_spk`,
        direction: 'up',
        x: midStep.x + Math.round(midStep.w / 2) - 12,
        y: midStep.y - 24,
        w: 24,
        h: 24,
        initialX: midStep.x + Math.round(midStep.w / 2) - 12,
        initialY: midStep.y - 24
      });
      triggers.push({
        id: `t${id}_asc_jump`,
        condition: 'player_jump',
        action: 'jump_spikes',
        params: { minX: midStep.x - 70, maxX: midStep.x + 10, spikeIds: [`s${id}_asc_spk`], force: spikeJumpForce }
      });

      hintText = `Tactical Clue: Ascend the rising terrace steps carefully. Bait the leaping spike on the middle ledge at x:${midStep.x} by jumping from a distance before leaping across.`;
      break;
    }

    case 1: { // Canyon Descent and Climb
      const chain = generatePlatformChain(startW, endX, 3, prng, 'descent', groundY);
      for (let i = 0; i < chain.length; i++) {
        const p = chain[i];
        blocks.push({
          id: `b${id}_c_${i}`,
          type: 'solid',
          x: p.x,
          y: p.y,
          w: p.w,
          h: 25,
          initialX: p.x,
          initialY: p.y
        });
      }
      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: groundY,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: groundY
      });

      // Falling stalactite over center
      const midP = chain[1];
      blocks.push({
        id: `b${id}_stala`,
        type: 'solid',
        x: midP.x + 15,
        y: 40,
        w: 45,
        h: 45,
        initialX: midP.x + 15,
        initialY: 40,
        color: '#64748b'
      });
      triggers.push({
        id: `t${id}_stala_trig`,
        condition: 'player_x_gt',
        action: 'drop_blocks',
        params: { x: chain[0].x + 20, blockIds: [`b${id}_stala`], delay: 0.08 }
      });

      addPitSpikes(
        [startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w, chain[2].x + chain[2].w],
        [chain[0].x, chain[1].x, chain[2].x, endX]
      );
      hintText = `Tactical Clue: Descend into the canyon island at x:${midP.x}. Watch the ceiling! A loose stalactite drops when you reach x:${chain[0].x + 20}. Bait it to fall first.`;
      break;
    }

    case 2: { // Floating Stepping Islands
      const islandCount = prng.rangeInt(3, 4);
      const chain = generatePlatformChain(startW, endX, islandCount, prng, 'random', groundY);
      const gaps: number[] = [startW];
      const gapEnds: number[] = [chain[0].x];

      for (let i = 0; i < islandCount; i++) {
        const p = chain[i];
        const bType: BlockType = i === 1 ? 'ice' : (i === 2 && prng.next() > 0.4 ? 'crumble' : 'solid');
        blocks.push({
          id: `b${id}_isl_${i}`,
          type: bType,
          x: p.x,
          y: p.y,
          w: p.w,
          h: 25,
          initialX: p.x,
          initialY: p.y
        });
        if (i < islandCount - 1) {
          gaps.push(p.x + p.w);
          gapEnds.push(chain[i + 1].x);
        }
      }
      gaps.push(chain[islandCount - 1].x + chain[islandCount - 1].w);
      gapEnds.push(endX);

      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: groundY,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: groundY
      });
      addPitSpikes(gaps, gapEnds);

      // Inverted controls trigger on 2nd island
      const triggerIsl = blocks[2];
      triggers.push({
        id: `t${id}_ctrl_flip`,
        condition: 'player_x_gt',
        action: 'invert_controls',
        params: { x: triggerIsl.x + 10, duration: 4.2, message: "MIND GLITCH: CONTROLS REVERSED! 🔄" }
      });

      hintText = `Tactical Clue: Stepping stones across the void! Stepping past x:${triggerIsl.x + 10} temporarily reverses steering. Be ready to press LEFT to move right!`;
      break;
    }

    case 3: { // Undulating Waves
      const chain = generatePlatformChain(startW, endX, 3, prng, 'waves', groundY);
      for (let i = 0; i < chain.length; i++) {
        const p = chain[i];
        blocks.push({
          id: `b${id}_w_${i}`,
          type: 'solid',
          x: p.x,
          y: p.y,
          w: p.w,
          h: 25,
          initialX: p.x,
          initialY: p.y
        });
      }
      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: groundY,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: groundY
      });

      // Spikes on the low trough platform
      const lowP = chain[1];
      spikes.push({
        id: `s${id}_w_spk`,
        direction: 'up',
        x: lowP.x + Math.round(lowP.w / 2) - 12,
        y: lowP.y - 24,
        w: 24,
        h: 24,
        initialX: lowP.x + Math.round(lowP.w / 2) - 12,
        initialY: lowP.y - 24
      });

      addPitSpikes(
        [startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w, chain[2].x + chain[2].w],
        [chain[0].x, chain[1].x, chain[2].x, endX]
      );
      hintText = `Tactical Clue: Wave hopping! Leap from the high ledge at x:${chain[0].x} cleanly over the spike in the middle of the low platform at x:${lowP.x}.`;
      break;
    }

    case 4: { // Anti-Gravity Ceiling Run
      const chain = generatePlatformChain(startW, endX, 3, prng, 'flat', 0);
      for (let c = 0; c < chain.length; c++) {
        const p = chain[c];
        blocks.push({
          id: `b${id}_ceil_${c}`,
          type: 'solid',
          x: p.x,
          y: 0,
          w: p.w,
          h: 70,
          initialX: p.x,
          initialY: 0
        });

        // Downward hanging spike
        if (c === 1) {
          spikes.push({
            id: `s${id}_cg_spk_${c}`,
            direction: 'down',
            x: p.x + Math.round(p.w / 2) - 12,
            y: 70,
            w: 24,
            h: 24,
            initialX: p.x + Math.round(p.w / 2) - 12,
            initialY: 70
          });
        }
      }

      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: 0,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: 0
      });
      doorY = 70;

      hintText = `Tactical Clue: Gravity is completely inverted! You run upside-down along the ceiling. Use short downward hops to clear the downward hanging spikes.`;
      break;
    }

    case 5: { // Ice Runway & Popup Spike
      const chain = generatePlatformChain(startW, endX, 2, prng, 'flat', groundY);
      const runway = chain[0];
      const landing = chain[1];

      blocks.push(
        { id: `b${id}_ice_main`, type: 'ice', x: runway.x, y: groundY, w: runway.w, h: 70, initialX: runway.x, initialY: groundY },
        { id: `b${id}_ice_land`, type: 'ice', x: landing.x, y: groundY, w: landing.w, h: 70, initialX: landing.x, initialY: groundY },
        { id: `b${id}_end`, type: 'solid', x: endX, y: groundY, w: endW, h: 70, initialX: endX, initialY: groundY }
      );

      const popupSpkX = runway.x + runway.w - 35;
      const trigX = runway.x + 30;

      spikes.push({
        id: `s${id}_ice_pop`,
        direction: 'up',
        x: popupSpkX,
        y: groundY - 24,
        w: 24,
        h: 24,
        initialX: popupSpkX,
        initialY: groundY - 24,
        hidden: true
      });

      triggers.push({
        id: `t${id}_ice_popup`,
        condition: 'player_x_gt',
        action: 'raise_spikes',
        params: { x: trigX, spikeIds: [`s${id}_ice_pop`] }
      });

      addPitSpikes([startW, runway.x + runway.w, landing.x + landing.w], [runway.x, landing.x, endX]);
      hintText = `Tactical Clue: High-speed icy slide! A popup spike emerges at x:${popupSpkX} when you cross x:${trigX}. Jump early while sliding to clear it.`;
      break;
    }

    case 6: { // Invisible Skyway
      const chain = generatePlatformChain(startW, endX, 3, prng, 'random', groundY);
      const coords: number[] = [];

      for (let i = 0; i < chain.length; i++) {
        const p = chain[i];
        coords.push(p.x);
        blocks.push({
          id: `b${id}_inv_${i}`,
          type: 'invisible',
          x: p.x,
          y: p.y,
          w: p.w,
          h: 25,
          initialX: p.x,
          initialY: p.y
        });
      }

      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: groundY,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: groundY
      });

      addPitSpikes(
        [startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w, chain[2].x + chain[2].w],
        [chain[0].x, chain[1].x, chain[2].x, endX]
      );
      hintText = `Tactical Clue: The chasm is bridged by invisible stepping stones at x:[${coords.join(', ')}]. Trust your leaps and hop firmly across!`;
      break;
    }

    case 7: { // Crumble Sprint
      const chain = generatePlatformChain(startW, endX, 4, prng, 'random', groundY);
      const gaps: number[] = [startW];
      const gapEnds: number[] = [chain[0].x];

      for (let i = 0; i < chain.length; i++) {
        const p = chain[i];
        blocks.push({
          id: `b${id}_crm_${i}`,
          type: 'crumble',
          x: p.x,
          y: p.y,
          w: p.w,
          h: 25,
          initialX: p.x,
          initialY: p.y
        });
        if (i < chain.length - 1) {
          gaps.push(p.x + p.w);
          gapEnds.push(chain[i + 1].x);
        }
      }
      gaps.push(chain[chain.length - 1].x + chain[chain.length - 1].w);
      gapEnds.push(endX);

      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: groundY,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: groundY
      });
      addPitSpikes(gaps, gapEnds);

      hintText = `Tactical Clue: Rapid collapse gauntlet! Every platform crumbles under your feet within ${trapDelay}s. Full forward sprint with uninterrupted hops!`;
      break;
    }

    case 8: { // Trampoline Catapult
      // Start ground -> Trampoline -> High Ledge -> Step 1 -> Step 2 -> End Ground
      const trampX = startW + 40;
      const trampW = 75;
      const highX = trampX + trampW + 55;
      const highW = 100;
      const highY = 245;

      const step1X = highX + highW + 45;
      const step1W = 80;
      const step1Y = 300;

      const step2X = step1X + step1W + 45;
      const step2W = endX - step2X - 50;
      const step2Y = 345;

      blocks.push(
        { id: `b${id}_trampoline`, type: 'bouncy', x: trampX, y: 370, w: trampW, h: 20, initialX: trampX, initialY: 370, color: '#ec4899' },
        { id: `b${id}_t_ceil`, type: 'solid', x: trampX - 20, y: 0, w: trampW + 30, h: 50, initialX: trampX - 20, initialY: 0 },
        { id: `b${id}_high`, type: 'solid', x: highX, y: highY, w: highW, h: 25, initialX: highX, initialY: highY },
        { id: `b${id}_step1`, type: 'solid', x: step1X, y: step1Y, w: step1W, h: 25, initialX: step1X, initialY: step1Y },
        { id: `b${id}_step2`, type: 'solid', x: step2X, y: step2Y, w: step2W, h: 25, initialX: step2X, initialY: step2Y },
        { id: `b${id}_end`, type: 'solid', x: endX, y: groundY, w: endW, h: 70, initialX: endX, initialY: groundY }
      );

      spikes.push({
        id: `s${id}_t_spk`,
        direction: 'down',
        x: trampX + Math.round(trampW / 2) - 12,
        y: 50,
        w: 24,
        h: 24,
        initialX: trampX + Math.round(trampW / 2) - 12,
        initialY: 50
      });

      addPitSpikes([startW, trampX + trampW, highX + highW, step1X + step1W, step2X + step2W], [trampX, highX, step1X, step2X, endX]);
      hintText = `Tactical Clue: Bouncy pad at x:${trampX}! Hold RIGHT the instant you hit the trampoline to curve around the ceiling spike and land on the high ledge at x:${highX}.`;
      break;
    }

    case 9: { // Double Trampoline Relay
      const t1X = startW + 40;
      const midW = 100;
      const midX = t1X + 65;
      const midY = 270;
      const t2X = midX + midW - 50;

      const b1X = midX + midW + 45;
      const b1W = 85;
      const b1Y = 260;

      const b2X = b1X + b1W + 45;
      const b2W = endX - b2X - 45;
      const b2Y = 255;

      blocks.push(
        { id: `b${id}_t1`, type: 'bouncy', x: t1X, y: 370, w: 50, h: 20, initialX: t1X, initialY: 370, color: '#ec4899' },
        { id: `b${id}_mid`, type: 'solid', x: midX, y: midY, w: midW, h: 25, initialX: midX, initialY: midY },
        { id: `b${id}_t2`, type: 'bouncy', x: t2X, y: midY - 15, w: 45, h: 15, initialX: t2X, initialY: midY - 15, color: '#ec4899' },
        { id: `b${id}_b1`, type: 'solid', x: b1X, y: b1Y, w: b1W, h: 25, initialX: b1X, initialY: b1Y },
        { id: `b${id}_b2`, type: 'solid', x: b2X, y: b2Y, w: b2W, h: 25, initialX: b2X, initialY: b2Y },
        { id: `b${id}_end`, type: 'solid', x: endX, y: 250, w: endW, h: groundY + 70 - 250, initialX: endX, initialY: 250 }
      );
      doorY = 250 - 44;

      addPitSpikes([startW, midX + midW, b1X + b1W, b2X + b2W], [t1X, b1X, b2X, endX]);
      hintText = `Tactical Clue: Double bounce relay! Launch from the first trampoline at x:${t1X} to the middle ledge, then hit the second pad at x:${t2X} straight into the high portal.`;
      break;
    }

    case 10: { // Ceiling Crusher Corridor
      const chain = generatePlatformChain(startW, endX, 2, prng, 'flat', groundY);
      const crushW = prng.rangeInt(150, 180);
      const crushX = chain[0].x + 30;
      const trigX = crushX - 70;

      for (let i = 0; i < chain.length; i++) {
        blocks.push({
          id: `b${id}_fl_${i}`,
          type: 'solid',
          x: chain[i].x,
          y: groundY,
          w: chain[i].w,
          h: 70,
          initialX: chain[i].x,
          initialY: groundY
        });
      }

      blocks.push(
        { id: `b${id}_crush`, type: 'solid', x: crushX, y: -25, w: crushW, h: 110, initialX: crushX, initialY: -25 },
        { id: `b${id}_end`, type: 'solid', x: endX, y: groundY, w: endW, h: 70, initialX: endX, initialY: groundY }
      );

      spikes.push({
        id: `s${id}_cr_spk`,
        direction: 'down',
        x: crushX + Math.round(crushW / 2) - 12,
        y: 85,
        w: 24,
        h: 24,
        initialX: crushX + Math.round(crushW / 2) - 12,
        initialY: 85
      });

      triggers.push({
        id: `t${id}_crush`,
        condition: 'player_x_gt',
        action: 'crush_ceiling',
        params: { x: trigX, blockIds: [`b${id}_crush`], speed: crushSpeed }
      });

      addPitSpikes([startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w], [chain[0].x, chain[1].x, endX]);
      hintText = `Tactical Clue: Ceiling crusher overhead! It slams down at ${crushSpeed}px/s when passing x:${trigX}. Step forward to trigger it, back up 30px, then climb over the fallen block.`;
      break;
    }

    case 11: { // Stalactite Rainstorm
      const chain = generatePlatformChain(startW, endX, 2, prng, 'flat', groundY);
      for (let i = 0; i < chain.length; i++) {
        blocks.push({
          id: `b${id}_st_m_${i}`,
          type: 'solid',
          x: chain[i].x,
          y: groundY,
          w: chain[i].w,
          h: 70,
          initialX: chain[i].x,
          initialY: groundY
        });
      }

      blocks.push(
        { id: `b${id}_end`, type: 'solid', x: endX, y: groundY, w: endW, h: 70, initialX: endX, initialY: groundY },
        { id: `b${id}_st1`, type: 'solid', x: chain[0].x + 30, y: 35, w: 45, h: 45, initialX: chain[0].x + 30, initialY: 35, color: '#64748b' },
        { id: `b${id}_st2`, type: 'solid', x: chain[1].x + 30, y: 35, w: 45, h: 45, initialX: chain[1].x + 30, initialY: 35, color: '#64748b' }
      );

      triggers.push(
        { id: `t${id}_st1`, condition: 'player_x_gt', action: 'drop_blocks', params: { x: chain[0].x - 20, blockIds: [`b${id}_st1`], delay: 0.08 } },
        { id: `t${id}_st2`, condition: 'player_x_gt', action: 'drop_blocks', params: { x: chain[1].x - 20, blockIds: [`b${id}_st2`], delay: 0.08 } }
      );

      addPitSpikes([startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w], [chain[0].x, chain[1].x, endX]);
      hintText = `Tactical Clue: Falling stalactites overhead! Bait the first stone at x:${chain[0].x - 20} and the second at x:${chain[1].x - 20} by taking a single step forward then stopping.`;
      break;
    }

    case 12: { // Jumping Spike Ambush
      const chain = generatePlatformChain(startW, endX, 2, prng, 'flat', groundY);
      for (let i = 0; i < chain.length; i++) {
        blocks.push({
          id: `b${id}_js_${i}`,
          type: 'solid',
          x: chain[i].x,
          y: groundY,
          w: chain[i].w,
          h: 70,
          initialX: chain[i].x,
          initialY: groundY
        });
      }
      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: groundY,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: groundY
      });

      const spk1X = chain[0].x + Math.round(chain[0].w / 2) - 12;
      const spk2X = chain[1].x + Math.round(chain[1].w / 2) - 12;

      spikes.push(
        { id: `s${id}_jp1`, direction: 'up', x: spk1X, y: groundY - 24, w: 24, h: 24, initialX: spk1X, initialY: groundY - 24, jumpsWithPlayer: true },
        { id: `s${id}_jp2`, direction: 'up', x: spk2X, y: groundY - 24, w: 24, h: 24, initialX: spk2X, initialY: groundY - 24, jumpsWithPlayer: true }
      );

      triggers.push({
        id: `t${id}_j_spk`,
        condition: 'player_jump',
        action: 'jump_spikes',
        params: { minX: chain[0].x - 40, maxX: chain[1].x + 40, spikeIds: [`s${id}_jp1`, `s${id}_jp2`], force: spikeJumpForce }
      });

      addPitSpikes([startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w], [chain[0].x, chain[1].x, endX]);
      hintText = `Tactical Clue: Ground spikes at x:${spk1X} and x:${spk2X} jump when you hop! Jump in place from the start edge to bait them into the air, then run underneath.`;
      break;
    }

    case 13: { // Fleeing Mirage Portal
      const chain = generatePlatformChain(startW, endX, 2, prng, 'flat', groundY);
      for (let i = 0; i < chain.length; i++) {
        blocks.push({
          id: `b${id}_fl_fl_${i}`,
          type: 'solid',
          x: chain[i].x,
          y: groundY,
          w: chain[i].w,
          h: 70,
          initialX: chain[i].x,
          initialY: groundY
        });
      }

      const elevW = prng.rangeInt(75, 95);
      const elevX = endX + 15;
      const elevY = 320; // 60px step from ground 380, effortless single jump
      const doorTargetX = elevX + Math.round((elevW - 32) / 2);
      const doorTargetY = elevY - 44;

      blocks.push(
        { id: `b${id}_fl_elev`, type: 'solid', x: elevX, y: elevY, w: elevW, h: groundY + 70 - elevY, initialX: elevX, initialY: elevY },
        { id: `b${id}_end`, type: 'solid', x: endX, y: groundY, w: endW, h: 70, initialX: endX, initialY: groundY }
      );

      doorX = chain[1].x + Math.round(chain[1].w * 0.55);
      doorY = groundY - 44;

      triggers.push({
        id: `t${id}_flee`,
        condition: 'distance_to_door',
        action: 'flee_door',
        params: {
          distance: 85,
          targetX: doorTargetX,
          targetY: doorTargetY,
          speed: doorFleeSpeed,
          message: "TOO SLOW! 💨"
        }
      });

      addPitSpikes([startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w], [chain[0].x, chain[1].x, endX]);
      hintText = `Tactical Clue: The door flees at ${doorFleeSpeed}px/s onto the elevated perch at x:${elevX} when approached! Chase it down and hop up to claim it.`;
      break;
    }

    case 14: { // Hologram Sike Door
      const stepW = 90;
      const stepX = 230;
      const stepY = 295;

      const highW = 120;
      const highX = 80;
      const highY = 210;

      // Continuous ground floor
      const floorW = endX - startW + 10;
      blocks.push(
        { id: `b${id}_sk_floor`, type: 'solid', x: startW, y: groundY, w: floorW, h: 70, initialX: startW, initialY: groundY },
        { id: `b${id}_sk_step`, type: 'solid', x: stepX, y: stepY, w: stepW, h: 25, initialX: stepX, initialY: stepY },
        { id: `b${id}_sk_high`, type: 'solid', x: highX, y: highY, w: highW, h: 25, initialX: highX, initialY: highY },
        { id: `b${id}_end`, type: 'solid', x: endX, y: groundY, w: endW, h: 70, initialX: endX, initialY: groundY }
      );

      doorX = endX + 30;
      doorY = groundY - 44;

      triggers.push({
        id: `t${id}_sk_fake`,
        condition: 'distance_to_door',
        action: 'fake_door_reveal',
        params: { distance: 50, realDoorX: highX + 30, realDoorY: highY - 44 }
      });

      hintText = `Tactical Clue: The exit door at x:${doorX} is an optical hologram! Touch it to spawn the genuine portal on the high ledge at x:${highX}. Use the step at x:${stepX} to climb back up.`;
      break;
    }

    case 15: { // Rocket Launch Door
      const pilW = 80;
      const pilX = 200;
      const pilY = 250;

      const stepW = 75;
      const stepX = 110;
      const stepY = 315;

      const floorW = endX - startW + 10;
      blocks.push(
        { id: `b${id}_rk_g`, type: 'solid', x: startW, y: groundY, w: floorW, h: 70, initialX: startW, initialY: groundY },
        { id: `b${id}_rk_step`, type: 'solid', x: stepX, y: stepY, w: stepW, h: 25, initialX: stepX, initialY: stepY },
        { id: `b${id}_rk_pil`, type: 'solid', x: pilX, y: pilY, w: pilW, h: groundY + 70 - pilY, initialX: pilX, initialY: pilY },
        { id: `b${id}_end`, type: 'solid', x: endX, y: groundY, w: endW, h: 70, initialX: endX, initialY: groundY }
      );

      spikes.push({
        id: `s${id}_rk_spk`,
        direction: 'up',
        x: pilX + pilW + 80,
        y: groundY - 24,
        w: 24,
        h: 24,
        initialX: pilX + pilW + 80,
        initialY: groundY - 24
      });

      triggers.push({
        id: `t${id}_rk_trig`,
        condition: 'distance_to_door',
        action: 'rocket_door',
        params: { distance: 95, newX: pilX + 25, newY: pilY - 44 }
      });

      hintText = `Tactical Clue: The door rockets upward when approached and descends onto the stone pillar at x:${pilX}. Use the step at x:${stepX} to jump onto the pillar!`;
      break;
    }

    case 16: { // Inverted Controls Crossing
      const chain = generatePlatformChain(startW, endX, 3, prng, 'random', groundY);
      for (let i = 0; i < chain.length; i++) {
        blocks.push({
          id: `b${id}_ic_${i}`,
          type: 'solid',
          x: chain[i].x,
          y: chain[i].y,
          w: chain[i].w,
          h: 25,
          initialX: chain[i].x,
          initialY: chain[i].y
        });
      }
      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: groundY,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: groundY
      });

      triggers.push({
        id: `t${id}_ic_inv`,
        condition: 'player_x_gt',
        action: 'invert_controls',
        params: { x: chain[0].x + 20, duration: 4.5, message: "CONTROLS INVERTED! 🔄" }
      });

      addPitSpikes(
        [startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w, chain[2].x + chain[2].w],
        [chain[0].x, chain[1].x, chain[2].x, endX]
      );
      hintText = `Tactical Clue: Controls flip at x:${chain[0].x + 20}! When jumping from the first platform, immediately steer with inverted keys to reach the second island safely.`;
      break;
    }

    case 17: { // Micro-Pillar Precision
      const chain = generatePlatformChain(startW, endX, 4, prng, 'random', groundY);
      const gaps: number[] = [startW];
      const gapEnds: number[] = [chain[0].x];

      for (let i = 0; i < chain.length; i++) {
        const p = chain[i];
        blocks.push({
          id: `b${id}_mp_${i}`,
          type: 'solid',
          x: p.x,
          y: p.y,
          w: p.w,
          h: 30,
          initialX: p.x,
          initialY: p.y
        });
        if (i < chain.length - 1) {
          gaps.push(p.x + p.w);
          gapEnds.push(chain[i + 1].x);
        }
      }
      gaps.push(chain[chain.length - 1].x + chain[chain.length - 1].w);
      gapEnds.push(endX);

      blocks.push({
        id: `b${id}_end`,
        type: 'solid',
        x: endX,
        y: groundY,
        w: endW,
        h: 70,
        initialX: endX,
        initialY: groundY
      });
      addPitSpikes(gaps, gapEnds);

      hintText = `Tactical Clue: Micro-pillar precision! Release the jump key quickly for short controlled hops so you do not overshoot the narrow pedestals.`;
      break;
    }

    case 18: { // Split-Level Over-Under
      const stepW = 75;
      const stepX = startW + 30;
      const stepY = 315;

      const topW1 = 90;
      const topW2 = 90;
      const topW3 = 85;

      const topX1 = stepX + stepW + 40;
      const topX2 = topX1 + topW1 + 45;
      const topX3 = topX2 + topW2 + 45;
      const topY = 250;

      blocks.push(
        { id: `b${id}_sl_step`, type: 'solid', x: stepX, y: stepY, w: stepW, h: 25, initialX: stepX, initialY: stepY },
        { id: `b${id}_sl_top1`, type: 'solid', x: topX1, y: topY, w: topW1, h: 25, initialX: topX1, initialY: topY },
        { id: `b${id}_sl_top2`, type: 'solid', x: topX2, y: topY, w: topW2, h: 25, initialX: topX2, initialY: topY },
        { id: `b${id}_sl_top3`, type: 'solid', x: topX3, y: topY, w: topW3, h: 25, initialX: topX3, initialY: topY },
        { id: `b${id}_end`, type: 'solid', x: endX, y: 250, w: endW, h: groundY + 70 - 250, initialX: endX, initialY: 250 }
      );
      doorY = 250 - 44;

      // Floor spikes below the high road
      spikes.push(
        { id: `s${id}_sl_fl1`, direction: 'up', x: topX1 + 20, y: 426, w: 24, h: 24, initialX: topX1 + 20, initialY: 426 },
        { id: `s${id}_sl_fl2`, direction: 'up', x: topX2 + 20, y: 426, w: 24, h: 24, initialX: topX2 + 20, initialY: 426 }
      );

      hintText = `Tactical Clue: The lower floor is a death pit! Take the upper high road: hop onto the step at x:${stepX}, then leap across the high ledges at y:${topY} to reach the portal.`;
      break;
    }

    case 19: { // Multi-Hazard Crucible
      const chain = generatePlatformChain(startW, endX, 3, prng, 'random', groundY);
      blocks.push(
        { id: `b${id}_mh1`, type: 'crumble', x: chain[0].x, y: chain[0].y, w: chain[0].w, h: 25, initialX: chain[0].x, initialY: chain[0].y },
        { id: `b${id}_mh2`, type: 'ice', x: chain[1].x, y: chain[1].y, w: chain[1].w, h: 25, initialX: chain[1].x, initialY: chain[1].y },
        { id: `b${id}_mh3`, type: 'solid', x: chain[2].x, y: chain[2].y, w: chain[2].w, h: 25, initialX: chain[2].x, initialY: chain[2].y },
        { id: `b${id}_end`, type: 'solid', x: endX, y: groundY, w: endW, h: 70, initialX: endX, initialY: groundY }
      );

      // Jumping spike on ice ledge
      const jSpkX = chain[1].x + Math.round(chain[1].w / 2) - 12;
      spikes.push({
        id: `s${id}_mh_jspk`,
        direction: 'up',
        x: jSpkX,
        y: chain[1].y - 24,
        w: 24,
        h: 24,
        initialX: jSpkX,
        initialY: chain[1].y - 24
      });

      triggers.push(
        {
          id: `t${id}_mh_jump`,
          condition: 'player_jump',
          action: 'jump_spikes',
          params: { minX: chain[0].x, maxX: chain[1].x + 10, spikeIds: [`s${id}_mh_jspk`], force: spikeJumpForce }
        },
        {
          id: `t${id}_mh_flee`,
          condition: 'distance_to_door',
          action: 'flee_door',
          params: { distance: 80, targetX: endX + endW - 40, speed: doorFleeSpeed, message: "SURPRISE! 🤡" }
        }
      );

      addPitSpikes(
        [startW, chain[0].x + chain[0].w, chain[1].x + chain[1].w, chain[2].x + chain[2].w],
        [chain[0].x, chain[1].x, chain[2].x, endX]
      );
      hintText = `Tactical Clue: Triple hazard crucible! Sprint past the crumble block at x:${chain[0].x}, bait the leaping spike on the ice ledge from afar, and chase the fleeing exit to finish!`;
      break;
    }
  }

  const door: Door = {
    x: doorX,
    y: doorY,
    w: 32,
    h: 44,
    initialX: doorX,
    initialY: doorY
  };

  return {
    id,
    title: `Level ${id}`,
    subtitle,
    theme,
    width,
    height,
    playerStart: { x: 50, y: playerStartY },
    door,
    blocks,
    spikes,
    triggers,
    gravityDirection: isGravityInverted ? -1 : 1,
    icePhysics: isIce,
    darkRoom: isDark,
    initialHint: `Difficulty escalated: ${mult} Harder.`,
    hint: hintText
  };
}

export const LEVELS: LevelData[] = (() => {
  const all: LevelData[] = [];
  all.push(ENTRANCE_TEST_LEVEL);
  BASE_LEVELS.forEach(lvl => {
    all.push({
      ...lvl,
      subtitle: `${lvl.subtitle} | ${getDifficultyMultiplier(lvl.id)} Harder`
    });
  });
  for (let i = 16; i <= 256; i++) {
    all.push(generateProceduralLevel(i));
  }
  return all;
})();
