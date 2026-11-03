# Adlyee – Architecture Guide

Flutter app, clean-architecture layout, `flutter_bloc` + `get_it/injectable` + `dartz` (Either) + `freezed`.
Package name is `solofy_vendor_app` (all imports use `package:solofy_vendor_app/...`).

## 1. Folder map – where does my code go?

```
lib/
├─ main.dart                       App entry: DI, providers, MaterialApp, routes
├─ presentation/                   UI ONLY (screens + widgets). No API calls here.
│  ├─ splash/
│  │  ├─ splash_screen.dart        Screen 1
│  │  └─ auth/                     Screens 2-4 (the Figma "Splash" flow)
│  │     ├─ mobile_login_screen.dart
│  │     ├─ otp_verification_screen.dart
│  │     ├─ user_details_screen.dart
│  │     └─ widgets/               Widgets used ONLY by the auth screens
│  │        ├─ auth_scaffold.dart  Blue bg + logo + "Welcome To Adlyee" + bottom card slot
│  │        ├─ auth_card.dart      White card: title + content
│  │        └─ country_code_prefix.dart
│  └─ widgets/                     COMMON widgets – reuse everywhere
│     ├─ custom_material_button.dart  (existing) bare tap wrapper
│     ├─ primary_button.dart       Blue button (loading state)
│     ├─ text_link_button.dart     Underlined text action
│     ├─ custom_text_field.dart    Rounded filled TextFormField
│     ├─ pattern_background.dart   Blue bg with faint bands
│     └─ app_logo.dart             Tinted SVG logo
├─ application/                    App logic + app-wide helpers
│  ├─ bloc/<feature>_bloc/         Bloc, events, states (freezed)
│  └─ core/
│     ├─ route/app_route.dart      ALL routes + navigation helpers
│     ├─ theme/                    colors.dart, text_styles.dart, diamentions.dart, app_theme.dart
│     ├─ service/                  dio_client, helpers, pickers, socket...
│     └─ utils/                    constants, string_file, validators, enums, app_assets, extentions
├─ domain/                         Pure Dart: contracts + models
│  ├─ bloc/<feature>/              i_<feature>_facade.dart (interface) + models/
│  └─ core/                        failures, value objects, DI setup
└─ infrastructure/<feature>/       <feature>_facade_impl.dart – talks to the API (Dio)
```

Dependency direction: `presentation → application → domain ← infrastructure`.

## 2. Rules the team follows

| Need | Use | Never |
|---|---|---|
| Colour | `ColorResources.x` (`theme/colors.dart`) | `Color(0xFF...)` in a screen |
| Text style | `baseTextStyle.s14.w500.white` or `context.textStyle1.s14` | raw `TextStyle(fontSize: ..)` |
| Spacing | `gap8`, `gap16`, `defaultPadding`... (`theme/diamentions.dart`) | `SizedBox(height: ..)` for plain gaps |
| Text in UI | `StringFile.x` | hard-coded strings in widgets |
| Limits / numbers | `AppConstants.x` | magic numbers |
| Validation | `Validators.x` (returns message or null) | inline regex in screens |
| Images | `AppAssets.x` | string paths in widgets |
| Navigation | `AppRoute.pushNamed(Screen.routeName, arguments: {...})` | `Navigator.push(...)` |
| Toast / alert | `CustomAlertDialog.showCustomDialog(...)` | `ScaffoldMessenger` snackbars |

If a widget is needed in 2+ screens, move it into `presentation/widgets/`.
If it is only for one feature, keep it in `<feature>/widgets/`.

## 3. How to add a new screen (checklist)

1. Create `presentation/<feature>/<name>_screen.dart` with `static const routeName = '<kebab-name>';`.
2. Add a `case <Name>Screen.routeName:` in `AppRoute.onGenerateRoute` (read arguments from the `arguments` map).
3. Add any text to `StringFile`, numbers to `AppConstants`, validators to `Validators`.
4. Build the UI from common widgets first (`PrimaryButton`, `CustomTextField`, ...). Only create a new widget if none fits.
5. Navigate with `AppRoute.pushNamed(...)`.

## 4. How to add an API feature (auth is the template)

1. `domain/bloc/<feature>/i_<feature>_facade.dart` – abstract methods returning `ResultFuture<T>`.
2. `domain/bloc/<feature>/models/` – freezed + json models.
3. `infrastructure/<feature>/<feature>_facade_impl.dart` – `@LazySingleton(as: I...)`, uses `DioClient` + `Urls`.
4. `application/bloc/<feature>_bloc/` – events/state with `ApiStatus` per call.
5. Run `dart run build_runner build --delete-conflicting-outputs`.
6. Provide the bloc in `main.dart` (`BlocProvider(create: (_) => sl<XBloc>())`) and listen in the screen.

## 5. Auth flow (Figma frames 1-4)

```
SplashScreen ──2s──▶ MobileLoginScreen ──Send OTP──▶ OtpVerificationScreen ──Confirm──▶ UserDetailsScreen ──Confirm──▶ Home
   (splash)             "Continue As Guest" ──▶ Home          (30s resend timer)              (name, email, pincode)
```

Screens 2-4 are the same layout: `AuthScaffold(card: AuthCard(title: ..., child: ...))`.
Only the card content changes – so a new auth step is ~30 lines.

## 6. Status / TODOs for the team

- UI for the 4 screens is done; validation and navigation work.
- `TODO(auth)` markers in the screens show exactly where `AuthBloc` events plug in
  (the bloc / facade files under `application/bloc/auth_bloc`, `domain/bloc/auth`,
  `infrastructure/auth` are currently commented-out templates – enable and adapt them to the real API).
- `TODO(home)`: Home screen does not exist yet; "Continue As Guest" and the final "Confirm" show a "Coming soon" alert.
- `assets/images/svgs/logo.svg` is a **placeholder** – replace with the real logo exported from Figma (same file name).
- `main.dart`: the version-check gate (`LifecycleGate`) and connectivity wrapper were removed because their
  sources/packages (`package_info_plus`, `flutter_screenutil`) are not in the project. Re-add when enabled.
