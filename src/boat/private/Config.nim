##
## Config
## ======
## provides a parser and standard interface

##[
## TLDR
- come back later

links
-----
- [parsecfg](https://nim-lang.org/docs/parsecfg.html)

]##

import std/[
  os,
  parsecfg,
  strutils,
]

import BoatErrors

const manifestName = "manifest.nim.ini" ## \
  ## the captains manifest must be named manifest.nim.ini
  ## TODO: ensure this is reflected in the docs

type Config* = ref object of RootObj
  cachedir*: string ## \
    ## defaults to getCacheDir();
  use*: string ## \
    ## path on disk pointing to a manifest / or dir with a manifest
    ## URL pointing to a *.ini file
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
  ## serialize Self.parsed to disk @ self.cachedir | getCachDir() / <SELF.ID>.manifest.nim.ini
  result = true

proc reload*(self: Config, path = self.use): bool =
  # starts with https?
    # ends with manifestName?
      # recurse self.reload path = save remote file to disk
    # throw: urls must point to a manifest.nim.ini
  case path.startsWith "https"
    of true: raise tddError
    else:
      try: doAssert self.localManifestIsValid(path) == true
      except CatchableError:
        debugEcho repr getCurrentException()
        raise fileLoadError
  # TODO: pretty sure ADRs require saving to captains.log as well
  # save is a critical action, dont catch it
  if not self.save(): raise fileSaveError
  else: result = true

proc load*(self: Config): bool =
  ## load whatever self.use points to
  result = if self.saved:
    if self.parsed is Config: true # TODO: ensure this checks its a Config instance
    else: raise tddError # self.parse() TODO: need to load from cacheDir
  else: self.reload()
