#!/bin/bash
# 1. Build the naked app
flutter build ios --release --no-codesign

# 2. Setup the Payload structure
cd build/ios/iphoneos
rm -rf Payload Attendify.ipa
mkdir Payload
cp -r Runner.app Payload/

# 3. Zip it up for LiveContainer
zip -vr Attendify.ipa Payload/

# 4. Start the transfer server
echo "Done! Download at http://$(ipconfig getifaddr en0):8000/Attendify.ipa"
python3 -m http.server 8000

