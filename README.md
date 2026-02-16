# Ollama Justfile

A collection of convenient commands to run various [Ollama](https://ollama.ai/)
AI models in a containerized environment using Podman. Available as both a
Justfile and Makefile.

This repo was created for a short online talk given to 
[CodeHub Bristol](https://codehub.org.uk), a peer-learning group in Bristol, UK.

## Features

- 🚀 Quick access to popular AI models (Mistral, Llama, Gemma, Qwen, Phi, DeepSeek Coder)
- 🐳 Containerized environment using Podman
- ⚡ Auto-starts Ollama container when needed
- 🔧 Choose your tool: `just` or `make`
- 📦 Persistent model storage with named volumes

## Prerequisites

- [Podman](https://podman.io/) installed and configured
- Either [just](https://github.com/casey/just) or `make` (most systems have make pre-installed)

### Installing Just (optional)

If you prefer using `just` over `make`:

```bash
# On Linux
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/bin

# On macOS
brew install just

# On Arch Linux
pacman -S just
```

## Usage

### Getting Help

```bash
# Using just
just help

# Using make
make help
```

### Available Models

Run any of these models with a single command. The Ollama container will start automatically if not already running:

| Command | Model | Description |
|---------|-------|-------------|
| `just mistral` / `make mistral` | Mistral 7B | Fast, balanced general-purpose model |
| `just llama` / `make llama` | Llama 3.1 | Meta's flagship model |
| `just gemma` / `make gemma` | Gemma 2 | Google's efficient model |
| `just qwen` / `make qwen` | Qwen 2.5 | Excellent multilingual & coding support |
| `just phi` / `make phi` | Phi-3 | Microsoft's small but capable model |
| `just deepseek-coder` / `make deepseek-coder` | DeepSeek Coder v2 | Specialized for coding tasks |

### Container Management

```bash
# Start the Ollama container
just start    # or: make start

# Stop the Ollama container
just stop     # or: make stop
```

## How It Works

1. The first time you run a model command, it creates a Podman container running Ollama
2. The container exposes port 11434 for API access
3. Models are stored in a persistent volume (`ollama-data`)
4. Subsequent runs reuse the existing container
5. When you run a model for the first time, Ollama will download it automatically

## Examples

```bash
# Start an interactive session with Mistral
just mistral

# Have a coding conversation with DeepSeek Coder
just deepseek-coder

# Use Qwen for multilingual tasks
just qwen
```

Once in an interactive session, you can chat with the model. Type `/bye` to exit.

## Technical Details

- **Container Runtime**: Podman
- **Base Image**: `docker.io/ollama/ollama`
- **Exposed Port**: 11434
- **Volume**: `ollama-data` (persistent storage for models)

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2026 Stephen Leach

## Contributing

Feel free to open issues or submit pull requests to add more models or improve functionality.

## Links

- [Ollama Documentation](https://github.com/ollama/ollama)
- [Just Command Runner](https://github.com/casey/just)
- [Podman](https://podman.io/)
