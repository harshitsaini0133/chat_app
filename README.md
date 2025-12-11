# Chat App

A modern, real-time chat application built with **Flutter**, designed with a sleek dark theme and tailored for performance using Clean Architecture principles.

## 🚀 Features

- **Real-Time Messaging**: Instant communication powered by **Socket.IO**.
- **Secure Authentication**: Robust user authentication flow.
- **Modern UI/UX**: A premium dark mode design using the **Outfit** font family and a carefully curated color palette.
- **State Management**: Scalable and testable code using **Flutter BLoC**.
- **Dependency Injection**: Decoupled modules using **GetIt**.
- **Smart Routing**: Declarative routing with **GoRouter**.
- **Networking**: Efficient API handling with **Dio** and caching strategies.

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: flutter_bloc, equatable
- **Networking**: dio, socket_io_client
- **DI**: get_it, dartz
- **Routing**: go_router
- **Storage**: shared_preferences
- **Fonts**: google_fonts

## 📂 Project Structure

This project follows a **Feature-First Clean Architecture**:

```
lib/
├── core/                   # Core utilities, services, and shared logic
│   ├── api/
│   ├── constants/
│   ├── error/
│   ├── models/
│   ├── routing/
│   ├── services/
│   └── usecase/
├── features/               # distinct features of the application
│   ├── auth/               # Authentication feature (Login/Register)
│   └── chat/               # Chat feature (Messaging logic & UI)
├── injection_container.dart # Dependency Injection setup
└── main.dart               # Entry point
```

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.10.3 or higher recommended)
- [Dart SDK](https://dart.dev/get-dart)

### Installation

1.  **Clone the repository**:

    ```bash
    git clone https://github.com/your-username/chat_app.git
    cd chat_app
    ```

2.  **Install dependencies**:

    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

## 🧪 Testing

To run unit and widget tests:

```bash
flutter test
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
