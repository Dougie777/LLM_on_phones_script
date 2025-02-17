#!/bin/bash
# This script sets up llama.cpp, downloads a GGUF model for serving, and starts the LLM server.
# It is designed to be re-runnable.
# Ensure Termux is installed and storage permissions are granted if needed.

set -e  # Exit immediately if a command exits with a non-zero status.

# 1. Update and upgrade packages
echo "Updating and upgrading packages..."
pkg update && pkg upgrade -y

# 2. Install required packages
echo "Installing required packages (cmake, clang, make, git, wget)..."
pkg install -y cmake clang make git wget

# 3. Clone or update the llama.cpp repository
if [ ! -d "llama.cpp" ]; then
    echo "Cloning llama.cpp repository..."
    git clone https://github.com/ggerganov/llama.cpp.git || { echo "Clone failed!"; exit 1; }
else
    echo "llama.cpp repository already exists. Pulling latest changes..."
    cd llama.cpp
    git pull
    cd ..
fi

# 4. Enter the llama.cpp directory and create the build directory
cd llama.cpp || exit 1
mkdir -p build
cd build || exit 1

# 5. Configure with CMake
echo "Configuring with CMake..."
cmake ..

# 6. Build the project in Release mode
echo "Building the project (this may take some time)..."
cmake --build . --config Release

# 7. Create models directory structure and navigate to the 3B folder
echo "Setting up models directory..."
mkdir -p models/3B
cd models/3B || exit 1

# 8. Download the LLM model using wget with resume support
echo "Downloading the LLM model (resumable)..."
wget -c -O small.gguf "https://huggingface.co/bartowski/SmallThinker-3B-Preview-GGUF/resolve/main/SmallThinker-3B-Preview-Q4_K_M.gguf?download=true"

# 9. Return to the build directory
cd ../.. || exit 1

# 10. Start the LLM server using the downloaded model
echo "Starting llama-server with the downloaded model..."
./bin/llama-server --model models/3B/small.gguf

# Once the server starts, open your browser and go to http://127.0.0.1:8080 to test your model.
