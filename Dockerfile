FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

# Android environment variables spoofing
ENV PREFIX=/data/data/com.termux/files/usr
ENV ANDROID_ROOT=/system
ENV ANDROID_DATA=/data
ENV EXTERNAL_STORAGE=/sdcard
ENV HOME=/data/data/com.termux/files/home
ENV PATH="/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/home/.local/bin:${PATH}"
ENV TERM=xterm-256color

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    bash \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 1. Recreate the exact Android phone layout from your screenshots
RUN mkdir -p /data/data/com.termux/files/home \
    && mkdir -p /data/data/com.termux/files/usr/bin \
    && mkdir -p /sdcard/cobra \
    && mkdir -p /sdcard/Download \
    && mkdir -p /storage/emulated \
    && ln -s /sdcard /storage/emulated/0 \
    && ln -s /usr/bin/python3 /data/data/com.termux/files/usr/bin/python \
    && ln -s /usr/bin/python3 /data/data/com.termux/files/usr/bin/python3 \
    && ln -s /bin/bash /data/data/com.termux/files/usr/bin/bash

# 2. Copy dependencies & install
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copy project files and place them in /sdcard, /sdcard/cobra, and Termux home
COPY . /app
RUN cp -r /app/* /sdcard/cobra/ 2>/dev/null || true
RUN cp -r /app/* /sdcard/ 2>/dev/null || true
RUN cp -r /app/* /data/data/com.termux/files/home/ 2>/dev/null || true

# 4. Run the script from the cobra folder
WORKDIR /sdcard/cobra

CMD ["python", "Cobra_Bomber.py"]
