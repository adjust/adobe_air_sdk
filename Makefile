ADT = $(AIR_SDK_PATH)/bin/adt
COMPC = $(AIR_SDK_PATH)/bin/compc

COMPC_ADJUST = com.adjust.sdk.Adjust
COMPC_CLASSES = $(COMPC_ADJUST) \
				com.adjust.sdk.LogLevel \
				com.adjust.sdk.Environment \
				com.adjust.sdk.AdjustConfig \
				com.adjust.sdk.AdjustEvent \
				com.adjust.sdk.AdjustAttribution
COMPC_OPTS = -swf-version 24 \
			 -external-library-path $(AIR_SDK_PATH)/frameworks/libs/air/airglobal.swc \
             -include-classes $(COMPC_CLASSES)

VERSION = $(shell cat VERSION)

SOURCEDIR = ./src
BUILDDIR = ./build
EXTDIR = ./ext
EXTS = $(patsubst $(EXTDIR)/%,%,$(wildcard $(EXTDIR)/*))

all: emulator $(EXTS) swc
	unzip -d $(BUILDDIR)/android -qq -o $(BUILDDIR)/Adjust.swc -x catalog.xml
	unzip -d $(BUILDDIR)/ios -qq -o $(BUILDDIR)/Adjust.swc -x catalog.xml
	cp -af $(SOURCEDIR)/platformoptions.xml $(BUILDDIR)/ios
	cp -af $(SOURCEDIR)/extension.xml $(BUILDDIR)/extension.xml
	cd $(BUILDDIR); $(ADT) -package -target ane ../Adjust-$(VERSION).ane extension.xml -swc Adjust.swc -platform Android-ARM -C android . -platform iPhone-ARM -C ios . -platformoptions ios/platformoptions.xml -platform default -C default .

swc:
	mkdir -p $(BUILDDIR)
	$(COMPC) -source-path src $(COMPC_OPTS) -output $(BUILDDIR)/Adjust.swc

$(EXTS):
	mkdir -p $(BUILDDIR)/$@
	cd $(EXTDIR)/$@; make OUTDIR=$(abspath $(BUILDDIR))/$@

emulator:
	mkdir -p $(BUILDDIR)/default
	$(COMPC) -source-path default/src $(COMPC_OPTS) -directory=true -output $(BUILDDIR)/default
	rm -rf $(BUILDDIR)/default/catalog.xml

clean:
	cd ext/Android; make clean
	cd ext/ios; make clean
	rm -rf *.ane $(BUILDDIR)
