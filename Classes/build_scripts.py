#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import jinja2
import re
from jinja2 import Environment, FileSystemLoader


YEEHAW_LANG = u"""
[YHCPerk_Scientist]
PerkName="Scientist"
EXPAction1="Dealing Scientist weapon damage"
EXPAction2="Head shots with Scientist weapons"

SkillCatagories[0]="I'm Helping"
SkillCatagories[1]="Gene Therapy"
SkillCatagories[2]="Rx"
SkillCatagories[3]="Chemistry"
SkillCatagories[4]="Zedxperiments"

Passives[0]=(Title="Perk Weapon Damage",Description="Increase perk weapon damage %x% per level");
Passives[1]=(Title="Syringe Recharge Rate",Description="Increase syringe recharge rate %x% per level");
Passives[2]=(Title="Health Bar Detection",Description="Range of 5m plus %x%m per level");

Bobbleheads="Bobbleheads"
BobbleheadsDescription="Darting Zeds will inflate them. Headshots most effective."

Sensitive="Sensitive"
SensitiveDescription="Darting Zeds will decrease damage by 20% and resistance by 20%. Headshots most effective."

Pharming="Pharming"
PharmingDescription="Darted zeds release healing clouds upon death. Headshots most effective."

Overdose="Overdose"
OverdoseDescription="Darted zeds will explode upon death. Headshots most effective."

NoPainNoGain="No Pain No Gain"
NoPainNoGainDescription="Darts have MUCH faster dart healing. Headshots are all awesome. Bodyshots will hurt teammate and you!"

ZedWhisperer="Zed Whisperer"
ZedWhispererDescription="Darting Zeds will de-rage or disable some special moves. Headshots most effective."

YourMineMine="Your Mine Mine"
YourMineMineDescription="Darted bloats upon explosive death will release mines that explode on zed contact"

SmellsLikeRoses="Smells Like Roses"
SmellsLikeRosesDescription="Darted bloats upon explosive death will release mines that release a healing cloud on contact"

ZedTimeGrenades="Zed Time Grenades"
ZedTimeGrenadesDescription="Swap your bloat mine grenades and wield the power to manipulate time!"

RealityDistortion="ZED TIME - Reality Distortion Field"
RealityDistortionDescription="Infinite darts and ammo!"

[YHProj_BloatMineGrenade]
ItemName="Healing Mines"
ItemCategory ="Mines"
ItemDescription="-"


[YHProj_ZedTimeGrenade]
ItemName="Zed Time Grenade"
ItemCategory ="Time"
ItemDescription="-Triggers Zed Time. You get to carry one. Nuff said?"

[YHWeap_Healer_Syringe]
ItemName="Medical Syringe"
ItemCategory="Equipment"

[YHWeap_Pistol_Medic]
ItemName="HMTech-101 Pistol"
ItemCategory="Pistol"
ItemDescription="-Fire mode is semi-auto only.\\n-Alt-fire shoots healing darts to heal team members.\\n-It uses caseless ammunition and it counts the rounds for you."

[YHWeap_SMG_Medic]
ItemName="HMTech-201 SMG"
ItemCategory="Submachine Gun"
ItemDescription="-Fire mode is full-auto only.\\n-Alt-fire shoots healing darts to heal team members.\\n-Your HMTech pistol, only beefed up!"

[YHWeap_Shotgun_Medic]
ItemName="HMTech-301 Shotgun"
ItemCategory="Shotgun"
ItemDescription="-Fire mode is semi-auto only.\\n-Alt-fire shoots healing darts to heal team members.\\n-The combat shotgun version of the HMTech pistol."

[YHWeap_AssaultRifle_Medic]
ItemName="HMTech-401 Assault Rifle"
ItemCategory="Assault Rifle"
ItemDescription="-Fire mode is full-auto only.\\n-Alt-fire shoots healing darts to heal team members.\\n-The full-blown assault rifle version of the HMTech pistol."

[YHWeap_Rifle_RailGun]
ItemName="Rail Gun"
ItemCategory="Sniper Rifle"
ItemDescription="-Fire mode is single shot only.\\n-Using the sight lets you lock on to vulnerable spots on your target. \\n-This weapon fires a solid steel slug at high speeds using magnets, penetrating Zeds like tissue paper."

[YHWeap_Beam_Microwave]
ItemName="Microwave Gun"
ItemCategory="Flames"
ItemDescription="-Fire mode uses microwaves to heat Zeds at range, burning them inside and out.\\n-Alt-fire unleashes a close-range microwave blast.\\n-The wonders of modern technology: a handheld Zed-cooker."

"""

SPAREIDEAS = """
Mudskipper="Mudskipper"
MudskipperDescription="Darting Zeds will slow movement by 30%"
SteadyHands="Steady Hands"
SteadyHandsDescription="Darted players reduce recoil, firing speed and increase damage up to 20%"
LoversQuarrel="ZED TIME - Lover's Qurarrel"
LoversQuarrelDescription="Dart headshots will cause zeds to attack other zeds"
EyeBleach="Eye Bleach"
EyeBleachDescription="Darted players reduce visual effects of explosions, bile and fire."
ExtraStrength="ZED TIME - Extra Strength"
ExtraStrengthDescription="Greatly increase the effectiveness of dart effects"
"""



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

print "[Monsters]"
# Create the pawns for the monsters
for monster in MONSTERS:
    print "-", monster

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

print "[SpawnManagers]"
# Load the template
for length in LENGTHS:
    print "-", length
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

print "[PERKS]"
for perk in PERKS:
    print "-", perk
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

print "[Weapons]"
for weap in medic_weapons:
    print "-", weap
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


current_module = ''

print "[LANGUAGE]"
line_items = []
for l in YEEHAW_LANG.split('\n'):
    m = re.search('^\[(.*)\]$',l)
    if m:
        current_module = m.group(1)
        continue

    line_match = re.search('^(\w+)(\[(\d+)])?=(.*)',l)
    if line_match:
        varname = line_match.group(1)
        val = line_match.group(4)
        if line_match.group(2):
            varindex = line_match.group(3)
            varname += "."+varindex
        if re.search("^\(.+\);?$",val):
            element_matches = re.findall('(\w+)=(".*?")',val)
            for ( subkey, subvalue ) in element_matches:
                subvarname = "{k}.{k2}".format(k=varname,k2=subkey)
                buf = u'YHStrings.Add( (m="{m}",k="{k}",s={s}) )'.format(m=current_module,k=subvarname,s=subvalue)
                line_items.append(buf)
        else:
            buf = u'YHStrings.Add( (m="{m}",k="{k}",s={s}) )'.format(m=current_module,k=varname,s=val)
            line_items.append(buf)


generate_source(
    'YHLocalization.uct',
    'YHLocalization.uc',
    line_items=line_items
)

