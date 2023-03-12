discard """
action: "run"
valgrind: true
"""

import ../bdd
import std / [ os ]

import boat / private / Config


let defaultManifest = getCurrentDir() / "src/boat/private/captain/manifest.nim.ini"

block baseCase:
  const t = "base case: "
  let captain = Config(use: defaultManifest)
  itShould "load config", t, captain.load()
  itShould "parse config", t, captain.parse()
  itShould "save config", t, captain.save()
