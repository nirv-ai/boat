##
## FileManager
## ===========
## Saving to and Retrieving from disk

from ../../../bdd import tddError

import std/[
  asyncdispatch,
  json,
  locks,
  parsecfg,
  threadpool,
  ]

import BoatConstants, BoatErrors

export asyncdispatch

type SaveType* = enum
  parsedConfig,
  captainsLog,
  remoteManifest,

proc dir*(self: SaveType): string =
  ## returns the directory where different SaveTypes are persisted
  result = case self
    of parsedConfig, captainsLog: cacheDir
    else: tempDir

proc path*(self: SaveType, fname: string): string =
  ## computes the filpath for a SaveType
  raise tddError
  # result = self.dir / hash(fname)

proc encode*[T: JsonNode | string](self: T): string =
  ## encodes json & strings for saving to disk
  raise tddError
  # of JsonNode -> parse to string -> base64
  # of string -> base64

proc persist*[T: string | Config](self: T, path: string): Future[void] {.async.} =
  ## writes strings to path
  ## calls parsecfg.writeConfig for configs
  raise tddError
  # lock
  # of string -> data.write path
  # of Config -> parsecfg.writeConfig path
  # unlock
  # throw if any errors occur

proc toDisk*[T: JsonNode | string | Config](
  self: SaveType,
  fname: string,
  data: T,
  captainsLog: JsonNode
  ): Future[string] {.async.} =
    ## persists data to cache or temp dir and returns path
    ## if file already exists, will overwrite if content is different
    ## any file saved to cacheDir will be added to the captains log
    raise tddError
    # fpath = self.path fname
    # if json | string
      # encoded = getEncode(data)
      # fpath exists ?
        # content == encoded? return fpath
          # i dont think we can check if Configs are different
          # ^ because configs are saved via parsecfg.writeConfig
          # ^ so if toDisk is called on BoatConfig.parsed it will always overwrite
    # persist data logic
      # self.persist fpath; dont wait, expect error if failure
      # captains.log.fname = fpath
      # return fpath


proc fromDisk*[T](
  self: SaveType,
  fname: string,
  to: T,
  errorNotFound = false
  ): Future[(string, T)] {.async.} =
    ## load hash(fname) and parse to T returning (fpath, T)
    ## throws if errorNotFound is true; else returns empty T
    raise tddError
    # yield readAsync self.dir / hash(fname)
    # if file not found / cant be read then throw if errorNotFound is true
    if errorNotFound and "cant load file" is string: raise fileLoadError
    else: result = ("", new(to))
