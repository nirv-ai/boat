## .. include:: ./readme.rst

import boat/private/boatConfig

proc boat*: void = echo "All HANDS! cat o'nine tails! blue peter! OMG... landlubber"

when isMainModule:
  let fake = BoatConfig[Config](use: "fake config")
  debugEcho fake.use
