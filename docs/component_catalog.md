# SR-POS Component Catalog

Import the complete public design-system API from one entry point:

```dart
import 'package:sr_pos/core/design_system/design_system.dart';
```

| Family      | Public components                                                                                                                          |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Assets      | `SrIcon`, `SrImagePlaceholder`, `SrFilePicker`, `SrVideoPlaceholder`, `SrAvatar`                                                        |
| Informative | `SrBanner`, `SrToast`, `SrDialog`, `SrTooltip`, `SrBadge`                                                                                  |
| Control     | `SrButton`, `SrContentSwitcher`, `SrActionSheet`, `SrFilter`, `SrTabs`                                                                     |
| Input       | `SrCheckbox`, `SrRadio`, `SrToggle`, `SrStarRating`, `SrSlider`, `SrNumberInput`, `SrTextField`, `SrTextArea`, `SrDropdown`, `SrSearchBar` |
| Navigation  | `SrTabBar`, `SrNavBar`                                                                                                                     |
| Content     | `SrTag`, `SrListItem`, `SrListTitle`, `SrDivider`, `SrCalendar`, `SrAccordion`, `SrCard`                                                   |
| Progress    | `SrProgressBar`, `SrPaginationDots`, `SrLoader`, `SrStepper`                                                                               |
| Chat        | `SrMessageBubble`, `SrMessageInput`                                                                                                        |
| Map         | `SrMap`, `SrLocationPin`                                                                                                                   |
| E-commerce  | `SrShoppingCartItem`                                                                                                                       |
| Device      | `SrOverlay`, `SrDeviceFrame`                                                                                                               |

The tablet Sale layout follows the shell and catalog composition from
`yosher-pos/pos-fe` while rendering with core components. The following
existing components expose `SrComponentSize.small` and `SrComponentSize.medium`
(`medium` remains the default): `SrButton`, `SrContentSwitcher`, `SrListItem`,
`SrDropdown`, `SrNumberInput`, `SrSearchBar`, `SrTextArea`, `SrTextField`, and
`SrShoppingCartItem`. The small density is an assumption derived from the Sale
reference, not a claim about an extracted Figma variant; it reduces visual
padding while preserving the 48 px touch-target baseline.
Helper text on small input fields uses the `SrTypography.bodyExtraSmall` role
and aligns with the outer leading edge of its field.
`SrFilePicker` renders an accessible image/file selection target with optional
image or filename preview; choosing and persisting files are injected by the
consuming feature. Its title and supporting copy use the input-value text role.
The compact cart image uses a 64 × 64 px square surface so it nearly fills the
row height while keeping the lower edge aligned with the quantity controls.

Sale navigation starts expanded at 208 logical pixels (implementation
assumption) so labels remain visible in a more compact width; the toggle in the
top navigation collapses it to an 80-pixel icon rail, preserving the menu items
and their accessible names. Sidebar items begin directly below the app header
without a separate toggle row.

`SrButtonVariant.destructive` uses the semantic `ColorScheme.error` for its
label and icon while retaining the tertiary text-button layout and touch target.
Use it for destructive actions such as removing cart items or clearing an
order; disabled appearance remains controlled by the theme.

`SrNavBar` supports `titleActions` for icon actions placed inline after the
title and `titleTrailing` for content after those actions. Its existing `actions`
remain at the far edge of the bar.

`SrListItemSelectedStyle.primary` is available when a selected navigation row
needs the solid brand-blue surface shown in the Sale reference. It uses the
shared medium radius; the existing `subtle` selected style remains the default.
When a `SrListItem` has a leading icon and an empty title, the icon is centered
across the row for icon-rail navigation; `semanticLabel` can preserve its
accessible name.

`SrDialog` keeps its title and actions while accepting arbitrary body `children`.
It can render an accessible close affordance with `onClose`, use compact spacing,
and accept a per-dialog `maxWidth`; the default maximum width remains 640 logical
pixels (assumption) on wide layouts.

`SrToast` is a compact, top-center notification with semantic tone variants
(`neutral`, `info`, `success`, `warning`, and `error`). `showSrToast` accepts an
optional title, supporting message, core-composed content, action, and dismiss
control so the same component can present short confirmations or richer status
updates. Its compact default composition uses a semantic container and border,
a solid rounded icon tile, one concise high-contrast message, and a trailing
dismiss action. Status glyphs use the same outlined Material icon family as
navigation and sit directly on their semantic tile, giving every tone the same
clean silhouette and breathing room.
`SrComponentSize.small` is the default at every viewport width, from phones and
tablets to laptops and large displays. It uses a 32-pixel icon tile,
12-pixel message, 48-pixel row height, and a 320-pixel maximum reading width,
while preserving the 48-pixel dismiss target. A caller may explicitly request
the medium variant. Toasts remain top-centered, capped in width, and respect
safe-area insets.

Feature-specific compositions remain inside their feature. For example,
`ProductGridCard` composes `SrCard` and `SrImagePlaceholder` without becoming a
global design-system primitive. Sale's `SaleOrderList` composes
`SrShoppingCartItem` with a centered, floating scroll-to-bottom affordance that
appears only while more order items remain below the current position. The
compact quantity controls and floating arrow have a 32 px visual surface within
a 48 px touch target.
In the small cart-item layout, the item name stays left and its per-item label
aligns to the right edge of the same row; long labels truncate independently.
