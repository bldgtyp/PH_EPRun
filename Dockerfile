# Use the existing EnergyPlus container as the base image
# https://hub.docker.com/r/nrel/energyplus/tags
FROM nrel/energyplus:23.2.0

# Set the Paths
ARG ENERGYPLUS_DIRECTORY=EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64
ARG APP_DIRECTORY=app

# Set the environment variables for the Paths
ENV PATH_ENERGY_PLUS_INSTALL=/${ENERGYPLUS_DIRECTORY}
ENV PATH_APP=/${APP_DIRECTORY}

# Install Python
RUN apt-get update && apt-get install -y python3 python3-pip

# Change to the app folder
WORKDIR /${APP_DIRECTORY}

# Install Python dependencies
COPY ./requirements.txt /${APP_DIRECTORY}
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy the python files
COPY main.py /${APP_DIRECTORY}

# Copy the EnergyPlus files
COPY Exercise1A.idf /${APP_DIRECTORY}/
COPY WeatherData/ /${APP_DIRECTORY}/WeatherData/

# Set the entrypoint to the execution
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]

# To Build: "docker-compose up --build"
# To Run: "docker run -d -p 8080:80 ph_ep_run"