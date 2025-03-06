default:
    @just --list

@install_uv:
	if ! command -v uv >/dev/null 2>&1; then \
		echo "uv is not installed. Installing..."; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	fi

setup: install_uv
    uv sync

login: setup
    uv run huggingface-cli login

# Use bash shebang
download_models: setup
    #!/usr/bin/env bash
    filenames=(
        "ctvit_pretrained.pt"
        "transformer_pretrained.pt"
        "superres_pretrained.pt"
    )
    for filename in "${filenames[@]}"; do
        uv run -- huggingface-cli download \
            generatect/GenerateCT \
            pretrained_models/$filename
    done

download_data: setup
    uv run -- huggingface-cli download \
        generatect/GenerateCT \
        example_data.zip
