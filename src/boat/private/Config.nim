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

import ../../../bdd

import std/[
  os,
  parsecfg,
  strutils,
]

# TODO: simply importing FileManager causes valgrind to throw
# ^ weird cuz nothing is in there but stubs
import BoatErrors, BoatConstants


type Config* = ref object of RootObj
  use*: string ## \
    ## filepath, dir containing a file or remote uri
  #--- private ---#
  parsed: parsecfg.Config ## \
    ## the parsed config after loading
  saved: bool ## \
    ## true if self.use has been saved to disk

proc parseLocalManifest*(self: Config, path: string = self.use): bool =
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
    of pcDir, pcLinkToDir: self.localManifestIsValid self.use / manifestName

proc save*(self: Config): bool =
  ## serialize Self.parsed to disk @ boatConstants.cacheDir / <SELF.ID>.{manifestName}
  ## updates captains manifest with stuffWeCached.self.use -> cache location
  # should call fileManager.toDisk
  result = true

proc reload*(self: Config, path = self.use): bool =
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
  if not self.save(): raise fileSaveDefect
  else: result = true

proc load*(self: Config): bool =
  ## load whatever self.use points to
  result = if self.saved:
    if self.parsed is Config: true # TODO: ensure this checks its a Config instance and not typedesc
    else: raise tddError # should call fileManager.fromDisk
  else: self.reload()
