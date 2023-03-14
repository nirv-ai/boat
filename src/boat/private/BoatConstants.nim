##
## BoatConstants
## =============
## the world is full of magic strings, patiently waiting for variable assignment

import std/os

import BoatErrors

const manifestName* = "manifest.nim.ini" ## \
  ## the captains manifest must be named manifest.nim.ini
  ## TODO: ensure this is reflected in the docs

const boatDirName* = "boat" ## \
  ## parent directory for all boat assets

let cacheDir* = getCacheDir() / boatDirName ## \
  ## captains manifest and other files

let tempDir* = getTempDir() / boatDirName ## \
  ## temporary directory for temporary things to be stored temporarily

for dir in @[cacheDir, tempDir]:
  try: discard dir.existsOrCreateDir
  except CatchableError:
    debugEcho repr getCurrentException()
    raise dirCreateDefect
