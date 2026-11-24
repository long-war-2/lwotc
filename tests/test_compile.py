import re

import pytest

# Compiler errors look like: C:\...\LW_Overhaul\Classes\Foo.uc(123) : Error, Bad or missing expression
SCRIPT_ERROR = re.compile(r"^\s*(?:\S+: )?(.+?\.uci?)\((\d+)\) : Error, (.+)$", re.MULTILINE)


def test_scripts_compile(build):
    errors = sorted(set(SCRIPT_ERROR.findall(build.stdout)))
    if errors:
        pytest.fail("Script errors:\n" + "\n".join(f"{path}({line}): {msg}" for path, line, msg in errors), pytrace=False)
    if "Compiled mod script packages" not in build.stdout:
        pytest.fail("Build stopped before compiling LWOTC:\n" + build.stdout[-3000:], pytrace=False)


def test_build_succeeds(build):
    if "Compiled mod script packages" not in build.stdout:
        pytest.skip("scripts did not compile; see test_scripts_compile")
    if build.returncode != 0:
        pytest.fail("Build failed after compiling (cooking or packaging):\n" + build.stdout[-3000:], pytrace=False)
