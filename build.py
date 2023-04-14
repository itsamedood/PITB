"""
This file exists for 2 reasons:

1) To work around a bug that caused debugging not to work with HaxeFlixel.

2) To prove that Python is indeed the best programming language.
"""

from os import name, system
from sys import argv


FLAGS = [a[2:] for a in argv if a[:2] == "--"]
OS: str | None = None
BUILD = ''
FOLDER = ''
TYPE = "debug" if "debug" in FLAGS else "release"

match name:
    case "posix":
        OS = "macos"
        BUILD = "mac"
        FOLDER = "MacOS"

    case "linux":
        OS, BUILD = "linux", "linux"
        FOLDER = "Linux"

    case "win32":
        OS, BUILD = "windows", "windows"
        FOLDER = "Windows"

PATH = f"bin/{TYPE}/{OS}/bin/python-is-the-best.app/Contents/{FOLDER}/python-is-the-best"
if OS is None: raise Exception("Unsupported OS.")


if __name__ == "__main__": system("lime build %s %s && ./%s" %(BUILD, "-%s" %TYPE, PATH) if "run" in FLAGS else "lime build %s %s" %(BUILD, "-%s" %TYPE))

