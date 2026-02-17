#!/usr/bin/make -f

# Container runtime to use (podman or docker)
CONTAINER_RUNTIME := podman

.PHONY: default help start stop mistral llama gemma qwen phi deepseek-coder dostart

default:
	@make -f $(MAKEFILE_LIST) help

# List available commands
help:
	@echo "A collection of commands to run various Ollama models in a containerized environment."
	@echo "Available models, which auto-start the Ollama container if not already running:"
	@echo "  - make mistral: Run Mistral 7B (fast, balanced general-purpose model)"
	@echo "  - make llama: Run Llama 3.1 (Meta's flagship model)"
	@echo "  - make gemma: Run Gemma 2 (Google's efficient model)"
	@echo "  - make qwen: Run Qwen 2.5 (excellent multilingual & coding)"
	@echo "  - make phi: Run Phi-3 (Microsoft's small but capable model)"
	@echo "  - make deepseek-coder: Run DeepSeek Coder v2 (specialized for coding)"
	@echo "Other commands:"
	@echo "  - make start: Start Ollama container if not already running"
	@echo "  - make stop: Stop Ollama container"

# Start Ollama container if not already running
start:
	@if ! $(CONTAINER_RUNTIME) ps --format '{{.Names}}' | grep -q '^ollama$$'; then \
	  if $(CONTAINER_RUNTIME) ps -a --format '{{.Names}}' | grep -q '^ollama$$'; then \
	    echo "Starting existing ollama container..." ; \
	    $(CONTAINER_RUNTIME) start ollama ; \
	  else \
	    echo "Creating and starting new ollama container..." ; \
	    make -f $(MAKEFILE_LIST) dostart ; \
	  fi \
	else \
	  echo "Ollama container already running." ; \
	fi

# Stop Ollama container
stop:
	@$(CONTAINER_RUNTIME) stop ollama

# Run Mistral 7B (fast, balanced general-purpose model)
mistral: start
	@$(CONTAINER_RUNTIME) exec -it ollama ollama run mistral

# Run Llama 3.1 (Meta's flagship model)
llama: start
	@$(CONTAINER_RUNTIME) exec -it ollama ollama run llama3.1

# Run Gemma 2 (Google's efficient model)
gemma: start
	@$(CONTAINER_RUNTIME) exec -it ollama ollama run gemma2

# Run Qwen 2.5 (excellent multilingual & coding)
qwen: start
	@$(CONTAINER_RUNTIME) exec -it ollama ollama run qwen2.5

# Run Phi-3 (Microsoft's small but capable model)
phi: start
	@$(CONTAINER_RUNTIME) exec -it ollama ollama run phi3

# Run DeepSeek Coder v2 (specialized for coding)
deepseek-coder: start
	@$(CONTAINER_RUNTIME) exec -it ollama ollama run deepseek-coder-v2

# Try to start Ollama container (used by mistral) regardless of its current state.
dostart:
	@$(CONTAINER_RUNTIME) run -d \
	  --name ollama \
	  -p 11434:11434 \
	  -v ollama-data:/root/.ollama \
	  docker.io/ollama/ollama
