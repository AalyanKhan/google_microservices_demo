# Use the official Python image from the Docker Hub
FROM python:3.11-slim-bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install and create a non-root user in the builder to avoid permission issues
RUN useradd --create-home --shell /bin/bash --uid 1000 appuser

COPY requirements.txt .

# Install dependencies for the application
RUN pip install --no-cache-dir --user --requirement requirements.txt

FROM python:3.11.10-slim-bookworm

WORKDIR /app
COPY --from=builder /root/.local /app/.local

COPY --chown=1000:1000 . .

ENV PATH=/app/.local/bin:$PATH

# Switch to the non-root user
USER 1000

CMD ["python", "email_service.py"]
