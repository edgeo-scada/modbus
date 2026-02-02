# Makefile for edgeo-modbus CLI
# Cross-compiles for Windows, Linux, and macOS

BINARY_NAME=edgeo-modbus
VERSION=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
BUILD_TIME=$(shell date -u '+%Y-%m-%d_%H:%M:%S')
LDFLAGS=-ldflags "-X main.version=$(VERSION) -s -w"

# Source directory
SRC_DIR=./cmd/edgeo-modbus

# Output directory
BIN_DIR=bin

# Platforms
PLATFORMS=darwin/amd64 darwin/arm64 linux/amd64 linux/arm64 windows/amd64

.PHONY: all clean build build-all darwin linux windows

all: build-all

# Build for current platform
build:
	@echo "Building for current platform..."
	@mkdir -p $(BIN_DIR)
	go build $(LDFLAGS) -o $(BIN_DIR)/$(BINARY_NAME) $(SRC_DIR)

# Build for all platforms
build-all: darwin linux windows
	@echo "Build complete for all platforms"

# macOS builds
darwin: darwin-amd64 darwin-arm64

darwin-amd64:
	@echo "Building for macOS (amd64)..."
	@mkdir -p $(BIN_DIR)
	GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BIN_DIR)/$(BINARY_NAME)-darwin-amd64 $(SRC_DIR)

darwin-arm64:
	@echo "Building for macOS (arm64)..."
	@mkdir -p $(BIN_DIR)
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BIN_DIR)/$(BINARY_NAME)-darwin-arm64 $(SRC_DIR)

# Linux builds
linux: linux-amd64 linux-arm64

linux-amd64:
	@echo "Building for Linux (amd64)..."
	@mkdir -p $(BIN_DIR)
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BIN_DIR)/$(BINARY_NAME)-linux-amd64 $(SRC_DIR)

linux-arm64:
	@echo "Building for Linux (arm64)..."
	@mkdir -p $(BIN_DIR)
	GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o $(BIN_DIR)/$(BINARY_NAME)-linux-arm64 $(SRC_DIR)

# Windows builds
windows: windows-amd64

windows-amd64:
	@echo "Building for Windows (amd64)..."
	@mkdir -p $(BIN_DIR)
	GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BIN_DIR)/$(BINARY_NAME)-windows-amd64.exe $(SRC_DIR)

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@rm -rf $(BIN_DIR)
	@rm -f $(BINARY_NAME)

# Install to GOPATH/bin
install:
	go install $(LDFLAGS) $(SRC_DIR)

# Run tests
test:
	go test -v ./...

# Show help
help:
	@echo "Available targets:"
	@echo "  build       - Build for current platform"
	@echo "  build-all   - Build for all platforms (default)"
	@echo "  darwin      - Build for macOS (amd64 and arm64)"
	@echo "  linux       - Build for Linux (amd64 and arm64)"
	@echo "  windows     - Build for Windows (amd64)"
	@echo "  clean       - Remove build artifacts"
	@echo "  install     - Install to GOPATH/bin"
	@echo "  test        - Run tests"
	@echo "  help        - Show this help"
