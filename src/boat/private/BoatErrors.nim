##
## BoatErrors
## ==========
## standard errors and defects

type BoatError* = ref object of CatchableError

var configParseError* = BoatError(msg: "Cant Parse Config")
var fileLoadError* = BoatError(msg: "Cant Load File")
var filePermissionError* = BoatError(msg: "Invalid File Permissions")
var fileSaveError* = BoatError(msg: "Cant Save File")
var manifestNameError* = BoatError(msg: "Invalid Manifest Name")

type BoatDefect = ref object of Defect

var dirCreateDefect* = BoatDefect(msg: "Dir Create Failed")
var fileSaveDefect* = BoatDefect(msg: "Cant Save File")
