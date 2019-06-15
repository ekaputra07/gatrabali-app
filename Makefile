bundle:
	flutter build appbundle --release --target-platform=android-arm --build-number=$(VCODE) --build-name=$(VNAME)

bundle64:
	flutter build appbundle --release --target-platform=android-arm64 --build-number=$(VCODE) --build-name=$(VNAME)

apk:
	flutter build apk --release --target-platform=android-arm --build-number=$(VCODE) --build-name=$(VNAME)

apk64:
	flutter build apk --release --target-platform=android-arm64 --build-number=$(VCODE) --build-name=$(VNAME)