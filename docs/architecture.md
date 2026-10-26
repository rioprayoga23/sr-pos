# SR-POS Architecture

SR-POS uses a feature-first structure with explicit UI, domain, and data
boundaries. This follows Flutter's MVVM guidance while keeping the optional
domain layer limited to stable business contracts and reusable logic.

```text
lib/
├── app/                         # composition root and app-level navigation
├── core/
│   └── design_system/           # tokens, themes, and shared UI components
└── features/
    └── <feature>/
        ├── data/                # repository implementations and services
        ├── domain/              # immutable models and repository contracts
        └── presentation/        # screens, view models, and feature UI
```

## Dependency direction

- Presentation depends on domain contracts, never on concrete data sources.
- Data implements domain repository contracts and owns data-source concerns.
- Domain has no dependency on Flutter UI.
- The app composition root constructs dependencies and injects them through
  constructors.
- Services are introduced only when data comes from an external API, local
  database, file, or platform integration.

## UI state

Each screen has a corresponding view model when it owns interaction or data
logic. Views render state and forward user events; sorting, filtering, loading,
and error handling stay outside widgets. Models exposed across layers are
immutable, and state updates flow in one direction from repositories through
view models to views.

## Temporary verification

Tests and previews may be created temporarily when they help verify a change.
Run verification before cleanup, then remove all test code, preview code,
images/baselines, screenshots, and directories used only for tests or previews
before completing the work. Do not remove runtime assets used by the app. See
`AGENTS.md` for the full agent rules.

## Naming

Files and directories use descriptive `snake_case` names. Classes, enums, and
typedefs use `UpperCamelCase`; variables, parameters, and methods use
`lowerCamelCase`. Architectural roles remain explicit in names such as
`ProductRepository`, `ProductSearchViewModel`, and `ProductSearchScreen`.
