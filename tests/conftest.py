"""Shared fixtures. Paths come from the same XCOM2SDKPATH / XCOM2GAMEPATH variables the build uses."""
import os
import subprocess
from pathlib import Path
from types import SimpleNamespace

import pytest

REPO = Path(__file__).resolve().parent.parent


def env_path(name):
    value = os.environ.get(name)
    if not value:
        pytest.skip(f"{name} is not set; see 'Building and running the mod' in the README")
    return Path(value)


def run(args, **kwargs):
    """Runs args, printing its output as it arrives; returns the exit code and the output."""
    proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, errors="replace", **kwargs)
    output = []
    for line in proc.stdout:
        print(line, end="", flush=True)
        output.append(line)
    return proc.wait(), "".join(output)


@pytest.fixture(scope="session")
def sdk_path():
    return env_path("XCOM2SDKPATH")


@pytest.fixture(scope="session")
def game_path():
    return env_path("XCOM2GAMEPATH")


def run_build(config):
    returncode, output = run([str(REPO / "build-lwotc.bat"), "-config", config], cwd=REPO)
    return SimpleNamespace(returncode=returncode, stdout=output)


@pytest.fixture(scope="session")
def compiled(sdk_path, game_path):
    """Compiles the scripts once per test session, skipping asset cooking; returns its exit code and output."""
    return run_build("compiletest")


@pytest.fixture(scope="session")
def build(sdk_path, game_path):
    """Runs the full build once per test session; returns its exit code and output."""
    return run_build("default")
