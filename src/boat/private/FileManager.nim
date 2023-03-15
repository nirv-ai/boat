##
## FileManager
## ===========
## Saving to and Retrieving from disk

from ../../../bdd import tddError

import std/[
    asyncdispatch,
    locks,
    threadpool,
  ]

import BoatConstants, BoatErrors

export asyncdispatch

type SaveType* = enum
  parsedConfig,
  captainsLog,
  remoteManifest,

proc fileDir*(self: SaveType): string =
  result = case self
    of parsedConfig, captainsLog: cacheDir
    else: tempDir

proc toDisk*[T](
    self: SaveType,
    fname: string,
    data: T,
): Future[string] {.async.} =
  ## persists data to cache or temp dir and returns path
  ## if file already exists, will overwrite if content is different
  ## any file saved to cacheDir will be added to the captains log
  raise tddError
  # file exists ?
    # content is same? return true
  # persist data
    # lock
    # hash(data) && save as self.fileDir / hash(fname)
      # we skipped https://nim-lang.org/docs/hashes.html
      # just save as is for now and swing back when base logic is working
    # if saving to cacheDir
      # update captainsLog with fname -> hash(fname) so we can retrieve later
    # unlock
    # return success
  result = ""

proc fromDisk*[T](
    self: SaveType,
    fname: string,
    to: T,
    errorNotFound = false
): Future[(string, T)] {.async.} =
  ## load hash(fname) and parse to T returning (fpath, T)
  ## throws if errorNotFound is true; else returns empty T
  raise tddError
  # yield readAsync self.fileDir / hash(fname)
  # if file not found / cant be read then throw if errorNotFound is true
  if errorNotFound and "cant load file" is string: raise fileLoadError
  else: result = ("", new(to))
