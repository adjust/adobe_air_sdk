ADT=$(AIR_SDK_PATH)/bin/adt
COMPC=$(AIR_SDK_PATH)/bin/compc

COMPC_CLASSES=com.adeven.adjustio.AdjustIo com.adeven.adjustio.LogLevel com.adeven.adjustio.Environment
COMPC_OPTS=-swf-version 13 -external-library-path $(AIR_SDK_PATH)/frameworks/libs/air/airglobal.swc -include-classes $(COMPC_CLASSES)

BUILD_DIR=build

all: AdjustIoDefault.swc AdjustIo.swc
	unzip -d $(BUILD_DIR)/ios -qq -o $(BUILD_DIR)/AdjustIo.swc -x catalog.xml
	unzip -d $(BUILD_DIR)/android -qq -o $(BUILD_DIR)/AdjustIo.swc -x catalog.xml
	cd $(BUILD_DIR); $(ADT) -package -target ane ../AdjustIo.ane extension.xml -swc AdjustIo.swc -platform Android-ARM -C android . -platform iPhone-ARM -C ios . -platformoptions ios/platformoptions.xml -platform default -C default .

AdjustIo.swc: tree
	$(COMPC) -source-path src $(COMPC_OPTS) -output ./$(BUILD_DIR)/AdjustIo.swc

AdjustIoDefault.swc: tree
	cp $(shell ls ./src/com/adeven/adjustio/*.as | grep -v "AdjustIo.as") ./default/src/com/adeven/adjustio/
	$(COMPC) -source-path default/src $(COMPC_OPTS) -directory=true -output ./$(BUILD_DIR)/default
	rm ./$(BUILD_DIR)/default/catalog.xml
	rm $(shell ls ./default/src/com/adeven/adjustio/*.as | grep -v "AdjustIo.as")

tree:
	mkdir -p $(BUILD_DIR)/ios
	mkdir -p $(BUILD_DIR)/android
	mkdir -p $(BUILD_DIR)/default
	cp src/extension.xml $(BUILD_DIR)/

clean:
	rm -rf *.ane $(BUILD_DIR)/*.swc $(BUILD_DIR)/ios/*.swf $(BUILD_DIR)/android/*.swf $(BUILD_DIR)/default/*.swf
