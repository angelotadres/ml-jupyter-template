# Use a lightweight Python base that supports Apple Silicon (ARM64) naturally
FROM python:3.10-slim

# Set working directory
WORKDIR /workspace

# Install system dependencies
# 'git' for cloning
# 'procps' is often needed for Jupyter kernel management
RUN apt-get update && apt-get install -y git procps && rm -rf /var/lib/apt/lists/*

# Install the exact Python libraries for Raschka's book
# Note: On Mac, 'torch' will install the CPU version by default which is correct for Docker
RUN pip install --no-cache-dir \
    jupyterlab \
    torch \
    tiktoken \
    tensorflow>=2.15.0 \
    tqdm>=4.66 \
    pandas \
    matplotlib \
    numpy

# Expose the Jupyter port
EXPOSE 8888

# Jupyter Configuration
# 1. Disable the "News" and "Update" popups
RUN mkdir -p /etc/jupyter/labconfig && \
    echo '{"disabledExtensions": {"@jupyterlab/apputils-extension:announcements": true}}' \
    > /etc/jupyter/labconfig/page_config.json

# 2. Force Dark Mode
RUN mkdir -p /usr/local/share/jupyter/lab/settings && \
    echo '{"@jupyterlab/apputils-extension:themes": {"theme": "JupyterLab Dark"}}' \
    > /usr/local/share/jupyter/lab/settings/overrides.json

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]