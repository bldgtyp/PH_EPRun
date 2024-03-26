# Use the existing EnergyPlus container as the base image
# https://hub.docker.com/r/nrel/energyplus/tags
FROM nrel/energyplus:23.2.0

# Install any additional dependencies required for your Python scripts
# For example, if you need Python and pip:
RUN apt-get update && apt-get install -y python3 python3-pip

# Install Python dependencies
RUN pip3 install eppy
RUN pip3 install python-dotenv
RUN pip3 install fastapi


# Copy your Python scripts into the container
COPY main.py /EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64/
COPY WeatherData/ /EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64/WeatherData/
COPY Exercise1A.idf /EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64/

# Set working directory
WORKDIR /EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64

ENV ENERGYPLUS_INSTALL_DIR=/EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64

# Set the entrypoint to your Python script
# CMD ["EnergyPlus", "--help"]
CMD ["python3", "main.py"]
