OUTDIR ?= .
SOURCEDIR = ./src ./sdk/AdjustIo/src

CLASSDIR = ./out
SRCS = $(shell find $(SOURCEDIR) -name *.java)
CLASSES = $(SRCS:.java=.class)

JC = javac
JAR = zip
JFLAGS = -Xlint:none \
         -classpath $(AIR_SDK_PATH)/lib/android/FlashRuntimeExtensions.jar:$(ANDROID_SDK_PATH)/platforms/android-$(ANDROID_VERSION)/android.jar \
         -sourcepath ./src:./sdk/AdjustIo/src \
         -d $(CLASSDIR)

default: jar

jar: classes
	cd $(CLASSDIR); $(JAR) $(OUTDIR)/AdjustIo.jar *

classes: $(CLASSDIR)
	$(JC) $(JFLAGS) $(SRCS)

clean:
	rm -rf $(CLASSDIR)

$(CLASSDIR):
	mkdir -p $@
