TARGET = mux


CC = gcc
AR = ar
SIZE = size

SRC += $(wildcard *.c)
SRC += $(wildcard mu/*.c)
SRC += $(wildcard linenoise/*.c)
OBJ := $(SRC:.c=.o)
DEP := $(SRC:.c=.d)
ASM := $(SRC:.c=.s)

ifdef DEBUG
CFLAGS += -O0 -g3 -DMU_DEBUG
CFLAGS += -fkeep-inline-functions
else ifdef FAST
CFLAGS += -O3
else ifdef SMALL
CFLAGS += -Os
else
CFLAGS += -O2
endif
CFLAGS += -std=c99 -pedantic
CFLAGS += -Wall -Winline

LFLAGS += -lm


all: $(TARGET)

asm: $(ASM)

size: $(OBJ)
	$(SIZE) -t $^

-include $(DEP)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $^ $(LFLAGS) -o $@

%.a: $(OBJ)
	$(AR) rcs $@ $^

%.o: %.c
	$(CC) -c -MMD $(CFLAGS) $< -o $@

%.s: %.c
	$(CC) -S $(CFLAGS) $< -o $@

clean:
	rm -f $(TARGET)
	rm -f $(OBJ)
	rm -f $(DEP)
	rm -f $(ASM)
