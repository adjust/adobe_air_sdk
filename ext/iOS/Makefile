OUTDIR ?= .
SOURCEDIR = ./src/AdjustExtension
SOURCEDIRFW = ./sdk
CC = xcodebuild

all:
	cd $(SOURCEDIRFW); \
	xcodebuild -target framework -configuration Release; \
	mkdir -p Adjust.framework/tmp; \
	cp Adjust.framework/Versions/A/Headers/* Adjust.framework/tmp; \
	cp Adjust.framework/Versions/A/adjust Adjust.framework/tmp; \
	rm -rf Adjust.framework/Adjust; rm -rf Adjust.framework/Headers; rm -rf Adjust.framework/Versions; \
	mkdir -p Adjust.framework/Headers; \
	mv Adjust.framework/tmp/*.h Adjust.framework/Headers; \
	mv Adjust.framework/tmp/adjust Adjust.framework/Adjust; \
	rm -rf Adjust.framework/tmp; cd ..; \
	cp -R $(SOURCEDIRFW)/Adjust.framework $(SOURCEDIR)/include/Adjust/; \
	cp -R $(SOURCEDIRFW)/Adjust.framework $(OUTDIR); \
	rm -rf $(SOURCEDIRFW)/Adjust.framework
	cd $(SOURCEDIR); $(CC) CONFIGURATION_BUILD_DIR=$(OUTDIR); \


clean:
	rm -rf $(SOURCEDIR)/build
