##
## BoatErrors
## ==========
## standard errors and defects

import std/strformat

type BoatError* = ref object of CatchableError ## \
  ## standard catchable boat error

var configParseError* = BoatError(msg: "Cant Parse Config")
var fileLoadError* = BoatError(msg: "Cant Load File")
var filePermissionError* = BoatError(msg: "Invalid File Permissions")
var fileSaveError* = BoatError(msg: "Cant Save File")
var manifestNameError* = BoatError(msg: "Invalid Manifest Name")

type BoatDefect = ref object of Defect ## \
  # standard boat defect

var dirCreateDefect* = BoatDefect(msg: "Dir Create Failed")
var fileLoadDefect* = BoatDefect(msg: "Cant Load File")
var fileSaveDefect* = BoatDefect(msg: "Cant Save File")
var boatConfigKindError* = BoatDefect(msg: fmt"Expected typeof BoatConfigKind")
