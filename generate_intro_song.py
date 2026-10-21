import math
import struct
import wave
import random

SAMPLE_RATE = 44100

def note_to_freq(note_str):
    # e.g. "C4", "D#4", "Eb4", "G3", etc.
    notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    aliases = {"Db": "C#", "Eb": "D#", "Gb": "F#", "Ab": "G#", "Bb": "A#"}
    name = note_str[:-1]
    octave = int(note_str[-1])
    if name in aliases:
        name = aliases[name]
    semitone = notes.index(name)
    # A4 is 440 Hz, semitone 9, octave 4
    n = (octave - 4) * 12 + (semitone - 9)
    return 440.0 * (2.0 ** (n / 12.0))

def pulse_wave(phase, duty=0.5):
    # Normalized -1 to 1
    p = phase % 1.0
    return 1.0 if p < duty else -1.0

def triangle_wave(phase):
    p = phase % 1.0
    return 4.0 * abs(p - 0.5) - 1.0

def generate_song():
    bpm = 148.0
    beat_dur = 60.0 / bpm
    step_dur = beat_dur / 4.0  # 16th note duration
    
    # Let's compose a 16-bar loop (4 bars intro riff + 8 bars main theme + 4 bars turnaround)
    # Total steps: 16 bars * 16 steps/bar = 256 steps (~25.9 seconds)
    total_steps = 256
    total_samples = int(total_steps * step_dur * SAMPLE_RATE)
    
    output = [0.0] * total_samples
    
    # 1. Lead Melody Channel (Pulse wave with varying duty cycle, arpeggiated chords & riffs)
    # Chord progression:
    # Bars 1-4:   Cm -> Ab -> Bb -> G
    # Bars 5-8:   Cm -> Fm -> Bb -> Eb - G
    # Bars 9-12:  Cm -> Ab -> Bb -> G7
    # Bars 13-16: Cm -> Eb -> Fm -> G (high energetic climax)
    
    lead_notes = [
        # Bar 1 (Cm)
        ("C5", 2), ("Eb5", 2), ("G5", 2), ("C6", 2), ("Bb5", 2), ("G5", 2), ("Eb5", 2), ("D5", 2),
        # Bar 2 (Ab)
        ("C5", 2), ("Eb5", 2), ("Ab5", 2), ("C6", 2), ("Ab5", 2), ("Eb5", 2), ("C5", 2), ("Eb5", 2),
        # Bar 3 (Bb)
        ("D5", 2), ("F5", 2), ("Bb5", 2), ("D6", 2), ("Bb5", 2), ("F5", 2), ("D5", 2), ("F5", 2),
        # Bar 4 (G)
        ("G5", 2), ("B5", 2), ("D6", 2), ("F6", 2), ("G6", 4), ("F6", 2), ("D6", 2),
        
        # Bar 5 (Cm melody theme A)
        ("C5", 4), ("G5", 2), ("Eb5", 2), ("D5", 2), ("C5", 2), ("D5", 2), ("Eb5", 2),
        # Bar 6 (Fm)
        ("F5", 4), ("Ab5", 2), ("F5", 2), ("Eb5", 2), ("D5", 2), ("C5", 2), ("D5", 2),
        # Bar 7 (Bb)
        ("D5", 4), ("F5", 2), ("Bb5", 2), ("D6", 4), ("C6", 2), ("Bb5", 2),
        # Bar 8 (Eb -> G)
        ("G5", 4), ("Bb5", 2), ("Eb6", 2), ("D6", 4), ("B5", 4),
        
        # Bar 9 (Cm driving hook)
        ("C5", 2), ("C5", 2), ("Eb5", 2), ("G5", 2), ("C6", 4), ("G5", 4),
        # Bar 10 (Ab)
        ("Ab5", 2), ("Ab5", 2), ("C6", 2), ("Eb6", 2), ("Ab6", 4), ("Eb6", 4),
        # Bar 11 (Bb)
        ("Bb5", 2), ("Bb5", 2), ("D6", 2), ("F6", 2), ("Bb6", 4), ("F6", 4),
        # Bar 12 (G7)
        ("G5", 2), ("B5", 2), ("D6", 2), ("F6", 2), ("G6", 4), ("D6", 2), ("B5", 2),
        
        # Bar 13 (Climax Cm)
        ("C6", 4), ("Eb6", 2), ("D6", 2), ("C6", 2), ("Bb5", 2), ("C6", 4),
        # Bar 14 (Eb)
        ("Eb6", 4), ("G6", 2), ("F6", 2), ("Eb6", 2), ("D6", 2), ("Eb6", 4),
        # Bar 15 (Fm)
        ("F6", 4), ("Ab6", 2), ("G6", 2), ("F6", 2), ("Eb6", 2), ("F6", 4),
        # Bar 16 (G turnaround)
        ("G6", 4), ("F6", 2), ("Eb6", 2), ("D6", 2), ("B5", 2), ("G5", 4)
    ]
    
    # Render Lead
    cur_step = 0
    phase = 0.0
    for note, dur_steps in lead_notes:
        freq = note_to_freq(note)
        start_samp = int(cur_step * step_dur * SAMPLE_RATE)
        dur_samp = int(dur_steps * step_dur * SAMPLE_RATE)
        # Note release gate (85% tone, 15% silence)
        play_samp = int(dur_samp * 0.88)
        
        duty = 0.25 if (cur_step // 16) % 2 == 0 else 0.5
        for s in range(play_samp):
            if start_samp + s >= total_samples:
                break
            t = s / SAMPLE_RATE
            # Subtle vibrato after 0.1s
            vib = 0.0
            if t > 0.08:
                vib = math.sin(2.0 * math.pi * 6.5 * (t - 0.08)) * 0.02
            f = freq * (1.0 + vib)
            phase += f / SAMPLE_RATE
            
            # Envelope (quick attack, slight decay, sustain)
            env = 1.0
            if s < 120:
                env = s / 120.0
            elif s > play_samp - 200:
                env = max(0.0, (play_samp - s) / 200.0)
            
            val = pulse_wave(phase, duty) * env * 0.28
            output[start_samp + s] += val
        cur_step += dur_steps
    
    # 2. Bass Channel (Bouncy 16th-note triangle bassline)
    bass_roots = [
        # Bar 1-4
        "C3", "C3", "Ab2", "Ab2", "Bb2", "Bb2", "G2", "G2",
        # Bar 5-8
        "C3", "C3", "F2", "F2", "Bb2", "Bb2", "Eb3", "G2",
        # Bar 9-12
        "C3", "C3", "Ab2", "Ab2", "Bb2", "Bb2", "G2", "G2",
        # Bar 13-16
        "C3", "C3", "Eb3", "Eb3", "F2", "F2", "G2", "G2"
    ]
    
    for bar_idx, root in enumerate(bass_roots):
        rfreq = note_to_freq(root)
        bar_start_step = bar_idx * 8  # 8 eighth notes per pair = 2 bars per pair
        bphase = 0.0
        for step_in_bar in range(8):
            step = bar_start_step + step_in_bar
            start_samp = int(step * 2 * step_dur * SAMPLE_RATE)
            dur_samp = int(2 * step_dur * SAMPLE_RATE)
            play_samp = int(dur_samp * 0.8)
            
            # Octave jump on upbeat
            bfreq = rfreq * 2.0 if (step_in_bar % 2 == 1) else rfreq
            for s in range(play_samp):
                if start_samp + s >= total_samples:
                    break
                bphase += bfreq / SAMPLE_RATE
                env = 1.0
                if s < 60:
                    env = s / 60.0
                else:
                    env = max(0.0, 1.0 - (s / dur_samp) * 0.7)
                val = triangle_wave(bphase) * env * 0.35
                output[start_samp + s] += val
                
    # 3. Drum / Percussion Channel (Kick, Snare, Hi-Hat)
    rand = random.Random(1337)
    for step in range(total_steps):
        start_samp = int(step * step_dur * SAMPLE_RATE)
        
        # Kick on beat 1, 3 (every 8 steps: 0, 8, 16, 24...) + occasional syncopation
        is_kick = (step % 8 == 0) or (step % 16 == 6)
        # Snare on beat 2, 4 (every 8 steps: 4, 12, 20, 28...)
        is_snare = (step % 8 == 4)
        # Hi-hat on every 2 steps
        is_hihat = (step % 2 == 0) and not is_snare
        
        if is_kick:
            kdur = int(0.12 * SAMPLE_RATE)
            for s in range(kdur):
                if start_samp + s >= total_samples:
                    break
                t = s / SAMPLE_RATE
                # Pitch sweep from 160Hz down to 45Hz
                kfreq = 45.0 + 115.0 * math.exp(-t * 30.0)
                val = math.sin(2.0 * math.pi * kfreq * t) * math.exp(-t * 22.0) * 0.42
                output[start_samp + s] += val
                
        if is_snare:
            sdur = int(0.14 * SAMPLE_RATE)
            sphase = 0.0
            for s in range(sdur):
                if start_samp + s >= total_samples:
                    break
                t = s / SAMPLE_RATE
                # Noise + body tone (180Hz)
                noise = rand.uniform(-1.0, 1.0)
                sphase += 180.0 / SAMPLE_RATE
                body = math.sin(2.0 * math.pi * sphase) * 0.4
                env = math.exp(-t * 24.0)
                val = (noise * 0.65 + body * 0.35) * env * 0.32
                output[start_samp + s] += val
                
        if is_hihat:
            hdur = int(0.045 * SAMPLE_RATE)
            for s in range(hdur):
                if start_samp + s >= total_samples:
                    break
                t = s / SAMPLE_RATE
                noise = rand.uniform(-1.0, 1.0)
                env = math.exp(-t * 80.0)
                val = noise * env * 0.12
                output[start_samp + s] += val

    # 4. Master Limiter / Normalization
    max_amp = max(abs(x) for x in output) or 1.0
    norm_factor = 0.88 / max_amp
    
    int_samples = []
    for x in output:
        clamped = max(-1.0, min(1.0, x * norm_factor))
        int_samples.append(int(clamped * 32767.0))
        
    return int_samples

def save_wav(filename, samples):
    with wave.open(filename, 'wb') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(SAMPLE_RATE)
        data = struct.pack(f'<{len(samples)}h', *samples)
        wf.writeframes(data)
    print(f"Saved {filename} ({len(samples)/SAMPLE_RATE:.1f}s)")

if __name__ == "__main__":
    samples = generate_song()
    save_wav("/Users/varunms/.gemini/antigravity/scratch/dont-die/godot_project/audio/intro_song.wav", samples)
    save_wav("/Users/varunms/.gemini/antigravity/scratch/dont-die/python_game/audio/intro_song.wav", samples)
