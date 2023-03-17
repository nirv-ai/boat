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
  captain: JsonNode
  ): Future[string] {.async.} =
    ## persists data to cache or temp dir and returns path
    ## if file already exists, will overwrite if content is different
    ## any file saved to cacheDir will be added to the captains log
    let dirName = use.pathDir
    let fpath = ft.path dirName
    # if json | string
      # encoded = getEncode(data)
      # fpath exists ?
        # content == encoded? return fpath
          # i dont think we can check if Configs are different
          # ^ because configs are saved via parsecfg.writeConfig
          # ^ so if toDisk is called on BoatConfig.parsed it will always overwrite
    # persist data logic
    result = case ft
      of captainsLog, remoteManifest: raise tddError
      of localManifest:
        data.writeConfig fpath
        # update captain.using[dirName] = fpath
        # return fpath to consumer
        fpath

proc fromDisk*[T](
  self: FileType,
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


export fileManagerUtils
