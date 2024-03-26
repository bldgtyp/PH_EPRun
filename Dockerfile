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

# Copy all files into the container
ARG ENERGYPLUS_DIRECTORY=EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64
COPY main.py /${ENERGYPLUS_DIRECTORY}/
COPY Exercise1A.idf /${ENERGYPLUS_DIRECTORY}/
COPY WeatherData/ /${ENERGYPLUS_DIRECTORY}/WeatherData/

# Set working directory
WORKDIR /${ENERGYPLUS_DIRECTORY}

# Set the environment variable for EnergyPlus
ENV ENERGYPLUS_INSTALL_DIR=/${ENERGYPLUS_DIRECTORY}

# Set the entrypoint to the execution
CMD ["python3", "main.py"]
