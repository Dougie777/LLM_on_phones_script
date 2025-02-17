#!/bin/sh
# This script sets up llama.cpp, downloads a GGUF model for serving, and starts the LLM server.
# It is adapted for Alpine Linux (e.g., running on iOS via iSH) and is re‑runnable.

set -e  # Exit immediately if a command exits with a non-zero status.

# 1. Update and upgrade packages
echo "Updating and upgrading packages..."
apk update && apk upgrade

# 2. Install required packages (cmake, clang, make, git, wget)
echo "Installing required packages..."
apk add --no-cache cmake clang make git wget

# 3. Clone or update the llama.cpp repository
if [ ! -d "llama.cpp" ]; then
    echo "Cloning llama.cpp repository..."
    git clone https://github.com/ggerganov/llama.cpp.git || { echo "Clone failed!"; exit 1; }
else
    echo "llama.cpp repository already exists; updating..."
    cd llama.cpp
    git pull
    cd ..
fi

# 4. Enter the repository and create the build directory
cd llama.cpp || exit 1
mkdir -p build
cd build || exit 1

# 5. Configure the project with CMake
echo "Configuring the project with CMake..."
cmake ..

# 6. Build the project (this may take a while)
echo "Building the project..."
cmake --build . --config Release

# 7. Create the models directory structure and download the GGUF model
echo "Setting up models directory..."
mkdir -p models/3B
cd models/3B || exit 1

echo "Downloading the LLM model (with resume support)..."
wget -c -O small.gguf "https://huggingface.co/bartowski/SmallThinker-3B-Preview-GGUF/resolve/main/SmallThinker-3B-Preview-Q4_K_M.gguf?download=true"

# 8. Return to the build directory
cd ../..

# 9. Start the LLM server using the downloaded model
echo "Starting llama-server with the downloaded model..."
./bin/llama-server --model models/3B/small.gguf

# When the server starts, open your browser and navigate to http://127.0.0.1:8080 to test your model.
