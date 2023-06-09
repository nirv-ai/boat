--debugger:native
--deepcopy:on
--define:nimPreviewHashRef
--define:nimStrictDelete
--define:ssl
--define:threadsafe
--hints:on
--mm:orc
--multimethods:on
--parallelBuild:0 # TODO: 1 is always a good idea in CI
--stackTraceMsgs:on
--styleCheck:error
--threads:on
--tlsEmulation:on
--warnings:on

case getCommand():
  of "c", "cc", "cpp", "objc":
    --lineDir:on
    --lineTrace:on
    --stackTrace:on
  else: discard

case getEnv "ENV":
  of "DEV":
    --assertions:on
    --checks:on
    # --colors:on # breaks vscode runner?
    --debuginfo:on
    --declaredLocs:on
    --errorMax:0
    --excessiveStackTrace:on
    --opt:size
    --showAllMismatches:on
    --verbosity:2
  else:
    --assertions:off
    --define:release
    --errorMax:1
    --forceBuild:on
    --opt:speed
    --verbosity:0
