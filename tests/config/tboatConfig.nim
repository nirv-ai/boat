discard """
action: "run"
valgrind: "leaks"
exitcode: 0
"""

import ../../bdd

import boat/private/boatConfig
from boat/private/boatErrors import overloadError

block boatInit:
  let it = bdd "boat init"
  it should, "create BoatConfig", () => (
    $BoatConfig(use: "xyz").typeof == "BoatConfig"
  )


block boatInterfaceProvided:
  let it = bdd "boat interface: provided"
  it should, "return self.use", () => (
    BoatConfig(use: "xyz").usePath == "xyz"
  )
  it should, "return provided path instead", () => (
    BoatConfig(use: "xyz").usePath("this path") == "this path"
  )

block boatInterfaceRequired:
  let it = bdd "boat interface: required"

  let bc = BoatConfig(use: "xyz")
  it shouldRaiseMsg, overloadError.msg, () => bc.init
  it shouldRaiseMsg, overloadError.msg, () => bc.isValid
  it shouldRaiseMsg, overloadError.msg, () => bc.load
  it shouldRaiseMsg, overloadError.msg, () => bc.parse
  it shouldRaiseMsg, overloadError.msg, () => bc.reload
  it shouldRaiseMsg, overloadError.msg, () => bc.save
