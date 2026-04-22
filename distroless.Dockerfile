# ── Stage 1: Build Stage ──────────────────────────
FROM python:3.11 AS builder

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/app/packages -r requirements.txt

# Copy source code
COPY . .

# ── Stage 2: Distroless Run Stage ─────────────────
FROM gcr.io/distroless/python3-debian12 AS runtime

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /app/packages /app/packages
COPY --from=builder /app/app.py .

# Set Python path to find packages
ENV PYTHONPATH=/app/packages

EXPOSE 5000

CMD ["app.py"]
