# Testing and Releasing Subscription Features on Play Store

## Table of Contents
- [1. Google Play Console Setup](#1-google-play-console-setup)
- [2. Configure In-App Products](#2-configure-in-app-products)
- [3. Create Test Tracks](#3-create-test-tracks)
- [4. Update App Code](#4-update-app-code)
- [5. Test Purchase Flow](#5-test-purchase-flow)
- [6. Testing Best Practices](#6-testing-best-practices)
- [7. Pre-Release Checklist](#7-pre-release-checklist)
- [8. Common Issues](#8-common-issues)
- [9. Next Steps](#9-next-steps)
- [10. Important Notes](#10-important-notes)

## 1. Google Play Console Setup

Before you can start testing, you need to:

1. Create a Google Play Developer account
   - One-time fee of $25
   - Requires basic business information

2. Create your app in the Play Console
   - Choose a unique package name
   - Basic store listing information

3. Complete initial setup
   - App category
   - Content rating
   - Target audience

## 2. Configure In-App Products

### Access Subscription Setup
1. Navigate to Play Console
2. Go to "Monetization setup" > "Products" > "Subscriptions"

### Create Subscription Products
Create the following products:
```
- Monthly Premium (keyra_premium_monthly)
- Yearly Premium (keyra_premium_yearly)
- Lifetime Premium (keyra_premium_lifetime)
```

### For Each Subscription:
1. Set base plan pricing
2. Configure subscription settings:
   - Free trial period (if offering)
   - Grace period
   - Renewal settings
   - Regional pricing
3. Add description and title
4. Save as draft

## 3. Create Test Tracks

### Internal Testing Track
1. Go to "Testing" > "Internal testing"
2. Create new release
3. Upload your APK/Bundle
4. Add test users:
   - Must be Google accounts
   - Can be personal or test accounts
   - Maximum 100 internal testers

### License Testing
1. Navigate to "Settings" > "License Testing"
2. Add test accounts
3. These accounts will get free purchases
4. Useful for testing purchase flow

## 4. Update App Code

### Update build.gradle
In `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        applicationId "com.keyra.app"  // Match Play Console
        versionCode 1
        versionName "1.0.0"
    }
}
```

### Update AndroidManifest.xml
In `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest>
    <uses-permission android:name="com.android.vending.BILLING" />
    <!-- ... other permissions ... -->
</manifest>
```

## 5. Test Purchase Flow

### Internal Testing Steps
1. Use test accounts added in License Testing
2. Install app from internal testing link
3. Test with test cards
4. Verify full subscription lifecycle

### Test Scenarios
```dart
// Required Test Cases
1. New User Flow
   - Sign up
   - Verify free tier
   - Check initial limits

2. Premium Upgrade
   - Purchase premium
   - Verify feature unlock
   - Check Firebase events

3. Subscription Management
   - Cancel subscription
   - Upgrade subscription
   - Restore purchases
   - Check grace period

4. Error Handling
   - Network errors
   - Payment failures
   - Receipt validation
```

## 6. Testing Best Practices

### Account Testing
- Use multiple test accounts
- Test with different device types
- Test offline functionality

### Feature Verification
- Verify Firebase events
- Check subscription status updates
- Test receipt validation
- Verify purchase restoration

### Error Testing
- Test network failures
- Verify error messages
- Check recovery flows

## 7. Pre-Release Checklist

```markdown
□ Play Console Setup
  □ Developer account active
  □ App created
  □ Basic store listing complete

□ Subscription Products
  □ All products created
  □ Prices set correctly
  □ Descriptions complete
  □ Trial periods configured

□ Testing Configuration
  □ Internal testing track set up
  □ Test users added
  □ License testing configured
  □ Test devices registered

□ App Code
  □ Billing permission added
  □ Version codes match
  □ Firebase configuration correct
  □ Receipt validation working

□ Purchase Flow
  □ New user flow works
  □ Premium upgrade successful
  □ Subscription management working
  □ Purchase restoration functional

□ Error Handling
  □ Network errors handled
  □ Payment failures managed
  □ User feedback clear
  □ Recovery flows working

□ Firebase Integration
  □ Events logging correctly
  □ Functions deployed
  □ Security rules updated
  □ Monitoring set up
```

## 8. Common Issues

### Receipt Validation
- Incorrect implementation
- Missing error handling
- Timeout issues
- Invalid responses

### Subscription Status
- Delayed updates
- Incorrect state
- Missing notifications
- Database inconsistencies

### Purchase Restoration
- Missing purchases
- Incorrect status
- Failed validation
- User feedback issues

### Firebase Functions
- Timeout errors
- Missing error handling
- Security rule issues
- Performance problems

## 9. Next Steps

After successful testing:

1. Fix identified issues
2. Update app metadata
3. Complete store listing
4. Plan closed testing
5. Submit for review

### Documentation
- Document test results
- Note any workarounds
- Update user guides
- Prepare support docs

## 10. Important Notes

### Testing Guidelines
- Always use test accounts first
- Real purchases can't be refunded automatically
- Keep test accounts separate from production
- Document all test cases

### Monitoring
- Watch Firebase logs
- Monitor purchase events
- Track error rates
- Check user feedback

### Support Preparation
- Prepare FAQ
- Set up support channels
- Document common issues
- Train support team

---

**Note**: This guide assumes you're using the current implementation of subscription features in the Keyra app. Adjust steps as needed based on your specific implementation or requirements.
