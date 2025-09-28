CXX		  := g++
CXX_FLAGS := -Wall -Wextra -std=c++17 -O2 -pg

ISPC		:= ispc
ISPC_FLAGS 	:= --PIC

BIN			:= bin
ISPC_NAME	:= newton
EXECUTABLE	:= frac


all: $(BIN)/$(EXECUTABLE)

run: clean all
	clear
	./$(BIN)/$(EXECUTABLE)

$(BIN)/$(EXECUTABLE):
	$(ISPC) $(ISPC_FLAGS) $(ISPC_NAME).ispc -o $(ISPC_NAME).o -h $(ISPC_NAME).h
	$(CXX) $(CXX_FLAGS) -o $(EXECUTABLE).out main.cpp $(ISPC_NAME).o
	-rm $(ISPC_NAME).o
clean:
	-rm $(BIN)/*
