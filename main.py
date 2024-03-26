print("- " * 25)
print("Starting main.py")

import os
import pathlib

try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError as e:
    print(e)

from eppy import modeleditor
from eppy.modeleditor import IDF


def list_files(start_path):
    for root, dirs, files in os.walk(start_path):
        level = root.replace(str(start_path), "").count(os.sep)
        indent = " " * 4 * (level)
        print("{}{}/".format(indent, os.path.basename(root)))
        sub_indent = " " * 4 * (level + 1)
        for file in files:
            if ".idd" in str(file):
                print("{}{}".format(sub_indent, file))


print("os.getcwd():", os.getcwd())
# # -- Setup the IDD and IDF Files needed
ep_install_dir = pathlib.Path(os.environ.get("ENERGYPLUS_INSTALL_DIR") or ".")
print(
    f"EnergyPlus Directory | {ep_install_dir.resolve()} [exists={ep_install_dir.exists()}]"
)

idd_file = ep_install_dir / "Energy+.idd"
print(f"IDD File | {str(idd_file.resolve())} [exists={idd_file.exists()}]")

idf_file = pathlib.Path("Exercise1A.idf")
print(f"IDF File | {str(idf_file.resolve())} [exists={idf_file.exists()}]")

epw_file = pathlib.Path("WeatherData/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
print(f"EPW File | {str(epw_file.resolve())} [exist={epw_file.exists()}]")

# -- Mess with the IDF file
IDF.setiddname(idd_file)
idf_model = IDF(idf_file, epw_file)

# TODO: Wrap all this inside a FastAPI app, pass JSON back when complete....
idf_model.run()
