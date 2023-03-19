discard """
action: "run"
valgrind: "leaks"
exitcode: 0
"""

import ../../bdd

import boat/private/[fileManagerUtils, boatErrors]
from ../helpers import defaultManifest

block pathDir:
  let it = bdd "file manager utils: pathDir"
  let input = "first/second/third/"
  let expected = input[0..^2]
  it should, "return remove trailing slash from dir", () => input.pathDir() == expected
  it should, "return directory as is", () => input[0..^2].pathDir() == expected
  it should, "remove fname from path", () => (input & "somefile.txt").pathDir() == expected

block config:
  let it = bdd "config"
  it should, "retrieve config", () => (
    $retrieve[Config](new(Config), defaultManifest).typeof == "Config"
  )

  it shouldRaiseMsg, fileLoadDefect.msg, () => (
    retrieve[Config](new(Config), "path/doesnt/exist").isNil
  )
