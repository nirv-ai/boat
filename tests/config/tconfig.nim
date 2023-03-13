discard """
action: "run"
valgrind: true
"""

import ../bdd
import ../helpers

block baseCaseLoadFile:
  let it = bdd("base case: Load Manifest from File -> ")
  it should, "load config", newConf().load()

block baseCaseLoadFileFromDir:
  let it = bdd("base case: Load Manifest from Directory -> ")
  it should, "load config", newConf().load()

block todoCases:
  let it = bdd("todo cases: ")
  it should, "parse config", newConf().parseLocalManifest()
  it should, "save config", newConf().save()
