OUTDIR ?= .
SOURCEDIR = ./src ./sdk/AdjustIo/src

CLASSDIR = ./out
SRCS = $(shell find $(SOURCEDIR) -name *.java)
CLASSES = $(SRCS:.java=.class)

JC = javac
JAR = jar
JFLAGS = -Xlint:none \
         -classpath $(AIR_SDK_PATH)/lib/android/FlashRuntimeExtensions.jar:$(ANDROID_SDK_PATH)/platforms/android-$(ANDROID_VERSION)/android.jar \
         -sourcepath ./src:./sdk/AdjustIo/src \
         -d $(CLASSDIR)

default: jar

jar: classes
	$(JAR) -cf $(OUTDIR)/AdjustIo.jar $(CLASSDIR)/*

classes: $(CLASSDIR)
	$(JC) $(JFLAGS) $(SRCS)

clean:
	rm -rf $(CLASSDIR)

$(CLASSDIR):
	mkdir -p $@
