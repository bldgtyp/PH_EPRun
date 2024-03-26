# Use the existing EnergyPlus container as the base image
FROM nrel/energyplus:23.2.0

# Install any additional dependencies required for your Python scripts
# For example, if you need Python and pip:
RUN apt-get update && apt-get install -y python3 python3-pip

# Set working directory
WORKDIR /app

# Copy your Python scripts into the container
COPY main.py /app/

# Set the entrypoint to your Python script
CMD ["EnergyPlus", "--help"]
# CMD ["python3", "main.py"]
