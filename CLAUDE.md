# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Flutter real-time chat application backed by Firebase (Authentication for email/password sign-in, Cloud Firestore for messages). Targets Android, iOS, web, macOS, Linux, and Windows. Dart SDK constraint: `>=2.19.0 <3.0.0`.

## Commands

```bash
flutter pub get                 # install dependencies
flutter run                     # run on the connected device/emulator
flutter run -d chrome           # run on web
flutter analyze                 # static analysis / lint (uses analysis_options.yaml)
flutter test                    # run all tests
flutter test test/widget_test.dart            # run a single test file
flutter test --plain-name "smoke test"        # run a single test by name
flutter build apk               # build Android release
```

Note: `test/widget_test.dart` is still the default Flutter counter template and does **not** match this app — it will fail if run. Replace it before relying on the test suite.

## Architecture

State management uses the **BLoC pattern via Cubits** (`flutter_bloc`). Two cubits are registered globally in `lib/main.dart` through `MultiBlocProvider` and drive the whole app:

- **`AuthCubit`** (`lib/cubit/auth_cubit/`) — wraps `FirebaseAuth` for `logInUser` and `signUpUser`, emitting Login*/Register* loading/success/failure states. Login maps Firebase error codes to user-facing messages.
- **`ChatCubit`** (`lib/cubit/chat_cubit/chat_cubit/cubit/`) — wraps the Firestore `messages` collection. `getMessages()` opens a `snapshots()` stream ordered by `createdAt` and emits `ChatSuccess`; `sendMessage()` optimistically appends a temp `Message` (with `isLoading`) before the Firestore write, then relies on the stream to reconcile.

Navigation is route-based, declared in `lib/main.dart` (`/loginPage`, `/chatPage`, `/signUpPage`; initial route is `/loginPage`). The chat page reads the logged-in email via `ModalRoute.of(context)!.settings.arguments` rather than from `AuthCubit` — the email is passed forward through route arguments.

### Important gotchas

- **Duplicate, unused Bloc:** `lib/bloc/auth_bloc/` (`AuthBloc`) is a hand-written event-driven copy of `AuthCubit` that is **not** registered anywhere. The Cubit in `lib/cubit/auth_cubit/` is the live implementation. Edit the Cubit, not the Bloc, unless intentionally migrating.
- **Firestore field keys** live in `lib/constants.dart`. Note `KEmail = 'id'` — the document field that stores the sender's email is literally named `id`. Message identity (own vs. friend bubble) is decided by string-comparing this email against the route argument.
- **`Message.fromJson`** only reads `message` and `id`; `isLoading`/`isFailed` are local-only UI flags and are not persisted.

## Conventions

- Class names do not follow Dart's UpperCamelCase convention (e.g. `loginView`, `chatPage`, `Signupview`). Match the existing style of the file you are editing.
- Code comments are written in Arabic; this is intentional and expected.
- Firebase config (`lib/firebase_options.dart`, `firebase.json`) is committed and points to project `chat-app-9a13c`.
