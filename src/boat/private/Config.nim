##
## Config
## ======
## provides a parser and standard interface

##[
## TLDR
- come back later

links
-----
- [parsecfg](https://nim-lang.org/docs/parsecfg.html)

Interface
=========
- come back later
]##

import std/[
  os,
  parsecfg,
  strutils,
]


type Config* = ref object of RootObj
  # pub #
  cachedir*: string ## \
    ## defaults to getCacheDir()
  use*: string ## \
    ## path on disk pointing to a manifest / or dir with a manifest
    ## URL pointing to a *.ini file

  # priv #
  parsed: parsecfg.Config ## \
    ## the parsed config after loading
  saved: bool ## \
    ## true if self.use has been saved to disk

proc save*(self: Config): bool =
  ## serialize Self.parsed to disk @ self.cachedir | getCachDir() / <SELF.ID>.manifest.nim.ini
  result = true

proc parse*(self: Config): bool =
  ## parse self.use to self.parsed
  result = true

proc reload*(self: Config): bool =
  # starts with https?
    # ends in .ini? break
    # throw: urls must point to a manifest.nim.ini
  # must be a filepath, as we only support https that point to an *.ini
    # do we have read access?
      # does it end in .ini ? break
      # must be a dir
        # does it contain a manifest.nim.ini ? break
    # throw: couldnt find / or read a *.ini file
  # manifest seems to be okay! lets do the actual loading
    # parse and upsert to self.parsed
      # if manifest.nim.ini loads other manifests, recurse
  # everything must be okay!
  case self.use.startsWith "https"
    of true: raise newException(CatchableError, "TODO: remote manifests not setup")
    else:
      try:
        let file = self.use.getFileInfo
        case file.kind
          of pcFile:
            if fpUserRead notin file.permissions:
              raise newException(CatchableError, "invalid file permissions")
            elif not self.use.endsWith ".ini":
              raise newException(CatchableError, "invalid file type")

            self.parsed = loadConfig self.use
            result = true
          else: raise newException(CatchableError, "TODO: loading from dir not setup")
      except:
        debugEcho repr getCurrentException()
        raise newException(CatchableError, "unable to load conf from disk")


proc load*(self: Config): bool =
  ## load whatever self.use points to
  result = if self.saved:
    if self.parsed is Config: true # TODO: ensure this checks its not an empty Config
    else: self.parse()
  else: self.reload()
