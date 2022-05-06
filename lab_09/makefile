CFLAGS := -O0 -fno-asynchronous-unwind-tables -m80387

app: main.cpp
	g++ $(CFLAGS) -S $^
	g++ $(CFLAGS) -o $@ $^
