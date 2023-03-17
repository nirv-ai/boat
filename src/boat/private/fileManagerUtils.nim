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

type FileType* = enum
  captainsLog,
  localManifest,
  remoteManifest,

proc persist*[T: FileType](self: T, path: string): Future[void] {.async.} =
  ## persists a FileType to path
  raise tddError
  # lock
  # of string -> data.write path
  # of Config -> parsecfg.writeConfig path
  # unlock
  # throw if any errors occur

proc retrieve*[T: FileType](self: T, path: string): BoatConfigKind =
  ## retrieves a FileType from path and parses to BoatConfigKind
  try:
    result = case self
      of captainsLog: raise tddError # parse to json
      of localManifest: loadConfig path
      of remoteManifest: raise tddError # download, then loadConfig path
  except CatchableError:
    debugEcho repr getCurrentException()
    raise fileLoadDefect

proc pathDir*(path: string): string = path.splitPath.head
  ## used to sync some/path/manifest.nim.ini and some/path/ to the same hash value
  # see the TODOS up top

proc dir*(self: FileType): string =
  ## returns the directory where different FileTypes are persisted
  result = case self
    of localManifest, captainsLog: cacheDir
    else: tempDir

proc path*(self: FileType, fname: string): string =
  ## computes the filpath for a FileType
  result = self.dir / $hash(fname)

proc encode*[T: JsonNode | string](self: T): string =
  ## encodes json & strings for saving to disk
  raise tddError
  # of JsonNode -> parse to string -> base64
  # of string -> base64

export
  asyncdispatch,
  json,
  parsecfg
