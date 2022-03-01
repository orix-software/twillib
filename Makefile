
SOURCES8=$(wildcard src/*.s)
OBJECTS8=$(SOURCES8:.s=.o)

ifeq ($(CC65_HOME),)
        CC = cc65
        AS = ca65
        LD = ld65
        AR = ar65
else
        CC = $(CC65_HOME)/bin/cc65
        AS = $(CC65_HOME)/bin/ca65
        LD = $(CC65_HOME)/bin/ld65
        AR = $(CC65_HOME)/bin/ar65
endif


all: init $(SOURCES8) $(OBJECTS8) archive

init:
	mkdir build/lib8/ -p

$(OBJECTS8): $(SOURCES8)
	$(AS) -ttelestrat $(@:.o=.s) -o $@ 
	$(AR) r build/lib8/twil.lib  $@

archive:	
	mkdir build/usr/include/ -p
	mkdir build/usr/arch/include/ -p
	mkdir build/usr/src/twillib/asm -p
	cp    src/*.s build/usr/src/twillib/asm/
	cp src/include/twil.h build/usr/include/
	cp src/include/twil.inc build/usr/arch/include/

clean:
	rm src/*.o
	# rm -rf build
	rm build/lib8/twil.lib


