# Aisle — Flutter test task

**Test login:** `emilys` / `emilyspass`

## How to run

Needs Flutter 3.44 or newer. Check with `flutter --version`.

```bash
# 1. Download the packages
flutter pub get

# 2. Run on a connected phone or simulator
flutter run

# Optional: build an Android APK that installs on any phone
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

---

## 1. Login and secure token

- **What:** a login screen that calls `POST /auth/login`.
- **How:** the token is saved in the phone's built-in vault: Keychain on iPhone, encrypted storage on Android (via `flutter_secure_storage`).
- **Why:** a token works like a password. The vault keeps it encrypted, and normal app storage doesn't.
- **Next launch:** the saved token is checked first.
  - Still valid → straight to the products.
  - Rejected → back to login.
  - No internet → you still get in, and the list explains that you're offline.

## 2. Product list

| State | What the user sees | Why |
|---|---|---|
| Loading | Grey placeholders in the exact shape of the products | Nothing jumps when the real products arrive |
| Error | A clear message and a "Try again" button, only when there's nothing to show | A failed refresh or next page never wipes products already on screen; the user just gets a small "Retry" |
| Empty | A friendly message instead of a blank screen | The user knows it's empty, not broken |
| Pull to refresh | The current list stays visible until the new one arrives | No flash of an empty screen |
| Pagination | 20 products at a time, the next 20 load on their own near the bottom, and a note at the very end | Fast first load, no "load more" button, no endless spinner |
| Search | Tapping the search bar folds the header and sections away, so results appear right under it. Cancel, × or the phone's back button brings everything back | Results are never hidden below the fold, and leaving search returns the user exactly where they were |

## 3. Detail page

- **What:** tapping a product opens its photos, price, stock, details and reviews.
- **How:** it reuses the product already loaded in the list instead of asking the API again.
- **Why:** it opens instantly and can't fail on a second request.

## 4. Structure and decisions

**Architecture: clean architecture, one folder per screen**

```
lib/
  core/                    shared: network, secure storage, theme, reusable widgets
  screens/<screen>/
    data/                  talks to the API
    domain/                what the screen can ask for, one small class per action
    presentator/           what the user sees: logic (bloc), screen (view), parts (widgets)
```

- **Why:** each part has one job. If the API changes, the screens don't; screens can be changed or tested without the network; and anyone can find anything quickly.
- It's more structure than three screens strictly need. That's deliberate: it shows how the app would grow without getting messy.

**State management: BLoC (`flutter_bloc`)**

- **How:** the screen sends an event ("refresh", "load more"), the bloc answers with a state ("loading", "loaded", "empty", "error"), and the screen simply draws that state.
- **Why:**
  - Every state the brief asks for is written down explicitly in one place, so none can be forgotten.
  - The logic stays out of the screen, and it's easy to test.
  - If an older request answers late, it's ignored, so the list never jumps back to old results.
- **Why not `setState`:** it mixes logic into the screen.
- **Why not Provider:** it's fine, but less strict once one screen has many states.

**Packages**

| Package | Why |
|---|---|
| `flutter_bloc` | State management |
| `dio` | Network calls with clear, readable errors |
| `flutter_secure_storage` | Encrypted token storage |
| `cached_network_image` | Photos download once and are reused |
| `google_fonts` | The app's typefaces |

