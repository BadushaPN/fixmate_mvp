
# Fixmate MVP

This is the MVP for Fixmate, a local service booking app built with Flutter.
It uses **Local Storage (SharedPreferences)** to mock a backend, allowing you to test the full flow immediately.

## Features

- **Authentication**: Mock login with OTP (any 4-digit OTP works).
- **Service Listing**: Browse services like Electrician, Plumber, etc.
- **Booking Flow**: Select date, time, and address to book a service.
- **My Bookings**: View current and past bookings with status.
- **Profile**: View user details.

## Project Structure

- `lib/main.dart`: App entry point and theme configuration.
- `lib/providers/app_provider.dart`: State management for User and Bookings.
- `lib/services/storage_service.dart`: Mock backend implementation using SharedPreferences.
- `lib/models/`: Data models (User, Service, Booking).
- `lib/screens/`: UI Screens (Splash, Login, Home, Booking Form).
- `lib/widgets/`: Reusable widgets (ServiceCard, BookingItem).

## Getting Started

1.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Run the App**:
    ```bash
    flutter run
    ```

## Mock Data

- **Login**: Enter any phone number. Enter any 4-digit OTP (e.g., 1234).
- **Services**: Pre-populated with Electrician, Plumber, AC Repair, Cleaning, Painting, RO Service.
- **Data Persistence**: Data is saved locally on the device.

## Note

This version does not connect to a real backend (Firebase/API). It is designed for demonstration and UI/UX validation.
