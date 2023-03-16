from ../../../bdd import tddError

import std/[
  asyncdispatch,
  json,
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


export asyncdispatch, json, parsecfg
