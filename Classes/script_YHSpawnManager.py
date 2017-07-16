#!/usr/bin/python

import os
import jinja2
import re

LENGTHS = """
Short
Normal
Long
""".split()

# Load the template
TEMPLATE = open('YHSpawnManager.uct').read()
manager_template = jinja2.Template(TEMPLATE)

for length in LENGTHS:
    print length
    fname = "YHSpawnManager_{length}.uc".format(length=length)

    # Get the data
    length_code = manager_template.render(length=length)
    open(fname,'w').write(length_code)


