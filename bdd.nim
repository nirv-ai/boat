##
## Bdd
## ===
## simple assertions for use with testament

# follow the leader: https://www.chaijs.com/api/bdd/


import std/sugar

export sugar

type TddError* = ref object of CatchableError
  ## generic error for test driven development

var tddError* = TddError(msg: "TODO: this feature isnt ready yet") ## \
  ## ready to be raised tddError

proc itShould*(
  msg: string,
  name = "test name: ",
  condition: bool,
  istrue = true
): void =
  ## asserts condition matches expectation
  ## prefer creating a test case with bdd
  doAssert condition == istrue, name & " -> " & msg

proc itShouldNot*(
  msg: string,
  name = "test name: ",
  condition: bool
): void =
  ## asserts condition matches expectation
  ## prefer creating a test case with bdd
  itShould msg, name, condition, false

type What* = enum
  ## expected result of some condition
  should, ## be true
  shouldError, ## when called
  shouldNot, ## be true
  shouldNotError, ## when called

proc bdd*(caseName: string): (What, string, () -> bool) -> void =
  ## simple assertions for use with testament
  ## provide a test name and receive a fn that
  ## validates condition matches expectation
  (what: What, msg: string, condition: () -> bool) => (
    case what
      of should: itShould msg, caseName, condition()
      of shouldNot: itShouldNot msg, caseName, condition()
      of shouldError, shouldNotError:
        var didError = false
        try: discard condition()
        except CatchableError, OSError: didError = true
        finally:
          if what.ord == shouldError.ord: itShould msg, caseName, didError
          else: itShouldNot msg, caseName, didError
  )
