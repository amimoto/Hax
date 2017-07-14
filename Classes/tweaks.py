#!/usr/bin/python

"""
File segments renamer

Usage:
    tweaks.py [options] <files>...

Options:
    -h --help               Show this screen
    --version               Show version
    -c --config=<config>    JSON config [default: ~/kf2make.json]
"""

import docopt

args = docopt.docopt(__doc__,version="Renamer 1.0")

for fname in args['<files>']:
    buf = open(fname).read()

    buf = buf.replace('YH','HX')
    buf = buf.replace('yhLog','hxLog')
    buf = buf.replace('yhScriptTrace','hxScriptTrace')

    open(fname,'w').write(buf)




