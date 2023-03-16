import std/parsecfg

export parsecfg

type BoatConfig* = ref object of RootObj
  use*: string ## \
    ## filepath, dir containing a file or remote uri

  parsed: Config ## \
    ## the parsed config after loading
  parsedPath: string ## \
    ## path on disk the parsed config was saved to

proc `parsed=`*(self: BoatConfig, config: Config): void =
  self.parsed = config

proc `parsed`*(self: BoatConfig): Config = self.parsed

proc `parsedPath=`*(self: BoatConfig, path: string): void =
  self.parsedPath = path

proc `parsedPath`*(self: BoatConfig): string = self.parsedPath
