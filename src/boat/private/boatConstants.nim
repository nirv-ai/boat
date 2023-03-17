##
## BoatConstants
## =============
## the world is full of magic strings, patiently waiting for variable assignment

import std/os

from json import JsonNode
from parsecfg import Config

import boatErrors

type CaptainActions* = enum
  boatConfigSave, boatConfigRemove

type BoatConfigKind* = Config | JsonNode ## \
  ## a Config generally means a manifest
  ## while JsonNode indicates a captainslog
  # object variant may be more appropriate: https://nim-lang.org/docs/manual.html#types-object-variants)

var captainsLogLoaded* {.global.} = false ## \
  ## true if we've attempted to load the captainslog from disk

const manifestName* = "manifest.nim.ini" ## \
  ## the captains manifest must be named manifest.nim.ini
  ## contains / points to other manifests

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

export json.JsonNode, parsecfg.Config

when isMainModule:
  debugEcho cacheDir
  debugEcho tempDir
