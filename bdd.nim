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
  shouldRaise, ## error when called
  shouldNot, ## be true
  shouldNotRaise, ## error when called

proc bdd*(caseName: string): (What, string, () -> bool) -> void =
  ## simple assertions for use with testament
  ## provide a test name and receive a fn that
  ## validates condition matches expectation
  (what: What, msg: string, condition: () -> bool) => (
    case what
      of should: itShould msg, caseName, condition()
      of shouldNot: itShouldNot msg, caseName, condition()
      of shouldRaise, shouldNotRaise:
        var didRaise = false
        try: discard condition()
        except CatchableError: didRaise = true
        finally:
          if what.ord == shouldRaise.ord: itShould msg, caseName, didRaise
          else: itShouldNot msg, caseName, didRaise
  )


when isMainModule:
  proc catchme: bool = raise TddError(msg: "if you can")

  let it = bdd "bdd tests"
  it should, "be true", () => true
  it shouldNot, "be true", () => false
  it shouldRaise, "error", () => catchme()
  it shouldNotRaise, "error", () => true
  it shouldNotRaise, "or care about result", () => false
