import std/[parsecfg, json]

import fileManager, boatConstants

type BoatConfig*[T: BoatConfigKind = Config] = ref object of RootObj
  ## base type for all boat configs
  use*: string ## \
    ## filepath, dir containing a file or remote uri
  parsed*: T ## \
    ## the parsed config after parsing

proc usePath*(self: BoatConfig, path: string = ""): string =
  ## returns path if not empty, else self.use
  ## used whenever BoatConfig.use doesnt point to the effective path
  if path.len > Natural.low: path else: self.use
