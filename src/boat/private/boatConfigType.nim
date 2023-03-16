import std/[parsecfg, json]

import fileManager, boatConstants

type BoatConfig*[T: BoatConfigKind = Config] = ref object of RootObj
  ## base type for all boat configs
  use*: string ## \
    ## filepath, dir containing a file or remote uri

  parsed: T ## \
    ## the parsed config after loading
  parsedPath: string ## \
    ## path on disk the parsed config was saved to

proc `parsed=`*(self: BoatConfig, path: string): void =
  self.parsed = self.parsed.retrieve path

proc `parsed`*(self: BoatConfig): BoatConfigKind = self.parsed

proc `parsedPath=`*(self: BoatConfig, path: string): void =
  self.parsedPath = path

proc `parsedPath`*(self: BoatConfig): string = self.parsedPath

proc usePath*(self: BoatConfig, path: string): string =
  if path.len is Positive: path else: self.use
