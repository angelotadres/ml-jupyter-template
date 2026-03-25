# ML Jupyter Template

A Docker-based JupyterLab environment for machine learning, pre-loaded with PyTorch, TensorFlow, and a standard data science stack. Use this as a starting point for any ML project — no local Python setup required.

## Stack

| Category | Packages |
|---|---|
| Deep Learning | PyTorch, TensorFlow ≥ 2.15 |
| Data | NumPy, Pandas |
| ML | scikit-learn |
| Visualization | Matplotlib, Seaborn |
| NLP | tiktoken |
| Jupyter | JupyterLab, ipywidgets |

Python 3.10 · JupyterLab · Dark theme · No auth token

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (includes Docker Compose)

## Quick Start

**macOS / Linux**
```bash
./run.sh
```

**Windows**
```
run.bat
```

Then open [http://localhost:8888](http://localhost:8888) in your browser.

> The first build takes a while — PyTorch and TensorFlow are large. Subsequent starts are fast because Docker caches the layers.

## Customizing Packages

Edit `requirements.txt` before building, then rebuild:

```bash
# Add a package
echo "transformers" >> requirements.txt

# Rebuild
./run.sh
```

PyTorch and TensorFlow are managed directly in the `Dockerfile` to keep them in their own cached layers. Everything else goes in `requirements.txt`.

## GPU Support (NVIDIA)

1. Install [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) on your host machine.
2. Uncomment the `deploy` block in `docker-compose.yml`.
3. Rebuild and start.

```yaml
# docker-compose.yml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: 1
          capabilities: [gpu]
```

To verify inside the notebook:
```python
import torch
print(torch.cuda.is_available())   # True
print(torch.cuda.get_device_name(0))
```

## Project Structure

```
.
├── Dockerfile            # Image definition (Python, PyTorch, TensorFlow, deps)
├── docker-compose.yml    # Container config, port mapping, volume, GPU toggle
├── requirements.txt      # Python packages — edit this to customize
├── run.sh                # Start script (macOS / Linux)
├── run.bat               # Start script (Windows)
└── workspace/            # Mounted volume — your notebooks and data go here
    └── getting_started.ipynb
```

## Notes

- **No authentication token** — access JupyterLab directly at `localhost:8888`. Only expose this on a trusted network.
- **Persistence** — everything saved in `workspace/` persists on your host machine. The container itself is stateless.
- **Git** — `git` is available inside the container, or you can commit from your host machine directly in the `workspace/` folder.
