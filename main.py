print("Starting main.py")
from dotenv import load_dotenv
import os
import pathlib
from eppy import modeleditor
from eppy.modeleditor import IDF

# -- Load environment variables from .env file
load_dotenv()

# -- Setup the IDD and IDF Files needed
ep_install_dir = pathlib.Path(os.environ.get("ENERGYPLUS_INSTALL_DIR") or ".")
print(f"EnergyPlus Install Directory  | {ep_install_dir}")

idd_file = ep_install_dir / "Energy+.idd"
print(
    f"IDD File                      | {str(idd_file.resolve()) :<50} | {idd_file.exists()}"
)

idf_file = pathlib.Path("Exercise1A.idf")
print(
    f"IDF File                      | {str(idf_file.resolve()) :<50} | {idf_file.exists()}"
)

# -- Mess with the IDF file
print(" - " * 25)
IDF.setiddname(idd_file)
idf_model = IDF(idf_file)

print(idf_model.idfobjects["BUILDING"])
bldg = idf_model.idfobjects["BUILDING"][0]
print(bldg.Name)
