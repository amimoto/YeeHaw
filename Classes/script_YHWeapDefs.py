#!/usr/bin/python

import os
import jinja2
import re

"""
MWG
Railgun
"""

medic_weapons = [
        'AssaultRifle',
        'Pistol',
        'Shotgun',
        'SMG'
    ]


# Load the template
TEMPLATE = open('YHWeap_MedicBase.uct').read()
weap_template = jinja2.Template(TEMPLATE)
DEFTEMPLATE = open('YHWeapDEF_MedicBase.uct').read()
weapdef_template = jinja2.Template(DEFTEMPLATE)

DEFTRANS = {
    'AssaultRifle': 'Rifle'
}

for weap in medic_weapons:
    print weap
    weapdef = DEFTRANS.get(weap,weap)

    # Dump the data
    fname = "YHWeap_{weap}_Medic.uc".format(weap=weap,weapdef=weapdef)
    weap_code = weap_template.render(weap=weap,weapdef=weapdef)
    open(fname,'w').write(weap_code)


    # Dump the data
    fname = "YHWeapDef_Medic{weapdef}.uc".format(weap=weap,weapdef=weapdef)
    weapdef_code = weapdef_template.render(weap=weap,weapdef=weapdef)
    open(fname,'w').write(weapdef_code)



