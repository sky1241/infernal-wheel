# DEEP RESEARCH PROMPT - UX UNIVERSEL (~100 pages cible)

## CONTEXTE
Je construis une base de connaissances UX/UI UNIVERSELLE couvrant:
- **Web** (desktop + responsive)
- **iOS** (iPhone, iPad, Apple Watch)
- **Android** (phones, tablets, Wear OS)

J'ai déjà documenté: États UI, Forms, Navigation basique, WCAG, Typography, Spacing, Data Viz, i18n.

## CE QUE JE RECHERCHE
Des **valeurs numériques concrètes** et **patterns spécifiques** pour TOUT type d'application:
- E-commerce
- SaaS / Productivity
- Social / Communication
- Media / Entertainment
- Finance / Banking
- Health / Fitness
- Education
- Gaming

Pour chaque règle:
- Valeurs exactes (px, dp, pt, ms, ratios)
- Différences Web vs iOS vs Android
- Exemples d'apps réelles
- Sources 2023-2026

---

## PARTIE 1: GAMIFICATION & ENGAGEMENT UNIVERSEL (25-30 pages)

### 1.1 Streaks & Progress Systems
- Streak design patterns (Duolingo, Snapchat, GitHub, Wordle)
- Optimal streak lengths avant récompense
- Grace periods et streak recovery
- Affichage: flames, calendriers, progress rings
- Quand les streaks sont toxiques (anxiety, churn)
- Alternatives aux streaks (milestones, levels)

### 1.2 Points, Badges, Leaderboards (PBL)
- Point systems: earning rates, inflation prevention, currency design
- Badge tiers: common, rare, epic, legendary
- Leaderboard types: global, friends, time-limited
- Quand PBL fonctionne vs quand ça backfire
- Exemples: Reddit karma, Stack Overflow, fitness apps

### 1.3 Rewards & Incentives
- Intrinsic vs extrinsic motivation
- Variable ratio reinforcement (slot machine psychology)
- Surprise rewards vs predictable rewards
- Daily login bonuses design
- Referral programs UX
- Premium/subscription upsell timing

### 1.4 Progress & Achievement
- Progress bars: linear vs circular, determinate vs indeterminate
- Milestone celebrations (confetti, animations)
- Level systems design
- XP curves (linear vs exponential)
- "Endowed progress effect" (Kopelman study)
- Empty progress vs completed progress visualization

### 1.5 Engagement Loops
- Hook Model (Nir Eyal): Trigger → Action → Variable Reward → Investment
- Fogg Behavior Model: Motivation × Ability × Prompt
- Daily active patterns (DAU optimization)
- Session length optimization
- Return triggers (notifications, emails)
- Churn prediction et re-engagement

### 1.6 Social Features
- Social proof patterns (X users online, Y people bought this)
- Activity feeds design
- Reactions & likes systems
- Comments UX (threading, moderation)
- Share sheets (native vs custom)
- Invite flows et viral loops

---

## PARTIE 2: TABLES & DATA GRIDS (15-20 pages)

### 2.1 Table Anatomy
- Column widths: min/max, auto-sizing, user-resizable
- Row heights: compact (32-36px), default (40-48px), comfortable (52-64px)
- Header design: sticky, sortable indicators, filter icons
- Cell alignment: numbers right, text left, dates center
- Zebra striping vs dividers vs whitespace
- Density controls (compact/default/comfortable toggle)

### 2.2 Sorting & Filtering
- Sort indicators (arrows, highlighting)
- Multi-column sort
- Filter UI: inline dropdowns, filter bar, sidebar
- Filter chips with clear/remove
- Saved filters / views
- Search within table

### 2.3 Selection & Actions
- Single row selection (click, radio)
- Multi-select (checkboxes, shift+click range)
- Select all (page vs all data)
- Bulk action toolbar (apparition, position)
- Row actions: inline icons vs menu vs hover reveal
- Confirmation pour bulk destructive actions

### 2.4 Pagination & Loading
- Pagination vs infinite scroll vs "Load more"
- Page size options (10, 25, 50, 100)
- "Showing X-Y of Z" pattern
- Loading states (skeleton rows, spinner overlay)
- Empty state dans table

### 2.5 Responsive Tables
- Horizontal scroll avec sticky first column
- Column priority (hide less important on mobile)
- Collapse to cards pattern
- Expandable rows
- Touch-friendly row actions (swipe, long press)

### 2.6 Inline Editing
- Click to edit vs double-click vs edit mode
- Cell validation
- Save: auto-save vs explicit save button
- Cancel/revert
- Keyboard navigation (Tab, Enter, Escape)

### 2.7 Accessibility
- Proper `<table>` semantics vs CSS grid
- `scope` et `headers` attributes
- Keyboard navigation (arrow keys)
- Screen reader announcements pour sort/filter
- Focus management

---

## PARTIE 3: SETTINGS & PREFERENCES (15-20 pages)

### 3.1 Settings Architecture
- Grouping: by function, by frequency, by workflow
- Hierarchy depth (max 2-3 levels recommandé)
- Search in settings (essential pour apps complexes)
- Settings vs Preferences vs Configuration vs Admin

### 3.2 Control Types

| Setting Type | Best Control | Example |
|--------------|--------------|---------|
| On/Off | Toggle/Switch | "Enable notifications" |
| One of few | Radio / Segmented | "Theme: Light/Dark/System" |
| One of many | Dropdown / Picker | "Language: [list]" |
| Range | Slider | "Volume: 0-100" |
| Precise number | Stepper / Input | "Font size: 14px" |
| Multiple selection | Checkboxes | "Show days: Mon, Tue, Wed..." |

### 3.3 Toggle vs Checkbox
- Toggle: immediate effect, binary state, mobile-friendly
- Checkbox: part of form, requires save, can be indeterminate
- Toggle size: iOS 51×31pt, Android 52×32dp, Web 44×24px min

### 3.4 Immediate vs Explicit Save
- Immediate: toggles, simple preferences, non-destructive
- Explicit save: forms, dangerous settings, multi-field changes
- Auto-save avec indication "Saved" / "Saving..."

### 3.5 Destructive Settings
- Account deletion (GDPR: must be possible, can have friction)
- Data export before deletion
- Confirmation patterns: type to confirm, countdown, checkbox
- Cooling-off period option
- Clear "this cannot be undone" warning

### 3.6 Privacy Settings
- Layered approach (summary + details)
- Plain language (pas de jargon légal)
- Granular controls groupés logiquement
- Default to privacy (opt-in vs opt-out)
- "What this means" explanations

### 3.7 Notification Preferences
- Channel grouping: Push, Email, SMS, In-app
- Category grouping: Marketing, Updates, Activity, Security
- Frequency options: Real-time, Daily digest, Weekly digest, Off
- "Pause all" / "Do not disturb" schedule
- Test notification button

### 3.8 Default Values
- Safe defaults (privacy-respecting, non-intrusive)
- Smart defaults (based on user segment, locale)
- "Reset to defaults" option
- Onboarding: ask key preferences upfront vs discover later

---

## PARTIE 4: SEARCH UX (15-20 pages)

### 4.1 Search Input Design
- Placement: header (global), in-page (contextual)
- Width: 200-600px desktop, full-width mobile
- Placeholder: "Search..." vs "Search products, articles..." (specific)
- Icon position: left (standard) vs right (less common)
- Clear button (X): appears when text present

### 4.2 Search Activation
- Click to expand vs always visible
- Keyboard shortcut: Cmd/Ctrl+K (spotlight pattern), / (vim pattern)
- Focus behavior: auto-select all text, cursor at end

### 4.3 Instant Search vs Submit
- Instant: results as you type (debounce 150-300ms)
- Submit: Enter or button required
- Hybrid: suggestions instant, full results on submit
- Loading indicator position

### 4.4 Autocomplete & Suggestions
- Sources: recent searches, popular, personalized, content preview
- Max suggestions: 5-10 items
- Highlight matching text (bold query terms)
- Keyboard navigation: arrows, Enter to select, Escape to close
- Category grouping dans suggestions

### 4.5 Search Results Page
- Result count: "X results for 'query'"
- Result card anatomy: title, snippet, metadata, thumbnail
- Query highlighting in results
- Sorting options: relevance, date, popularity
- Filters: sidebar (desktop), sheet/drawer (mobile)

### 4.6 No Results State
- Friendly message: "No results for 'xyz'"
- Suggestions: check spelling, try different keywords
- Related content / popular items
- Contact support option
- Clear search to start over

### 4.7 Spell Correction
- "Did you mean: [corrected query]?" (clickable)
- Auto-correct with "Showing results for X. Search instead for Y"
- Fuzzy matching for typos

### 4.8 Voice Search
- Microphone icon placement
- Permission request UX
- Listening state feedback
- Transcription display
- Fallback if no speech detected

### 4.9 Faceted Search / Filters
- Filter sidebar: collapsible sections, counts
- Active filters: chips above results, easy clear
- Filter combinations: AND vs OR logic
- Mobile: filter button → full sheet
- "Clear all filters" always visible

### 4.10 Search Analytics (for devs)
- Track: queries, results count, click-through, zero results
- Identify gaps in content
- Popular queries optimization

---

## PARTIE 5: LOADING & PERFORMANCE UX (15-20 pages)

### 5.1 Response Time Thresholds
- 0-100ms: Instant (no feedback needed)
- 100-300ms: Slight delay (subtle indicator OK)
- 300ms-1s: Noticeable (spinner or skeleton)
- 1-10s: Long (progress indicator, explanation)
- 10s+: Very long (background task, notification when done)

### 5.2 Skeleton Screens
- Anatomy: shapes mimicking content layout
- Animation: shimmer left-to-right, pulse, none
- Colors: light gray (#E0E0E0) on white, darker on dark mode
- When to use: content layout known, <3s load
- When NOT to use: unknown layout, very fast loads

### 5.3 Spinners
- Types: circular (most common), linear (progress), dots
- Size: 16-24px inline, 32-48px page-level
- Placement: center of loading area, inline with trigger
- When to use: indeterminate wait, action feedback

### 5.4 Progress Indicators
- Determinate: file upload, multi-step process, known duration
- Indeterminate: unknown duration, background task
- Percentage display: optional, can cause anxiety if stuck
- Cancel option for long operations

### 5.5 Optimistic UI
- Pattern: update UI immediately, sync in background
- Use cases: likes, saves, adds to list, simple toggles
- Failure handling: revert + error toast
- Visual indicator: subtle pending state (opacity, icon)

### 5.6 Lazy Loading
- Images: placeholder → load on scroll (Intersection Observer)
- Components: code-splitting, dynamic imports
- Data: pagination, infinite scroll
- "Load more" button vs auto-load

### 5.7 Perceived Performance Tricks
- Start animations immediately
- Progressive image loading (blur-up, LQIP)
- Preload likely next actions
- Optimistic navigation (start transition before data ready)
- Skeleton > spinner (feels faster)

### 5.8 Offline & Error States
- Offline indicator (banner, icon)
- Cached content availability
- Queue actions for sync
- Retry mechanism
- "Last updated X ago"

---

## PARTIE 6: DARK MODE (10-15 pages)

### 6.1 Color System for Dark
- Surface colors (Material Design):
  - 0dp: #121212
  - 1dp: #1E1E1E
  - 2dp: #222222
  - 3dp: #242424
  - 4dp: #272727
  - 6dp: #2C2C2C
  - 8dp: #2E2E2E
  - 12dp: #333333
  - 16dp: #363636
  - 24dp: #383838

### 6.2 Text on Dark Backgrounds
- Primary text: #FFFFFF at 87% opacity (or #E0E0E0)
- Secondary text: #FFFFFF at 60% opacity (or #A0A0A0)
- Disabled text: #FFFFFF at 38% opacity
- Never pure white on pure black (too harsh)

### 6.3 Accent Colors in Dark Mode
- Reduce saturation légèrement
- Increase brightness pour contraste
- Test WCAG contrast on dark surface
- Brand colors may need dark variants

### 6.4 Elevation in Dark Mode
- Higher elevation = lighter surface (inverted from light mode)
- Use surface color, NOT shadows (shadows invisible on dark)
- Subtle border option (1px rgba(255,255,255,0.12))

### 6.5 Images & Media
- Reduce image brightness slightly in dark mode
- Avoid pure white images (use off-white, add dark mode variants)
- Videos: no change needed usually
- Illustrations: provide dark mode variants

### 6.6 Implementation
```css
/* System preference detection */
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #121212;
    --text: #E0E0E0;
  }
}

/* Manual toggle with class */
.dark-mode {
  --bg: #121212;
  --text: #E0E0E0;
}

/* Smooth transition */
:root {
  transition: background-color 0.3s, color 0.3s;
}
```

### 6.7 User Preference
- Options: Light / Dark / System
- Remember choice (localStorage, user profile)
- Sync across devices if logged in
- System = follow OS setting
- Schedule option (dark at night)

### 6.8 Platform Specifics
- iOS: `UIUserInterfaceStyle`, SF Symbols adapt automatically
- Android: `DayNight` theme, Material You dynamic colors
- Web: CSS variables + `prefers-color-scheme`

---

## PARTIE 7: MODALS, SHEETS & OVERLAYS (10-15 pages)

### 7.1 Modal Types

| Type | Use Case | Dismissal |
|------|----------|-----------|
| Alert/Dialog | Critical info, confirmation | Buttons only |
| Modal | Forms, complex content | X button, outside click optional |
| Bottom Sheet | Mobile actions, filters | Swipe down, X, outside tap |
| Drawer | Navigation, panels | X, outside click, swipe |
| Popover | Contextual info, menus | Outside click, Escape |
| Toast | Feedback, status | Auto-dismiss, optional action |

### 7.2 Modal Sizing
- Small: 400px max (alerts, confirmations)
- Medium: 600px max (forms, content)
- Large: 800px max (complex content)
- Fullscreen: mobile default, desktop option
- Max-height: 90vh with internal scroll

### 7.3 Bottom Sheets (iOS/Android)

**iOS Detents:**
- Small: ~25% of screen
- Medium: ~50% of screen
- Large: ~90% of screen
- Custom heights possible

**Android:**
- Standard: content-sized
- Modal: blocks interaction behind
- Expanding: drag to resize

### 7.4 Overlay Backgrounds
- Scrim color: black at 50-60% opacity
- Click outside to dismiss: optional, disable for critical actions
- Scroll lock on body

### 7.5 Animation
- Entry: fade + slide up (200-300ms)
- Exit: fade + slide down (150-200ms)
- Easing: ease-out for entry, ease-in for exit
- Scale: optional subtle (0.95 → 1.0)

### 7.6 Multi-step Modals
- Progress indicator (steps, dots, progress bar)
- Back button within modal
- State preservation on back
- Exit confirmation if dirty state
- "Step X of Y" text

### 7.7 Accessibility
- Focus trap: Tab cycles within modal
- Initial focus: first interactive element or close button
- Escape key closes modal
- Return focus to trigger on close
- `role="dialog"` + `aria-modal="true"`
- `aria-labelledby` pointing to title

### 7.8 Mobile Considerations
- Bottom sheets preferred over center modals
- Full-screen modals for complex forms
- Swipe to dismiss (with threshold ~100px)
- Safe area padding

---

## PARTIE 8: ANIMATIONS & MICRO-INTERACTIONS (10-15 pages)

### 8.1 Timing Standards

| Category | Duration | Use Case |
|----------|----------|----------|
| Instant | 50-100ms | Button press, toggle |
| Fast | 100-200ms | Hover, focus, small reveals |
| Medium | 200-400ms | Page transitions, modals |
| Slow | 400-700ms | Complex reveals, celebrations |

### 8.2 Easing Functions
- **ease-out** (decelerate): entering elements, modals opening
- **ease-in** (accelerate): exiting elements, modals closing
- **ease-in-out**: elements that stay on screen, moving
- **linear**: progress bars, continuous motion
- **spring**: iOS default, bouncy feel

### 8.3 CSS Spring Approximations
```css
/* iOS-like spring */
transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);

/* Subtle bounce */
transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
```

### 8.4 Common Micro-interactions
- Button press: scale(0.95-0.98), background darken
- Toggle: slide + color change
- Checkbox: scale bounce + checkmark draw
- Like/heart: scale pop + color + optional particles
- Add to cart: fly-to-cart animation
- Delete: fade + collapse
- Reorder: drag shadow + insertion indicator

### 8.5 Page Transitions
- Fade: simple, safe default (200-300ms)
- Slide: horizontal (navigation), vertical (hierarchy)
- Shared element: item → detail (complex but powerful)
- Crossfade: image galleries

### 8.6 Loading Animations
- Spinner: rotation (1-1.5s per rotation)
- Skeleton shimmer: 1.5-2s sweep
- Dots: bounce or pulse pattern
- Progress: smooth increment

### 8.7 Celebration Animations
- Confetti: achievement unlocks, purchases
- Checkmark: task completion
- Scale pulse: success feedback
- Particle burst: rewards
- **Restraint**: use sparingly, user can disable

### 8.8 Reduced Motion
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```
- Respect user preference
- Fade OK, motion not OK
- Essential animations: simplify, don't remove

---

## PARTIE 9: ONBOARDING & FIRST-RUN UX (10-15 pages)

### 9.1 Onboarding Types
- **Feature tour**: carousel of benefits (risky, often skipped)
- **Progressive**: learn as you go, contextual hints
- **Empty state**: teach through first-use prompts
- **Interactive tutorial**: guided first task
- **Video walkthrough**: passive, low retention

### 9.2 Best Practices
- Time to value: <60 seconds to first success
- Skip option always available
- Max 3-5 screens if carousel
- Show, don't tell (interactive > text)
- Personalization early (ask 1-3 questions)

### 9.3 Permission Requests

**iOS:**
- Ask in context (e.g., camera when user taps photo)
- Pre-permission screen explaining why
- If denied: explain how to enable in Settings
- Required permissions: ask at appropriate moment

**Android:**
- Runtime permissions since Android 6.0
- Rationale screen before system dialog
- Handle "Don't ask again" gracefully

### 9.4 Permission Timing
| Permission | When to Ask |
|------------|-------------|
| Push notifications | After first value moment, not immediately |
| Location | When needed for feature |
| Camera/Photos | When user initiates action |
| Contacts | When user wants to invite/share |
| Biometrics | During security setup |

### 9.5 Account Creation
- Defer until necessary ("try before you sign up")
- Social login options: Google, Apple, Facebook
- Email: verify later, not blocking
- Password requirements: show upfront, real-time validation
- Single sign-on for enterprise

### 9.6 Empty States as Onboarding
- Title: what this area is for
- Description: why it's valuable
- CTA: clear action to populate
- Illustration: optional, adds personality
- Example: "No projects yet. Create your first project to get started."

### 9.7 Progressive Disclosure
- Coach marks / tooltips: point to UI elements
- Hotspots: pulsing indicators on new features
- One tip at a time, not overwhelming
- Dismissible, remembers dismissed state
- Re-accessible via help menu

### 9.8 Return User Experience
- "Welcome back" (not re-onboarding)
- Show what's new (if significant updates)
- Restore previous state
- Smart suggestions based on history

### 9.9 Re-engagement
- Dormant user email sequence
- Win-back notifications (careful with frequency)
- Incentives to return (time-limited offers)
- "We miss you" messaging (can feel manipulative)

---

## FORMAT DE RÉPONSE SOUHAITÉ

Pour chaque pattern:

```markdown
### [Nom du Pattern]

| Platform | Value | Source |
|----------|-------|--------|
| Web | [value] | [source] |
| iOS | [value] | [source] |
| Android | [value] | [source] |

**Apps utilisant ce pattern:** [App1], [App2], [App3]

**Quand utiliser:**
**Quand éviter:**

**Checklist:**
- [ ] Point 1
- [ ] Point 2

**Code (si applicable):**
```

---

## SOURCES PRIORITAIRES
- Apple Human Interface Guidelines 2024-2026
- Google Material Design 3 2024-2026
- Nielsen Norman Group 2023-2026
- Baymard Institute (e-commerce)
- Laws of UX (lawsofux.com)
- Mobbin (real app patterns)
- Refactoring UI
- Linear App design system
- Stripe design system
- Vercel Geist design system
- Game design / behavioral economics literature

---

## OBJECTIF
Document de ~100 pages avec valeurs CONCRÈTES couvrant Web + iOS + Android. Patterns universels applicables à tout type d'application. Pas de généralités - spécifications précises et actionnables.
