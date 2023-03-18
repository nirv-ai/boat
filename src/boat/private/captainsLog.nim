##
## CaptainsLog
## ===========
## a boat's runtime manifest; internally managed

import captainsLogUtils

proc initCaptainsLog(): Future[void] {.async.} =
  ## loads the previous or initializes a new captains log
  # this should really call BoatConfig.init
  # BoatConfig[Json].parsed = captainsLogUtils.captainsLog
  # ^ dont parse to a nimtype, we want to enable consumers to add arbitrary things to it

  if captainsLog["state"].getInt < 2: captainsLog["state"] = %* Initializing.ord
  else: return
  # try to retrieve the prev captainslog from cachDir
  # else initialize an empty captainslog
  # set true if successful, else throw defect
  captainsLog["state"] = %* Ready.ord

asyncCheck initCaptainsLog()

# when isMainModule:
#   debugEcho captainsLog["state"]
  # debugEcho CaptainState(captainsLog["state"].getInt)
