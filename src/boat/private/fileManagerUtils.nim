from ../../../bdd import tddError

import std/[
  asyncdispatch,
  json,
  parsecfg,
]

import boatErrors, boatConstants


proc persist*[T: string | Config](self: T, path: string): Future[void] {.async.} =
  ## writes strings to path
  ## calls parsecfg.writeConfig for configs
  raise tddError
  # lock
  # of string -> data.write path
  # of Config -> parsecfg.writeConfig path
  # unlock
  # throw if any errors occur

proc retrieve*[T: BoatConfigKind](self: T, path: string): T =
  # retrieves a Config or Json from a path
  try:
    if self is Config: result = loadConfig path
    elif self is JsonNode: raise tddError # should load json from path
    else: raise boatConfigKindError
  except CatchableError:
    debugEcho repr getCurrentException()
    raise fileLoadDefect


export asyncdispatch, json, parsecfg
