##
## Config
## ======
## extendable interface for creating, parsing and saving boat configs

##[
## TLDR
- come back later

todos
-----
- cmd to parse arbitrarily, e.g. boat conf load ./some/dir
- cmd to see current captains: e.g. boat conf list -> X, Y, Z
]##

from ../../../bdd import tddError

import std/[
  os,
  parsecfg,
  strutils,
]

import
  BoatConstants,
  BoatErrors,
  FileManager

var captainsLog* {.global.} = newConfig() ## \
  ## captains log is the world

type Config* = ref object of RootObj
  use*: string ## \
    ## filepath, dir containing a file or remote uri

  parsed: parsecfg.Config ## \
    ## the parsed config after loading
  parsedPath: string ## \
    ## path on disk the parsed config was saved to

proc parseLocalManifest*(self: Config, path = self.use): bool =
  ## parse self.use to self.parsed
  ## prefer calling self.load or self.reload for validation
  self.parsed = loadConfig path
  result = true

proc localManifestIsValid*(self: Config, path: string = self.use): bool =
  ## throws if manifest not found, cant be read, or errors during parsing
  let pathInfo = path.getFileInfo
  result = case pathInfo.kind
    of pcFile, pcLinkToFile:
      if fpUserRead notin pathInfo.permissions: raise filePermissionError
      elif not path.endsWith manifestName: raise manifestNameError
      elif not self.parseLocalManifest path: raise configParseError
      else: true
    of pcDir, pcLinkToDir:
      # force directories to use their manifest
      self.use = self.use / manifestName
      self.localManifestIsValid()

proc save*(self: Config, path = self.use): bool =
  ## serialize Self.parsed to disk @ boatConstants.cacheDir / <SELF.ID>.{manifestName}
  ## updates captains manifest with stuffWeCached.self.use -> cache location
  # should call fileManager.toDisk
  result = true

proc init*(self: Config, path = self.use): bool =
  # starts with https?
    # ends with manifestName?
      # save to boatConstants.tempDir / self.use
      # recurse self.reload path = temp location
    # throw: urls must point to a manifest.nim.ini
  case path.startsWith "https"
    of true: raise tddError
    else:
      try: doAssert self.localManifestIsValid(path) == true
      except CatchableError:
        debugEcho repr getCurrentException()
        raise fileLoadError
  if not self.save path : raise fileSaveDefect
  else: result = true

proc reload*(self: Config): bool =
  ## reloads a configuration from disk
  # (fpath, T) = FileMananger.fromDisk(...)
    # self.parsedPath = fpath, self.parsed = T
  raise tddError

proc load*(self: Config): bool =
  ## (re)load a Configuration; safer than calling reload specifically
  result =
    if captainsLogLoaded and self.parsedPath.len is Positive: self.reload()
    else: self.init()

proc loadCaptainsLog(): void =
  ## loads the global manifest, or set an empty Config
  if not captainsLogLoaded: echo "loading captains log"
    # captainsLogLoaded = true
    # let (fpath, prevCaptainsLog) = captainsLog.fromDisk(cacheDir / manifestName, Config, false)
    # captainsLog = prevCaptainsLog

# always load the captainsLog
if not captainsLogLoaded: loadCaptainsLog()
