##
## BoatErrors
## ==========
## Its an error to call this BoatErrors, should be BoatErrorsAndDefectsForRaisingExceptionsWhenThingsGoBad

type BoatError* = ref object of CatchableError

var tddError* = BoatError(msg: "TODO: this feature isnt ready yet")

var configParseError* = BoatError(msg: "Cant Parse Config")
var fileLoadError* = BoatError(msg: "Cant Load File")
var filePermissionError* = BoatError(msg: "Invalid File Permissions")
var fileSaveError* = BoatError(msg: "Cant Save File")
var manifestNameError* = BoatError(msg: "Invalid Manifest Name")

type BoatDefect = ref object of Defect

var dirCreateDefect* = BoatDefect(msg: "Dir Create Failed")
var fileSaveDefect* = BoatDefect(msg: "Cant Save File")
