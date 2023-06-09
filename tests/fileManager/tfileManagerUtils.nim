discard """
action: "run"
valgrind: "leaks"
exitcode: 0
"""

from std/strutils import startsWith
from std/hashes import hash
from std/os import lastPathPart

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

block dir:
  let it = bdd "file manager utils: dir"
  it should, "return cacheDir path", () => true.dir == cacheDir
  it should, "return tempDir path", () => false.dir == tempDir

block path:
  let it = bdd "file manager utils: path"
  let testPath = "test/path"

  it should, "use cacheDir", () => (
    testPath.path(true).startsWith cacheDir
  )
  it should, "use tempDir", () => (
    testPath.path(false).startsWith tempDir
  )
  it should, "compute hash", () => (
    testPath.path(true).lastPathPart() == $hash(testPath)
  )
  it should, "compute identical hashes", () => (
    testPath.path(true).lastPathPart() == testPath.path(false).lastPathPart()
  )

block config:
  let it = bdd "config"
  it should, "retrieve config", () => (
    $retrieve[Config](new(Config), defaultManifest).typeof == "Config"
  )

  it shouldRaiseMsg, fileLoadDefect.msg, () => (
    retrieve[Config](new(Config), "if/config/not/found").isNil
  )
