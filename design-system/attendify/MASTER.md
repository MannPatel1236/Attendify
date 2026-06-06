# Attendify Design System · Studio Linear-Soft

This is the canonical reference for the Attendify visual design.

**The full design spec is in `docs/superpowers/specs/2026-06-06-attendify-design-direction.md`.** This file is a quick reference; the spec is the source of truth.

---

## Direction

A precision instrument for students who take attendance seriously. Dark, calm, dense with meaning but never cluttered. Linear's product rigor + Vercel's restraint + an editorial layer (numbered sections, monospace data, sharp geometry) that signals "this team thought about this."

## Tokens

### Surfaces
- `surface/base` — `#0B0F1A` — app background
- `surface/raised` — `#0F1320` — cards, list items
- `surface/overlay` — `#161B2A` — modals, dropdowns

### Borders
- `border/subtle` — `#1E2330` — default 1px dividers
- `border/strong` — `#2A3142` — hover/focus borders

### Text
- `text/primary` — `#FFFFFF` — headlines, key data
- `text/secondary` — `#E4E7EB` — body, list item primary
- `text/tertiary` — `#8A94A6` — captions, meta
- `text/muted` — `#6B7280` — disabled, footnotes

### Accent
- `accent/primary` — `#5E6AD2` — the one signature color
- `accent/primary-dim` — `rgba(94,106,210,0.12)` — selected/hover backgrounds

### Semantic
- `semantic/safe` — `#10B981` — ≥80%
- `semantic/warning` — `#F59E0B` — 75-80%
- `semantic/danger` — `#EF4444` — <75%

## Geometry

- Cards: 0px radius, 1px `border/subtle`, no shadow
- Buttons: 8px radius
- Inputs: 8px radius
- Section dividers: 1px `border/subtle`
- Icons: Tabler line icons, 1.5px stroke, 16/20/24px sizes

## Typography

- Inter: body, headlines, buttons
- JetBrains Mono: section labels, data, percentages, codes
- Tabular-nums enabled globally on the mono family

## Motion

- Default: 180ms
- Named exceptions: 240ms (page transition), 320ms (gauge + progress bar fill)
- Easing: `cubic-bezier(0.4, 0, 0.2, 1)` (Material standard)
- No scale/rotate on hover, no hero animations, no springs

## Components

All components live in `lib/widgets/studio/` and are documented in the spec:

- `NumberedRow` — fundamental list unit (spec §3.1)
- `SegmentedControl` — default + compact (spec §3.2)
- `StudioButton` — primary/secondary/destructive (spec §3.3)
- `HeroAttendanceGauge` — 270° arc + threshold tick (spec §3.4)
- `SubjectProgressBar` — 2px bar with semantic fill (spec §3.5)
- `StudioInput` — text field (spec §3.6)
- `StudioCard` — used sparingly (spec §3.7)
- `SectionHeader` — `01 / LABEL` (spec §3.9)

## Compliance

The grep-based test in `test/design_system_compliance_test.dart` enforces:
- No imports of softclaw/clay/monolith code
- No `BoxShadow` in the codebase
- No non-zero `BorderRadius.circular` outside the studio design system
