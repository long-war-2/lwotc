"""In-game tests: build the harness mod, launch XCOM 2 in auto-test mode, and read results from Launch.log.

The game runs with the mods enabled in your launcher plus the harness. For the run, the harness is added to
XComModOptions.ini and the game's local Mods folder to XComEngine.ini; both files are restored afterwards.
"""
import os
import re
import shutil
import subprocess
import winreg
from pathlib import Path

import pytest
from conftest import run

pytestmark = pytest.mark.game

HARNESS = Path(__file__).resolve().parent / "harness" / "X2TestHarness"
MOD = "X2TestHarness"
GAME_TIMEOUT_S = 5 * 60
TEST_CLASSES = re.findall(r'^\+TestClasses="([^"]+)"', (HARNESS / "Config" / "XComX2TestHarness.ini").read_text(), re.M)


def user_dir():
    """The game's per-user folder under Documents (which may be redirected, e.g. to OneDrive)."""
    key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")
    documents = os.path.expandvars(winreg.QueryValueEx(key, "Personal")[0])
    return Path(documents) / "My Games" / "XCOM2 War of the Chosen" / "XComGame"


def replace_tree(src, dest):
    shutil.rmtree(dest, ignore_errors=True)
    shutil.copytree(src, dest)


def compile_harness(sdk_path):
    stage = sdk_path / "XComGame" / "Mods" / MOD
    for sub in ("Src", "Config"):
        replace_tree(HARNESS / sub, stage / sub)
    replace_tree(HARNESS / "Src" / MOD, sdk_path / "Development" / "Src" / MOD)
    (stage / f"{MOD}.XComMod").write_text("[mod]\npublishedFileId=0\nTitle=X2 Test Harness\nRequiresXPACK=true\n")

    exe = sdk_path / "Binaries" / "Win64" / "XComGame.com"
    log_path = sdk_path / "XComGame" / "Logs" / "Launch.log"
    log_path.unlink(missing_ok=True)  # never read an earlier build's log
    returncode, _ = run([str(exe), "make", "-nopause", "-unattended", "-mods", MOD, str(stage)])
    log = log_path.read_text(errors="replace") if log_path.exists() else ""
    errors = [line for line in log.splitlines() if ") : Error," in line]
    assert returncode == 0 and not errors, "Harness failed to compile:\n" + ("\n".join(errors) or log[-3000:])
    return stage


def install_harness(sdk_path, stage, game_path):
    dest = game_path / "XComGame" / "Mods" / MOD
    replace_tree(stage / "Config", dest / "Config")
    (dest / "Script").mkdir(exist_ok=True)
    shutil.copy2(sdk_path / "XComGame" / "Script" / f"{MOD}.u", dest / "Script")
    shutil.copy2(stage / f"{MOD}.XComMod", dest)


def add_to_section(path, section, line):
    """Appends line to the end of section; a missing section means the game's defaults apply, so nothing is added.
    The end matters for ModRootDirs: when a mod is in two folders, the game loads it from the last one listed,
    so your local LWOTC build wins over a Workshop subscription."""
    text = path.read_bytes().decode()
    if line not in text:
        text = re.sub(rf"({re.escape(section)}\r\n(?:[^\[\r\n].*\r\n)*)", lambda m: m.group(1) + line, text, count=1)
        path.write_bytes(text.encode())


@pytest.fixture(scope="session")
def game_log(sdk_path, game_path):
    """Runs the game once per session; returns the X2TH lines it logged."""
    stage = compile_harness(sdk_path)
    game_log_path = user_dir() / "Logs" / "Launch.log"
    game_log_path.unlink(missing_ok=True)  # never read a previous run's results
    config = user_dir() / "Config"
    mod_options, engine_ini = config / "XComModOptions.ini", config / "XComEngine.ini"
    originals = {path: path.read_bytes() for path in (mod_options, engine_ini)}
    try:
        install_harness(sdk_path, stage, game_path)
        add_to_section(mod_options, "[Engine.XComModOptions]", f"ActiveMods={MOD}\r\n")
        assert f"ActiveMods={MOD}".encode() in mod_options.read_bytes(), \
            f"Could not enable the test harness in {mod_options}; enable LWOTC in your mod launcher first"
        add_to_section(engine_ini, "[Engine.DownloadableContentEnumerator]",
                       f"ModRootDirs={game_path / 'XComGame' / 'Mods'}\\\r\n")
        exe = game_path / "Binaries" / "Win64" / "XCom2.exe"
        try:
            subprocess.run([str(exe), "-AutoTest", f"-AutoTestClass={MOD}.X2TH_AutoTestMgr",
                            "-nostartupmovies", "-noRedScreens", "-windowed", "-ResX=1280", "-ResY=720"],
                           timeout=GAME_TIMEOUT_S)
        except subprocess.TimeoutExpired:
            pass  # the log check below reports how far the tests got
    finally:
        for path, data in originals.items():
            path.write_bytes(data)
        shutil.rmtree(game_path / "XComGame" / "Mods" / MOD, ignore_errors=True)
    assert game_log_path.exists(), "The game did not write Launch.log"
    log = game_log_path.read_text(errors="replace")
    lines = [line.split("X2TH ", 1)[1] for line in log.splitlines() if "X2TH " in line]
    assert any(line.startswith("SUMMARY") for line in lines), "Tests did not finish. X2TH log lines:\n" + "\n".join(lines)
    return lines


@pytest.mark.parametrize("test_class", TEST_CLASSES)
def test_ingame(game_log, test_class):
    assert f"RUN {test_class}" in game_log, f"{test_class} did not run. X2TH log lines:\n" + "\n".join(game_log)
    start = game_log.index(f"RUN {test_class}")
    end = next((i for i in range(start + 1, len(game_log)) if game_log[i].startswith(("RUN ", "SUMMARY"))), len(game_log))
    checks = game_log[start + 1:end]
    failures = [line for line in checks if line.startswith("FAIL")]
    assert checks and not failures, "\n".join(checks)
