discard """
action: "run"
output: '''
All HANDS! cat o'nine tails! blue peter! OMG... landlubber
'''
valgrind: "leaks"
"""

import boat

boat()
