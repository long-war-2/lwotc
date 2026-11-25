import re

import pytest

# Compiler errors look like: C:\...\LW_Overhaul\Classes\Foo.uc(123) : Error, Bad or missing expression
SCRIPT_ERROR = re.compile(r"^\s*(?:\S+: )?(.+?\.uci?)\((\d+)\) : Error, (.+)$", re.MULTILINE)


def test_scripts_compile(compiled):
    errors = sorted(set(SCRIPT_ERROR.findall(compiled.stdout)))
    if errors:
        pytest.fail("Script errors:\n" + "\n".join(f"{path}({line}): {msg}" for path, line, msg in errors), pytrace=False)
    if "Compiled mod script packages" not in compiled.stdout or compiled.returncode != 0:
        pytest.fail("Build stopped before compiling LWOTC:\n" + compiled.stdout[-3000:], pytrace=False)


@pytest.mark.build
def test_build_succeeds(build):
    if "Compiled mod script packages" not in build.stdout:
        pytest.fail("Scripts did not compile:\n" + build.stdout[-3000:], pytrace=False)
    if build.returncode != 0:
        pytest.fail("Build failed after compiling (cooking or packaging):\n" + build.stdout[-3000:], pytrace=False)
