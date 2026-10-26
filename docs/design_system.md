# SR-POS Design System Extraction

This document is the working reference for implementing the SR-POS design
system from the Figma reference. Values labeled **Figma exact** come from
extracted reference data. Semantic names and implementation rules elsewhere
are SR-POS internal contracts; they do not imply that Figma uses the same
naming.

## Sources

- Figma file: [`kE0ttvjNMBfzLofbm2Bklc`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-)
- Components: [node `6:757`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=6-757)
- Styles: [node `6:464`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=6-464)
- Color: [node `261:8659`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=261-8659)
- Badge: [node `261:6762`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=261-6762)
- Validation screen: [node `283:6138`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=283-6138)

## Extraction status

All component families in the catalog have been inventoried through the Figma
Layers panel and are available as reusable Flutter widgets in
`lib/core/design_system/components`. Primitives, semantic theme, typography,
spacing, radii, sizing, borders, and motion are centralized in
`lib/core/design_system`. The validation screen uses public components through
a single barrel import rather than ad hoc styling.

Visual previews may be created temporarily for inspection during
implementation and must be cleaned up afterward, as described in `AGENTS.md`.

Do not treat the following as Figma-exact values until they have been extracted
directly from the relevant nodes:

- typography line height and letter spacing;
- spacing, grid, radii, border widths, elevation, and shadows;
- icon sizes and touch targets;
- component states and variants;
- motion duration and easing.

If temporary values for these properties are needed during implementation,
mark them with an `assumption` comment, keep them in one centralized token, and
replace them after validation. Do not spread temporary values as literals
through screens or components.

## Colors — Figma exact

Swatch order is preserved from the extracted data. Labels `01`, `02`, and so on
are ordering markers used only in this document; they are not official Figma
names or scales.

| Family | 01 | 02 | 03 | 04 | 05 |
| --- | --- | --- | --- | --- | --- |
| Highlight | `#006FFD` | `#2897FF` | `#6FBAFF` | `#B4DBFF` | `#EAF2FF` |
| Neutral light | `#C5C6CC` | `#D4D6DD` | `#E8E9F1` | `#F8F9FE` | `#FFFFFF` |
| Neutral dark | `#1F2024` | `#2F3036` | `#494A50` | `#71727A` | `#8F9098` |
| Success | `#298267` | `#3AC0A0` | `#E7F4E8` | — | — |
| Warning | `#E86339` | `#FFB37C` | `#FFF4E4` | — | — |
| Error | `#ED3241` | `#FF616D` | `#FFE2E5` | — | — |

### Semantic color rules

1. Store the values above as immutable primitives, such as
   `SrColorPrimitives.highlight01`. This is an SR-POS implementation convention,
   not a Figma name.
2. Components may only use semantic aliases such as `brandPrimary`,
   `textPrimary`, `textSecondary`, `surfaceBase`, `borderDefault`,
   `statusSuccess`, `statusWarning`, or `statusError`.
3. Map semantic aliases to primitives based on the node context and contrast
   results. Do not infer a role from a swatch's position alone.
4. Do not write hex literals in screens or components. All colors must come
   through the theme or tokens.
5. Token names describe a role, not a usage location. Avoid names such as
   `loginBlue`, `homeGrey`, or `cardColor`.

## Typography

The product's default font family is **Poppins**. The size and weight scale
below follows the Figma extraction.

| Category | Style | Weight | Size |
| --- | --- | --- | ---: |
| Heading | H1 | ExtraBold | 24 |
| Heading | H2 | ExtraBold | 18 |
| Heading | H3 | ExtraBold | 16 |
| Heading | H4 | Bold | 14 |
| Heading | H5 | Bold | 12 |
| Body | XL | Regular | 18 |
| Body | L | Regular | 16 |
| Body | M | Regular | 14 |
| Body | S | Regular | 12 |
| Body | XS | Medium | 10 |
| Action | L | SemiBold | 14 |
| Action | M | SemiBold | 12 |
| Action | S | SemiBold | 10 |
| Caption | M | SemiBold | 10 |

The sizes follow the extracted data; Flutter implementation units are logical
pixels. Line height and letter spacing still need to be extracted and must not
be guessed as Figma-exact values.

The following Flutter weight mapping is an implementation decision, not
additional Figma data: Regular → `FontWeight.w400`, Medium → `w500`, SemiBold →
`w600`, Bold → `w700`, and ExtraBold → `w800`.

Use stable role names such as `headingH1`, `bodyM`, `actionL`, and `captionM`.
Screens must not create ad hoc `TextStyle` values when a suitable role already
exists.

## Component catalog

| Family | Inventoried components |
| --- | --- |
| Assets | Icon, Image, File Picker, Video, Avatar |
| Informative | Banner, Toast, Dialog, Tooltip, Badge |
| Control | Button, Content Switcher, Action Sheet, Filter, Tabs |
| Input | Checkbox, Radio Button, Toggle, Star Rating, Slider, Number Input, Text Field, Text Area, Dropdown, Search Bar |
| Navigation | Tab Bar, Nav Bar |
| Content | Tag, List Item, List Title, Divider, Calendar, Accordion, Card |
| Progress | Progress Bar, Pagination Dots, Loader, Stepper |
| Chat | Message Bubble, Message Input |
| Map | Map, Location Pin |
| E-commerce | Shopping Cart Item |
| Device | Overlay, Device Components |

### Figma-confirmed variants

The following list records only names, states, or compositions visible in the
relevant Layers/nodes. It does not define sizes, spacing, radii, or other visual
values that have not been extracted.

- **Button**: Primary, Secondary, and Tertiary. Figma spells the third variant
  `Terciary`; the implementation uses `Tertiary` and retains a note about the
  typo for traceability. SR-POS also provides a `destructive` variant (not a
  Figma variant) with a foreground from semantic `ColorScheme.error` and the
  same text-button layout.
- **Dialog**: 2-button and 3-button variants. `SrDialog` accepts flexible body
  `children` between its title/message and actions, an optional upper-right
  close affordance, compact spacing, and a per-dialog width cap. The default
  maximum width of 640 logical pixels is an implementation assumption for
  tablet/desktop layouts.
- **Badge**: A dot uses an `8 × 8` circle; a one-digit count uses `CircleBorder`
  within `24 × 24` square constraints; longer counts and labels use a pill shape
  with a minimum height of `24`.
- **Content Switcher**: section/item layers and a container; the reference shows
  compositions with 2 to 4 segments.
- **Action Sheet**: `.Action` and `Action Sheet`.
- **Tabs**: `.Tab Item` and `Tabs`.
- **Search Bar**:
  empty state with a placeholder, focused state with text/cursor, and filled
  state with text. The confirmed properties are `Placeholder` and `Text`. All
  text inputs with placeholders (`Text Field`, `Text Area`, `Dropdown`, `Search
  Bar`, and `Message Input`) derive their typography metrics from the active
  value style; the placeholder and label shown inside an empty field use the
  same size/metrics and differ only in semantic color.
- **Card**:
  vertical composition with media/icon/avatar, title, subtitle, description,
  optional tag, and optional button; horizontal composition with
  media/avatar/icon and an optional trailing button/chevron.

Each component provides an intent-based API and gets visual values from the
theme/tokens. Development of a new variant must document:

- anatomy and hierarchy;
- size and density;
- states (`enabled`, `pressed`, `focused`, `disabled`, `loading`, and any other
  states actually shown in the reference);
- Figma property/variant and default value;
- color, typography, radius, spacing, border, and icon tokens used;
- interaction behavior and semantics.

### Sale tablet layout and density

The Sale composition adapts the shell and catalog from the `yosher-pos/pos-fe`
project: a full-width header, icon-and-label navigation rail, horizontal
category filters, search with a recommendation filter, the catalog on the left,
and the order panel on the right. On portrait tablets, the catalog and order
panel stack vertically. The sidebar starts at 208 logical pixels (an
implementation assumption) so labels remain readable in a compact layout, and
can collapse to an 80-logical-pixel icon rail. Transitions respect reduced
motion preferences, and item names remain available for accessibility. The
hide/show button sits inline after the outlet identity.

The `SrComponentSize.small` variant is a density assumption for the Sale
screen, not an extraction of a Figma size. Its spacing is centralized in
`SrComponentMetrics`, and the interaction target remains at least `48 × 48`
logical pixels. Sale order quantity controls and the scroll arrow use a
`32 × 32` logical-pixel visual circle within a `48 × 48` logical-pixel touch
target; the floating arrow appears below the list only when more items can be
scrolled into view.
`SrListItemSelectedStyle.primary` uses the semantic `ColorScheme.primary` /
`onPrimary` pair and a medium radius for the active menu's rounded background;
the `subtle` selected style remains the default.

## Naming and usage in code

The following conventions are SR-POS internal rules:

- prefix public components and tokens with `Sr`, such as `SrButton`,
  `SrTextField`, `SrTypography`, and `SrSemanticColors`;
- use lower camel case for Dart tokens (`headingH1`, `spaceM`) and Upper Camel
  Case for types/widgets (`SrButton`);
- separate primitives from semantic tokens; widgets depend only on semantic
  tokens;
- give each component an intent-/variant-based API instead of colliding
  booleans;
- keep cross-screen components in the design system and compositions used by
  only one feature in that feature;
- derive all visual states from the theme for consistency and maintainability;
- include a source node for each new token, or label it `assumption` until
  validated.

## Accessibility baseline

The following are implementation requirements, not Figma-exact measurements:

- maintain WCAG 2.1 AA minimum contrast: `4.5:1` for normal text and `3:1` for
  large text and important UI elements;
- do not use color as the only indicator for success, warning, error, selected,
  or disabled states; include an icon, label, or shape change;
- provide clear `Semantics` labels, focus order, and keyboard support for
  interactive controls;
- use touch targets of at least `44 × 44` logical pixels; use `48 × 48` when
  following the Material default;
- support text scaling without clipping, and do not lock text component heights
  before checking larger scales;
- associate helper/error text with its input and announce important status
  changes to screen readers;
- respect reduced motion preferences for non-essential animation.

## Checklist before a component is considered ready for use

- The variants and states required by the screen match the Figma node.
- No literal colors or text styles exist outside tokens/theme.
- Assumptions are documented and distinguished from Figma-exact values.
- Semantics, focus, text scaling, and contrast have been checked.
- Key states, semantics, focus, text scaling, and contrast are verified during
  implementation; temporary test/preview artifacts are cleaned up afterward.
