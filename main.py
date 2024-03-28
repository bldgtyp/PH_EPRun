import os
import pathlib

from typing import List

from dataclasses import dataclass

try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError as e:
    print(e)

# from eppy import modeleditor
# from eppy.modeleditor import IDF

from fastapi import FastAPI, Response

app = FastAPI()


@dataclass
class AppPath:
    path: pathlib.Path
    exists: bool


@dataclass
class AppPaths:
    os_getcwd: AppPath
    ep_install_dir: AppPath
    idd_file: AppPath
    idf_file: AppPath
    epw_file: AppPath
    app_files: List[str]
    ep_files: List[str]


@app.get("/", response_model=AppPaths)
def get_root() -> AppPaths:
    cwd = pathlib.Path(os.getcwd())
    app_dir = pathlib.Path(os.environ.get("PATH_APP") or "/").resolve()
    ep_install_dir = pathlib.Path(os.environ.get("PATH_ENERGY_PLUS_INSTALL") or "/")
    idd_file = ep_install_dir / "Energy+.idd"
    idf_file = app_dir / "Exercise1A.idf"
    epw_file = app_dir / "WeatherData" / "USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"

    d = AppPaths(
        AppPath(cwd.resolve(), cwd.resolve().exists()),
        AppPath(ep_install_dir.resolve(), ep_install_dir.resolve().exists()),
        AppPath(idd_file.resolve(), idd_file.resolve().exists()),
        AppPath(idf_file.resolve(), idf_file.resolve().exists()),
        AppPath(epw_file.resolve(), epw_file.resolve().exists()),
        [f"{f.resolve()}" for f in app_dir.iterdir() if f.is_file()],
        [f"{f.resolve()}" for f in ep_install_dir.iterdir() if f.is_file()],
    )
    return d


# # # -- Setup the IDD and IDF Files needed
# # -- Mess with the IDF file
# IDF.setiddname(idd_file)
# idf_model = IDF(idf_file, epw_file)

# # TODO: Wrap all this inside a FastAPI app, pass JSON back when complete....
# idf_model.run()
