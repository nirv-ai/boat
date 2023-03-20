discard """
action: "run"
valgrind: "leaks"
exitcode: 0
"""

from std/strutils import startsWith
import std/os

import ../../bdd

import boat/private/[fileManager, boatErrors]

block config:
  let it = bdd "fileManager: config"
  let fname = "fakeconfig"

  it should, "save config to cacheDir", () => (
    let fpath = waitFor toDisk[Config](new(Config), fname)

    itShould "be in cacheDir", fpath.startsWith cacheDir
    fpath.tryRemoveFile # returns false if file doesnt exist
  )
