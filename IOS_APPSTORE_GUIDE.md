# iOS App Store Deployment Guide

## Business Expense Tracker — `com.purplegate.bet`

---

## Prerequisites

### 1. Apple Developer Account
- **Enroll** at [developer.apple.com](https://developer.apple.com/programs/) ($99/year)
- You need an **individual** or **organization** account
- Organization accounts require a D-U-N-S number

### 2. Mac Required
- **You cannot build iOS apps on Windows.** You need:
  - A physical Mac (MacBook, iMac, Mac mini), OR
  - A cloud Mac CI service (Codemagic, GitHub Actions with macOS runner, etc.)
- **Xcode 15+** must be installed (from Mac App Store)
- **CocoaPods**: `sudo gem install cocoapods`

### 3. Flutter on Mac
```bash
# Install Flutter (if not already)
# See: https://docs.flutter.dev/get-started/install/macos

flutter doctor   # Verify setup
```

---

## Step-by-Step Deployment

### Step 1: Apple Developer Portal Setup

1. **Sign in** to [Apple Developer Portal](https://developer.apple.com/account)

2. **Register an App ID**:
   - Go to **Certificates, Identifiers & Profiles** → **Identifiers**
   - Click **+** → **App IDs** → **App**
   - Description: `Business Expense Tracker`
   - Bundle ID: **Explicit** → `com.purplegate.bet`
   - Enable capabilities: (none needed beyond defaults)
   - Click **Continue** → **Register**

3. **Create a Distribution Certificate** (if you don't have one):
   - Go to **Certificates** → Click **+**
   - Select **Apple Distribution**
   - Follow the CSR (Certificate Signing Request) instructions
   - Download and install the certificate

4. **Create a Provisioning Profile**:
   - Go to **Profiles** → Click **+**
   - Select **App Store Connect**
   - Choose your App ID: `com.purplegate.bet`
   - Select your Distribution Certificate
   - Name it: `BET App Store Distribution`
   - Download and double-click to install

### Step 2: App Store Connect Setup

1. **Sign in** to [App Store Connect](https://appstoreconnect.apple.com)

2. **Create a new app**:
   - Go to **My Apps** → Click **+** → **New App**
   - **Platform**: iOS
   - **Name**: Business Expense Tracker
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: com.purplegate.bet
   - **SKU**: `bet-ios-001` (any unique string)
   - **User Access**: Full Access

3. **Fill in App Information**:
   - **Category**: Finance
   - **Subtitle**: Smart Expense & Income Tracking
   - **Privacy Policy URL**: Your hosted privacy policy URL
   - **Content Rights**: Does not contain third-party content

4. **Pricing and Availability**:
   - Set price to **Free** (or your chosen price)
   - Select availability territories

### Step 3: Prepare App Store Listing

Use the metadata from `APP_STORE_METADATA.md` in your project root.

#### Required Assets:
- **App Icon**: 1024x1024 PNG (no alpha, no rounded corners)
- **Screenshots** (required for each device size you support):
  - iPhone 6.7" (1290 x 2796) — iPhone 15 Pro Max
  - iPhone 6.5" (1284 x 2778) — iPhone 14 Plus
  - iPhone 5.5" (1242 x 2208) — iPhone 8 Plus
  - iPad Pro 12.9" (2048 x 2732) — if supporting iPad
- **Description**: From APP_STORE_METADATA.md
- **Keywords**: From APP_STORE_METADATA.md
- **Support URL**: Your support page/email
- **Marketing URL** (optional)

#### Tips for Screenshots:
- Take screenshots on a simulator or real device
- Use tools like [Fastlane Frameit](https://docs.fastlane.tools/actions/frameit/) to add device frames
- Show key features: Dashboard, Income List, Customer Management, Invoice Generation

### Step 4: Build the iOS Release

On your Mac, clone the repo and run:

```bash
# 1. Get dependencies
flutter pub get

# 2. Install CocoaPods (first time only)
cd ios && pod install && cd ..

# 3. Build the release IPA
flutter build ipa --release

# The IPA will be at:
# build/ios/ipa/bet.ipa
```

#### If you get signing errors:
```bash
# Open Xcode to configure signing
open ios/Runner.xcworkspace
```
In Xcode:
- Select **Runner** target → **Signing & Capabilities**
- Set **Team** to your Apple Developer team
- Ensure **Automatically manage signing** is checked
- Bundle Identifier should be: `com.purplegate.bet`

Then rebuild:
```bash
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

### Step 5: Upload to App Store Connect

#### Option A: Using Xcode (Recommended)
```bash
# Build archive
flutter build ipa --release
```
Then:
1. Open **Xcode** → **Window** → **Organizer**
2. Select the archive → Click **Distribute App**
3. Choose **App Store Connect** → **Upload**
4. Follow the prompts

#### Option B: Using `xcrun altool` (Command Line)
```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/bet.ipa \
  --apiKey YOUR_API_KEY_ID \
  --apiIssuer YOUR_ISSUER_ID
```

#### Option C: Using Transporter App
1. Download **Transporter** from Mac App Store
2. Sign in with your Apple ID
3. Drag and drop the `.ipa` file
4. Click **Deliver**

### Step 6: Submit for Review

1. In **App Store Connect** → **My Apps** → **Business Expense Tracker**
2. Select the build you uploaded
3. Fill in **Version Information**:
   - What's New: "Initial release"
   - App Review Information:
     - Contact info (name, phone, email)
     - Demo account credentials (if login required)
     - Notes for reviewer
4. **App Review Information** (important!):
   - Provide a **demo account** so Apple can test the app
   - Example: `demo@purplegate.com` / `DemoPass123!`
   - Add notes: "This app requires an account to access features. Please use the demo credentials provided."
5. Click **Submit for Review**

---

## App Review Guidelines — Common Rejection Reasons

### 1. Missing Demo Account
- Always provide working demo credentials
- Ensure the demo account has sample data

### 2. Incomplete Features
- "Coming Soon" screens may cause rejection
- Consider removing or hiding unfinished features

### 3. Privacy Policy
- Must be accessible via a URL (not just in-app)
- Must accurately describe data collection
- Host at: `https://purplegate.com/privacy-policy`

### 4. Permissions Without Use
- Don't declare camera/photo permissions if not actively used
- Apple will reject if permissions are declared but never triggered

### 5. Login Issues
- Ensure login/signup flow works perfectly
- Test OTP verification end-to-end
- Handle network errors gracefully

---

## Important Configuration Details

### Current iOS Settings:
| Setting | Value |
|---|---|
| Bundle ID | `com.purplegate.bet` |
| App Name | Business Expense Tracker |
| Min iOS Version | 13.0 |
| Deployment Target | 13.0 |
| Device Family | iPhone + iPad |
| Orientations | Portrait (iPhone), All (iPad) |
| Encryption | No (ITSAppUsesNonExemptEncryption = NO) |
| Privacy Manifest | PrivacyInfo.xcprivacy included |
| ATS | Enabled (localhost exception for dev) |

### Files Modified for App Store:
- `ios/Runner/Info.plist` — App name, permissions, ATS, encryption
- `ios/Runner/PrivacyInfo.xcprivacy` — Apple privacy manifest (NEW)
- `ios/Runner.xcodeproj/project.pbxproj` — Deployment target 13.0, privacy manifest
- `ios/Flutter/AppFrameworkInfo.plist` — MinimumOSVersion 13.0
- `ios/ExportOptions.plist` — Archive export template (NEW)

---

## Cloud Build Alternative (No Mac Required)

If you don't have a Mac, use **Codemagic**:

1. Sign up at [codemagic.io](https://codemagic.io)
2. Connect your GitHub repo
3. Configure Flutter iOS build
4. Add your Apple Developer credentials (certificates + profiles)
5. Codemagic builds and uploads to App Store Connect automatically

### Codemagic Setup:
```yaml
# codemagic.yaml (place in project root)
workflows:
  ios-release:
    name: iOS Release
    max_build_duration: 60
    environment:
      flutter: stable
      xcode: latest
      cocoapods: default
      groups:
        - appstore_credentials
    scripts:
      - name: Get dependencies
        script: flutter pub get
      - name: Install CocoaPods
        script: cd ios && pod install
      - name: Build IPA
        script: flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
    artifacts:
      - build/ios/ipa/*.ipa
    publishing:
      app_store_connect:
        auth: integration
        submit_to_testflight: true
```

---

## Pre-Submission Checklist

- [ ] Apple Developer account enrolled and active
- [ ] App ID registered with bundle ID `com.purplegate.bet`
- [ ] Distribution certificate created and installed
- [ ] Provisioning profile created and downloaded
- [ ] App created in App Store Connect
- [ ] App icon (1024x1024) uploaded
- [ ] Screenshots for required device sizes
- [ ] App description, keywords, and category filled
- [ ] Privacy policy hosted at a public URL
- [ ] Demo account credentials prepared for reviewer
- [ ] `flutter build ipa --release` succeeds on Mac
- [ ] IPA uploaded to App Store Connect
- [ ] Build selected in version page
- [ ] Review information filled in
- [ ] Submitted for App Review

---

## Timeline Expectations

| Step | Duration |
|---|---|
| Apple Developer enrollment | 1-2 days (up to 48 hours) |
| First build + upload | 1-2 hours |
| App Review (first submission) | 1-3 days (sometimes same day) |
| Rejection fix + resubmit | 1-2 days per cycle |
| Total (smooth process) | ~1 week |

---

## Support

- [Flutter iOS deployment docs](https://docs.flutter.dev/deployment/ios)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Codemagic Flutter docs](https://docs.codemagic.io/yaml-quick-start/building-a-flutter-app/)
