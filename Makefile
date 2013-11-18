ADT=$(AIR_SDK_PATH)/bin/adt
COMPC=$(AIR_SDK_PATH)/bin/compc
BUILD_DIR=build

all: AdjustIo.swc
	unzip -d $(BUILD_DIR)/ios -qq -o $(BUILD_DIR)/AdjustIo.swc -x catalog.xml
	unzip -d $(BUILD_DIR)/android -qq -o $(BUILD_DIR)/AdjustIo.swc -x catalog.xml
	unzip -d $(BUILD_DIR)/default -qq -o $(BUILD_DIR)/AdjustIo.swc -x catalog.xml
	cd $(BUILD_DIR); $(ADT) -package -target ane ../AdjustIo.ane extension.xml -swc AdjustIo.swc -platform Android-ARM -C android . -platform iPhone-ARM -C ios . -platformoptions ios/platformoptions.xml -platform default -C default .

AdjustIo.swc: tree
	$(COMPC) -swf-version 13 -source-path src -include-classes com.adeven.adjustio.AdjustIo -external-library-path $(AIR_SDK_PATH)/frameworks/libs/air/airglobal.swc -output ./$(BUILD_DIR)/AdjustIo.swc

tree:
	mkdir -p $(BUILD_DIR)/ios
	mkdir -p $(BUILD_DIR)/android
	mkdir -p $(BUILD_DIR)/default
	cp src/extension.xml $(BUILD_DIR)/

clean:
	rm -rf *.ane $(BUILD_DIR)/*.swc
