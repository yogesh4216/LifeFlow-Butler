# LifeFlow Butler 🎩

**Built for the Flutter Butler with Serverpod Hackathon** 🏆

LifeFlow Butler is an intelligent personal command center designed to reclaim your attention. It unifies your tasks, emails, and calendar into a single, distraction-free "Briefing" interface.

## 🚀 Features

*   **Natural Language Tasking**: Type "Call Mom tomorrow at 5pm urgent" and let the AI handle the scheduling, parsing priority and time automatically.
*   **Daily Briefings**: Get a high-level summary of your day instead of a cluttered to-do list.
*   **Focus Mode**: A dedicated UI state that hides non-essential information to help you execute deep work.
*   **Unified Integration**: (Demo) Simulates fetching emails and turning them into actionable tasks.

## 🛠️ Built With

*   **Frontend**: [Flutter](https://flutter.dev) (MacOS) - For a premium native desktop experience.
*   **Backend**: [Serverpod](https://serverpod.dev) (Dart) - For a type-safe, scalable server and generated client.
*   **Database**: PostgreSQL & Redis (via Docker).
*   **Language**: 100% Dart 🎯.

## 🏃‍♂️ Getting Started

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install/macos)
*   [Docker Desktop](https://www.docker.com/products/docker-desktop/)
*   [Serverpod CLI](https://docs.serverpod.dev/)

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/[YOUR_USERNAME]/lifeflow_butler.git
    cd lifeflow_butler
    ```

2.  **Start the Backend**
    ```bash
    cd lifeflow_butler_server
    # Start the database containers
    docker-compose up -d --build
    # Run the server
    dart bin/main.dart
    ```

3.  **Run the Client**
    Open a new terminal window:
    ```bash
    cd lifeflow_butler_flutter
    flutter run -d macos
    ```

## 🧠 How It Works

LifeFlow Butler leverages a custom **Natural Language Parser** implemented in pure Dart. It uses regex pattern matching to extract semantic meaning (temporal data, urgency) from unstructured text inputs, proving that you don't always need a heavy LLM for a smart user experience.

---
*Created by Yogesh for the Flutter Butler Hackathon.*
