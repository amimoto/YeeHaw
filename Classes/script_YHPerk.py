#!/usr/bin/python

import os
import jinja2
import re

PERKS = """Berserker
Commando
FieldMedic
Gunslinger
Sharpshooter
SWAT""".split()

# Load the template
TEMPLATE = open('YHPerk.uct').read()
perk_template = jinja2.Template(TEMPLATE)

for perk in PERKS:
    print perk
    fname = "YHPerk_{perk}.uc".format(perk=perk)

    # Get the data
    perk_code = perk_template.render(perk=perk)
    open(fname,'w').write(perk_code)


"""
for perk in PERKS:
    print perk
    fname = "YHPerk_{perk}.uc".format(perk=perk)
    if not os.path.exists(fname):
        continue

    # Get the data
    override_buf = perk_template.render(perk=perk)
    buf = open(fname).read()

    # Mix it in...
    buf = re.sub(r"/\*OVERRIDES_START\*/(.*)/\*OVERRIDES_END\*/",override_buf,buf,flags=re.M|re.S)

    with open(fname,"w") as f:
        f.write(buf)

"""
