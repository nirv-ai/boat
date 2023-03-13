import std/sugar

export sugar

# TODO: both itShould & Not should be templates
# ^ so we can lazy eval cond and wrap it in try, except
# ^ or add an overload to accept a callback, think thats what everyone else does
proc itShould*(
  msg: string,
  name = "test name: ",
  cond: bool,
  istrue = true
  ): void = doAssert cond == istrue, name & msg

proc itShouldNot*(
  msg: string,
  name = "test name: ",
  cond: bool
  ): void = itShould msg, name, cond, false

# TODO: follow the leader: https://www.chaijs.com/api/bdd/
type What* = enum
  should, shouldNot, shouldError, shouldNotError

proc bdd*(caseName: string): (What, string, () -> bool) -> void =
  (what: What, msg: string, cond: () -> bool) => (
    case what
      of should: itShould(msg, caseName, cond())
      of shouldNot: itShouldNot(msg, caseName, cond())
      of shouldError, shouldNotError:
        var didError = false
        try: discard cond()
        except CatchableError: didError = true
        finally:
          if ord(what) == ord(shouldError): itShould(msg, caseName, didError)
          else: itShouldNot(msg, caseName, didError)

  )
