#!/usr/bin/python

import os
import jinja2
import re
from jinja2 import Environment, FileSystemLoader
import os

THIS_DIR = os.path.dirname(os.path.abspath(__file__))

JINJA2ENV = Environment(loader=FileSystemLoader(THIS_DIR), trim_blocks=True)

def generate_source( template_fpath, source_fpath, **kwargs):
    target_fpath = source_fpath.format(**kwargs)
    target_template_fpath = target_fpath+'t'

    if os.path.exists(target_template_fpath):
        template_fpath = target_template_fpath

    data_code = JINJA2ENV.get_template(template_fpath).render(**kwargs)
    open(target_fpath,'w').write(data_code)


MONSTERS = """
Bloat
Clot_AlphaKing
Clot_Alpha
Clot_Cyst
Clot_Slasher
Clot
CrawlerKing
Crawler
FleshpoundKing
FleshpoundMini
Fleshpound
GorefastDualBlade
Gorefast
HansFriendlyTest
Hans
HuskFriendlyTest
Husk
Patriarch
Scrake
Siren
Stalker
""".split()


CD_MONSTERS = """
CD_Pawn_ZedClot_AlphaKing
CD_Pawn_ZedClot_Alpha_Regular
CD_Pawn_ZedClot_Alpha_Special
CD_Pawn_ZedClot_Alpha
CD_Pawn_ZedCrawler_Regular
CD_Pawn_ZedCrawler_Special
CD_Pawn_ZedFleshpoundKing_NoMinions
CD_Pawn_ZedFleshpoundMini_NRS
CD_Pawn_ZedFleshpoundMini_RS
CD_Pawn_ZedFleshpound_NRS
CD_Pawn_ZedFleshpound_RS
CD_Pawn_ZedGorefast_Regular
CD_Pawn_ZedGorefast_Special
""".split()

for cd_monster in CD_MONSTERS:
    m = re.search('^CD_Pawn_Zed(.*)$',cd_monster)
    if not m: continue
    monster = m.group(1)
    if monster not in MONSTERS:
        MONSTERS.append(monster)

# Load the template
MAPPINGS = []

# Create the pawns for the monsters
for monster in MONSTERS:
    print monster

    monster_class = "YHPawn_Zed{monster}".format(monster=monster)
    fname = monster_class + '.uc'

    cd_monster = "CD_Pawn_Zed{monster}".format(monster=monster)
    monster_superclass = "KFPawn_Zed{monster}".format(monster=monster)
    if cd_monster in CD_MONSTERS:
        monster_superclass = cd_monster

    MAPPINGS.append({
        'monster_superclass': monster_superclass,
        'monster_class': monster_class
    })

    # Get the data
    generate_source(
        'YHPawn_Monster.uct',
        'YHPawn_Zed{monster}.uc',
        monster=monster,
        monster_superclass=monster_superclass,
        monster_class=monster_class
    )

# Create the remappers to map monsters into what we desire them to be
MAPPER_TEMPLATE = open('YHPawn_Monster_Remapper.uct').read()
mapper_template = jinja2.Template(MAPPER_TEMPLATE)
mapper_buf = mapper_template.render(mappings=MAPPINGS)
open('YHPawn_Monster_Remapper.uc','w').write(mapper_buf)


# Now handle the spawn manager
LENGTHS = """
Short
Normal
Long
""".split()

# Load the template
for length in LENGTHS:
    generate_source(
        'YHSpawnManager.uct',
        'YHSpawnManager_{length}.uc',
        length=length
    )

# Handle the Perks
PERKS = """Berserker
Commando
Support
FieldMedic
Gunslinger
Sharpshooter
Demolitionist
Firebug
Survivalist
SWAT""".split()

for perk in PERKS:
    generate_source(
        'YHPerk.uct',
        'YHPerk_{perk}.uc',
        perk=perk
    )


# Handle the Weapons
medic_weapons = [
        'AssaultRifle',
        'Pistol',
        'Shotgun',
        'SMG'
    ]

# Load the template
DEFTRANS = {
    'AssaultRifle': 'Rifle'
}

for weap in medic_weapons:
    print weap
    weapdef = DEFTRANS.get(weap,weap)

    generate_source(
        'YHWeap_MedicBase.uct',
        'YHWeap_{weap}_Medic.uc',
        weap=weap,
        weapdef=weapdef
    )

    generate_source(
        'YHWeapDEF_MedicBase.uct',
        'YHWeapDef_Medic{weapdef}.uc',
        weap=weap,
        weapdef=weapdef
    )

