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
