-- Add voice-settings columns to accessibility_settings
-- spoken_guidance_enabled: whether TTS guidance is read aloud
-- speaking_rate: TTS playback speed, 0.0 (slowest) to 1.0 (fastest)
alter table public.accessibility_settings
  add column spoken_guidance_enabled boolean not null default true,
  add column speaking_rate numeric(3,2) not null default 0.45
    check (speaking_rate between 0.0 and 1.0);
