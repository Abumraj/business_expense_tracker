# Android Release Signing Configuration

## Generate Release Keystore

To create a release keystore for signing the Android app:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

## Configure Signing

1. Create a file `android/key.properties` (add this to .gitignore):

```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<path to your keystore file>
```

2. Update `android/app/build.gradle.kts` to use the signing configuration:

```kotlin
def keystorePropertiesFile = rootProject.file("key.properties")
def keystoreProperties = new Properties()
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            ...
            signingConfig = signingConfigs.release
        }
    }
}
```

## Build Release APK/AAB

```bash
# Build APK for testing
flutter build apk --release

# Build AAB for Play Store
flutter build appbundle --release
```

## Important Notes

- Keep your keystore and passwords secure
- Add `key.properties` to `.gitignore`
- Backup your keystore file safely
- Never lose your keystore or you won't be able to update your app
