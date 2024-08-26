
# BMS Collabify- Find Partners For Your Projects

BMS Collabify is an innovative project collaboration platform designed specifically for BMS
College of Engineering students. This platform addresses the unique challenges faced in
academic project collaborations by providing a streamlined and secure environment for project
management.



## Table of Contents
- [About](#about)
  - [What is BMS Collabify?](#what-is-BMS-Collabify)
  - [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Technology Used](#technology-used)
- [Screenshots](#screenshots)
- [Team](#the-team)
## About
### What is BMS Collabify?
 In an academic environment where collaboration is key, BMS Collabify addresses the unique challenges faced by students and clients alike, providing a streamlined and secure environment for project management.This platform ensures that both project seekers and contributors can connect effectively, resulting in meaningful collaborations that drive academic success.

The clean and user-friendly interface of BMS Collabify ensures that users, regardless of their technical expertise, can engage with the platform effortlessly. This simplicity not only makes the platform accessible but also allows users to focus on what truly matters—the successful completion of their projects.

Communication is at the heart of any successful collaboration, and BMS Collabify recognizes this by incorporating a dynamic feed module. This feature allows users to post updates, share insights, and interact in real-time, thereby enhancing the collaborative process.

BMS Collabify is more than just a project management tool; this platform not only simplifies the process of connecting skilled students with project opportunities but also nurtures a collaborative spirit that is essential for academic success. As a result, BMS Collabify stands out as a valuable asset to the BMS community, empowering students and clients to achieve their collaborative goals!

### Features

- **Dashboard**
  - Upload projects with detailed descriptions, requirements, and deadlines.
  - View all project statuses and edit project details with ease.

- **Project Management**
  - Organize and track projects.
  - Update project statuses: open, in progress, or completed, for seamless management.

- **User Profiles**
  - Create comprehensive profiles showcasing skills, experiences, and portfolios.
  - Update and refine your profile as you gain more experience.

- **Advanced Project Search**
  - Search for projects that align with your skills and interests.
  - Use powerful filters to find the perfect match effortlessly.

- **Collaboration Tools**
  - Collaborate directly with clients and team members within the platform.
  - Share feedback and ideas in real-time for enhanced teamwork.

- **Secure User Data**
  - Protect user profiles, project details, and communication with our security.
  - Ensure that all data is securely stored and accessible only to authorized users.

- **Real-Time Notifications**
  - Stay updated with instant notifications on project applications, status changes, and messages.
## Getting Started
### Prerequisites

Before you begin, ensure that you have the following prerequisites installed on your development environment:


1. **Flutter with Android Studio**: To build and run the BMS Collabify application, you must have Flutter and Android Studio installed. Follow the installation instructions for Flutter and Android Studio based on your operating system:

   - [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
   - [Android Studio Installation Guide](https://developer.android.com/studio)

2. **Android SDK**: Android Studio usually comes with the Android SDK, but it's essential to ensure it's correctly installed and configured. Android SDK is necessary for building and running Android applications with Flutter.

Make sure all the required paths are added to PATH in environment variables of you PC.

After installing Flutter and Android Studio, it's highly recommended to run the following command to check for any additional requirements or corrections in your Flutter environment:

```bash
flutter doctor
```

### Installation
1. **Clone the Repository**: Begin by cloning the BMS-Collabify repository from GitHub to your local machine. This step ensures you have the server's source code.
    ```bash
    git clone https://github.com/gajanana07/BMS-Collabify.git
    ```
2. **Setting Up the Environment**:
- **Install Flutter:** Ensure Flutter is installed on your machine. If you don’t have Flutter installed, follow the official [Flutter Installation Guide.](https://flutter.dev/docs/get-started/install)

- **Install Firebase CLI:** Install the Firebase CLI tools, if you haven't already, to interact with Firebase services. Follow the [Firebase CLI installation guide](https://firebase.google.com/docs/cli) for details.

- **Navigate to Project Directory:** Move into the project directory where the Flutter app is located.

3. **Firebase Configuration:**
- **Set Up Firebase:** You need to link the app to your Firebase project.

   ->Create a Firebase Project: Go to the Firebase Console and   create a new project.

     ->Add Android/iOS App: Add an Android/iOS app to your Firebase project and download the google-services.json (for Android) or GoogleService-Info.plist (for iOS).

     ->Place Configuration File: Place the google-services.json file in android/app/ directory, or the GoogleService-Info.plist in the ios/Runner/ directory.
- **Enable Firebase Services:** Enable the necessary Firebase services such as Authentication, Firestore, and others as per the app’s requirements.

Refer this youtube video for establishing firebase connection to your project https://youtu.be/fm79vu4hTKo?si=Xgfj6CxgjC9JNYLZ


4. **Compiling and Running the App**: 
- **Get Dependencies:** Fetch and install the necessary Flutter dependencies by running:
    ```bash
    flutter pub get
    ```
  (Note: Ensure that you have installed all the dependencies required to run the project. If not get it from here -> https://pub.dev/     
  And also don't forget to check all your gradle files once!)

- **Update Firebase Configurations:** Ensure that the Firebase settings match your project’s configuration by updating any necessary files, such as API keys and project IDs.

- **Build the App:**  Build the app for your target platform (Android or iOS).
    ```bash
    flutter build apk   
    flutter build ios  

    ```

- **Connect Device or Emulator:** Connect an Android device or start an emulator. Ensure USB debugging is enabled if using a physical device.

- **Run the App:** Finally, run the app on your connected device or emulator:
    ```bash
    flutter run
    ```

These steps will help you set up and run both the server and the app smoothly. You're now ready to go!
## Technology Used
<div style="display: flex; justify-content: center; gap: 50px;align-items: center;">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/database.png" width="45%">

</div>


[![Tech](https://skillicons.dev/icons?i=figma,flutter,dart,firebase)](https://skillicons.dev)

Figma, Flutter, Dart, Firebase

Figma: Figma is a collaborative web-based design tool used for creating user interfaces, prototypes, and visual designs.

Flutter:
Flutter is Google's UI toolkit for building natively compiled apps for various platforms.

Dart:
Dart is a fast, modern programming language primarily used in Flutter development.

Firebase:
Firebase is Google's mobile and web app development platform with a wide range of tools and services.
## Screenshots

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/dashboard1.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/dashboard2.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/signup.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/signup2.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/signup3.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/login.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/lol1.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/lol2.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/profile1.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/profile2.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/search1.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/search2.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/search3.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/search4.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/search5.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/upload.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/feed1.png" width="200">

<img src="https://github.com/gajanana07/BMS-Collabify/blob/master/assets/feed2.png" width="200">


## The Team

**S Gajanana nayak**

[![GitHub](https://img.shields.io/badge/GitHub-black?style=flat&logo=github)](https://github.com/gajanana07)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/s-gajanana-nayak-b0854a29a/)

**Raghavendra R**

[![GitHub](https://img.shields.io/badge/GitHub-black?style=flat&logo=github)](https://github.com/RaghavendraCodes)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/raghavendra-r-363701202/)

**Rahul N Raju**

[![GitHub](https://img.shields.io/badge/GitHub-black?style=flat&logo=github)]()

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/rahul-n-raju-ab6919247/)

**Revanth K**

[![GitHub](https://img.shields.io/badge/GitHub-black?style=flat&logo=github)]()

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin)]()