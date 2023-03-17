import std/[parsecfg, json]

import fileManager, boatConstants

type BoatConfig*[T: BoatConfigKind = Config] = ref object of RootObj
  ## base type for all boat configs
  use*: string ## \
    ## filepath, dir containing a file or remote uri
  parsed*: T ## \
    ## the parsed config after parsing

proc usePath*(self: BoatConfig, path: string = ""): string =
  if path.len is Positive: path else: self.use
