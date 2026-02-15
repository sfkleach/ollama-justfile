[private]
@default:
    just -f {{justfile()}} --list

# List available commands
@help:
    echo "A collection of commands to run various Ollama models in a containerized environment."
    echo "Available models, which auto-start the Ollama container if not already running:"
    echo "  - ollama mistral: Run Mistral 7B (fast, balanced general-purpose model)"
    echo "  - ollama llama: Run Llama 3.1 (Meta's flagship model)"
    echo "  - ollama gemma: Run Gemma 2 (Google's efficient model)"
    echo "  - ollama qwen: Run Qwen 2.5 (excellent multilingual & coding)"
    echo "  - ollama phi: Run Phi-3 (Microsoft's small but capable model)"
    echo "  - ollama deepseek-coder: Run DeepSeek Coder v2 (specialized for coding)"
    echo "Other commands:"
    echo "  - ollama start: Start Ollama container if not already running"
    echo "  - ollama stop: Stop Ollama container"

# Start Ollama container if not already running
@start:
    if ! podman ps --format '{{{{.Names}}' | grep -q '^ollama$'; then \
      if podman ps -a --format '{{{{.Names}}' | grep -q '^ollama$'; then \
        echo "Starting existing ollama container..." ; \
        podman start ollama ; \
      else \
        echo "Creating and starting new ollama container..." ; \
        just -f {{justfile()}} dostart ; \
      fi \
    else \
      echo "Ollama container already running." ; \
    fi

# Stop Ollama container
@stop:
    podman stop ollama

# Run Mistral 7B (fast, balanced general-purpose model)
@mistral: start
    podman exec -it ollama ollama run mistral

# Run Llama 3.1 (Meta's flagship model)
@llama: start
    podman exec -it ollama ollama run llama3.1

# Run Gemma 2 (Google's efficient model)
@gemma: start
    podman exec -it ollama ollama run gemma2

# Run Qwen 2.5 (excellent multilingual & coding)
@qwen: start
    podman exec -it ollama ollama run qwen2.5

# Run Phi-3 (Microsoft's small but capable model)
@phi: start
    podman exec -it ollama ollama run phi3

# Run DeepSeek Coder v2 (specialized for coding)
@deepseek-coder: start
    podman exec -it ollama ollama run deepseek-coder-v2

# Try to start Ollama container (used by @mistral) regardless of its current state.
[private]
@dostart:
    podman run -d \
    --name ollama \
    -p 11434:11434 \
    -v ollama-data:/root/.ollama \
    docker.io/ollama/ollama

