##
## FileManagerUtils
## ================
## low level procs used by FileManager

##[
## TLDR

todos
-----
- rework procs to use
  - os.expandFilename
  - os.expandTilde
  - os.isValidFilename
  - os.normalizedPath
  - os.normalizePathEnd
  - os.sameFileContent
]##

from ../../../bdd import tddError

import std/[
  asyncdispatch,
  hashes,
  json,
  os,
  parsecfg,
]

import boatErrors, boatConstants


type FileTypes* = Config | JsonNode | string
type Encodable* = JsonNode | string

proc persist*[T: FileTypes](self: T, path: string): Future[void] {.async.} =
  ## persists a FileType to path
  raise tddError
  # lock
  # of string -> data.write path
  # of Config -> parsecfg.writeConfig path
  # unlock
  # throw if any errors occur

proc retrieve*[T: FileTypes](self: T, path: string): T =
  ## retrieves data from path and parses to T
  try:
    result =
      if self is Config: loadConfig path
      else: raise tddError
  except CatchableError:
    debugEcho repr getCurrentException()
    raise fileLoadDefect

proc pathDir*(self: string): string =
  ## returns path to a files directory, or the directory without a trailing slash
  result =
    if self.searchExtPos >= Natural.low: self.splitPath.head
    else: self.normalizePathEnd(true).splitPath.head

proc dir*(useCache: bool = true): string =
  ## returns the cache / temp directory path
  result = if useCache: cacheDir else: tempDir


proc path*(fname: string, useCache: bool = true): string =
  ## computes a filepath
  result = useCache.dir  / $hash(fname)

proc encode*[T: Encodable](self: T): string =
  ## encodes json & strings for saving to disk
  raise tddError
  # of JsonNode -> parse to string -> base64
  # of string -> base64

proc decode*[T: Encodable](self: T): T = raise tddError

export
  asyncdispatch,
  boatConstants.cacheDir,
  boatConstants.tempDir,
  json,
  parsecfg
