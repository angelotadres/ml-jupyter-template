FROM python:3.10-slim

WORKDIR /workspace

# System dependencies
RUN apt-get update && apt-get install -y git procps && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip

# ── LAYER 1: PyTorch ──────────────────────────────────────────────────────────
# Installed alone so Docker can cache it independently.
# --verbose shows download progress (these are large files).
RUN pip install --no-cache-dir --verbose torch

# ── LAYER 2: TensorFlow ───────────────────────────────────────────────────────
RUN pip install --no-cache-dir --verbose "tensorflow>=2.15.0"

# ── LAYER 3: Everything else (edit requirements.txt to customize) ─────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8888

# Disable announcement popups
RUN mkdir -p /etc/jupyter/labconfig && \
    echo '{"disabledExtensions": {"@jupyterlab/apputils-extension:announcements": true}}' \
    > /etc/jupyter/labconfig/page_config.json

# Dark theme by default
RUN mkdir -p /usr/local/share/jupyter/lab/settings && \
    echo '{"@jupyterlab/apputils-extension:themes": {"theme": "JupyterLab Dark"}}' \
    > /usr/local/share/jupyter/lab/settings/overrides.json

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=''"]
