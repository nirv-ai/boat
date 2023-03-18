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
  boatConstants,
  boatErrors,
  fileManagerUtils

proc toDisk*[T: JsonNode | string | Config](
  ft: FileType,
  use: string,
  data: T,
  ): Future[string] {.async.} =
    ## persists data to cache or temp dir and returns path or throws if unsuccessful
    ## if T is json/string, will overwrite file if content is different
    ## if T is config, will always overwrite
    let dirName = use.pathDir
    let fpath = ft.path dirName
    # if json | string
      # encoded = getEncode(data)
      # fpath exists ?
        # content == encoded? return fpath
          # i dont think we can check if Configs are different
          # ^ because configs are saved via parsecfg.writeConfig
          # ^ so if toDisk is called on BoatConfig.parsed it will always overwrite
    result = case ft
      of CaptainsLog, RemoteManifest: raise tddError
      of LocalManifest:
        try:
          data.writeConfig fpath # throws IOError, OSError
          fpath
        except CatchableError:
          debugEcho repr getCurrentException()
          raise fileSaveDefect

proc fromDisk*[T](
  self: FileType,
  fname: string,
  to: T, # shouldnt be necessary, we know what it is based on filetype
  errorNotFound = false
  ): Future[(string, T)] {.async.} =
    ## load hash(fname) and parse to T returning (fpath, T)
    ## throws if errorNotFound is true; else returns empty T
    raise tddError
    # yield readAsync self.dir / hash(fname)
    # if file not found / cant be read then throw if errorNotFound is true
    if errorNotFound and "cant load file" is string: raise fileLoadError
    else: result = ("", new(to))


export fileManagerUtils
