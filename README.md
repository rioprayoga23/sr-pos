# SR-POS

SR-POS is a Flutter point-of-sale application for processing sales and managing
the product catalog, including ingredient inventory. The app currently uses
local sample data and does not connect to a backend. A shared design system
keeps the interface consistent across its features.

## Structure

```text
lib/
├── app/                         # composition root
├── core/design_system/          # tokens, themes, shared components
└── features/
    ├── product_search/          # product search and catalog
    └── sale/                    # point-of-sale and ingredient inventory
```

See [architecture](docs/architecture.md), [design system](docs/design_system.md),
and [component catalog](docs/component_catalog.md) for implementation details.
Repository-wide development rules for contributors and Codex sessions live in
[AGENTS.md](AGENTS.md).

## Commands

```bash
flutter run
flutter analyze --no-pub
```

Tests and previews are created only temporarily when needed for verification,
then removed before work is completed. See the [agent rules](AGENTS.md).
