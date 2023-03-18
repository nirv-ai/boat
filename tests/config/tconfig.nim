discard """
action: "run"
valgrind: "leaks"
exitcode: 0
"""

import std/os

import ../../bdd
import ../helpers

block baseCaseInitialization:
  let it = bdd "base case: Initialize Boat Config"
  it should, "create cfg config", () => (
    $BoatConfig[Config](use: "xyz").typeof == "BoatConfig[parsecfg.Config]"
  )
  it should, "create json config", () => (
    $BoatConfig[JsonNode](use: "xyz").typeof == "BoatConfig[json.JsonNode]"
  )

  # for conf in @[
  #   newConf(use = "192.168.1.1"),
  #   newConf(use = "http://www.not.https")
  # ]: it shouldRaise, "invalid protocol", () => conf.load()

block baseCaseLoadFile:
  let it = bdd "base case: Load Manifest from File"
  it should, "load manifest", () => newConf().load()
  it should, "auto parse manifest to Config", () => (
    let c = newConf()
    itShould(msg = "be nil before load()", condition = c.parsed.isNil)
    discard c.load()
    itShould(msg = "not be nil after load()", condition = c.parsed != nil)
    $c.parsed.typeof == "Config"
  )
  it should, "save parsed config to disk", () => (
    let c = newConf()
    let expected = LocalManifest.path c.use.pathDir
    if expected.fileExists: expected.removeFile
    discard c.load()
    expected.fileExists
  )

block baseCaseLoadFileFromDir:
  let it = bdd "base case: Load Manifest from Directory"
  it should, "load config", () => newConfD().load()
