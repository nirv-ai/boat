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

proc parseLocalManifest*(self: BoatConfig, path: string = ""): bool =
  ## parse self.use to self.parsed
  ## prefer calling self.load or self.reload for validation
  let usePath = self.usePath path

  # self.parsed = self.parsed.retrieve usePath
  result = true

proc localManifestIsValid*(self: BoatConfig, path: string = ""): bool =
  ## throws if manifest not found, cant be read, or errors during parsing
  let usePath = self.usePath path
  let pathInfo = usePath.getFileInfo

  result = case pathInfo.kind
    of pcFile, pcLinkToFile:
      if fpUserRead notin pathInfo.permissions: raise filePermissionError
      elif not usePath.endsWith manifestName: raise manifestNameError
      elif not self.parseLocalManifest usePath: raise configParseError
      else: true
    of pcDir, pcLinkToDir:
      # force directories to use their manifest
      self.use = self.use / manifestName
      self.localManifestIsValid()

proc save*(self: BoatConfig, path: string = ""): bool =
  ## serialize Self.parsed to disk @ boatConstants.cacheDir / <SELF.ID>.{manifestName}
  ## updates captains manifest with stuffWeCached.self.use -> cache location
  # should call fileManager.toDisk
  result = true

proc init*(self: BoatConfig, path: string = ""): bool =
  let usePath = self.usePath path
  # starts with https?
    # ends with manifestName?
      # save to boatConstants.tempDir / self.use
      # recurse self.reload path = temp location
    # throw: urls must point to a manifest.nim.ini
  case usePath.startsWith "https"
    of true: raise tddError
    else:
      try: doAssert self.localManifestIsValid(path) == true
      except CatchableError:
        debugEcho repr getCurrentException()
        raise fileLoadError
  if not self.save usePath: raise fileSaveDefect
  else: result = true

proc reload*(self: BoatConfig): bool =
  ## reloads a configuration from disk
  # (fpath, T) = FileMananger.fromDisk(...)
    # self.parsedPath = fpath, self.parsed = T
  raise tddError

proc load*(self: BoatConfig): bool =
  ## (re)load a Configuration; safer than calling reload specifically
  result =
    if captainsLogLoaded and self.parsedPath.len is Positive: self.reload()
    else: self.init()

proc loadCaptainsLog(): void =
  ## loads the previous or initializes a new captains log
  if not captainsLogLoaded: echo "loading captains log"
    # captainsLogLoaded = true
    # let (fpath, prevCaptainsLog) = captainsLog.fromDisk(cacheDir / manifestName, JsonNode, false)
    # captainsLog = prevCaptainsLog

# always load the captainsLog into ram
if not captainsLogLoaded: loadCaptainsLog()


# consumers can retrieve the parsed Config and path on disk
# but only internal functions should be able to set it
export
  boatConfigType.BoatConfig,
  parsed,
  parsedPath
