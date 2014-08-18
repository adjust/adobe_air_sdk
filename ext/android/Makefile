OUTDIR ?= .
SOURCEDIR = ./src ./sdk/Adjust/src

CLASSDIR = ./out
SRCS = $(shell find $(SOURCEDIR) -name *.java)
CLASSES = $(SRCS:.java=.class)

JC = javac
JAR = zip
JFLAGS = -Xlint:none \
         -classpath $(AIR_SDK_PATH)/lib/android/FlashRuntimeExtensions.jar:$(ANDROID_SDK_PATH)/platforms/android-$(ANDROID_VERSION)/android.jar \
		 -sourcepath ./src:./sdk/Adjust/src: \
         -d $(CLASSDIR)

default: jar

jar: classes
	cd $(CLASSDIR); $(JAR) -rq $(OUTDIR)/Adjust.jar *

classes: $(CLASSDIR)
	$(JC) $(JFLAGS) $(SRCS)

clean:
	rm -rf $(CLASSDIR)

$(CLASSDIR):
	mkdir -p $@
