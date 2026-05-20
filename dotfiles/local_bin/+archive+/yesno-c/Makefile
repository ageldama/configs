
TARGET=yesno-c.exe
SRCS = yesno.c


CC = gcc
CFLAGS = -g -O0 -Wall -fPIC
LDFLAGS =

OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
