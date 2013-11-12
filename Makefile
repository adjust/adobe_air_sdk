ADT=$(FLEX_SDK_PATH)/bin/adt
COMPC=$(FLEX_SDK_PATH)/bin/compc
BUILD_DIR=build

all: AdjustIo.swc
	unzip -d $(BUILD_DIR)/android -qq -o $(BUILD_DIR)/AdjustIo.swc -x catalog.xml
	unzip -d $(BUILD_DIR)/default -qq -o $(BUILD_DIR)/AdjustIo.swc -x catalog.xml
	cd $(BUILD_DIR); $(ADT) -package -target ane ../AdjustIo.ane extension.xml -swc AdjustIo.swc -platform Android-ARM -C android . -platform default -C default .

AdjustIo.swc:
	$(COMPC) -source-path src -include-classes com.adeven.adjustio.AdjustIo -external-library-path $(FLEX_SDK_PATH)/frameworks/libs/air/airglobal.swc -output ./$(BUILD_DIR)/AdjustIo.swc

clean:
	rm -rf *.ane $(BUILD_DIR)/*.swc
