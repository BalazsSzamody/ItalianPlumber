#!/bin/sh

xcodebuild \
    -project ItalianPlumber.xcodeproj \
    -scheme ItalianPlumber \
    -sdk iphoneos \
    -destination generic/platform=iOS \
    CODE_SIGN_STYLE=Automatic \
    archive \
    -archivePath archive/Archive
xcodebuild \
    -exportArchive \
    -exportOptionsPlist $1 \
    -archivePath archive/Archive.xcarchive \
    -exportPath output/ItalianPlumber