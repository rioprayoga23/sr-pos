# SR-POS

Flutter POS application with a reusable design system extracted from the
referenced Figma prototyping kit. The current implementation is local-only and
does not integrate a backend.

## Structure

```text
lib/
├── app/                         # composition root
├── core/design_system/          # tokens, themes, components, previews
└── features/product_search/
    ├── data/                    # repository implementations
    ├── domain/                  # models and repository contracts
    └── presentation/            # state, view model, widgets, screen
```

See [architecture](docs/architecture.md), [design system](docs/design_system.md),
and [component catalog](docs/component_catalog.md) for implementation details.
Repository-wide development rules for contributors and Codex sessions live in
[AGENTS.md](AGENTS.md).

## Commands

```bash
flutter run
flutter analyze --no-pub
flutter test --no-pub
flutter widget-preview start --web-server --no-pub
```
