import std/[os]

import ../src/boat/private/BoatConfig

export BoatConfig
export os

let defaultManifest = getCurrentDir() / "src/boat/private/captain/manifest.nim.ini"

proc newConf*(use: string = defaultManifest): BoatConfig = BoatConfig(use: use)
proc newConfD*(use: string = defaultManifest): BoatConfig = BoatConfig(use: use.splitPath.head)

when isMainModule:
  debugEcho repr newConf()
  debugEcho repr newConfD()
