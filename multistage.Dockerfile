# ── Stage 1: Build Stage ──────────────────────────
FROM python:3.11 AS builder

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# ── Stage 2: Run Stage ────────────────────────────
FROM python:3.11-slim AS runtime

WORKDIR /app

# Copy only installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /app .

EXPOSE 5000

CMD ["python", "app.py"]
