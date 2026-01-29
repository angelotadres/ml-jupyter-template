# Use a lightweight Python base
FROM python:3.10-slim

# Set working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y git procps && rm -rf /var/lib/apt/lists/*

# Upgrade pip first
RUN pip install --no-cache-dir --upgrade pip

# --- LAYER 1: The Heavyweight (PyTorch) ---
# We install this alone. Adding --verbose lets you see the download progress 
# so you know it isn't stuck.
RUN pip install --no-cache-dir --verbose torch

# --- LAYER 2: The Second Heavyweight (TensorFlow) ---
RUN pip install --no-cache-dir --verbose tensorflow>=2.15.0

# --- LAYER 3: The Rest ---
# These are smaller and faster to resolve
RUN pip install --no-cache-dir \
    jupyterlab \
    tiktoken \
    tqdm>=4.66 \
    pandas \
    matplotlib \
    numpy

# Expose the Jupyter port
EXPOSE 8888

# Jupyter Configuration (Popups & Dark Mode)
RUN mkdir -p /etc/jupyter/labconfig && \
    echo '{"disabledExtensions": {"@jupyterlab/apputils-extension:announcements": true}}' \
    > /etc/jupyter/labconfig/page_config.json

RUN mkdir -p /usr/local/share/jupyter/lab/settings && \
    echo '{"@jupyterlab/apputils-extension:themes": {"theme": "JupyterLab Dark"}}' \
    > /usr/local/share/jupyter/lab/settings/overrides.json

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]