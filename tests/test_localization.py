from pathlib import Path

import pytest

REPO = Path(__file__).resolve().parent.parent
FILES = sorted(p for p in REPO.glob("*/Localization/**/*") if p.is_file())


# The build reads localization as UTF-8 before converting it to UTF-16 for the game; any other encoding garbles text.
@pytest.mark.parametrize("path", FILES, ids=lambda p: str(p.relative_to(REPO)))
def test_localization_is_utf8(path):
    path.read_bytes().decode("utf-8")
