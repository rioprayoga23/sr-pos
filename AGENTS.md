# SR-POS Repository Instructions

These rules apply across the repository and must be followed for every
implementation, refactor, review, and bug fix. Do not weaken or deviate from
them unless the user explicitly instructs you to do so.

## Sources of truth

- For structure and dependencies, follow `docs/architecture.md`.
- For UI work, follow `docs/design_system.md` and
  `docs/component_catalog.md`.
- The authoritative design-system API is the public barrel
  `lib/core/design_system/design_system.dart` and its actual implementation.
- Read the relevant documents before changing an area. If the documentation
  conflicts with the actual code, do not guess or create a new contract; report
  the discrepancy and ask the user to decide.

## UI and core rules

1. Code in `lib/app/**` and `lib/features/**` must import the design system
   only through:

   ```dart
   import 'package:sr_pos/core/design_system/design_system.dart';
   ```

   Do not deep-import component files, category barrels, internal helpers, or
   the `components/shared` directory. Deep imports are allowed only within the
   core implementation and tests/previews that specifically exercise internals.

2. Before writing UI, inspect `docs/component_catalog.md` and the public barrel.
   If a suitable `Sr*` component or variant already exists, you must use it.
   For example, use `SrButton`, `SrTextField`, `SrSearchBar`, `SrCard`,
   `SrIcon`, `SrLoader`, and other `Sr*` components instead of raw
   Material/Cupertino widgets or custom-built visuals.

3. Flutter layout primitives may be used when core has no equivalent, such as
   `Scaffold`, `SafeArea`, `Row`, `Column`, `Flex`, `Expanded`, `Padding`,
   `SizedBox`, `Align`, `Stack`, `Sliver*`, and builders. These primitives may
   only arrange screens and `Sr*` components; do not use them to recreate the
   visuals or behavior of components already available in core. `Text` may be
   used because there is no `SrText`, but it must inherit the theme or use a
   role from `SrTypography`.

4. All visual decisions must come from core: semantic `ColorScheme`/theme
   extensions, `SrTypography`, `SrSpacing`, `SrSizing`, `SrRadii`, `SrBorders`,
   and `SrMotion`. Outside core, do not add literal hex/colors, `Colors.*`, ad
   hoc `TextStyle`, spacing, radii, borders, icon sizes, or motion values for
   styling. Truly screen-specific layout constraints may be private named
   constants when no matching token exists.

5. Do not use `SrColors` primitives directly in screens/features. Use the
   semantic theme. Temporary design values must be centralized, marked with an
   `assumption` comment, and must not be scattered as literals.

## Custom component approval gate

- By default, **do not create** reusable UI components, feature-specific visual
  components, new `Sr*` components, variants, tokens, or wrappers that establish
  a new visual contract.
- A screen/page requirement does not by itself authorize a custom component.
  Authorization is valid only when the user explicitly requests or approves
  that component for the current task.
- If the core catalog cannot meet a requirement, stop that part of the UI and
  report the missing component/variant, its required behavior, and the closest
  existing `Sr*` component. Wait for the user's direction; do not silently use a
  raw widget as a substitute.
- Private widgets may only split screen structure and compose layout
  primitives with `Sr*` components. They must not introduce new visuals,
  interaction patterns, or reusable APIs.
- Existing custom components may be used, but their visual and interactive
  contents must still be composed from core APIs.
- Once the user authorizes a component, place cross-screen components in
  `core/design_system` with the `Sr` prefix, and feature-specific compositions
  in `features/<feature>/presentation/widgets`. Continue to use core tokens,
  accessibility baselines, the public barrel, and documentation. Tests and
  previews may be created temporarily for verification, but must be removed
  before the work is declared complete.

## Required architecture

- Preserve feature-first MVVM:

  ```text
  lib/
  ├── app/                         # composition root and navigation
  ├── core/design_system/          # shared UI, theme, and tokens
  └── features/<feature>/
      ├── data/                    # repository implementations and data sources
      ├── domain/                  # immutable models and repository contracts
      └── presentation/            # screens, view models, state, and widgets
  ```

- `presentation` may depend on `domain` and the public design system, but must
  not import concrete repositories or data sources.
- `data` implements contracts from `domain` and must not depend on
  `presentation`.
- `domain` must remain free of Flutter UI and infrastructure details.
- `app` is the composition root: create concrete dependencies there and inject
  them through constructors. Do not use a global service locator.
- Views only render state and forward events. Loading, errors, filtering,
  sorting, data transformations, and interaction/data logic belong in view
  models.
- Preserve the one-way flow repository -> view model -> immutable UI state ->
  view. Collections exposed across layers must be immutable/unmodifiable.
- Preserve the existing `ChangeNotifier` pattern. Do not add state management,
  DI, routing, or architecture frameworks without the user's explicit
  instruction.
- Create services only for real I/O such as APIs, databases, files, or platform
  integration. Do not create empty layers or speculative abstractions.
- Do not change the established folder structure or dependency direction
  without the user's explicit approval.

## Code conventions

- Use package imports instead of relative imports across library files.
- Files/directories use `snake_case`; classes/enums/typedefs use
  `UpperCamelCase`; variables, parameters, and methods use `lowerCamelCase`.
- Keep architectural roles explicit in names such as `Repository`,
  `ViewModel`, `UiState`, and `Screen`.
- Follow all strict analyzer and lint rules in `analysis_options.yaml`.
- Do not add dependencies unless the user explicitly requests or approves them.

## Testing and definition of done

- Tests and previews are temporary. Create them only when useful for verifying
  a change, run verification while the files exist, then remove all test code,
  preview code, preview images/baselines, test screenshots, and directories
  used only for tests/previews before completing the work.
- Do not remove runtime assets or code used by the application merely because
  they are images or use the word `preview` in an accessibility label.
- The final repository must not retain test or preview directories. This also
  applies to goldens and test failure artifacts.
- Format changed files, then run at least:

  ```bash
  flutter analyze --no-pub
  ```

- If temporary tests are created, run `flutter test --no-pub` before removing
  all test files/directories.

- Before declaring a task complete, ensure there are no raw substitutes for
  `Sr*` components, unauthorized custom components, deep design-system imports,
  or dependencies that violate layer direction. If any verification cannot be
  run, explain why honestly.

## Review rules

Treat violations of core usage, unauthorized custom components, and dependency
layer direction as blocking findings. Do not approve or declare an
implementation complete until they are fixed or the user explicitly grants an
exception.
