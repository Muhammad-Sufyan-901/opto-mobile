-- Add voice-settings columns to accessibility_settings.
-- spoken_guidance_enabled: TTS read-aloud feature. Has no effect when voice_enabled = false.
-- speaking_rate: TTS playback speed (flutter_tts scale 0.0–1.0; 0.5 = platform normal).
--   Default 0.45 is slightly below normal — intentional for accessibility users who prefer slower TTS.
--   numeric(3,2) physically accepts -9.99..9.99; the CHECK constraint below is the range guard.
alter table public.accessibility_settings
  add column spoken_guidance_enabled boolean not null default true,
  add column speaking_rate numeric(3,2) not null default 0.45
    check (speaking_rate between 0.0 and 1.0);
