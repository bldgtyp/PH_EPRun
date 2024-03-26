FROM ubuntu:latest

# Install wget and python3-pip (for installing EpPy)
RUN apt-get update && \
    apt-get install -y wget python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Download and install EnergyPlus
RUN wget --quiet https://github.com/NREL/EnergyPlus/releases/download/v23.1.0/EnergyPlus-23.1.0-87ed9199d4-Linux-Ubuntu18.04-x86_64.sh && \
    chmod +x EnergyPlus-23.1.0-87ed9199d4-Linux-Ubuntu18.04-x86_64.sh && \
    echo "y" | ./EnergyPlus-23.1.0-87ed9199d4-Linux-Ubuntu18.04-x86_64.sh && \
    rm EnergyPlus-23.1.0-87ed9199d4-Linux-Ubuntu18.04-x86_64.sh

# Install Python dependencies
RUN pip3 install eppy
RUN pip3 install python-dotenv

# Set environment variables
ENV ENERGYPLUS_INSTALL_DIR=/usr/local/EnergyPlus-23-1-0

# Set working directory
WORKDIR /usr/local/EnergyPlus-23-1-0

# Copy main.py into the Docker image
COPY main.py .
COPY WeatherData/ ./WeatherData/
COPY Exercise1A.idf .

# Expose any necessary ports
# EXPOSE <port>

# Define the command to run main.py
CMD ["python3", "main.py"]

