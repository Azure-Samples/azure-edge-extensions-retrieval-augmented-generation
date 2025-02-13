# Overview

This is the LLM component of the RAG-on-Edge project.

Before building the container and deploying:

1. The variable `N_THREADS` gets set to the number of logical CPUs available on the system by default. You can override this value by setting the Environment Variable `N_THREADS` in the Kubernetes manifest `./deploy/yaml/rag-llm-dapr-workload.yaml`. This variable is commented out by default.

2. Before deploying the LLM component, make sure to put model files into `./modules/LLMModule/models` folder.
For quantized Llama2 model, download the model files from the [huggingface Llama-2-7B](https://huggingface.co/TheBloke/Llama-2-7B-GGUF). Download the llama-2-7b.Q4_K_M.gguf version and move the file into `./modules/LLMModule/models` folder.

For Phi2 small language model, download the model files from [huggingface Phi2](https://huggingface.co/TheBloke/phi-2-GGUF/tree/main). Download the Phi-2.Q4_K_M.gguf version.
  ```bash
  curl -L https://huggingface.co/TheBloke/phi-2-GGUF/resolve/main/phi-2.Q4_K_M.gguf?download=true --output phi-2.Q4_K_M.gguf
  ```
