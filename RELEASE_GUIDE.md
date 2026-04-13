# Release Preparation Guide

## ✅ Completed Tasks

### 1. App Configuration
- ✅ Updated app version to 1.0.0+1
- ✅ Changed package ID to com.purplegate.bet across all platforms
- ✅ Added proper app descriptions and metadata

### 2. Icons and Splash Screens
- ✅ Configured flutter_launcher_icons for adaptive icons
- ✅ Set up flutter_native_splash for splash screens
- ✅ Added proper icon configurations for Android/iOS

### 3. Android Release Setup
- ✅ Updated Android manifest with proper permissions
- ✅ Configured ProGuard for code obfuscation
- ✅ Added network security configuration
- ✅ Set up data extraction rules
- ✅ Created release signing documentation

### 4. iOS Release Setup
- ✅ Updated Info.plist with proper configurations
- ✅ Added required permissions descriptions
- ✅ Configured network security settings
- ✅ Set up file sharing capabilities
- ✅ Updated macOS AppInfo configuration

### 5. App Store Metadata
- ✅ Created comprehensive app store descriptions
- ✅ Added privacy policy template
- ✅ Prepared keywords and content ratings

## 🚀 Next Steps for Release

### Generate Icons and Splash Screens
```bash
flutter pub get
flutter packages pub run flutter_launcher_icons:main
flutter packages pub run flutter_native_splash:create
```

### Android Release Build
```bash
# 1. Create keystore (follow android/RELEASE_SIGNING.md)
# 2. Create key.properties file (add to .gitignore)
# 3. Build release APK/AAB
flutter build appbundle --release
```

### iOS Release Build
```bash
# 1. Open Xcode project
open ios/Runner.xcworkspace

# 2. Configure signing in Xcode
# 3. Build archive
flutter build ios --release

# 4. Upload to App Store Connect
```

## 📋 Pre-Release Checklist

### Before Building
- [ ] Test all features thoroughly
- [ ] Verify app works on minimum supported OS versions
- [ ] Check for memory leaks and performance issues
- [ ] Ensure all network calls use HTTPS in production
- [ ] Validate all user input properly
- [ ] Test offline functionality

### App Store Requirements
- [ ] Prepare app store screenshots (6-8 screenshots)
- [ ] Set up privacy policy URL
- [ ] Configure app store categories and keywords
- [ ] Set age rating appropriately
- [ ] Add support email and website

### Final Testing
- [ ] Test release builds on actual devices
- [ ] Verify in-app purchases work (if applicable)
- [ ] Test push notifications (if implemented)
- [ ] Check deep linking functionality
- [ ] Validate export/import features

## ⚠️ Important Notes

### Security
- Never commit your keystore or signing keys
- Use different signing configs for debug/release
- Enable ProGuard for release builds
- Test network security configurations

### App Store Guidelines
- Follow platform-specific design guidelines
- Ensure proper permission usage
- Provide clear privacy policy
- Test on various screen sizes
- Handle edge cases gracefully

### Post-Release
- Monitor crash reports
- Respond to user reviews
- Prepare for quick bug fixes
- Plan for feature updates

## 🔧 Build Commands Reference

```bash
# Clean build
flutter clean
flutter pub get

# Android
flutter build apk --release          # For testing
flutter build appbundle --release    # For Play Store

# iOS
flutter build ios --release          # Build for App Store
flutter build ipa --release          # Generate IPA file

# Web (if needed)
flutter build web --release

# Desktop (if needed)
flutter build macos --release
flutter build windows --release
flutter build linux --release
```

## 📞 Support Resources

- **Flutter Release Documentation**: https://flutter.dev/docs/deployment
- **Play Store Console**: https://play.google.com/console
- **App Store Connect**: https://appstoreconnect.apple.com
- **Privacy Policy Generator**: Consider using online generators for legal compliance

---

**Ready for release!** 🎉

Follow this guide and your app should be ready for both Play Store and App Store submission.
