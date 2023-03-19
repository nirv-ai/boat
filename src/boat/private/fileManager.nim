##
## FileManager
## ===========
## Saving to and Retrieving from disk

from ../../../bdd import tddError

# import std/[
#   locks,
#   threadpool,
# ]

import
  boatErrors,
  fileManagerUtils

proc toDisk*[T: FileTypes](
  self: T,
  fname: string,
  useCache: bool = true
  ): Future[string] {.async.} =
    ## persists data to cache or temp dir and returns path or throws if unsuccessful
    ## if T is json/string, will overwrite file if content is different
    ## if T is config, will always overwrite
    let dirName = fname.pathDir
    let fpath = fname.path useCache
    # if json | string
      # encoded = getEncode(data)
      # fpath exists ?
        # content == encoded? return fpath
          # i dont think we can check if Configs are different
          # ^ because configs are saved via parsecfg.writeConfig
          # ^ so if toDisk is called on BoatConfig.parsed it will always overwrite
    result =
      if self is Config:
        try:
          self.writeConfig fpath # throws IOError, OSError
          fpath
        except CatchableError:
          debugEcho repr getCurrentException()
          raise fileSaveDefect
      else: raise tddError

proc fromDisk*[T1: FileTypes, T2: FileTypes](
  self: T1,
  fname: string,
  to: T2,
  errorNotFound = false
  ): Future[(string, T2)] {.async.} =
    ## load hash(fname) and parse to T2 returning (fpath, T2)
    ## throws if errorNotFound is true; else returns empty T
    raise tddError
    # yield readAsync self.dir / hash(fname)
    # if file not found / cant be read then throw if errorNotFound is true
    if errorNotFound and "cant load file" is string: raise fileLoadError
    else: result = ("", new(to))


export fileManagerUtils
