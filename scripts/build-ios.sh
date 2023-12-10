#!/usr/bin/env bash
git apply ./scripts/enable-android-google-services.patch
FLUFFYCHAT_ORIG_GROUP="im.fluffychat"
FLUFFYCHAT_ORIG_TEAM="4NXF6Z997G"
#FLUFFYCHAT_NEW_GROUP="com.example.fluffychat"
#FLUFFYCHAT_NEW_TEAM="ABCDE12345"

# In some cases (ie: running beta XCode releases) some pods haven't updated their minimum version
# but XCode will reject the package for using too old of a minimum version. 
# This will fix that, but. Well. Use at your own risk.
# export I_PROMISE_IM_REALLY_SMART=1

# If you want to automatically install the app
# export FLUFFYCHAT_INSTALL_IPA=1

### Rotate IDs ###
[ -n "${FLUFFYCHAT_NEW_GROUP}" ] && {
	# App group IDs
	sed -i "" "s/group.${FLUFFYCHAT_ORIG_GROUP}.app/group.${FLUFFYCHAT_NEW_GROUP}.app/g" "ios/FluffyChat Share/FluffyChat Share.entitlements"
	sed -i "" "s/group.${FLUFFYCHAT_ORIG_GROUP}.app/group.${FLUFFYCHAT_NEW_GROUP}.app/g" "ios/Runner/Runner.entitlements"
	sed -i "" "s/group.${FLUFFYCHAT_ORIG_GROUP}.app/group.${FLUFFYCHAT_NEW_GROUP}.app/g" "ios/Runner.xcodeproj/project.pbxproj"
	# Bundle identifiers
	sed -i "" "s/${FLUFFYCHAT_ORIG_GROUP}.app/${FLUFFYCHAT_NEW_GROUP}.app/g" "ios/Runner.xcodeproj/project.pbxproj"
}

[ -n "${FLUFFYCHAT_NEW_TEAM}" ] && {
	# Code signing team
	sed -i "" "s/${FLUFFYCHAT_ORIG_TEAM}/${FLUFFYCHAT_NEW_TEAM}/g" "ios/Runner.xcodeproj/project.pbxproj"
}
cat << EOHELP
If something later in the build explodes, and looks possibly related to App IDs:
1. Ask Xcode nicely
    - Open ios/Runner.xcodeproj in Xcode
    - Go to the Signing & Capabilities tab
    - Ask it to repair the certificates/register app IDs/etc
2. Fix it yourself
    - Go to https://developer.apple.com/account/resources/identifiers/list
    - Ensure that Xcode created the App ID successfully (for fluffychat.app and fluffychat.app.FluffyChat-Share)
    - Under "App Groups", make sure it registered your group
    - Back "App IDs", check that the App Group was added to each App ID's entitlements
EOHELP

### [optional] override pods minimum iphoneos deployment target ###
[ -n "${I_PROMISE_IM_REALLY_SMART}" ] && {
# 1. I'm sorry about the indentation't ;_; heredocs are weird about it
# 2. The patch basically just removes any preference on target iOS version
#    This lets our default from ios/Flutter/AppFrameworkInfo.plist take precendence
cat << EOPATCH | patch --forward --reject-file=apple_please_fix_your_coreutils --silent ios/Podfile
diff --git a/ios/Podfile b/ios/Podfile
index 9411102b..0446120a 100644
--- a/ios/Podfile
+++ b/ios/Podfile
@@ -37,5 +37,8 @@ end
 post_install do |installer|
   installer.pods_project.targets.each do |target|
     flutter_additional_ios_build_settings(target)
+    target.build_configurations.each do |config|
+      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
+    end
   end
 end
EOPATCH
rm -f apple_please_fix_your_coreutils
}

### Make release build ###
flutter build ipa --release

### [optional] Install release build ###
[ -n "${FLUFFYCHAT_INSTALL_IPA}" ] && {
  TMPDIR=$(mktemp -d)
  # 1. Turn the xcarchive that flutter created into a dev-signed IPA
  echo '{"compileBitcode":false,"method":"development"}' | plutil -convert xml1 -o "${TMPDIR}/options.plist" -
  xcodebuild -exportArchive -archivePath ./build/ios/archive/Runner.xcarchive -exportPath "${TMPDIR}" -exportOptionsPlist "${TMPDIR}/options.plist"
  # 2. ...and install it on your connected devices
  cfgutil --foreach install-app "${TMPDIR}/fluffychat.ipa"
  rm -rf "${TMPDIR}"
}
