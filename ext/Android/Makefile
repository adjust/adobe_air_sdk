MVNDIR = ./sdk/Adjust
JARINDIR = ./sdk/Adjust/target
OUTDIR ?= .

default: copy

build: 
	cd $(MVNDIR); mvn clean; mvn package;

clean:
	rm $(OUTDIR)/Adjust.jar;

copy: build
	cp $(JARINDIR)/adjust-android-*.*.*.jar $(OUTDIR); \
	rm $(OUTDIR)/*-javadoc.jar; \
	rm $(OUTDIR)/*-sources.jar; \
	mv $(OUTDIR)/adjust-android-*.*.*.jar $(OUTDIR)/Adjust.jar
