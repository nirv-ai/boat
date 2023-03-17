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


var captain* {.global.} = %* { "using": {} } ## \
  ## captains log is the world
  # we need an ADR for the captainlog structure
  # it should scale with increased complexity

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

proc updateCaptainsLog*(self: BoatConfig, action: CaptainActions, data: auto): bool =
  ## tracks actions taken to the captains log
  # we should create an ADR for this to ensure
  # this fn can scale with increased complexity and scope
  result = case action
    of boatConfigSave: true
    else: raise tddError

proc save*(self: BoatConfig, ft: FileType): bool =
  ## caches BoatConfig to disk and potentially updates captainslog with path
  result = case ft
    of captainsLog, remoteManifest: raise tddError
    of localManifest:
      let fpath = waitFor toDisk[Config](ft, self.use, self.parsed)
      self.updateCaptainsLog boatConfigSave, fpath

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
        if self.isValid and self.save localManifest: true
        else: raise fileSaveDefect
      except CatchableError:
        debugEcho repr getCurrentException()
        raise fileLoadDefect

proc reload*(self: BoatConfig): bool =
  ## reloads a configuration from captainsLog
  raise tddError

proc load*(self: BoatConfig): bool =
  ## (re)load a Configuration
  result =
    if 1 > 2:
      # if self.use in captainsLog ? reload from captainslog
      raise tddError
    else: self.init

proc loadCaptainsLog(): void =
  ## loads the previous or initializes a new captains log
  captainsLogLoaded = true
  # try to retrieve the prev captainslog from cachDir
  # else initialize an empty captainslog

# always load the captainsLog into ram
if not captainsLogLoaded: loadCaptainsLog()

export boatConfigType, boatConstants
