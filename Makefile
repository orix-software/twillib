
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
	$(AS) -ttelestrat src/twil_restore_registers.s
	$(AS) -ttelestrat src/twil_save_registers.s
	$(AR) r twil.lib  src/twil_restore_registers.o
	$(AR) r twil.lib  src/twil_save_registers.o

$(OBJECTS8): $(SOURCES8)
	$(AS) -ttelestrat $(@:.o=.s) -o $@ 
	$(LD) -tnone $(@:.o) $@ libs/lib8/ch376.lib twil.lib
	$(AR) r twil.lib  $@

archive:	
	mkdir build/usr/include/ -p
	mkdir build/usr/arch/include/ -p
	mkdir build/lib8/ -p
	cp src/include/twil.h build/usr/include/
	cp src/include/twil.inc build/usr/arch/include/
	cp twil.lib build/lib8/

clean:
	rm src/*.o
	rm twil.lib


