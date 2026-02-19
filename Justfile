#!/usr/bin/just -f

# Container runtime to use (podman or docker).
container_runtime := "podman"
# Command display name (e.g. "just" or "ollama-go") for help text.
command := "just"

[private]
@default:
    just -f {{justfile()}} --list

# List available commands
@help:
    echo "A collection of commands to run various Ollama models in a containerized environment."
    echo "Available models, which auto-start the Ollama container if not already running:"
    echo "  - {{command}} mistral: Run Mistral 7B (fast, balanced general-purpose model)"
    echo "  - {{command}} llama: Run Llama 3.1 (Meta's flagship model)"
    echo "  - {{command}} gemma: Run Gemma 2 (Google's efficient model)"
    echo "  - {{command}} qwen: Run Qwen 2.5 (excellent multilingual & coding)"
    echo "  - {{command}} phi: Run Phi-3 (Microsoft's small but capable model)"
    echo "  - {{command}} deepseek-coder: Run DeepSeek Coder v2 (specialized for coding)"
    echo "Other commands:"
    echo "  - {{command}} start: Start Ollama container if not already running"
    echo "  - {{command}} stop: Stop Ollama container"

# Start Ollama container if not already running
@start:
    if ! {{container_runtime}} ps --format '{{{{.Names}}' | grep -q '^ollama$'; then \
      if {{container_runtime}} ps -a --format '{{{{.Names}}' | grep -q '^ollama$'; then \
        echo "Starting existing ollama container..." ; \
        {{container_runtime}} start ollama ; \
      else \
        echo "Creating and starting new ollama container..." ; \
        just -f {{justfile()}} dostart ; \
      fi \
    else \
      echo "Ollama container already running." ; \
    fi

# Stop Ollama container
@stop:
    {{container_runtime}} stop ollama

# Run Mistral 7B (fast, balanced general-purpose model)
@mistral: start
    {{container_runtime}} exec -it ollama ollama run mistral

# Run Llama 3.1 (Meta's flagship model)
@llama: start
    {{container_runtime}} exec -it ollama ollama run llama3.1

# Run Gemma 2 (Google's efficient model)
@gemma: start
    {{container_runtime}} exec -it ollama ollama run gemma2

# Run Qwen 2.5 (excellent multilingual & coding)
@qwen: start
    {{container_runtime}} exec -it ollama ollama run qwen2.5

# Run Phi-3 (Microsoft's small but capable model)
@phi: start
    {{container_runtime}} exec -it ollama ollama run phi3

# Run DeepSeek Coder v2 (specialized for coding)
@deepseek-coder: start
    {{container_runtime}} exec -it ollama ollama run deepseek-coder-v2

# Try to start Ollama container (used by @mistral) regardless of its current state.
[private]
@dostart:
    {{container_runtime}} run -d \
    --name ollama \
    -p 11434:11434 \
    -v ollama-data:/root/.ollama \
    docker.io/ollama/ollama
