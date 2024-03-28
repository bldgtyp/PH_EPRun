import os
import pathlib

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


@app.get("/", response_model=AppPaths)
def get_root() -> AppPaths:
    cwd = pathlib.Path(os.getcwd())
    app_dir = pathlib.Path(os.environ.get("PATH_APP") or ".").resolve()
    ep_install_dir = pathlib.Path(os.environ.get("PATH_ENERGY_PLUS_INSTALL") or ".")
    idd_file = ep_install_dir / "Energy+.idd"
    idf_file = app_dir / pathlib.Path("Exercise1A.idf").resolve()
    epw_file = (
        app_dir
        / pathlib.Path(
            "WeatherData/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"
        ).resolve()
    )

    d = AppPaths(
        AppPath(cwd, cwd.exists()),
        AppPath(ep_install_dir, ep_install_dir.exists()),
        AppPath(idd_file, idd_file.exists()),
        AppPath(idf_file, idf_file.exists()),
        AppPath(epw_file, epw_file.exists()),
    )
    return d


# # # -- Setup the IDD and IDF Files needed
# # -- Mess with the IDF file
# IDF.setiddname(idd_file)
# idf_model = IDF(idf_file, epw_file)

# # TODO: Wrap all this inside a FastAPI app, pass JSON back when complete....
# idf_model.run()
