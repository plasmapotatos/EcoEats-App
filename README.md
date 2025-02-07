# EcoEats

<img src="ecoeats-logo.png" alt="EcoEats Logo" width="200">

**A way to make eating healthy easy**

## Getting Started

Follow these steps to set up and run EcoEats on your local machine.

### Prerequisites
Ensure you have the following installed:
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) (for iOS development)
- A physical device or emulator

### Setup Flutter
1. Download and install Flutter from the [official site](https://flutter.dev/docs/get-started/install).
2. Add Flutter to your system path:
   ```sh
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
3. Verify the installation:
   ```sh
   flutter doctor
   ```
   Ensure all dependencies are correctly installed.

### Set Up an Emulator or Device
#### Android Emulator:
1. Open Android Studio.
2. Navigate to **AVD Manager** (Android Virtual Device Manager).
3. Create a new virtual device and start it.

#### iOS Simulator:
1. Open Xcode.
2. Navigate to **Simulator** via `Xcode > Open Developer Tool > Simulator`.

#### Physical Device:
1. Enable **Developer Mode** and **USB Debugging** (for Android) or **Enable Development Mode** (for iOS).
2. Connect your device via USB and run:
   ```sh
   flutter devices
   ```
   Ensure your device appears in the list.

### Run the App
To launch EcoEats, execute:
```sh
flutter run
```
This will build and deploy the app on the selected emulator or device.

## Contributing
Feel free to submit pull requests or open issues to improve EcoEats!

## License
This project is licensed under the [MIT License](LICENSE).