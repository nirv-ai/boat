discard """
action: "run"
cmd: "nim $target --hints:on -d:testing --mm:orc -d:useMalloc --nimblePath:build/deps/pkgs $options $file"
output: '''
All HANDS! cat o'nine tails! blue peter! OMG... landlubber
'''
valgrind: "true"
"""

import boat

boat()
