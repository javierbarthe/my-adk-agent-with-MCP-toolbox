# my-adk-base-agent-with-MCP

A base ReAct agent built with Google's Agent Development Kit (ADK)
Agent generated with [`googleCloudPlatform/agent-starter-pack`](https://github.com/GoogleCloudPlatform/agent-starter-pack) version `0.3.5` 
and integrated with [`googleapis/genai-toolbox`](https://googleapis.github.io/genai-toolbox/getting-started/introduction/) 

Simple agent for local testing and prototyping.

## Project Structure

This project is organized as follows:

```
my-adk-base-agent/
├── app/                 # Core application code
│   ├── agent.py         # Main agent logic
│   ├── agent_engine_app.py # Agent Engine application logic
│   └── utils/           # Utility functions and helpers
├── Makefile             # Makefile for common commands
└── pyproject.toml       # Project dependencies and configuration
```

The create agent starter pack will generate also the following folders.
├── deployment/          # Infrastructure and deployment scripts
├── notebooks/           # Jupyter notebooks for prototyping and evaluation
├── tests/               # Unit, integration, and load tests

## Requirements

Before you begin, ensure you have:
- **uv**: Python package manager - [Install](https://docs.astral.sh/uv/getting-started/installation/)
- **Google Cloud SDK**: For GCP services - [Install](https://cloud.google.com/sdk/docs/install)
- **Terraform**: For infrastructure deployment - [Install](https://developer.hashicorp.com/terraform/downloads)
- **make**: Build automation tool - [Install](https://www.gnu.org/software/make/) (pre-installed on most Unix-based systems)
- **MCP Toolbox**: MCP Toolbox - [Install](https://www.gnu.org/software/make/) (pre-installed on most Unix-based systems)
- **Alloydb Auth Proxy**: Alloydb Proxy


## Quick Start (Local Testing)

Install required packages and launch the local development environment:

```bash
python -m venv .venv
source .venv/bin/activate    
pip install google-adk langchain toolbox-langchain agent-starter-pack uv
make install 
start_stop_services.sh start
make playground
```

## Commands


| Command              | Description                                                                                 |
| -------------------- | ------------------------------------------------------------------------------------------- |
| `make install`       | Install all required dependencies using uv                                                  |
| `make playground`    | Launch Streamlit interface for testing agent locally and remotely |
| `make backend`       | Deploy agent to Agent Engine |
| `make test`          | Run unit and integration tests                                                              |
| `make lint`          | Run code quality checks (codespell, ruff, mypy)                                             |
| `make setup-dev-env` | Set up development environment resources using Terraform                                    |
| `uv run jupyter lab` | Launch Jupyter notebook                                                                     |



## Usage

