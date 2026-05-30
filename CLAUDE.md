# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Flutter real-time chat application backed by Firebase (Authentication for email/password sign-in, Cloud Firestore for messages). Targets Android, iOS, web, macOS, Linux, and Windows. Dart SDK constraint: `>=3.0.0 <4.0.0`.

## Commands

```bash
flutter pub get                 # install dependencies
flutter run                     # run on the connected device/emulator
flutter run -d chrome           # run on web
flutter analyze                 # static analysis / lint (uses analysis_options.yaml)
flutter test                    # run all tests
flutter test test/validators_test.dart        # run a single test file
flutter test --plain-name "rejects empty input"   # run a single test by name
flutter build apk               # build Android release
```

## Architecture

State management uses the **BLoC pattern via Cubits** (`flutter_bloc`). Two cubits are registered globally in `lib/main.dart` through `MultiBlocProvider` and drive the whole app:

- **`AuthCubit`** (`lib/cubit/auth_cubit/`) — wraps `FirebaseAuth` for `logInUser` and `signUpUser` (both take named `email`/`password`), emitting Login*/Register* loading/success/failure states. Firebase error codes are mapped to user-facing messages via `_loginErrorMessage`/`_registerErrorMessage`; sign-up always emits a failure state on error.
- **`ChatCubit`** (`lib/cubit/chat_cubit/chat_cubit/cubit/`) — wraps the Firestore `messages` collection. `getMessages()` opens a **single** `snapshots()` stream ordered by `createdAt` **descending**, stores the `StreamSubscription`, and cancels it in `close()`. `sendMessage()` optimistically prepends a temp `Message` (with `isLoading`) before the Firestore write, then relies on the stream to reconcile. States are `sealed` (`ChatInitial`/`ChatSuccess`/`ChatFailure`).

### Navigation & auth flow

`lib/main.dart` wires `home: AuthGate`, a `StreamBuilder` over `FirebaseAuth.authStateChanges()` that shows `ChatPage` when signed in and `LoginView` otherwise (persistent login). Named routes (`LoginView.route`, `SignUpView.route`, `ChatPage.route`) still exist for explicit navigation between login and sign-up. `ChatPage` reads the logged-in email from `FirebaseAuth.currentUser`, **not** from route arguments.

### Important notes

- **Firestore field keys** live in `lib/constants.dart`. Note `kSenderField = 'id'` — the document field that stores the sender's email is literally named `id` (kept for backward compatibility with existing data). Message identity (own vs. friend bubble) is decided by comparing `Message.senderEmail` against `FirebaseAuth.currentUser?.email`.
- **`Message.fromJson`** reads `message`, `id`, and `createdAt` (parsed into a nullable `sentAt`); `isLoading`/`isFailed` are local-only UI flags and are not persisted.
- The chat list uses `reverse: true` over the descending query, so the newest message sits at the bottom without manual scrolling.

## Conventions

- Code follows standard Dart naming (UpperCamelCase types, lowerCamelCase members/constants). Files are `lower_case_with_underscores`.
- Reusable widgets live in `lib/widget/` (`CustomButton`, `CustomTextField`, `AuthScaffold`, `ChatBubble`/`FriendChatBubble`); screens in `lib/views/`; shared helpers in `lib/helper/` (`showSnackBar`, `Validators`).
- Code comments are written in Arabic; this is intentional and expected.
- `analysis_options.yaml` enables stricter lints (strict-casts/raw-types, prefer_const_*, avoid_print); keep `flutter analyze` clean.
- Firebase config (`lib/firebase_options.dart`, `firebase.json`) is committed and points to project `chat-app-9a13c`.
