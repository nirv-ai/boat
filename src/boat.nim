## .. include:: ./readme.rst

import boat/manifest

proc boat*: void = echo "All HANDS! cat o'nine tails! blue peter! OMG... landlubber"

when isMainModule:
  let fake = Manifest(use: "fake config")
  debugEcho fake.use
