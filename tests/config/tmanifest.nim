discard """
action: "run"
valgrind: "leaks"
exitcode: 0
"""

import std/os

import ../../bdd
import ../helpers

block baseCaseInitialization:
  let it = bdd "base case: Initialize Manifest"
  it should, "create Manifest", () => (
    $Manifest(use: "xyz").typeof == "Manifest"
  )

  for conf in @[
    newManifest(use = "192.168.1.1"),
    newManifest(use = "http://www.not.https")
  ]: it shouldRaise, "invalid protocol", () => conf.load()

block baseCaseLoadFile:
  let it = bdd "base case: Load Manifest from File"
  it should, "load manifest", () => newManifest().load()
  it should, "auto parse manifest to Config", () => (
    let c = newManifest()
    itShould "be nil before load()", c.parsed.isNil
    discard c.load()
    itShouldNot "be nil after load()", c.parsed.isNil
    $c.parsed.typeof == "Config"
  )
  it should, "save parsed config to disk", () => (
    let c = newManifest()
    let expected = c.use.path true
    if expected.fileExists: expected.removeFile
    discard c.load()
    expected.fileExists
  )

block baseCaseLoadFileFromDir:
  let it = bdd "base case: Load Manifest from Directory"
  it should, "load config", () => newManifestD().load()
