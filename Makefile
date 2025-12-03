ENV_FILE := .env.local
PYTHON_BIN ?= /opt/homebrew/bin/python3
UV ?= uv

ifneq (,$(wildcard $(ENV_FILE)))
include $(ENV_FILE)
export PENTESTGPT_USE_OLLAMA_DEFAULT
export OLLAMA_BASE_URL
export OLLAMA_MODEL
endif

.PHONY: build install clean format lint unittest test ollama-local gui uv-sync uv-ollama uv-gui

build: # force build
	poetry build

install:
	$(PYTHON_BIN) -m pip install -e .

format: updatesetup
	isort pentestgpt
	black pentestgpt

updatesetup:
	bash pentestgpt/scripts/update.sh

ollama-local:
	@echo "Using Ollama base URL: $${OLLAMA_BASE_URL:-http://localhost:11434}"
	@echo "Using Ollama model: $${OLLAMA_MODEL:-gpt-oss:20b}"
	$(PYTHON_BIN) -m pentestgpt.main --ollama $${OLLAMA_MODEL:-gpt-oss:20b}

gui:
	@echo "Launching PentestGPT GUI"
	$(PYTHON_BIN) -m pentestgpt.gui.ollama_console

uv-sync:
	$(UV) sync --python $(PYTHON_BIN)

uv-ollama:
	@echo "Using Ollama base URL: $${OLLAMA_BASE_URL:-http://localhost:11434}"
	@echo "Using Ollama model: $${OLLAMA_MODEL:-gpt-oss:20b}"
	$(UV) run -- python -m pentestgpt.main --ollama $${OLLAMA_MODEL:-gpt-oss:20b}

uv-gui:
	@echo "Launching PentestGPT GUI via uv"
	$(UV) run -- python -m pentestgpt.gui.ollama_console