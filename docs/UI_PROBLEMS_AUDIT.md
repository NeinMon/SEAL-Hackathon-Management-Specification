# UI Problems Audit

This audit maps the Flutter UI technical checklist to the current SEAL Hackathon Android app.

## Status Summary

| Area | Status | Evidence |
| --- | --- | --- |
| Navigation and login flow | Complete | `GoRouter`, `AppShell`, `RoleGate`, role-based bottom navigation, event detail route by id |
| Responsive layout | Complete | `SafeArea`, `ListView`, `Wrap`, `Expanded`, keyboard-safe login, widget tests for landscape/mobile |
| Reusable widgets | Complete | shared `SealSectionHeader`, `StatusBanner`, `ErrorState`, `EmptyState`, `MetricCard`, `EventNetworkImage`, `StatusPill` |
| State management | Complete | Provider-based auth, events, teams, submissions, scores, notifications, chat |
| Data/API handling | Complete | Supabase services with `AppOperation` timeout/retry and typed model mapping |
| Validation | Complete | email, URL, team name, invite email, score range, required feedback, non-empty chat |
| Image handling | Complete | cached event images have loading placeholder and fallback state |
| Consistent UI system | Complete | shared `SealPalette`, Material 3 theme, consistent cards/buttons/chips |
| Performance | Complete for demo scale | API calls run outside `build`; main data lists use builders; heavy repeated UI is scoped |
| Common Flutter errors | Complete | no `RenderFlex` issues in tested flows; mounted checks before navigation/snackbar |
| User feedback | Complete | snackbars, inline errors, loading indicators, disabled buttons during requests |
| Special states | Complete | loading, empty, error, no-internet/retry, unauthorized, success/message banners |
| Accessibility/usability | Complete | 48px+ buttons, tooltips, proper keyboard types, show/hide password, key Semantics labels |
| UI testing | Complete | unit/model tests and widget flow tests pass, including login validation, events, teams, submit, judge, chat, map |
| Code organization | Complete | `main.dart` is a small entrypoint; app/router/theme live in `app.dart`; shared exports live in `shared.dart`; no Dart `part` files remain |
| Screen-specific flows | Complete | login, events/detail, teams, submit, judge, notifications, chat, map, profile, organizer |

## Completed UI/Flow Fixes

- Added a reusable `EventNetworkImage` with loading placeholder and error fallback.
- Added `cached_network_image` so event banners are cached between loads.
- Replaced Dart `part`/`part of` architecture with normal imports/exports.
- Added `ErrorState` for clear no-internet/retry handling.
- Converted Login to `Form`, `TextFormField`, validators, and `AutofillGroup`.
- Added visible `Back to events` action on Event Detail to make back-stack behavior clear in demo.
- Login supports show/hide password and keyboard-safe scrolling.
- Teams only shows actions that make sense for the current user/team state.
- Submission defaults to `submitted`, auto-fills the latest submission, and shows only the latest record.
- Judge screen lets judges select one submission before scoring instead of rendering the full queue.
- Map prioritizes `Copy address`; external Maps is secondary and confirmed.
- Chat prevents empty/multi-send and keeps messages oldest-to-newest with auto-scroll.
- Notifications use grouped read/unread states and a compact action menu.
- Organizer dashboard includes a `System Status` card for database/API and Provider state demo.
- Events, event detail leaderboard, team roster, notification groups, chat messages, organizer recent lists, and submission history/feedback use builder-based list rendering.
- Judge workflow includes search, score progress, next-unscored navigation, and tablet two-pane layout.
- Event Detail uses a responsive two-pane layout on tablet/large screens.
- Organizer workflow includes user-role review, team detail, submission detail, event close-registration action, and hosted demo reset guidance.
- CI uploads Android debug/release APK artifacts.
- Release signing has a local keystore generation script and Git ignore protection.

## Remaining Outside Current Scope

- Hosted Supabase production/staging setup requires external project credentials.
- Release signing is configured to use `android/key.properties` when a real keystore is provided; the keystore itself must stay outside Git and be managed as a secret.
