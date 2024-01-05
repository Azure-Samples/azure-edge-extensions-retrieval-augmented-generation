# Overview

This is the LLM component of the RAG-on-Edge project. 
The environment variables N_THREADS in main.py is set to 32 for running on a cluster node with 32 CPU cores.
Make sure to set proper N_THREADS value before deploying the LLM component, the N_THREADS value should be equal to the number of CPU cores on the node.

Before deploying the LLM component, make sure to put model files into ./modules/LLMModule/models folder.

For quantized Llama2 model, download the model files from the [huggingface Llama-2-7B](https://huggingface.co/TheBloke/Llama-2-7B-GGML). Download the llama-2-7b.Q4_K_M.gguf version and put the files into ./modules/LLMModule/models folder.
