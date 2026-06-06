# Attendify Design Direction · Studio Linear-Soft

**Date:** 2026-06-06
**Status:** Approved (Direction C selected from A/B/C)
**Supersedes:** SoftClaw (claymorphism) direction documented in `design-system/MASTER.md`

---

## 1. North Star

Attendify should feel like a **precision instrument for students who take attendance seriously**. Dark, calm, dense with meaning but never cluttered. Every surface, type choice, and motion is in service of one job: showing a student exactly where they stand relative to the 75% line, and what they can do about it.

The aesthetic borrows Linear's product rigor and Vercel's restraint, then adds an editorial layer (numbered sections, monospace data, sharp geometry) that signals "this team thought about this."

**Why this and not claymorphism:** SoftClaw's inflated shadows, pastel surfaces, and rounded "clay" shapes felt too playful for the audience — engineering and CS students in India who live in Linear, GitHub, and VS Code. The new direction speaks the same language those products use, with enough editorial texture to feel considered rather than derivative.

---

## 2. Design Tokens

All tokens are the single source of truth. No screen, widget, or component may use a value that is not in this table.

### 2.1 Color

| Token | Value | Use |
|---|---|---|
| `surface/base` | `#0B0F1A` | App background. Used for `Scaffold.backgroundColor`. |
| `surface/raised` | `#0F1320` | Card background, list items, grouped content |
| `surface/overlay` | `#161B2A` | Modals, dropdowns, popovers, tooltips |
| `border/subtle` | `#1E2330` | Default 1px dividers and card outlines |
| `border/strong` | `#2A3142` | Hover/focus borders, floating element outlines |
| `text/primary` | `#FFFFFF` | Headlines, hero numbers, key data |
| `text/secondary` | `#E4E7EB` | Body copy, list item primary text |
| `text/tertiary` | `#8A94A6` | Captions, meta, timestamps |
| `text/muted` | `#6B7280` | Disabled, footnotes, decorative mono |
| `accent/primary` | `#5E6AD2` | The one signature color. Use in micro-doses. |
| `accent/primary-hover` | `#7180E0` | Interactive hover state |
| `accent/primary-dim` | `rgba(94, 106, 210, 0.12)` | Tinted backgrounds, selected/active rows |
| `semantic/safe` | `#10B981` | Above 80% attendance |
| `semantic/warning` | `#F59E0B` | 75-80% (approaching threshold) |
| `semantic/danger` | `#EF4444` | Below 75% (at risk) |

**Color discipline rules:**
- `accent/primary` appears on at most 1-2 surfaces per screen.
- Never use semantic colors for non-semantic purposes (no green buttons, no red text for emphasis).
- Never use opacity to create new colors. Use the token.

### 2.2 Typography

Font families are loaded via `google_fonts: ^6.2.1` (already in `pubspec.yaml`).

| Role | Family | Size | Weight | Letter-spacing | Notes |
|---|---|---|---|---|---|
| Editorial headline | Inter | 40px | 600 | -1.5px | Login screen only |
| Page title | Inter | 24px | 600 | -0.5px | Top of every screen |
| Section label | JetBrains Mono | 10px | 700 | 2px | Uppercase, e.g. `01 / WELCOME` |
| Mono small | JetBrains Mono | 11px | 500 | 0 | Numbered row prefix, time labels, count captions |
| Body | Inter | 14px | 400 | 0 | Default reading text |
| Body emphasis | Inter | 14px | 500 | 0 | List item primary text (e.g. numbered row primary) |
| Strong body | Inter | 14px | 600 | 0 | Rarely used; reserved for inline emphasis |
| Caption | Inter | 12px | 400 | 0 | Meta, timestamps |
| Button | Inter | 13px | 600 | 0 | All interactive labels |
| Data / numbers | JetBrains Mono | varies | 500 | 0 | Tabular-nums enabled. Percentages, roll numbers, counts. |
| Hero number | JetBrains Mono | 64px | 600 | -2px | The attendance percentage on the dashboard |

**Typography rules:**
- Inter handles everything except data and section labels.
- JetBrains Mono is reserved for: section labels, roll numbers, percentages, counts, codes, IDs, file sizes, durations.
- Tabular-nums is enabled globally on the mono family for aligned columns.

### 2.3 Geometry

| Element | Property | Value |
|---|---|---|
| Cards | border-radius | `0px` (sharp corners) |
| Cards | border | `1px solid border/subtle` |
| Cards | box-shadow | none |
| Buttons | border-radius | `8px` |
| Buttons (primary) | background | `accent/primary` |
| Buttons (secondary) | background | transparent |
| Buttons (secondary) | border | `1px solid border/subtle` |
| Inputs | border-radius | `8px` |
| Inputs | border | `1px solid border/subtle` (focus: `border/strong`) |
| Inputs (focus) | outline | `2px solid accent/primary`, offset 0 (no glow) |
| Section dividers | height | `1px` |
| Section dividers | color | `border/subtle` |
| Section spacing | padding-top | `56-64px` |
| Icon default size | — | `20px` |
| Icon (dense list) | — | `16px` |
| Icon (header) | — | `24px` |
| Icon stroke | — | `1.5px` (line-only, Tabler style) |

**Geometry rules:**
- Sharp corners on all containers. Only buttons and inputs get an 8px radius.
- No drop shadows anywhere in the app.
- The only allowed "elevation" is a 1px border. Floating elements (modals, popovers) get a 1px `border/strong`.

### 2.4 Motion

| Property | Value |
|---|---|
| Default duration | `180ms` |
| Easing | `cubic-bezier(0.4, 0, 0.2, 1)` (Material standard) |
| Page transition | `240ms` fade + `8px` slide |
| Hover transitions | background-color, border-color only |
| Scale/rotate on hover | never |

**Motion rules:**
- No bouncy springs, no elastic curves, no hero animations.
- A list item appearing is a 180ms fade. Nothing more.
- Loading states are monospace text ("LOADING…"), not spinners. (Spinner is acceptable only when wait time is unknown.)

**Named exceptions** (the only durations allowed besides 180ms):
- Page transition: 240ms
- Hero gauge fill: 320ms ease-out (single pass, no loop)
- Subject progress bar fill: 320ms ease-out (single pass, no loop)

### 2.5 Iconography

- **Library:** A Tabler Icons Flutter package (e.g. `tabler_icons_flutter` or its maintained equivalent). The package must provide line-only icons at 1.5px stroke, MIT licensed. The implementation plan should pick the most actively maintained package and pin the version.
- **Style:** outline only. Never use the filled variant.
- **Sizing:** 16px in dense lists, 20px default, 24px in headers.
- **Color:** inherits from `text/secondary` by default; switches to `accent/primary` on hover/active.

### 2.6 Spacing scale

Use a 4px scale. Allowed values: `4, 8, 12, 16, 20, 24, 32, 40, 48, 56, 64`. No other values. Use the smallest value that achieves the desired separation; do not round up for visual generosity.

---

## 3. Component Patterns

These are the only patterns. Reuse them; do not invent new ones.

### 3.1 Numbered row
The fundamental list unit. Used for portal selection, today's classes, subject breakdown, recovery suggestions.

```
[ 01 ]   [Primary text]                    [→]
         [Secondary text in caption size]
─────────────────────────────────────────────────
```

- Left: 2-digit zero-padded number in JetBrains Mono 11px, `text/tertiary`. For active/selected row, number becomes `accent/primary`.
- Center: 2 lines max. Primary in `text/secondary` weight 500, secondary in `text/tertiary` weight 400.
- Right: a single trailing element — chevron, status dot, or action. Never both.
- Divider: 1px `border/subtle` below, full-width, no inset padding.
- Row height: auto-fit content, 20px vertical padding minimum.
- Selected/hover: `accent/primary-dim` background.

### 3.2 Segmented control
Replaces switches, radio buttons, and the three-state attendance toggle.

```
[ Present ] [ Absent ] [ Cancelled ]
```

- Height: 36px. Border-radius: 8px outer, 6px inner.
- Container: `surface/raised` background, `border/subtle` outline.
- Active segment: `accent/primary` background, white text, 4px horizontal padding.
- Inactive segment: transparent, `text/tertiary`.
- Transition between segments: 180ms background-color.

**Compact variant (used on the attendance-taking screen, §4.4):** Height 32px, border-radius 6px outer / 4px inner, font 12px. Otherwise identical.

### 3.3 Button

**Primary:**
- Background: `accent/primary`. Text: white. Weight 600.
- Padding: 10px 16px. Height: 40px. Radius: 8px.
- Hover: background → `accent/primary-hover`.

**Secondary:**
- Background: transparent. Text: `text/secondary`. Weight 600.
- Border: 1px `border/subtle`. Hover: border → `border/strong`.

**Destructive:**
- Same as primary but background `semantic/danger`. Used only for delete-account and similar irreversible actions.

### 3.4 Hero attendance gauge
The data anchor of the student dashboard. Replaces the claymorphism gauge.

- Thin progress arc, 2px stroke, drawn at 270° (top opens at 90°).
- Color: `text/primary` (the percentage is the only "white" element on the screen).
- Track: `border/subtle`.
- Threshold tick: a single 1px vertical mark at the 75% position on the arc, in `semantic/warning`.
- Center: the percentage in JetBrains Mono 64px weight 600, with one line of caption below ("4.2% above safe line" or "2 classes to recover").
- No animation on initial render. Updates animate the arc length over 320ms.

### 3.5 Subject progress bar
- Height: 2px. Full width of the parent.
- Track: `border/subtle`. Fill: `text/primary` for safe, `semantic/warning` for warning, `semantic/danger` for danger.
- Animated fill on first render: 320ms ease-out from 0 to value.
- No labels inside the bar. The percentage sits to the right in JetBrains Mono.

### 3.6 Input field
- Height: 40px. Radius: 8px. Padding: 0 12px.
- Border: 1px `border/subtle`.
- Background: `surface/raised`.
- Text: `text/secondary` 14px.
- Placeholder: `text/muted`.
- Focus: border → `border/strong`, outline `2px solid accent/primary` (no glow, no shadow).
- Error: border → `semantic/danger`, helper text in `semantic/danger` 12px below.

### 3.7 Card (used sparingly)
The numbered row is preferred. A card is used only when content cannot be expressed as a row — e.g., the hero gauge block, a modal's content area.

- Background: `surface/raised`. Border: 1px `border/subtle`. Radius: 0.
- Padding: 20-24px.
- No shadow.

### 3.8 Modal / Bottom sheet
- Background: `surface/overlay`. Border-top: 1px `border/strong` (bottom sheet) or full border (centered modal).
- Padding: 24px.
- Open animation: 240ms slide-up (bottom sheet) or fade+scale 0.95→1.0 (centered modal).
- Dismiss: tap backdrop or swipe down (bottom sheet).

### 3.9 Section header
Used at the top of every major content block on a dashboard.

```
01 / TODAY'S CLASSES                        4 OF 5 ATTENDED
─────────────────────────────────────────────────────────
```

- Left: section label in JetBrains Mono 10px weight 700 letter-spacing 2px, `text/tertiary`.
- Right: meta caption in JetBrains Mono 11px, `text/muted`.
- Divider below: 1px `border/subtle`, full-width.
- Vertical padding: 16px above the label, 12px below the divider.

---

## 4. Screen Specifications

### 4.1 Login Screen

**Purpose:** Choose portal (student or teacher). No account creation in v1; user is already authenticated.

**Layout (top to bottom):**
1. **Wordmark row** (24px top padding): single accent dot (8px, `accent/primary`, subtle glow), wordmark "Attendify" in Inter 14px weight 600 `text/secondary`, "v1.0" pushed right in JetBrains Mono 11px `text/muted`.
2. **Editorial headline block** (56px top padding): section label `01 / WELCOME` in mono, then a 40px Inter headline "Track your attendance, calmly.", then a 14px Inter body "A precision tool for students who care about the 75% line. No noise, no clutter."
3. **Portal selector** (40px top padding): two numbered rows. Row 01 = Student Portal, row 02 = Teacher Portal. Each row shows only the portal name (no description). Tap → navigates to the respective dashboard.
4. **Footer** (48px top padding): mono caption "OFFLINE-FIRST · OPEN SOURCE" left-aligned, three small color swatches (the brand palette) right-aligned.

**No illustrations. No avatars. No background images. No gradient.**

### 4.2 Student Dashboard

**Purpose:** Show the student exactly where they stand today, this week, and against the 75% line.

**Layout (vertical scroll, 16px horizontal padding):**
1. **Page title** (24px top padding): the literal string `"Hey, {firstName}"` where `{firstName}` is a template variable substituted at render time from the authenticated user's profile (e.g. "Hey, Aarav"). Inter 24px weight 600, plus a JetBrains Mono caption "WED · 06 JUN" right-aligned (date formatted from `DateTime.now()` in the device locale).
2. **Hero gauge block** (32px top padding): the hero attendance gauge (component 3.4) centered. Percentage is the weighted average across all subjects. Caption underneath summarizes the gap to 75%.
3. **Section: `02 / TODAY'S CLASSES`** with a "4 OF 5 ATTENDED" meta caption. Five numbered rows, one per class. Each row: time (mono 11px, `text/muted`), subject name, status dot (filled `semantic/safe` / `semantic/warning` / `semantic/danger` / `text/muted` for upcoming), trailing chevron.
4. **Section: `03 / BY SUBJECT`**. Five to eight numbered rows. Each row: subject name, percentage right-aligned in mono, a 2px progress bar below the row spanning full width.
5. **Section: `04 / RECOVERY`** (only visible if attendance < 85%). One to three numbered rows. Each: action ("Attend the next 2 Algorithm classes"), expected impact ("+5.4% to overall").
6. **No bottom navigation. No FAB. No floating action button.**

### 4.3 Teacher Dashboard

**Purpose:** Take attendance. See class-level health. Export reports.

**Layout (vertical scroll, 16px horizontal padding):**
1. **Page title**: "Classes" with a mono caption of today's date.
2. **Section: `01 / TODAY`**. List of classes the teacher takes today. Each row: time, class name, "23/30 PRESENT" mono caption right-aligned, status dot.
3. **Section: `02 / THIS WEEK`**. Same row pattern, grouped by day with mono day labels as sub-headers.
4. **Section: `03 / REPORTS`**. A single secondary button "Export this week as CSV".

**Tapping a class row** opens the attendance-taking screen (§4.4).

### 4.4 Attendance-Taking Screen

**Purpose:** Mark each student as present, absent, or cancelled. Fast.

**Layout:**
1. **Header bar** (sticky, top): back chevron, class name in Inter 16px weight 600, mono caption "23/30 MARKED" right-aligned.
2. **Section: `01 / STUDENTS`**. Numbered list, one row per student. Each row: roll number (mono 11px `text/muted`), name, segmented control on the right (Present / Absent / Cancelled). The segmented control is 32px tall (compact variant).
3. **Footer bar** (sticky, bottom): primary button "Save attendance" full-width minus 16px padding on each side. Disabled until at least one student is marked.

### 4.5 Settings

**Layout:**
1. **Page title**: "Settings".
2. **Section: `01 / PROFILE`**. Name, email (read-only in v1), roll number (mono).
3. **Section: `02 / PREFERENCES`**. Theme is hard-coded to dark in v1 (display a read-only row: "Theme" → "Dark"). Notifications toggle (uses segmented control: On / Off).
4. **Section: `03 / ABOUT`**. Version (mono), "Open source" link, "Privacy" link.
5. **Section: `04 / DANGER ZONE`**. "Sign out" as a secondary button. "Delete account" as a destructive button (with confirmation modal).

---

## 5. What Replaces What

| File | Action | Replacement |
|---|---|---|
| `lib/theme/softclaw_theme.dart` | **Delete** | `lib/theme/studio_theme.dart` (new) |
| `lib/widgets/clay_widgets.dart` | **Delete** | (no replacement — components live in their feature folders) |
| `lib/widgets/attendance_gauges.dart` | **Delete** | `lib/widgets/hero_attendance_gauge.dart` (new) |
| `lib/screens/login_screen.dart` | **Rewrite** | Uses editorial layout (§4.1) |
| `lib/screens/student_dashboard.dart` | **Rewrite** | Uses numbered-list layout (§4.2) |
| `lib/screens/teacher_dashboard.dart` | **Rewrite** | Uses numbered-list layout (§4.3) |
| `lib/screens/attendance_screen.dart` | **Rewrite** | Uses compact segmented control (§4.4) |
| `lib/screens/settings_screen.dart` | **Rewrite** | Uses section pattern (§4.5) |
| `lib/main.dart` | **Update** | Import and wire `StudioTheme` |
| `pubspec.yaml` | **Add** | `tabler_icons_flutter: ^1.0.0` (or compatible version) |
| `design-system/MASTER.md` | **Rewrite** | Document the new direction |
| `design-system/showcase.html` | **Regenerate** | New mockups matching this spec |

**No new features, no new screens, no new dependencies beyond Tabler icons.**

---

## 6. What We Are NOT Doing (v1)

1. **No light mode.** Dark surface is the design.
2. **No new icons beyond Tabler.** No custom illustrations, no emoji, no Lottie.
3. **No animations beyond the named exceptions in §2.4.** No hero animations, no Rive, no spring physics, no new durations.
4. **No per-user theming.** One look for everyone.
5. **No glass-morphism, no backdrop-blur, no gradients** except an optional brand-gradient on the wordmark.
6. **No new screens.** The five screens above (§4.1-4.5) are the entire scope.
7. **No accessibility regression.** The new design must meet WCAG AA contrast (text/primary on surface/base = 16.8:1, text/secondary on surface/base = 14.1:1, accent/primary on surface/base = 5.4:1).
8. **No data migration.** Schema and state logic stay as they are. This is purely a visual rebuild.

---

## 7. Migration Strategy

To avoid a "refactor clay into studio" failure mode, the build is sequenced as:

1. **Build the new theme tokens and components alongside the old ones.** Both can coexist temporarily by being in different files.
2. **Rewrite one screen at a time**, swapping the new screen in via `main.dart` routing.
3. **Delete the old theme and clay widgets** only after every screen is on the new design system.
4. **Update `main.dart` import last**, not first.

This sequencing is captured in detail by the implementation plan (created by the writing-plans skill after this spec is approved).

---

## 8. Success Criteria

The rebuild is complete when:

- [ ] `pubspec.yaml` includes `tabler_icons_flutter` and `flutter pub get` succeeds.
- [ ] `lib/theme/studio_theme.dart` exists and exports a `ThemeData` matching §2.
- [ ] All five screens in §4 render without overflow on a 360×640 viewport (smallest target).
- [ ] No file imports from `softclaw_theme.dart` or `clay_widgets.dart`.
- [ ] `lib/widgets/clay_widgets.dart` is deleted.
- [ ] `lib/theme/softclaw_theme.dart` is deleted.
- [ ] All `Card` widgets use `borderRadius: 0` and a 1px border, no shadow.
- [ ] All accent color usage is in the dim/hover/active variants; full-saturation accent appears on at most 1-2 surfaces per screen.
- [ ] No `BoxShadow` widget appears in the codebase.
- [ ] All motion durations are from the set {180ms, 240ms, 320ms}; no other values.
- [ ] `design-system/MASTER.md` and `design-system/showcase.html` reflect the new direction.

---

## 9. Open Questions

None. All design decisions resolved during the brainstorm on 2026-06-06.

---

## 10. References

- Visual mockups: `.superpowers/brainstorm/44998-1780752459/content/direction-{a,b,c}.html`
- Existing app state: `lib/`, `lib/screens/`, `lib/models/`, `lib/state/`
- Phase 1 design (superseded): `design-system/MASTER.md`, `design-system/showcase.html`
