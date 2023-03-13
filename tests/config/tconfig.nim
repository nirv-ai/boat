discard """
action: "run"
valgrind: true
"""

import ../bdd
import ../helpers

block baseCase:
  let it = bdd("base case: ")
  it should, "load config", newConf().load()
  it should, "parse config", newConf().parse()
  it should, "save config", newConf().save()
