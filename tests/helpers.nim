import std/[os]

import ../src/boat/private/Config

export Config
export os

let defaultManifest = getCurrentDir() / "src/boat/private/captain/manifest.nim.ini"

proc newConf*(use: string = defaultManifest): Config = Config(use: use)
proc newConfD*(use: string = defaultManifest): Config = Config(use: use.splitPath.head)

when isMainModule:
  debugEcho repr newConf()
  debugEcho repr newConfD()
