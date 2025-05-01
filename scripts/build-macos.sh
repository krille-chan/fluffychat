#!/usr/bin/env bash
git apply ./scripts/enable-android-google-services.patch
HERMES_ORIG_GROUP="im.hermes"
HERMES_ORIG_TEAM="4NXF6Z997G"
#HERMES_NEW_GROUP="com.example.hermes"
#HERMES_NEW_TEAM="ABCDE12345"

# In some cases (ie: running beta XCode releases) some pods haven't updated their minimum version
# but XCode will reject the package for using too old of a minimum version.
# This will fix that, but. Well. Use at your own risk.
# export I_PROMISE_IM_REALLY_SMART=1

# If you want to automatically install the app
# export HERMES_INSTALL_IPA=1

### Rotate IDs ###
[ -n "${HERMES_NEW_GROUP}" ] && {
	# App group IDs
	sed -i "" "s/group.${HERMES_ORIG_GROUP}.app/group.${HERMES_NEW_GROUP}.app/g" "macos/Runner/Runner.entitlements"
	sed -i "" "s/group.${HERMES_ORIG_GROUP}.app/group.${HERMES_NEW_GROUP}.app/g" "macos/Runner.xcodeproj/project.pbxproj"
	# Bundle identifiers
	sed -i "" "s/${HERMES_ORIG_GROUP}.app/${HERMES_NEW_GROUP}.app/g" "macos/Runner.xcodeproj/project.pbxproj"
}

[ -n "${HERMES_NEW_TEAM}" ] && {
	# Code signing team
	sed -i "" "s/${HERMES_ORIG_TEAM}/${HERMES_NEW_TEAM}/g" "macos/Runner.xcodeproj/project.pbxproj"
}

### Make release build ###
flutter build macos --release

echo "Build build/macos/Build/Products/Release/Hermes.app"
