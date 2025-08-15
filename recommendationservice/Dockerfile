FROM python:3.11-slim-bookworm AS builder

WORKDIR /app

RUN useradd --create-home --shell /bin/bash --uid 1000 appuser

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.11.10-slim-bookworm

WORKDIR /app
COPY --from=builder /home/app/.local /app/.local

ENV PATH=/app/.local/bin:$PATH

COPY . .

USER 1000

CMD ["python", "recommendation_service.py"]
