
BODIES=$(wildcard src/*.c)
OBJECTS=$(BODIES:.c=.o)

# Win32 and MingW in particular require special treatment
# best handled via build-time feature detection,
# but that would entail something like autoconf.

# For now, to build for Windows requires overriding
# CC and CONFIG_H. For example, to build for MingW-W64 on cygwin:
# make CC=x86_64-w64-mingw32-gcc CONFIG_H=-DHAVE_IO_H

CONFIG_H=-DHAVE_SYS_STAT_H

CFLAGS=-O2 -Wall -std=c99 $(CONFIG_H)
LDFLAGS=

.PHONY: test install clean

endlines: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

%.o:%.c
	$(CC) $(CFLAGS) -c $< -o $@

test: endlines
	@(cd test; bash runtest.sh)

install: endlines
	mv endlines /usr/local/bin/endlines

clean:
	-rm src/*.o endlines


# Dependencies on headers
src/command_line_parser.o: src/command_line_parser.h
src/convert_stream.o: src/endlines.h
src/file_operations.o: src/endlines.h
src/file_operations.o: src/walkers.h
src/main.o: src/command_line_parser.h
src/main.o: src/endlines.h
src/main.o: src/walkers.h
src/utils.o: src/endlines.h
src/utils.o: src/known_binary_extensions.h
src/walkers.o: src/walkers.h
