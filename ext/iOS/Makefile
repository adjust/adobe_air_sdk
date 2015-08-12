OUTDIR ?= .
SOURCEDIR = ./src/AdjustExtension
CC = xcodebuild

all:
	cd $(SOURCEDIR); $(CC) CONFIGURATION_BUILD_DIR=$(OUTDIR)

clean:
	rm -rf $(SOURCEDIR)/build
