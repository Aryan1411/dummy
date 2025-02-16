# Use an official Python image as a base
FROM python:3.11-slim
RUN apt-get update && \
    apt-get install -y curl ca-certificates git tesseract-ocr ffmpeg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g prettier@3.4.2 && \
    rm -rf /var/lib/apt/lists/*

    

# Set the working directory inside the container


# Copy the project files into the container
COPY . /app
COPY funtion_tasks.py /app/
COPY datagen.py /app/
RUN apt-get update && apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

ADD https://astral.sh/uv/install.sh /uv-installer.sh

# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

# Install system dependencies for Python packages
WORKDIR /app
# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt


# Expose the port for FastAPI
EXPOSE 8000

# Run the FastAPI app
CMD ["uv", "run", "main:app"]
