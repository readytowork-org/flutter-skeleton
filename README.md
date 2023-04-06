# flutter_skeleton

Flutter Skeleton

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a
full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to include with your application.

The `assets/images` directory
contains [resolution-aware images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

The `assets/translations` directory contains translation files in json format. File name format : <country-code>.json

## Firebase setup

### Android

Goto `android/build.gradle` and add this line inside dependency

`classpath "com.google.gms:google-services:4.3.10"`

Now, goto `android/app/build.gradle` and add this line

`apply plugin: 'com.google.gms.google-services'`

below `apply plugin: 'com.android.application'`

### IOS

Goto `ios?Runner/AppDelegate.swift` and add this line on top

`import Firebase`

and inside application function of AppDelegate class before return

`FirebaseApp.configure()`

now goto `ios/podfile` add this line

`pod 'Firebase/Auth'`

below

`target 'Runner' do`

# Environments

Place the env files like `config.dart, google-services.json, GoogleService.plist` inside respective `env/<dev|prod>`
folder.

And you can run `make set-env-dev | make set-env-prod` in terminal to set the required environment files.

# Pre-commit Script

Add the below script in .git/hooks/precommit of project

# Remove un used imports
echo "Running dartfmt --fix-imports..."
if ! dartfmt --fix-imports --set-exit-if-changed .
then
    echo ""
    echo "There were formatting issues. Please fix them before committing."
    exit 1
fi

exit 0
# To remove print 
PATTERN="print\("

FILES=$(git diff --cached --name-only --diff-filter=ACMR -- '*.dart')

for FILE in $FILES
do
  sed -i '' "s/$PATTERN//g" "$FILE"
done
echo "All print statements have been removed from your Dart code."


exit 0

# To Format Code    
echo "Running dart format..."
pub run dart_style:format

if [[ $? -ne 0 ]]; then
    echo "dart format failed. Commit aborted."
    exit 1
fi

echo "Running dart analyze..."
dart analyze

if [[ $? -ne 0 ]]; then
    echo "dart analyze failed. Commit aborted."
    exit 1
fi

# Check Outdated packages

echo "Checking for outdated packages..."
OUTDATED=$(flutter pub outdated)

# If there are outdated packages, print a message with the list of packages.
if echo "$OUTDATED" | grep -q 'is outdated'; then
  echo "The following packages are outdated:"
  echo "$OUTDATED"
  echo "Please update these packages before committing your code."
  exit 1
fi

# If there are no outdated packages, print a success message.
echo "All packages are up to date."


