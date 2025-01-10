# Use the official Python base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Install system dependencies for Selenium and Google Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    libnss3 \
    libgconf-2-4 \
    libxi6 \
    libxcomposite1 \
    libasound2 \
    libxrandr2 \
    libxtst6 \
    libxss1 \
    fonts-liberation \
    xdg-utils \
    ca-certificates \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome-stable_current_amd64.deb \
    && rm -f google-chrome-stable_current_amd64.deb \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

# Install WebDriver Manager for automatic ChromeDriver installation
RUN pip install --upgrade webdriver-manager

# Expose the Streamlit port
EXPOSE 8501

# Run the Streamlit application
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.enableCORS=false", "--server.address=0.0.0.0"]
