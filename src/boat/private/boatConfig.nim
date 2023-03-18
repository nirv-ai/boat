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
  boatConfigType,
  boatConstants,
  boatErrors,
  captainsLog,
  fileManager

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
      elif not self.parse(usePath, LocalManifest): raise configParseError
      else: true
    of pcDir, pcLinkToDir:
      # force directories to use their manifest
      self.use = self.use / manifestName
      self.isValid

proc logAction*(self: BoatConfig, action: Action, data: auto): bool =
  ## tracks actions taken to the captains log
  result = case action
    of BoatConfigSave: true
    else: raise tddError

proc save*(self: BoatConfig, ft: FileType): bool =
  ## caches BoatConfig to disk and potentially updates CaptainsLog with path
  result = case ft
    of CaptainsLog, RemoteManifest: raise tddError
    of LocalManifest:
      let fpath = waitFor toDisk[Config](ft, self.use, self.parsed)
      self.logAction BoatConfigSave, fpath

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
        if self.isValid and self.save LocalManifest: true
        else: raise fileSaveDefect
      except CatchableError:
        debugEcho repr getCurrentException()
        raise fileLoadDefect

proc reload*(self: BoatConfig): bool =
  ## reloads a configuration from CaptainsLog
  raise tddError

proc load*(self: BoatConfig): bool =
  ## (re)load a Configuration
  result =
    if 1 > 2:
      # if self.use in CaptainsLog ? reload from CaptainsLog
      raise tddError
    else: self.init


export boatConfigType, boatConstants
