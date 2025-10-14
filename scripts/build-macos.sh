#!/usr/bin/env bash
git apply ./scripts/enable-android-google-services.patch
STAWI_ORIG_GROUP="im.stawi"
STAWI_ORIG_TEAM="4NXF6Z997G"
#STAWI_NEW_GROUP="com.example.fluffychat"
#STAWI_NEW_TEAM="ABCDE12345"

# In some cases (ie: running beta XCode releases) some pods haven't updated their minimum version
# but XCode will reject the package for using too old of a minimum version. 
# This will fix that, but. Well. Use at your own risk.
# export I_PROMISE_IM_REALLY_SMART=1

# If you want to automatically install the app
# export STAWI_INSTALL_IPA=1

### Rotate IDs ###
[ -n "${STAWI_NEW_GROUP}" ] && {
	# App group IDs
	sed -i "" "s/group.${STAWI_ORIG_GROUP}.app/group.${STAWI_NEW_GROUP}.app/g" "macos/Runner/Runner.entitlements"
	sed -i "" "s/group.${STAWI_ORIG_GROUP}.app/group.${STAWI_NEW_GROUP}.app/g" "macos/Runner.xcodeproj/project.pbxproj"
	# Bundle identifiers
	sed -i "" "s/${STAWI_ORIG_GROUP}.app/${STAWI_NEW_GROUP}.app/g" "macos/Runner.xcodeproj/project.pbxproj"
}

[ -n "${STAWI_NEW_TEAM}" ] && {
	# Code signing team
	sed -i "" "s/${STAWI_ORIG_TEAM}/${STAWI_NEW_TEAM}/g" "macos/Runner.xcodeproj/project.pbxproj"
}

### Make release build ###
flutter build macos --release

echo "Build build/macos/Build/Products/Release/FluffyChat.app"
