## .. include:: ./readme.rst

import boat/private/[
  boatConfig,
  boatConstants,
  boatErrors,
]

proc boat*: void = echo "All HANDS! cat o'nine tails! blue peter! OMG... landlubber"

when isMainModule:
  boat()
