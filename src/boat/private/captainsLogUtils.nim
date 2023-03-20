from ../../../bdd import tddError

import std/[asyncdispatch, json]
from os import sleep

type Action* = enum
  BoatConfigRm,
  BoatConfigSave,

type LogData* = JsonNode | string

type CaptainState* = enum
  ## realtime state of CaptainsLog
  ## the order of the first 4 values will always be:
  ## 0 - InitializedFalse
  ## 1 - Initializing
  ## 2 - Ready
  ## 3 - Working
  InitializedFalse, ## initial state
  Initializing, ## init process started
  Ready, ## for work
  Busy, ## doing something

proc logAction*(self: Action, data: string): bool =
  ## tracks actions taken to the captains log
  result = case self
    of BoatConfigSave: true
    else: raise tddError

# todo: @see https://nim-lang.org/docs/manual.html#types-reference-and-pointer-types
var captainsLog* = %* {
    "captain": {},
    "cmd": {},
    "history": [],
    "queue": [],
    "state": InitializedFalse.ord,
  } ## \
  ## captains log is the runtime world

proc captainState*(self: JsonNode = captainsLog): CaptainState =
  CaptainState(self["state"].getInt)
proc captainState*(self: JsonNode = captainsLog, to: CaptainState): void =
  captainsLog["state"] = %* to.ord

proc captainReady*: Future[void] {.async.} =
  while CaptainState(captainsLog["state"].getInt) != Ready:
    sleep(100)


export asyncdispatch, json
