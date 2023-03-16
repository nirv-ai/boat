import std/[os, parsecfg]

import ../src/boat/private/[boatConfig, boatConstants]

let defaultManifest = getCurrentDir() / "src/boat/private/captain/manifest.nim.ini"

proc newConf*[T: BoatConfigKind](self: T = newConfig(), use: string = defaultManifest): BoatConfig[T] =
  BoatConfig[T](use: use)

proc newConfD*[T: BoatConfigKind](self: T = newConfig(), use: string = defaultManifest): BoatConfig[T] =
  BoatConfig[T](use: use.splitPath.head)


export boatConfig, os

when isMainModule:
  debugEcho repr newConf()
  debugEcho repr newConfD()
