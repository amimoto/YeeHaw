#!/usr/bin/python

import os
import jinja2
import re


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
    m = re.search('CD_PawnZed(.*)',cd_monster)
    if not m: continue
    monster = m.group(1)
    if monster not in MONSTERS:
        MONSTERS.append(monster)

# Load the template
TEMPLATE = open('YHPawn_Monster.uct').read()
monster_template = jinja2.Template(TEMPLATE)

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
    monster_code = monster_template.render(monster=monster,monster_superclass=monster_superclass)
    open(fname,'w').write(monster_code)

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
TEMPLATE = open('YHSpawnManager.uct').read()
manager_template = jinja2.Template(TEMPLATE)

for length in LENGTHS:
    print length
    fname = "YHSpawnManager_{length}.uc".format(length=length)

    # Get the data
    length_code = manager_template.render(length=length)
    open(fname,'w').write(length_code)


