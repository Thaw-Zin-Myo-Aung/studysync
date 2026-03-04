# StudySync

> **Find your perfect study partner at MFU.**

StudySync is a cross-platform mobile application built with **Flutter** and **Firebase** that helps Mae Fah Luang University (MFU) students find compatible study partners, form study groups, schedule sessions, and collaborate through in-app discussions.

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Firebase Setup](#firebase-setup)
- [Firestore Data Model](#firestore-data-model)
- [Architecture](#architecture)
- [Screens & Navigation](#screens--navigation)
- [Author](#author)

---

## Overview

University students often struggle to find study partners whose schedules, courses, and learning styles align with theirs. **StudySync** solves this by:

1. **Smart Matching** — An algorithm scores compatibility based on shared courses (30%), overlapping availability (40%), study goals (20%), and learning style (10%).
2. **Study Groups** — Students can create or join groups, manage members, and customize group icons.
3. **Session Scheduling** — Group admins schedule study sessions; members mark attendance, which feeds into a **reliability score**.
4. **Discussions** — Each group has a threaded discussion board with replies and likes.
5. **Real-time Notifications** — Firestore-streamed in-app notifications for group invites, join requests, new discussions, and new sessions.

Access is restricted to **@lamduan.mfu.ac.th** email addresses.

---

## Key Features

| Feature | Description |
|---|---|
| **MFU-Only Auth** | Email/password registration restricted to `@lamduan.mfu.ac.th`. Forgot-password flow via Firebase Auth reset email. |
| **4-Step Onboarding** | Major & year → enrolled courses → weekly availability grid → learning style selection. |
| **Discover (Matching)** | Swipe-style cards ranked by compatibility score. Invite to existing group or create a new group directly. Find partner by user ID. |
| **Study Groups** | Create, join (with admin approval), search (case-insensitive partial match). Customizable group icons. Group settings with copyable Group ID. |
| **Discussion Board** | Create posts per group. Threaded replies. Like/unlike support. |
| **Session Scheduling** | Admin-only session creation. All members can mark attendance. |
| **Reliability Score** | `(sessionsAttended / sessionsScheduled) × 100` — updated in real-time via Firestore transactions. Displayed as a ring on profiles. |
| **Real-Time Notifications** | `StreamNotifierProvider` over Firestore `snapshots()`. Works offline (served from cache) and updates live when online. |
| **Live Form Validation** | Signup fields validate on every keystroke — email domain, password rules (6+ chars, 1 uppercase, 1 symbol), confirm match. |
| **Group Activity Notifications** | Members can toggle group activity notifications (discussions & sessions) per user in Settings. |

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart) |
| **State Management** | Riverpod (`flutter_riverpod`) — `Notifier`, `StreamNotifier`, `FutureProvider.family` |
| **Backend** | Firebase (Spark / free plan) |
| **Authentication** | Firebase Auth (email/password) |
| **Database** | Cloud Firestore |
| **Routing** | GoRouter (`go_router`) |
| **Icons** | Lucide Icons (`lucide_icons_flutter`) |
| **Fonts** | Google Fonts (`google_fonts`) |

---

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── firebase_options.dart              # Auto-generated Firebase config
│
├── core/
│   ├── constants/                     # Route names, group icons, MFU majors, availability slots
│   ├── theme/                         # AppColors, AppTheme
│   ├── utils/                         # Date formatter, snackbar utilities
│   └── widgets/                       # Shared UI: buttons, input fields, badges, nav bar, etc.
│
├── models/                            # Firestore data classes (UserModel, StudyGroupModel, etc.)
│
├── providers/                         # Global Riverpod providers
│   ├── auth_provider.dart             # Auth state + user document
│   ├── groups_provider.dart           # User's groups list
│   ├── notifications_provider.dart    # Real-time notification stream
│   └── sessions_provider.dart         # Upcoming sessions across all groups
│
├── services/
│   ├── firebase/                      # Firestore CRUD: auth, groups, sessions, notifications
│   └── navigation/                    # GoRouter config + route guards
│
└── features/
    ├── authentication/                # Login, signup, email verification screens
    ├── onboarding/                    # 4-step profile setup wizard
    ├── home/                          # Dashboard: groups overview, upcoming sessions, header
    ├── matching/                      # Discover screen, partner cards, filters, matching algorithm
    ├── groups/                        # Group list, detail, settings, discussions, sessions, members
    ├── discussions/                   # Discussion models, providers, service
    ├── notifications/                 # Notifications screen
    ├── profile/                       # View/edit profile, availability calendar
    └── settings/                      # App settings (group activity toggle, account actions)
```

---

## Getting Started

### Prerequisites

- **Flutter SDK** ≥ 3.0.0
- **Dart SDK** ≥ 3.0.0
- **Firebase CLI** (`npm install -g firebase-tools`)
- An Android device/emulator or iOS simulator

### Installation

```bash
# 1. Clone the repository
git clone <repo-url>
cd studysync

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device
flutter run
```

### Build APK

```bash
flutter build apk --release
```

---

## Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
2. Add an **Android** app with package name matching `android/app/build.gradle.kts`.
3. Download `google-services.json` → place in `android/app/`.
4. Enable **Email/Password** sign-in under Firebase Auth.
5. Create a **Cloud Firestore** database (start in production mode).
6. Deploy security rules:

```bash
firebase deploy --only firestore:rules
```

### Required Firestore Indexes

Deploy the composite indexes defined in `firestore.indexes.json`:

```bash
firebase deploy --only firestore:indexes
```

---

## Firestore Data Model

| Collection | Key Fields |
|---|---|
| `users/{userId}` | `name`, `email`, `major`, `year`, `courses[]`, `availability{}`, `learningStyles[]`, `groupIds[]`, `reliabilityScore`, `sessionsAttended`, `sessionsScheduled`, `settings{}` |
| `groups/{groupId}` | `name`, `course`, `location`, `description`, `adminId`, `memberIds[]`, `iconName`, `maxMembers`, `joinRequests[]` |
| `groups/{gId}/discussions/{dId}` | `topic`, `message`, `authorId`, `authorName`, `likedBy[]`, `replyCount`, `createdAt` |
| `groups/{gId}/discussions/{dId}/replies/{rId}` | `message`, `authorId`, `authorName`, `createdAt` |
| `groups/{gId}/sessions/{sId}` | `title`, `date`, `time`, `location`, `status`, `groupId` |
| `groups/{gId}/sessions/{sId}/attendance/{userId}` | `attended`, `markedAt` |
| `notifications/{notifId}` | `userId`, `type`, `title`, `body`, `isRead`, `createdAt`, `data{}` |

### Notification Types

| Type | Trigger |
|---|---|
| `group_invite` | User invited to an existing group |
| `group_create_invite` | Matched user invited to a newly created group |
| `join_request` | Someone requests to join a group (sent to admin) |
| `join_accepted` | Admin accepts a join request (sent to requester) |
| `discussion_post` | New discussion posted in a group |
| `session_created` | New session scheduled in a group |
| `attendance_reminder` | Session attendance reminder |

---

## Architecture

```
┌──────────────────────────────────────────┐
│                  UI Layer                │
│   Screens  →  Widgets  →  GoRouter      │
└──────────────┬───────────────────────────┘
               │ ref.watch / ref.read
┌──────────────▼───────────────────────────┐
│            State Management              │
│  Riverpod: Notifier, StreamNotifier,     │
│  FutureProvider.family, StateProvider    │
└──────────────┬───────────────────────────┘
               │ service calls
┌──────────────▼───────────────────────────┐
│            Service Layer                 │
│  AuthService, GroupService,              │
│  SessionService, NotificationService,    │
│  DiscussionService, MatchingService      │
└──────────────┬───────────────────────────┘
               │ Firestore SDK
┌──────────────▼───────────────────────────┐
│          Firebase (Cloud)                │
│  Auth  ·  Firestore  ·  Rules           │
└──────────────────────────────────────────┘
```

---

## Screens & Navigation

| Route | Screen | Description |
|---|---|---|
| `/login` | LoginScreen | MFU email + password login, forgot password |
| `/signup` | SignupScreen | Registration with live validation |
| `/onboarding` | ProfileSetupScreen | 4-step profile wizard |
| `/home` | HomeScreen | Dashboard with groups, sessions, partner banner |
| `/discover` | DiscoverScreen | Matching cards, filters, find by ID |
| `/groups` | GroupsScreen | My groups + available groups (search & join) |
| `/groups/:id` | GroupDetailScreen | Tabs: Discussion · Sessions · Members |
| `/groups/:id/settings` | GroupSettingsScreen | Group info, icon picker, danger zone |
| `/notifications` | NotificationsScreen | Real-time notification feed |
| `/profile` | ProfileScreen | View profile, reliability ring, courses |
| `/profile/edit` | EditProfileScreen | Edit all profile sections |
| `/settings` | SettingsScreen | Notifications toggle, account actions |

---

## Author

**Thaw Zin Myo Aung**  
Student ID: 6731503088  
Software Engineering
Mae Fah Luang University — School of Applied Digital Technology  
Course: Mobile Application Development (2nd Semester, 2nd Year)
