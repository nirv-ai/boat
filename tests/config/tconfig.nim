discard """
action: "run"
valgrind: true
exitcode: 0
"""

import ../../bdd
import ../helpers

block baseCaseLoadFile:
  let it = bdd "base case: Load Manifest from File"
  it should, "load config", () => newConf().load()

block baseCaseLoadFileFromDir:
  let it = bdd "base case: Load Manifest from Directory"
  it should, "load config", () => newConfD().load()

block todoCases:
  let it = bdd "todos"
  it should, "parse config", () => newConf().parseLocalManifest()
  it should, "save config", () => newConf().save()

  for conf in @[
    newConf("192.168.1.1"),
    newConf("http://www.not.https")
  ]: it shouldError, "invalid protocol", () => conf.load()
