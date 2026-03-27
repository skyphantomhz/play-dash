# Play Dash App

Flutter MVP scaffold plan for the Play Dash darts scoring app.

## MVP Scope

- Game modes: 301, 501, Cricket
- Match setup, active game flow, and basic settings
- Scoring engine with X01 bust / checkout rules and Cricket mark tracking
- Local-only persistence for in-progress matches and app settings
- Offline-first implementation

## Tech Decisions

- Framework: Flutter
- State management: Riverpod
- Routing: GoRouter
- Immutable models: Freezed + JSON serialization
- Persistence: local storage for MVP

## Proposed Project Structure

```text
play_dash_app/
  lib/
    app/
      app.dart
      router/
        app_router.dart
      theme/
        app_theme.dart
    core/
      constants/
      errors/
      services/
      utils/
    features/
      home/
        presentation/
      match_setup/
        application/
        domain/
        presentation/
      x01/
        application/
        domain/
        presentation/
      cricket/
        application/
        domain/
        presentation/
      history/
        application/
        domain/
        presentation/
      settings/
        application/
        presentation/
    shared/
      models/
      widgets/
    main.dart
  test/
    unit/
    widget/
  assets/
    images/
    icons/
```

## Architecture Notes

- `app/`: app bootstrap, router, and theme setup
- `core/`: shared utilities and low-level services
- `features/`: feature-first modules to keep rules and UI separated by domain
- `application/`: Riverpod providers, controllers, and orchestration logic
- `domain/`: entities, value objects, rules, and repository contracts
- `presentation/`: pages, widgets, and feature UI state
- `shared/`: reusable UI and app-wide models used across features

## MVP Screens

- Home
- Match setup
- Active X01 match
- Active Cricket match
- Settings

## Routing Plan

- `/`
- `/setup`
- `/match/x01`
- `/match/cricket`
- `/settings`

## Persistence Plan

- Save current in-progress match locally
- Save lightweight user preferences locally
- Keep storage behind a repository interface so it can be replaced later

## Notes

- The interactive dartboard remains part of MVP, but a simpler score-entry fallback can be implemented first if needed to unblock core gameplay.
- This folder currently documents structure and dependencies only. Flutter source files can be added once the SDK is available locally.