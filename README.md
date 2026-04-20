# Random Users iOS

A clean, modular iOS application built with **SwiftUI** and **Swift Concurrency** that manages, filters, and blacklists random user data. Designed following **Clean Architecture** and **SOLID** principles for maintainability and testability.

![Swift](https://img.shields.io/badge/Swift-6-orange.svg)
![iOS](https://img.shields.io/badge/iOS-18.0%2B-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-Clean_MVVM+Store--Observable-green.svg)

---

## 🚀 Core Features

- **Dynamic User Directory:** Fetches and displays paginated user data from the RandomUser API.
- **Infinite Scroll:** Implements seamless pagination using onAppear triggers for a fluid reading experience.
- **Advanced Filtering:** Real-time search by name or email with a 400ms debounce to minimize unnecessary processing.
- **Blacklist Management:** Intuitive deletion mechanism that persists blocked users locally.
- **Data Integrity:** Intelligent duplicate prevention via a custom Array extension, ensuring unique identity per user.
- **Adaptive UI:** Full support for Light and Dark Mode using semantic colors and standard system materials for a native look and feel.

---

## 🏗️ Architecture & Technical Decisions

The project enforces a strict **Clean Architecture** to separate business logic from UI concerns.

### 1. Presentation Layer (MVVM + Observable)
- **@Observable Store:** Uses the modern `@Observable` macro to ensure reactive UI updates with minimal boilerplate.
- **Dependency Injection:** The `DependencyFactory` protocol allows for seamless injection of real or mock services, supporting the **PreviewContainer** pattern for instant SwiftUI Previews.
- **Navigation:** Implemented via `NavigationStack` with an `AppRoute` enum for type-safe routing.

### 2. Domain & Data Layer
- **Repositories & Mappers:** Clear separation between network DTOs and internal domain models.
- **Persistence:** Local storage implemented via `BlacklistRepository` using `UserDefaults`, ensuring that blacklisted users remain blocked across app restarts.
- **SOLID Compliance:** Use cases (e.g., `FetchUsersUseCase`) abstract the business logic from the view models.

### 3. Logic Optimization
- **Duplicate Prevention:** A custom set-based algorithm prevents API-returned duplicates from polluting the list:
  $Result=Existing+UniqueNewElements$
  
- **Search Debouncing:** Prevents main-thread bottlenecking during rapid user input:                      
  $Task→CancelPrevious→Sleep(400ms)→Filter$

---

## 🧪 Testing Strategy

The project utilizes the new **Swift Testing** framework to ensure robust code quality across all layers.

### 1. Repository & Data Testing

* **Blacklist Persistence:** Tests verify that UserDefaults operations (save/load/remove) accurately sync with the BlacklistStore.
* **Mapping Logic:** Confirms that UserDTO to User domain model transformations handle all fields correctly.

### 2. View Model Testing

* **State Machine:** Validates state transitions (.loading, .success, .error) under different network conditions.
* **Pagination Logic:** Ensures fetchNewPage respects concurrency limits (prevents reentrancy) and correctly toggles hasMoreResults.

### 3. Logic Units
* **Uniqueness Algorithm:** Comprehensive test suite for appendingUnique, confirming that internal batch duplicates and list-existing duplicates are stripped out without affecting order.

---

## 📦 Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/rauulmp/random_users_ios.git](https://github.com/rauulmp/random_users_ios.git)

2. Open RandomUsers.xcodeproj.
3. Select a simulator with iOS 18.0+.
4. Run! (Cmd + R).

   
