---
name: Live Screen Auto-Translator
colors:
  surface: '#0f131d'
  surface-dim: '#0f131d'
  surface-bright: '#353944'
  surface-container-lowest: '#0a0e18'
  surface-container-low: '#171b26'
  surface-container: '#1c1f2a'
  surface-container-high: '#262a35'
  surface-container-highest: '#313540'
  on-surface: '#dfe2f1'
  on-surface-variant: '#b9cacb'
  inverse-surface: '#dfe2f1'
  inverse-on-surface: '#2c303b'
  outline: '#849495'
  outline-variant: '#3a494b'
  surface-tint: '#00dce6'
  primary: '#e0fdff'
  on-primary: '#00373a'
  primary-container: '#00f2fe'
  on-primary-container: '#006a70'
  inverse-primary: '#00696f'
  secondary: '#c0c1ff'
  on-secondary: '#1000a9'
  secondary-container: '#3131c0'
  on-secondary-container: '#b0b2ff'
  tertiary: '#e1ffec'
  on-tertiary: '#003824'
  tertiary-container: '#67f4b7'
  on-tertiary-container: '#006e4b'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#6ff6ff'
  primary-fixed-dim: '#00dce6'
  on-primary-fixed: '#002022'
  on-primary-fixed-variant: '#004f53'
  secondary-fixed: '#e1e0ff'
  secondary-fixed-dim: '#c0c1ff'
  on-secondary-fixed: '#07006c'
  on-secondary-fixed-variant: '#2f2ebe'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#0f131d'
  on-background: '#dfe2f1'
  surface-variant: '#313540'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  title-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 10px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

The design system embodies a high-performance, real-time computational utility interface designed for power users, multilingual mobile gamers, manga/comic readers, and global professionals. The emotional goal is immediate operational confidence: the system must look precision-engineered, ultra-responsive, and imperceptible when idle, yet authoritative during active capture and translation.

The visual style blends **Tactile Cyber-Minimalism** with an evolved **Dark Mode Material UI** baseline. It utilizes deep obsidian surfaces, sharp luminescent strokes, and surgical data readouts rather than ambient, blurry decorative glass. The interface prioritizes low battery strain (OLED-friendly dark baselines), low cognitive friction, and instantaneous technical comprehension via high-contrast cybernetic state markers.

## Colors

The palette establishes an OLED-optimized foundation layered with luminescent data accents:

- **Background Canvas & Base**: `#0B0F19` (Obsidian Deep) serves as the primary canvas for maximum contrast and display power efficiency.
- **Surface Elevation Levels**:
  - `Surface-0 (App Background)`: `#0B0F19`
  - `Surface-1 (Containers & Base Cards)`: `#111827`
  - `Surface-2 (Interactive Elements & Floating Panels)`: `#1E293B`
  - `Surface-3 (Hover/Pressed States & Overlays)`: `#334155`
- **Primary Cyber Cyan (`#00F2FE` & `#06B6D4`)**: Reserved for live OCR bounding indicators, active engine hooks, progress gauges, and focused interface triggers.
- **Secondary Electric Indigo (`#6366F1` & `#4F46E5`)**: Utilized for structural brand affordances, persistent controls, paired language tokens, and inactive-yet-ready state controls.
- **Telemetry Indicators**:
  - `Active/Daemon Running`: `#10B981` (Emerald Cyber-Glow)
  - `Halted/Service Error`: `#EF4444` (Rose Hazard)
  - `Buffering/Processing OCR`: `#F59E0B` (Amber Neon)
- **Stroke & Structural Lines**: Low-alpha crisp borders at `rgba(255, 255, 255, 0.08)` for container distinction without visual clutter.

## Typography

Typography prioritizes high-density legibility and rapid status parsing:

- **Primary Interface (Inter)**: Handles all top-level headers, system prompts, configuration settings, and destination translated text strings. Its neutral grotesk anatomy ensures zero intrusion when rendering varying script lengths across Western and Asian character sets.
- **Machine & Technical Readouts (JetBrains Mono)**: Applied strictly to frame metrics (FPS, inference ms), translation language pair badges (`EN -> JA`), OCR bounding box coordinates, and floating bubble state indicators.
- **Hierarchy Rules**: Numerical telemetry always utilizes tabular figures via OpenType settings (`tnum`). All badge labels retain letter-spacing of `+0.05em` to maintain clarity against dark surfaces.

## Layout & Spacing

The layout is built for fluid touch screens across mobile and tablet environments, utilizing an 8dp/4dp strict grid rhythm compatible with Flutter's layout engine:

- **Canvas Safe Insets**: Margins scale from `16dp` (`1rem`) on handheld devices up to `24dp` (`1.5rem`) on foldables and tablets. Top and bottom insets strictly honor native mobile display cutouts and gesture navigation bars.
- **Card and Stack Flow**: Grouped functional blocks (e.g., Engine Settings, Model Manager) maintain an inner padding of `space-md` (16dp) with an inter-card vertical stack distance of `space-md`. Compact sub-actions or parameter chips utilize `space-xs` (4dp) and `space-sm` (8dp) gaps.
- **Overlay Window Constraints**: The floating translation bubble and dynamic HUD overlay adopt absolute viewport edge snapping, retaining a minimum floating margin of `12dp` from any viewport edge to avoid native OS gesture trigger conflicts.

## Elevation & Depth

Visual hierarchy uses tonal surface step-ups coupled with surgical hair-line borders rather than heavy diffuse drop-shadows:

- **Border Architecture**: All card containers, bottom navigation sheets, and floating HUD widgets carry a uniform `1dp` border styled with `rgba(255, 255, 255, 0.08)`. Hover or focused components step up to `rgba(0, 242, 254, 0.35)`.
- **Level 0 (Base)**: `#0B0F19` — Canvas background.
- **Level 1 (Docked Containers)**: `#111827` + `1dp` border `rgba(255, 255, 255, 0.08)`.
- **Level 2 (Active Cards & Menus)**: `#1E293B` + subtle directional edge light (`box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5)`).
- **Level 3 (HUD Floater / Active Daemon Bubble)**: `#111827` backdrop with a localized neon aura (`box-shadow: 0 0 16px rgba(0, 242, 254, 0.25)` when active, or `rgba(239, 68, 68, 0.2)` when suspended).

## Shapes

The design system standardizes on a **Rounded (Level 2)** shape profile:

- **Cards and Major Surfaces**: Fixed at `16dp` (`rounded-lg` equivalent) border radius, delivering modern ergonomics without feeling excessively bubbly.
- **Buttons and Primary Switches**: Scaled at `8dp` to `12dp` for high click-target precision.
- **Telemetry Chips and Status Badges**: Configured with a `6dp` radius to preserve the technical, dashboard-inspired aesthetic.
- **Floating Translation Bubble**: Strict circular or pill geometry (`50%` / full rounded) to cleanly distinguish floating runtime overlays from native host app rectangular bounds.

## Components

### Buttons
- **Primary Action (Start Service / Capture)**: Filled with a gradient from Cyber Cyan (`#00F2FE`) to Electric Indigo (`#6366F1`), dark text (`#0B0F19`), font weight `600`. Emits a faint cyan rim lighting when active.
- **Secondary Action (Configure / Clear)**: Background `#1E293B`, border `1dp` `rgba(255, 255, 255, 0.08)`, text `#E2E8F0`. Focused state shifts the border to `#00F2FE`.

### Switch Toggles & Status Indicators
- **Master Daemon Switch**: Embedded inside a dedicated status card. Track width 52dp, height 32dp. When active: track turns `#06B6D4`, thumb transitions to `#FFFFFF` accompanied by an emerald pulse indicator (`#10B981`) labeled `ACTIVE (45ms)`. When halted: track `#1E293B`, thumb `#94A3B8`, status indicator turns `#EF4444` labeled `IDLE`.

### Status Badges & Chips
- Monospaced badges utilizing `JetBrains Mono`. Background rendered at 10% opacity of the associated accent (`rgba(0, 242, 254, 0.1)` for source model tags, `rgba(16, 185, 129, 0.1)` for OCR engine status). Borders use identical color at 20% alpha.

### Input Fields & Selectors
- **Language Switcher Bar**: Two interconnected pill containers (`Source` -> `Target`) linked by an animated swap icon. Field background `#111827`, border `1dp` `rgba(255, 255, 255, 0.08)`. Active typing or language selection modal triggers a cyan border highlight.

### Cards
- Standard cards feature a `16dp` radius, `#111827` surface fill, and `1dp` subtle outline (`rgba(255,255,255,0.08)`). Content divides horizontally using faint dividers (`rgba(255, 255, 255, 0.04)`).

### Floating HUD / Screen Overlay Component
- Minimal floating pill rendered on top of external Android/iOS screens. Semi-translucent dark slate (`#0B0F19` at 85% alpha with 16dp backdrop blur). Contains:
  1. Micro status LED (`#10B981` active / `#EF4444` stopped).
  2. One-tap screen translate shutter button.
  3. Real-time inference latency counter in `JetBrains Mono` (`label-sm`).