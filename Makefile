ADT = $(AIR_SDK_PATH)/bin/adt
COMPC = $(AIR_SDK_PATH)/bin/compc

COMPC_CLASSES = com.adeven.adjustio.AdjustIo \
                com.adeven.adjustio.LogLevel \
                com.adeven.adjustio.Environment
COMPC_OPTS = -swf-version 13 \
             -external-library-path $(AIR_SDK_PATH)/frameworks/libs/air/airglobal.swc \
             -include-classes $(COMPC_CLASSES)

SOURCEDIR = ./src
BUILDDIR = ./build
EXTDIR = ./ext
EXTS = $(patsubst $(EXTDIR)/%,%,$(wildcard $(EXTDIR)/*))

all: emulator $(EXTS) swc
	unzip -d $(BUILDDIR)/android -qq -o $(BUILDDIR)/AdjustIo.swc -x catalog.xml
	unzip -d $(BUILDDIR)/ios -qq -o $(BUILDDIR)/AdjustIo.swc -x catalog.xml
	cp -af $(SOURCEDIR)/platformoptions.xml $(BUILDDIR)/ios
	cp -af $(SOURCEDIR)/extension.xml $(BUILDDIR)/
	cd $(BUILDDIR); $(ADT) -package -target ane ../AdjustIo.ane extension.xml -swc AdjustIo.swc -platform Android-ARM -C android . -platform iPhone-ARM -C ios . -platformoptions ios/platformoptions.xml -platform default -C default .

swc:
	mkdir -p $(BUILDDIR)
	$(COMPC) -source-path src $(COMPC_OPTS) -output $(BUILDDIR)/AdjustIo.swc

$(EXTS):
	mkdir -p $(BUILDDIR)/$@
	cd $(EXTDIR)/$@; make OUTDIR=$(realpath $(BUILDDIR))/$@/

emulator:
	mkdir -p $(BUILDDIR)/default
	cp $(shell ls ./src/com/adeven/adjustio/*.as | grep -v "AdjustIo.as") ./default/src/com/adeven/adjustio/
	$(COMPC) -source-path default/src $(COMPC_OPTS) -directory=true -output $(BUILDDIR)/default
	rm -rf $(BUILDDIR)/default/catalog.xml $(shell ls ./default/src/com/adeven/adjustio/*.as | grep -v "AdjustIo.as")

clean:
	cd ext/android; make clean
	cd ext/ios; make clean
	rm -rf *.ane $(BUILDDIR)
