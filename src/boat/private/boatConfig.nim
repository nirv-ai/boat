##
## Config
## ======
## extendable interface for creating, parsing and saving boat configs

##[
## TLDR
- come back later

]##

from ../../../bdd import tddError

import std/[
  json,
  os,
  strutils,
]

import
  boatConstants,
  boatErrors,
  boatConfigType,
  fileManager


var captainsLog* {.global.} = %* {} ## \
  ## captains log is the world

proc parseManifest*(self: BoatConfig, path: string = "", ft: FileType): bool =
  ## sets self.parsed to the parsed manifest
  self.parsed = ft.retrieve self.usePath path
  result = true

proc manifestIsValid*(self: BoatConfig, path: string = ""): bool =
  ## throws if manifest not found, cant be read, or errors during parsing
  let usePath = self.usePath path
  let pathInfo = usePath.getFileInfo

  result = case pathInfo.kind
    of pcFile, pcLinkToFile:
      if fpUserRead notin pathInfo.permissions: raise filePermissionError
      elif not usePath.endsWith manifestName: raise manifestNameError
      elif not self.parseManifest(usePath, localManifest): raise configParseError
      else: true
    of pcDir, pcLinkToDir:
      # force directories to use their manifest
      self.use = self.use / manifestName
      self.manifestIsValid

proc save*(self: BoatConfig, path: string = ""): bool =
  ## serialize Self.parsed to disk @ boatConstants.cacheDir / <SELF.ID>.{manifestName}
  ## updates captains manifest with stuffWeCached.self.use -> cache location
  # should call fileManager.toDisk
  result = true

proc init*(self: BoatConfig): bool =
  # starts with https?
    # ends with manifestName?
      # check FileManagerUtils.retrieve
      # it should contain logic for loading remote manifests
    # throw: urls must point to a manifest.nim.ini
  case self.use.startsWith "https"
    of true: raise tddError
    else:
      try: doAssert self.manifestIsValid == true
      except CatchableError:
        debugEcho repr getCurrentException()
        raise fileLoadError
  if not self.save: raise fileSaveDefect
  else: result = true

proc reload*(self: BoatConfig): bool =
  ## reloads a configuration from captainsLog
  raise tddError

proc load*(self: BoatConfig): bool =
  ## (re)load a Configuration
  result =
    # if self.use in captainsLog ? reload from captainslog
    if 1 > 2: raise tddError
    else: self.init

proc loadCaptainsLog(): void =
  ## loads the previous or initializes a new captains log
  captainsLogLoaded = true
  # try to retrieve the prev captainslog from cachDir
  # else initialize an empty captainslog

# always load the captainsLog into ram
if not captainsLogLoaded: loadCaptainsLog()

export boatConfigType
