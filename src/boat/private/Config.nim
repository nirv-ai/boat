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
  cachedir*: string ## \
    ## defaults to getCacheDir()
  use*: string ## \
    ## path on disk pointing to a manifest / or dir with a manifest
    ## URL pointing to a *.ini file
  #--- private ---#
  parsed: parsecfg.Config ## \
    ## the parsed config after loading
  saved: bool ## \
    ## true if self.use has been saved to disk

proc parseLocalManifest*(self: Config, path = self.use): bool =
  ## parse self.use to self.parsed
  ## prefer calling self.load or self.reload for validation
  self.parsed = loadConfig path
  result = true


proc save*(self: Config): bool =
  ## serialize Self.parsed to disk @ self.cachedir | getCachDir() / <SELF.ID>.manifest.nim.ini
  result = true


proc reload*(self: Config): bool =
  # starts with https?
    # ends in .ini? break
    # throw: urls must point to a manifest.nim.ini
  # must be a filepath, as we only support https
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
        # TODO: test this throws if its not a file
        # we only check if its not https, whatif ftp? http? etc
        let path = self.use.getFileInfo
        case path.kind
          of pcFile, pcLinkToFile:
            if fpUserRead notin path.permissions:
              raise newException(CatchableError, "invalid file permissions")
            elif not self.use.endsWith ".ini":
              raise newException(CatchableError, "invalid file type")

            result = self.parseLocalManifest()
          of pcDir, pcLinkToDir:
            raise newException(CatchableError, "TODO: loading from dir not setup")
      except:
        debugEcho repr getCurrentException()
        raise newException(CatchableError, "unable to load conf from disk")


proc load*(self: Config): bool =
  ## load whatever self.use points to
  result = if self.saved:
    if self.parsed is Config: true # TODO: ensure this checks its a Config instance
    else: true # self.parse() TODO: need to load from cacheDir
  else: self.reload()
