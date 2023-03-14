##
## FileManager
## ===========
## Saving to and Retrieving from disk

import std/[
  asyncdispatch,
  locks,
  parsecfg,
  threadpool,
  ]

import BoatConstants, BoatErrors

export asyncdispatch

type SaveType* = enum
  parsedConfig,
  upsertManifest,
  remoteManifest,

proc fileDir*(self: SaveType): string =
  result = case self
    of parsedConfig, upsertManifest: cacheDir
    else: tempDir

proc toDisk*[T: Config | string](
    self: SaveType,
    fname: string,
    data: T,
  ): Future[bool] {.async.} =
  ## persists data to cache or temp dir
  ## if file already exists, will overwrite if content is different
  raise tddError
  # file exists ?
    # content is same? return true
  # persist data
    # lock
    # save as self.fileDir / hash(fname)
    # unlock
    # return success
  result = true

proc fromDisk*[T: Config | string](
    self: SaveType,
    fname: string,
    to: T,
    errorNotFound = false
  ): Future[T] {.async.} =
  ## parse to T and return T
  ## throws if errorNotFound is true; else returns empty T
  raise tddError
  # yield readAsync self.fileDir / hash(fname)
  # if file not found / cant be read then throw if errorNotFound is true
  if errorNotFound and "cant load file" is string: raise fileLoadError
  else: result = new(to)
