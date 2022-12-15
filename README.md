# flutter_application

Multi-platform application with Flutter, Dart and Firebase. Authentication page - profile page - search page - folder storage page (images, videos sorted by date) - calendar page (upcoming events, dates, event details...).


# My progress on the project step by step

I - Setting up the project and the dependencies :

I started by creating a flutter project with the command: flutter create NameOfTheProject. 
I create a new firebase project, I follow instructions for creating my android, ios and web applications. I add the dependencies with flutter pub add firebase_core -  flutter pub add firebase_auth - cloud_firestore: ^4.2.0 (find on pub.dev) - provider: ^6.0.5 (pub.dev) - flutter_spinkit: ^5.1.0 (pub.dev). Add also for the web in index.html file :    
<script src="https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js"></script>

<script defer src="https://www.gstatic.com/firebasejs/8.10.0/firebase-auth.js"></script>

<script defer src="https://www.gstatic.com/firebasejs/8.10.0/firebase-firestore.js"></script>.

and for android in android/app/build.gradle:
replace minSdkVersion flutter.minSdkVersion -> minSdkVersion 19
in android {default config {}} add : multiDexEnabled true
and under android {} add :
dependencies {
    implementation 'com.android.support:multidex:1.0.3'
}
 -- End --
 
 II - Creation of the authentication form
