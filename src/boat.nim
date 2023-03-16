## .. include:: ./readme.rst

import boat/private/[
  BoatConfig,
  BoatConstants,
  BoatErrors,
  ]

proc boat*: void = echo "All HANDS! cat o'nine tails! blue peter! OMG... landlubber"

when isMainModule:
  boat()
