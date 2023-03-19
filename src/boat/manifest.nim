# import std/[
#   json,
#   os,
# ]

from ../../bdd import tddError

import std/[os, strutils]

from private/captainsLogUtils import logAction, Action

import private/[
  boatConstants,
  boatConfig,
  boatErrors,
  fileManager
]


type Manifest* = ref object of BoatConfig
  parsed*: Config ## \
    ## the parsed configuration

method parse*(self: Manifest, path: string = ""): bool =
  ## parses a local BoatConfig
  self.parsed = retrieve[Config](self.parsed, self.usePath path)
  result = true

method isValid*(self: Manifest): bool =
  ## throws if self.use not found, cant be read, or errors during parsing
  let pathInfo = self.use.getFileInfo

  result = case pathInfo.kind
    of pcFile, pcLinkToFile:
      if fpUserRead notin pathInfo.permissions: raise filePermissionError
      elif not self.use.endsWith manifestName: raise manifestNameError
      elif not self.parse: raise configParseError
      else: true
    of pcDir, pcLinkToDir:
      # force directories to use their manifest
      self.use = self.use / manifestName
      self.isValid


method save*(self: Manifest): bool =
  ## caches BoatConfig to disk and potentially updates CaptainsLog with path
  let fpath = waitFor toDisk[Config](self.parsed, self.use)
  BoatConfigSave.logAction fpath


method reload*(self: Manifest): bool =
  ## reloads a configuration from CaptainsLog
  raise tddError

method load*(self: Manifest): bool =
  ## (re)load a Configuration
  result =
    # if self.use in CaptainsLog ? reload from CaptainsLog
    if 1 > 2: raise tddError
    else: self.init

method init*(self: Manifest): bool =
  # starts with https?
    # ends with manifestName?
      # check FileManagerUtils.retrieve
      # it should contain logic for loading remote manifests
    # throw: urls must point to a manifest.nim.ini
  result = case self.use.startsWith "https"
    of true: raise tddError
    else:
      try:
        if self.isValid and self.save: true
        else: raise fileSaveDefect
      except CatchableError:
        debugEcho repr getCurrentException()
        raise fileLoadDefect

when isMainModule:
  debugEcho repr Manifest(use: "xyz")
  debugEcho repr Manifest(use: "xyz").typeof
