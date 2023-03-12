--colors:off
--define:nimLegacyTypeMismatch
--excessiveStackTrace:off
--path:"$projectDir/../../src"
--processing:off

when (NimMajor, NimMinor, NimPatch) >= (1,5,1):
  # to make it easier to test against older nim versions, (best effort only)
  switch("filenames", "legacyRelProj")
  switch("spellSuggest", "0")
