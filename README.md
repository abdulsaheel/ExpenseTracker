---

# Expense Tracker

**Expense Tracker** is a comprehensive Flutter application designed to read and manage transactional SMS messages, enabling users to effectively track their expenses. The app utilizes advanced features such as background services, notifications, and dynamic permission handling to deliver a seamless user experience.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Screenshots](#screenshots)
- [API Endpoints](#api-endpoints)
- [Design and Architecture](#design-and-architecture)
- [Notes](#notes)
- [Upcoming Features](#upcoming-features)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Project Overview

Expense Tracker is designed to help users monitor their spending by automatically reading SMS messages related to financial transactions. It captures transaction details such as amount, type, and bank information, allowing users to track and manage their expenses easily.

## Features

- **Automatic SMS Reading:** Fetches and parses incoming SMS messages that contain transaction details.
- **Expense Tracking:** Displays tracked expenses in a user-friendly interface.
- **Background Service:** Operates continuously in the background to monitor SMS messages in real-time.
- **Real-time Notifications:** Notifies users of new transactions with options to add or ignore.
- **Permissions Management:** Requests and manages SMS permissions dynamically.
- **Transaction Management:** Allows users to add, view, and manage their transactions.
- **Data Persistence:** Saves transactions locally using Shared Preferences for offline access.

## Technologies Used

- **Flutter:** A UI toolkit for building natively compiled applications for mobile from a single codebase.
- **Dart:** The programming language used with Flutter.
- **Awesome Notifications:** A package for managing and displaying notifications in Flutter.
- **Permission Handler:** A package for managing and requesting permissions dynamically.
- **Shared Preferences:** A package for storing simple data in key-value pairs locally.
- **Flutter Background Service:** A package for running background services in Flutter.

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/expense-tracker.git
   ```

2. **Navigate to Project Directory:**
   ```bash
   cd expense-tracker
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Configure Permissions:**

   **Android:**
   - Open `android/app/src/main/AndroidManifest.xml` and add the following permissions:
     ```xml
     <uses-permission android:name="android.permission.RECEIVE_SMS"/>
     <uses-permission android:name="android.permission.READ_SMS"/>
     ```

   **iOS:**
   - Open `ios/Runner/Info.plist` and add the following keys:
     ```xml
     <key>NSSMSUsageDescription</key>
     <string>We need access to your SMS to track your expenses.</string>
     ```

5. **Run the App:**
   ```bash
   flutter run
   ```

## Configuration

### Android Configuration

- Ensure you have configured the `android/app/src/main/AndroidManifest.xml` to handle SMS permissions.
- Make sure the background service is properly set up by following the [Flutter Background Service documentation](https://pub.dev/packages/flutter_background_service).

### iOS Configuration

- Add necessary permissions in `Info.plist` as described above.
- Ensure background modes are configured in your Xcode project.

## Usage

1. **Permissions Request:**
   Upon launching the app for the first time, it will prompt you to grant SMS permissions. The app cannot function without these permissions, so please grant them when requested.

2. **View Transactions:**
   Navigate to the Messages page to view a list of incoming transactional messages. The messages are parsed to extract relevant transaction details.

3. **Add Transactions:**
   When a new transaction is detected, a notification will be displayed with options to add the transaction to your records or ignore it.

4. **Dashboard:**
   Use the Dashboard page to review all tracked transactions. The dashboard provides insights into your spending patterns, including a summary of transactions over time.

## Screenshots

- **Home Screen:** ![Home Screen](https://i.ibb.co/xJg0ZDT/Screenshot-2024-08-02-07-00-12-750-com-example-expense-tracker.jpg)
- **Messages Page:** ![Messages Page](assets/screenshots/messages_page.png)
- **Dashboard:** ![Dashboard](assets/screenshots/dashboard.png)

## API Endpoints

This project does not use external API endpoints. It operates primarily with local data storage and background services for managing SMS transactions.

## Design and Architecture

### Core Components

- **`messages_page.dart`**: Fetches and displays SMS messages, parses them for transaction details, and allows users to manage transactions.
- **`permission_request_page.dart`**: Handles SMS permission requests and navigates to the main dashboard upon permission grant.
- **`notification_service.dart`**: Manages notifications, including displaying transaction alerts and handling user actions.
- **`background_service.dart`**: Runs as a background service to monitor and manage SMS messages continuously.

### Data Flow

1. **SMS Reading:** The background service continuously monitors SMS messages.
2. **Transaction Parsing:** Parsed messages are used to identify and extract transaction details.
3. **Local Storage:** Transactions are saved and retrieved using Shared Preferences.
4. **User Interaction:** Users receive notifications and can manage transactions via the app interface.

## Notes

- Ensure all required permissions are granted for the app to function correctly.
- The background service requires proper configuration and continuous permission to monitor SMS messages.
- The app is optimized for educational purposes and may need additional features or enhancements for production use.

## Upcoming Features

- **Expense Reports:** Generate comprehensive reports and analytics of your expenses over various periods.
- **Data Synchronization:** Implement cloud sync to backup and access transactions from multiple devices.
- **User Authentication:** Add user accounts and profiles for a personalized experience and secure access.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Acknowledgements

- **Flutter Team:** For developing the powerful Flutter framework.
- **Awesome Notifications:** For providing a robust notifications package.
- **Permission Handler:** For simplifying permission management.
- **Flutter Background Service:** For enabling background processing in Flutter apps.

