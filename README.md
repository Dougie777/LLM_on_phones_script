## This is a step by step process of how to get your LLMs running on an Android Phone


1.	Install Termux from Google Play
2.	Once inside termux, run the following
```bash
pkg update && pkg upgrade
pkg install cmake clang make git wget
```

4.	Go, to llama cpp github and copy the repo.
```bash
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
```

6.	Build the system

```bash
mkdir build
cd build
cmake ..
cmake  - -build . - -config Release
```
7.	Make a Models folder inside Build if not available
```bash
mkdir models
cd models
mkdir 3B
cd 3B
```
9.	Go to the desired GGUF huggingface link
(a).	https://huggingface.co/bartowski/SmallThinker-3B-Preview-GGUF
(b).	Select a particular version’s download link eg. https://huggingface.co/bartowski/SmallThinker-3B-Preview-GGUF/resolve/main/SmallThinker-3B-Preview-Q4_K_M.gguf?download=true

11.	Upload the LLM to models folder
(a).	Inside the 3B folder, type
```bash
wget https://huggingface.co/bartowski/SmallThinker-3B-Preview-GGUF/resolve/main/SmallThinker-3B-Preview-Q4_K_M.gguf?download=true
```
b.	This will download the model, it may take some time.
13.	Rename the GGUF to a short name
```bash
mv https://huggingface.co/bartowski/SmallThinker-3B-Preview-GGUF/resolve/main/SmallThinker-3B-Preview-Q4_K_M.gguf?download=true small.gguf
```
14.	Come back to build folder
a.	Since you are in 3B folder, type
```bash
cd ..
```
required number of times to come back to the build folder.
16.	Serve your LLM model

(a).	Type this command: 
```bash
./bin/llama-server –model models/3B/small.gguf
```
17.	Go to localhost:8080 for testing the model
(a).	Go to a browser and type 127.0.0.1:8080
(b).	Play with your model
