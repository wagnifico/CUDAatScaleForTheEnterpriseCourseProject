################################################################################
# Copyright (c) 2019, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
################################################################################
#
# Makefile project only supported on Mac OS X and Linux Platforms)
#
################################################################################

# Define the compiler and flags
NVCC = nvcc
CXX = g++

CXXFLAGS = -std=c++17
CXXFLAGS += -I./external/cuda-samples/Common -I./external/cuda-samples/Common/UtilNPP
CXXFLAGS += -I./external/FreeImage/Source

LDFLAGS = -lcudart -lnppc -lnppial -lnppicc -lnppidei -lnppif -lnppig -lnppim -lnppist -lnppisu -lnppitc
LDFLAGS += -lnppisu_static -lnppif_static -lnppc_static -lculibos -lfreeimage


# Define directories
SRC_DIR = src
BIN_DIR = bin
DATA_DIR = data
LIB_DIR = lib

# Define source files and target executable
SRC = $(SRC_DIR)/imageRotationNPP.cpp
TARGET = $(BIN_DIR)/imageRotationNPP

# Define the default rule
all: $(TARGET)

# Get external code if not available
get:
	@if [ -d "external/cuda-samples" ]; then \
		echo "Found cuda-samples"; \
	else \
		cd external; \
		git clone https://github.com/NVIDIA/cuda-samples; \
		cd ..; \
	fi
	@if [ -d "external/FreeImage" ]; then \
		echo "Found FreeImage"; \
	else \
		cd external; \
		wget http://downloads.sourceforge.net/freeimage/FreeImage3180.zip; \
		unzip FreeImage3180.zip; \
		rm FreeImage3180.zip; \
		cd ..; \
	fi

build: get $(TARGET)

# Rule for building the target executable
$(TARGET): $(SRC)
	mkdir -p $(BIN_DIR)
	$(NVCC) $(CXXFLAGS) $(SRC) -o $(TARGET) $(LDFLAGS)

# Rule for running the application
run: $(TARGET)
	./$(TARGET) --input $(DATA_DIR)/Lena.png --output $(DATA_DIR)/Lena_rotated.png

# Clean up
clean:
	rm -rf $(BIN_DIR)/*

# Help command
help:
	@echo "Available make commands:"
	@echo "  make        - Build the project."
	@echo "  make get    - Get external dependencies (cuda-samples, FreeImage)."
	@echo "  make run    - Run the project."
	@echo "  make clean  - Clean up the build files."
	@echo "  make build  - Build the app."
	@echo "  make help   - Display this help message."
