FROM python:3.11-slim

# Force Python output to flush directly to Railway logs
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# CRITICAL: Replace "main.py" with the EXACT name of your .py file
CMD ["python", "Cobra_Bomber.py"]
