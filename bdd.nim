##
## Bdd
## ===
## simple assertions for use with testament
## - [inspired by chaijs](https://www.chaijs.com/api/bdd/)
# todo: extract this to a separate package
# todo: think through how to auto-clean up stuff created during tests
# ^ think testament auto sets d:testing which can help with this
# ^ also make note about native nimlang procs, e.g. tryRemoveFile returns bool

import std/sugar

type TddError* = ref object of CatchableError
  ## generic error for test driven development
var tddError* = TddError(msg: "TODO: this feature isnt ready yet") ## \
  ## ready to be raised tdd error

type BddDefect = ref object of Defect
  ## not a tddError, used internally
var failure = BddDefect(msg: "Invalid Test Parameters") ## \
  ## escape hatch to fail a test early

proc assertCondition(
  condition: bool,
  matches: bool,
  name: string,
  msg: string,
  ): void =
    ## tests the assertion
    ## all other methods are sugar for this proc
    doAssert condition == matches, name & " -> " & msg

proc itShould*(
  msg: string,
  condition: bool,
  name = "test name: ",
  ): void =
    ## asserts condition matches expectation
    ## prefer creating a test case with bdd
    assertCondition condition, true, name, msg

proc itShouldNot*(
  msg: string,
  condition: bool,
  name = "test name: ",
  ): void =
    ## asserts condition matches expectation
    ## prefer creating a test case with bdd
    assertCondition condition, false, name, msg

type What* = enum
  ## expected result of some condition
  should, ## be true
  shouldNot, ## be true
  shouldNotRaise, ## error when called
  shouldRaise, ## error when called
  shouldRaiseMsg, ## when called
  shouldNotRaiseMsg, ## but should raise a different msg when called

proc bdd*(caseName: string): (What, string, () -> bool) -> void =
  ## simple assertions for use with testament
  ## provide a test name and receive a fn that
  ## validates condition matches expectation
  (what: What, msg: string, condition: () -> bool) => (
    case what
      of should: itShould msg, condition(), caseName
      of shouldNot: itShouldNot msg, condition(), caseName
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
            of shouldNotRaise: itShouldNot msg, didRaise, caseName
            of shouldNotRaiseMsg: itShould msg, didRaise and msgRaised != msg, caseName
            of shouldRaise: itShould msg, didRaise, caseName
            of shouldRaiseMsg: itShould msg, didRaise and msgRaised == msg, caseName
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
