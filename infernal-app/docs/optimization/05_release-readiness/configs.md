# Configurations

## Modes de build

### Debug
- Logs verbeux
- Hot reload actif
- Assertions actives
- DevTools accessible

### Profile
- Performance proche prod
- DevTools accessible
- Pas de hot reload

### Release
- Optimise (tree shaking, minification)
- Logs minimaux
- Pas de DevTools

---

## Variables par environnement

### Pattern recommande

```dart
// lib/core/config.dart

enum Environment { dev, staging, prod }

class Config {
  static Environment env = Environment.dev;

  static bool get isDev => env == Environment.dev;
  static bool get isProd => env == Environment.prod;

  // Logs
  static LogLevel get minLogLevel =>
      isDev ? LogLevel.trace : LogLevel.info;

  // Feature flags
  static bool get enableDevTools => !isProd;
  static bool get enableCrashReporting => isProd; // Futur: Crashlytics
}
```

### Initialisation

```dart
// main.dart
void main() {
  // Detecter automatiquement
  Config.env = kDebugMode ? Environment.dev : Environment.prod;

  runApp(const MyApp());
}
```

---

## Configuration iOS

### Info.plist (permissions)

```xml
<!-- ios/Runner/Info.plist -->

<!-- HealthKit (requis pour sommeil) -->
<key>NSHealthShareUsageDescription</key>
<string>InfernalWheel lit vos donnees de sommeil pour suivre votre repos.</string>

<key>NSHealthUpdateUsageDescription</key>
<string>InfernalWheel n'ecrit jamais dans vos donnees sante.</string>

<!-- Optionnel: Face ID si futur verrouillage -->
<key>NSFaceIDUsageDescription</key>
<string>Proteger l'acces a vos donnees sensibles.</string>
```

### Capabilities (Xcode)

- [x] HealthKit (cocher dans Signing & Capabilities)

---

## Configuration Android

### AndroidManifest.xml

```xml
<!-- android/app/src/main/AndroidManifest.xml -->

<manifest ...>
    <!-- Health Connect -->
    <uses-permission android:name="android.permission.health.READ_SLEEP" />

    <application ...>
        <!-- Intent pour Health Connect -->
        <intent-filter>
            <action android:name="androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" />
        </intent-filter>
    </application>
</manifest>
```

### build.gradle

```groovy
// android/app/build.gradle

android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 26  // Pour Health Connect
        targetSdkVersion 34
    }

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## Fichiers a NE PAS commiter

### .gitignore

```gitignore
# Secrets
*.jks
*.keystore
key.properties
google-services.json
GoogleService-Info.plist

# Local config
.env
.env.local

# IDE
.idea/
.vscode/
*.iml

# Build
build/
.dart_tool/
.packages

# iOS
ios/Pods/
ios/.symlinks/
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec

# Android
android/.gradle/
android/local.properties
```

---

## Checklist pre-release

### Code
- [ ] Version incrementee dans `pubspec.yaml`
- [ ] Changelog a jour
- [ ] Pas de secrets dans le code

### iOS
- [ ] Bundle ID configure
- [ ] Signing configure (certificat + provisioning)
- [ ] App icons toutes tailles
- [ ] Launch screen configure

### Android
- [ ] Application ID configure
- [ ] Keystore cree et securise
- [ ] App icons toutes densites
- [ ] Splash screen configure

### Store
- [ ] Screenshots preparees
- [ ] Description redigee
- [ ] Privacy policy URL
- [ ] Support email
