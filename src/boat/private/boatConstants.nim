##
## BoatConstants
## =============
## the world is full of magic strings, patiently waiting for variable assignment

import std/os

import boatErrors

const boatDirName* = "boat" ## \
  ## parent directory for all boat assets

let cacheDir* = boatDirName.getCacheDir() ## \
  ## captains manifest and other files
  ## that should persist across invocations

let tempDir* = getTempDir() / boatDirName ## \
  ## temporary directory for temporary things to be stored temporarily

for dir in @[cacheDir, tempDir]:
  try: discard dir.existsOrCreateDir
  except CatchableError:
    debugEcho repr getCurrentException()
    raise dirCreateDefect

when isMainModule:
  debugEcho cacheDir
  debugEcho tempDir
