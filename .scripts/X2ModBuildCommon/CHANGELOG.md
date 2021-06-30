## Next

## 1.1.0 (2021-06-15)

* Remove compiled script packages when switching between debug and release mode to prevent compiler error (#16)
* Remove compiled script packages when modifying macros (#20)
* Overridden Steam UGC IDs can now be `long` (`int64`) (#22)
* Use error syntax `file(line)` for compiler errors to be compatible with both ModBuddy and VS Code (#26)
* Add a `clean.ps1` script, ModBuddy configuration and VS Code example task to remove all cached build artifacts (#24)
* Remove project file verification. Consider using [Xymanek/X2ProjectGenerator](https://github.com/Xymanek/X2ProjectGenerator) instead (#28)
* Catch macro name clashes through `extra_globals.uci` (#30)
* Add debugging option to profile build times (#35)

## 1.0.0 (2021-05-22)

* Initial release
