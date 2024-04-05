# Use the existing EnergyPlus container as the base image
# https://hub.docker.com/r/nrel/energyplus/tags
# https://github.com/NREL/docker-energyplus
FROM nrel/energyplus:23.2.0

# -----------------------------------------------------------------------------
# -- Paths & Env. Variables
ARG ENERGYPLUS_DIRECTORY=EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64
ARG APP_DIRECTORY=app

ENV PATH_ENERGY_PLUS_INSTALL=/${ENERGYPLUS_DIRECTORY}
ENV PATH_APP=/${APP_DIRECTORY}

# -----------------------------------------------------------------------------
# -- Python
# Install Python3.8 (since we're using Ubuntu 20.04)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

# -- Upgrade pip
RUN pip install --upgrade pip

# -- Install Python dependencies
WORKDIR /${APP_DIRECTORY}
COPY requirements.txt /${APP_DIRECTORY}
RUN pip install -r requirements.txt

# -- Copy the python files
COPY main.py /${APP_DIRECTORY}

# -----------------------------------------------------------------------------
# -- EnergyPlus
# Copy the EnergyPlus files
COPY Exercise1A.idf /${APP_DIRECTORY}/
COPY WeatherData/ /${APP_DIRECTORY}/WeatherData/

# -----------------------------------------------------------------------------
# -- Uvicorn
EXPOSE 80

# Set the entrypoint to the execution
CMD ["python3", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]

# -----------------------------------------------------------------------------
# -- Uvicorn
# To Build & Run: "docker-compose up --build"