##
## Bdd
## ===
## simple assertions for use with testament
## - [inspired by chaijs](https://www.chaijs.com/api/bdd/)


import std/sugar

type TddError* = ref object of CatchableError
  ## generic error for test driven development
var tddError* = TddError(msg: "TODO: this feature isnt ready yet") ## \
  ## ready to be raised tdd error

type BddDefect = ref object of Defect
  ## not a tddError, used internally
var failure = BddDefect(msg: "Invalid Test Parameters") ## \
  ## escape hatch to fail a test early

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
  shouldNot, ## be true
  shouldNotRaise, ## error when called
  shouldRaise, ## error when called
  shouldRaiseMsg, ## when called
  shouldNotRaiseMsg, ## but any different msg

proc bdd*(caseName: string): (What, string, () -> bool) -> void =
  ## simple assertions for use with testament
  ## provide a test name and receive a fn that
  ## validates condition matches expectation
  (what: What, msg: string, condition: () -> bool) => (
    case what
      of should: itShould msg, caseName, condition()
      of shouldNot: itShouldNot msg, caseName, condition()
      of
        shouldNotRaise,
        shouldNotRaiseMsg,
        shouldRaise,
        shouldRaiseMsg:
          var didRaise = false
          var msgRaised: string
          try: discard condition()
          except CatchableError, Defect:
            didRaise = true
            msgRaised = getCurrentExceptionMsg()
          finally:
            case what:
            of shouldNotRaise: itShouldNot msg, caseName, didRaise
            of shouldNotRaiseMsg: itShould msg, caseName, didRaise and msgRaised != msg
            of shouldRaise: itShould msg, caseName, didRaise
            of shouldRaiseMsg: itShould msg, caseName, didRaise and msgRaised == msg
            else: raise failure
  )

export sugar

when isMainModule:
  proc catchme: bool = raise TddError(msg: "if you can")
  proc raiseMsg: bool = raise failure

  let it = bdd "bdd tests"
  it should, "be true", () => true
  it shouldNot, "be true", () => false
  it shouldNotRaise, "error", () => true
  it shouldNotRaise, "or care about result", () => false
  it shouldNotRaiseMsg, "anything but this", () => raiseMsg()
  it shouldRaise, "error", () => catchme()
  it shouldRaiseMsg, failure.msg, () => raiseMsg()
