##
## CaptainsLog
## ===========
## a boat's runtime manifest; internally managed

import std/json

import boatConstants

var captains* {.global.} = %* {
    "captain": {},
    "cmd": {},
    "history": []
  } ## captains log is the world

proc loadCaptainsLog(): void =
  ## loads the previous or initializes a new captains log
  captainsLogLoaded = true
  # try to retrieve the prev captainslog from cachDir
  # else initialize an empty captainslog

# always load the captainsLog into ram
if not captainsLogLoaded: loadCaptainsLog()
