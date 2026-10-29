# Aisle

A small catalogue store built on the [DummyJSON](https://dummyjson.com) API: sign in, browse products, open a product.

**Test account:** `emilys` / `emilyspass`

## Running it

Requires Flutter 3.44 (Dart 3.12) or newer.

```bash
flutter pub get
flutter run
```

## What's in the app

| Brief | Where |
|---|---|
| Login (`POST /auth/login`), token stored securely | Sign In screen. Access and refresh tokens plus the profile go to the Keychain (iOS) / encrypted storage (Android). |
| Product list (`GET /products`) with loading, error and empty states | Discover screen. Per-section skeletons, a full error state only when nothing can be shown, an empty state, and a separate "no matches" state for search. |
| Pull-to-refresh and pagination | 20 products per page, loaded as the grid nears its end. A failed page shows an inline Retry and keeps what's already loaded. |
| Product detail | Opens from any product with a shared-element image transition. |

Beyond the brief:
- a welcome screen
- search, categories and today's biggest discounts (all real DummyJSON endpoints)
- sign out from the avatar menu
- a session check on launch

The Apple and Google buttons on Sign In are visual only and say "coming soon", because DummyJSON has no social login. The share button on the product page is visual only too.

## Architecture

Feature-first clean architecture, laid out the same way as our other Flutter apps so the codebase feels familiar to the team:

```
lib/
  core/
    api/        Dio client, auth interceptor, Result and Failure types
    enums/      StatusIndicator
    models/     UserSession
    services/   secure storage, navigation
    theme/      colours, typography, ThemeData
    utils/      constants (spacing, radii, durations), category styling, formatting
    widgets/    shared Aisle* widgets (button, text field, skeleton, network image…)
  screens/<feature>_screen/
    data/        models and the remote repository implementation
    domain/      repository contract and one use case per call
    presentator/ bloc (event, state), view, widgets (one widget per file)
```

Features: `route_screen` (start-up check), `welcome_screen`, `sign_in_screen`, `discover_screen`, `product_detail_screen`.

The detail screen has no data layer. It receives the product already loaded in the list, so it opens instantly and needs no loading state of its own.

### State management: flutter_bloc

- **Why bloc:** every user action is an explicit event and every screen state is a plain object. That makes the flows easy to follow and to test. Bloc is also what the team already uses.
- **Status:** each state carries a `StatusIndicator`. Discover tracks the initial load, the next page, categories and deals separately, so one failing section never blanks the others.
- **Stale responses:** every grid reset (search, category, retry) gets a request id. A late response for a search or category the user has already left is dropped, so the grid always matches the latest choice.
- **Search** is debounced (400ms) in the view. Search and category are mutually exclusive, because DummyJSON can't combine them.

### Networking

- **`DioClient`:** a singleton that maps every `DioException` to a typed `Failure` (network, validation, unauthorised, server) with a readable message.
- **Repositories** return `Result<T>`, and blocs handle both outcomes with `fold`.
- **`AuthInterceptor`** attaches the bearer token only to requests that ask for it.

### Session and token storage

- **Storage:** tokens are kept with `flutter_secure_storage`, which uses the iOS Keychain and Keystore-backed encryption on Android. They are never kept in plain preferences.
- **On launch:** the saved token is checked with `GET /auth/me`. Any HTTP rejection clears the session and returns to Welcome: DummyJSON answers 401 for an expired token but 500 for a malformed one. Only when the server can't be reached (offline or timeout) does the user still get in, and the list then shows its own offline state.
- **Not implemented: token refresh.** DummyJSON tokens last 60 minutes; after that, the next launch asks the user to sign in again. A refresh-token flow (`POST /auth/refresh`) is the natural next step.

## Design and UX decisions

- **Original brand.** Colours come from a pistachio: shell cream, kernel green, plum skin, golden stars, and olive-brown text instead of black. Body text, headings, buttons and links pass WCAG AA contrast. The light grey used for placeholders, small captions, dates and footnotes (`#A39E8C`, 2.6:1) does not; see the next steps below.
- **Products on colour.** Every product sits on a soft tint picked by category, so the same product keeps its colour from the grid to the detail stage.
- **Nothing jumps.** Fixed control heights (56), a reserved line for error messages, two-line titles reserved on every tile, skeletons with the exact final geometry, fixed-size image boxes, and fixed-width digits for prices. Loading, errors and new data never shift the layout.
- **Images:** `cached_network_image` keeps photos on disk, with a shimmer skeleton while they load. On the detail page, the small cached thumbnail shows instantly and the sharp image fades in over it.
- **Motion:** a collapsing, parallax header on Discover and on the detail page; shared-element image transitions; light haptics on key actions; and reduced-motion support on the Welcome wall.
- **Platform menus:** the avatar opens a native-style menu on each platform (`CupertinoMenuAnchor` on iOS, `MenuAnchor` on Android).

## Notes on the data

- DummyJSON's `price` is the list price. The selling price shown is the list price minus `discountPercentage`, with the list price struck through.
- 92 of 194 products have no brand, so brand is optional throughout.
- Weight and dimensions come without units and are synthetic values, so they are shown as raw numbers rather than with guessed units.

## Packages

| Package | Why |
|---|---|
| `flutter_bloc` | State management |
| `dio`, `pretty_dio_logger` | HTTP client with interceptors; request logging in debug builds only |
| `flutter_secure_storage` | Encrypted token storage |
| `cached_network_image` | Disk-cached product images with placeholders |
| `google_fonts` | Plus Jakarta Sans and Inter |

## What I'd do next

- Unit tests for the blocs against a fake repository, plus widget tests for the list states (the repo has no tests yet).
- A token refresh flow.
- Bundle the two fonts as assets instead of fetching them on first launch.
- Dark mode (the colour tokens are already defined in the design spec).
- A full accessibility pass: darken the light caption grey to reach AA, add screen-reader labels, and check large text sizes.
