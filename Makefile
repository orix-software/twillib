SOURCES8=$(wildcard src/*.s)
OBJECTS8=$(SOURCES8:.s=.o)

all: $(SOURCES8) $(OBJECTS8)  

$(OBJECTS8): $(SOURCES8)
	ca65 -ttelestrat $(@:.o=.s) -o $@
	ar65 r twilighte.lib  $@


clean:
	rm src/*.o
	rm twilighte.lib


