##
## BoatConfig
## ==========
## extendable interface for creating, parsing and saving boat configs

from ../../../bdd import tddError

from parsecfg import Config
from json import JsonNode

from captainsLogUtils import Action, LogData

type BoatConfig* = ref object of RootObj
  ## base type for all boat configs
  use*: string ## \
    ## file / dir / remote uri pointing to a manifest.nim.ini

proc usePath*(self: BoatConfig, path: string = ""): string =
  ## returns path if not empty, else self.use
  ## used whenever BoatConfig.use doesnt point to the effective path
  if path.len > Natural.low: path else: self.use

method init*(
  self: BoatConfig
  ): bool {.base.} = raise tddError

method isValid*(
  self: BoatConfig
  ): bool {.base.} = raise tddError

method load*(
  self: BoatConfig
  ): bool {.base.} = raise tddError


method parse*(
  self: BoatConfig,
  path: string = ""
  ): bool {.base.} = raise tddError

method reload*(
  self: BoatConfig
  ): bool {.base.} = raise tddError

method save*(
  self: BoatConfig
  ): bool {.base.} = raise tddError


export
  captainsLogUtils.LogData,
  json.JsonNode,
  parsecfg.Config

when isMainModule:
  debugEcho repr BoatConfig(use: "xyz")
  debugEcho repr BoatConfig(use: "xyz")
