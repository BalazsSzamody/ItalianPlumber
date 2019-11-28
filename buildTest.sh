sdk = xcodebuild -showsdks | grep iphonesimulator | awk -F'-sdk ' '{print $NF}'
