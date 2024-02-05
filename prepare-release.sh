#!/bin/bash

# Check if directory parameter is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <directory_name>"
  exit 1
fi

flutter build apk --release

# Assign directory name from command line argument
dir="$1"

# Check if release directory exists, if not create it
if [ ! -d "release" ]; then
  mkdir release
fi

# Copy the APK file to the specified directory
cp build/app/outputs/flutter-apk/app-release.apk release/"${dir}"

echo "APK file copied to release/${dir}"