# TODO: follow the leader: https://www.chaijs.com/api/bdd/
# we should aim to provide similar functionality
# to ease the context switching between nim and our js stuff

import std/sugar

export sugar

proc itShould*(
    msg: string,
    name = "test name: ",
    condition: bool,
    istrue = true
  ): void =
  ## asserts condition matches expectation
  doAssert condition == istrue, name & " -> " & msg

proc itShouldNot*(
    msg: string,
    name = "test name: ",
    condition: bool
  ): void =
  ## asserts condition matches expectation
  itShould msg, name, condition, false

type What* = enum
  ## expected result of some condition
  should, ## be true
  shouldError, ## when called
  shouldNot, ## be true
  shouldNotError, ## when called

proc bdd*(caseName: string): (What, string, () -> bool) -> void =
  ## simple assertions for use with testament
  (what: What, msg: string, condition: () -> bool) => (
    case what
      of should: itShould msg, caseName, condition()
      of shouldNot: itShouldNot msg, caseName, condition()
      of shouldError, shouldNotError:
        var didError = false
        try: discard condition()
        except CatchableError: didError = true
        finally:
          if what.ord == shouldError.ord: itShould msg, caseName, didError
          else: itShouldNot msg, caseName, didError
  )
