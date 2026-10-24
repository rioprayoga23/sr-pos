# SR-POS Component Catalog

Import the complete public design-system API from one entry point:

```dart
import 'package:sr_pos/core/design_system/design_system.dart';
```

| Family | Public components |
| --- | --- |
| Assets | `SrIcon`, `SrImagePlaceholder`, `SrVideoPlaceholder`, `SrAvatar` |
| Informative | `SrBanner`, `SrToast`, `SrDialog`, `SrTooltip`, `SrBadge` |
| Control | `SrButton`, `SrContentSwitcher`, `SrActionSheet`, `SrFilter`, `SrTabs` |
| Input | `SrCheckbox`, `SrRadio`, `SrToggle`, `SrStarRating`, `SrSlider`, `SrNumberInput`, `SrTextField`, `SrTextArea`, `SrDropdown`, `SrSearchBar` |
| Navigation | `SrTabBar`, `SrNavBar` |
| Content | `SrTag`, `SrListItem`, `SrListTitle`, `SrDivider`, `SrCalendar`, `SrAccordion`, `SrCard` |
| Progress | `SrProgressBar`, `SrPaginationDots`, `SrLoader`, `SrStepper` |
| Chat | `SrMessageBubble`, `SrMessageInput` |
| Map | `SrMap`, `SrLocationPin` |
| E-commerce | `SrShoppingCartItem` |
| Device | `SrOverlay`, `SrDeviceFrame` |

Interactive previews live in `lib/core/design_system/previews`. Run them with:

```bash
flutter widget-preview start --web-server --no-pub
```

Visual regression baselines for every family live in
`test/core/design_system/previews/goldens`. They use a fixed DPR of `1` so the
output is deterministic across local and CI environments.

Feature-specific compositions remain inside their feature. For example,
`ProductGridCard` composes `SrCard` and `SrImagePlaceholder` without becoming a
global design-system primitive.
