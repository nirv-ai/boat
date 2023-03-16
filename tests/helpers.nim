import std/[os, parsecfg]

import ../src/boat/private/[boatConfig, boatConstants]

let defaultManifest = getCurrentDir() / "src/boat/private/captain/manifest.nim.ini"

proc newConf*[T: BoatConfigKind = Config](
  self: T = newConfig(),
  use: string = defaultManifest
  ): BoatConfig[T] = BoatConfig[T](use: use)

proc newConfD*[T: BoatConfigKind = Config](
  self: T = newConfig(),
  use: string = defaultManifest
  ): BoatConfig[T] = BoatConfig[T](use: use.splitPath.head)


export boatConfig, boatConstants

when isMainModule:
  # let confFromFile = newConf()
  # discard confFromFile.load()
  # debugEcho repr BoatConfig[JsonNode](use: "xyz")
  debugEcho repr newConf()
  debugEcho repr newConfD()
