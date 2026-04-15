# STAGE 1 — Install Python dependencies
FROM python:3.12-alpine AS deps

# Install system dependencies required by postgres
RUN apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev

# Copy dependency file first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# STAGE 2 — Build source code
FROM deps AS builder

# Work directory
WORKDIR /app

# Copy source code
COPY . .

# Compile Python bytecode
RUN python -m compileall .

# STAGE 3 — Runtime
FROM python:3.12-alpine AS runtime

# Install runtime library for postgres
RUN apk add --no-cache libpq

# Set logging for CloudWatch
ENV PYTHONUNBUFFERED=1

# Work directory
WORKDIR /app

# Create non-root user and switch
RUN adduser -D appuser
USER appuser

# Copy application source from builder
COPY --chown=appuser:appuser --from=builder /app /app

# Copy Python packages from deps
COPY --from=deps /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# Copy uvicorn binary
COPY --from=deps /usr/local/bin/uvicorn /usr/local/bin/uvicorn

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/healthz').read()" || exit 1

# Expose port
EXPOSE 8080

# Run application
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080", "--timeout-graceful-shutdown", "10"]