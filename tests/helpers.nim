import std/[os]

import ../src/boat/private/[boatConstants, fileManagerUtils]
import ../src/boat/manifest

let defaultManifest* = getCurrentDir() / "src/boat/private/captain/manifest.nim.ini"

proc newManifest*(
  use: string = defaultManifest
  ): Manifest = Manifest(use: use)

proc newManifestD*(
  use: string = defaultManifest
  ): Manifest = Manifest(use: use.splitPath.head)


export manifest, boatConstants, fileManagerUtils

when isMainModule:
  let confFromFile = newManifest()
  discard confFromFile.load()
  # debugEcho repr BoatConfig[JsonNode](use: "xyz")
  debugEcho repr newManifest()
  debugEcho repr newManifestD()
