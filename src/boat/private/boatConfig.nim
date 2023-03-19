##
## BoatConfig
## ==========
## extendable interface for creating, parsing and saving boat configs

from parsecfg import Config
from json import JsonNode

from captainsLogUtils import Action, LogData
from boatErrors import overloadError

type BoatConfig* = ref object of RootObj
  ## base type for all boat configs
  use*: string ## \
    ## file / dir / remote uri pointing to a manifest.nim.ini

proc usePath*(self: BoatConfig, path: string = ""): string =
  ## returns path if not empty, else self.use
  ## used whenever BoatConfig.use doesnt point to the effective path
  if path.len > Natural.low: path else: self.use

method init*(self: BoatConfig): bool {.base.} = raise overloadError
  ## initializes (load/reload) a BoatConfig

method isValid*(self: BoatConfig): bool {.base.} = raise overloadError
  ## validates a BoatConfig

method load*(self: BoatConfig): bool {.base.} = raise overloadError
  ## loads a fresh BoatConfig

method parse*(self: BoatConfig, path: string = ""): bool {.base.} = raise overloadError
  ## parses a boatConfig

method reload*(self: BoatConfig): bool {.base.} = raise overloadError
  ## reloads a BoatConfig from cache

method save*(self: BoatConfig): bool {.base.} = raise overloadError
  ## saves a BoatConfig to disk

export
  captainsLogUtils.Action,
  captainsLogUtils.LogData,
  json.JsonNode,
  parsecfg.Config

when isMainModule:
  debugEcho repr BoatConfig(use: "xyz")
  debugEcho repr BoatConfig(use: "xyz").typeof
