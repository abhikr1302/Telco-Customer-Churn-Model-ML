FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY requirements.txt .

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    libffi-dev \
    libssl-dev \
    libpq-dev \
    pkg-config \
    python3-dev \
    cargo \
    rustc \
    && pip install --upgrade pip setuptools wheel \
    && pip install --prefer-binary --no-cache-dir "cffi>=1.17.1,<2" \
    && pip install --prefer-binary --no-cache-dir fastapi==0.115.0 pydantic==2.8.2 gradio==4.44.0 pandas==2.1.4 numpy==1.26.4 mlflow==2.14.1 xgboost==3.0.3 uvicorn==0.30.5 gunicorn==22.0.0 requests==2.32.4 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .

CMD ["python", "-m", "uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "8000"]