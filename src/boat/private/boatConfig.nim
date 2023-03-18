##
## BoatConfig
## ==========
## boat configuration variants

import std/[parsecfg, json]

type BoatConfigKind* = enum
  CaptainsLog,
  Gunner,
  Manifest,
  Vessel

type BoatConfig*[T: Config | JsonNode] = ref object of RootObj
  ## base type for all boat configs
  use*: string ## \
    ## filepath, dir containing a file or remote uri
  case kind: BoatConfigKind
    of Manifest: manifest: Config
    of CaptainsLog: log: JsonNode
    of Gunner: gunner: T
    of Vessel: vessel: T



when isMainModule:
  debugEcho repr BoatConfig[Config](kind: Manifest, use: "x")
