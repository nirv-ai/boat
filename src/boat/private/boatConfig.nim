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


var captain* {.global.} = %* {} ## \
  ## captains log is the world

proc parse*(self: BoatConfig, path: string = "", ft: FileType): bool =
  ## parses a local BoatConfig
  self.parsed = ft.retrieve self.usePath path
  result = true

proc isValid*(self: BoatConfig, path: string = ""): bool =
  ## throws if local BoatConfig not found, cant be read, or errors during parsing
  let usePath = self.usePath path
  let pathInfo = usePath.getFileInfo

  result = case pathInfo.kind
    of pcFile, pcLinkToFile:
      if fpUserRead notin pathInfo.permissions: raise filePermissionError
      elif not usePath.endsWith manifestName: raise manifestNameError
      elif not self.parse(usePath, localManifest): raise configParseError
      else: true
    of pcDir, pcLinkToDir:
      # force directories to use their manifest
      self.use = self.use / manifestName
      self.isValid

proc save*(self: BoatConfig, path: string = "", ft: FileType): bool =
  ## caches self.parsed to disk and updates captainslog with path
  case ft
  of captainsLog, remoteManifest: raise tddError
  of localManifest: result = true

proc init*(self: BoatConfig): bool =
  # starts with https?
    # ends with manifestName?
      # check FileManagerUtils.retrieve
      # it should contain logic for loading remote manifests
    # throw: urls must point to a manifest.nim.ini
  result = case self.use.startsWith "https"
    of true: raise tddError
    else:
      try:
        doAssert self.isValid == true
        if self.save(ft = localManifest): true
        else: raise tddError
      except CatchableError:
        debugEcho repr getCurrentException()
        raise fileLoadError

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

export boatConfigType, boatConstants
