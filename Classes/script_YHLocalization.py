#!/usr/bin/python

import re

localize = """
[YHCPerk_Scientist]
PerkName="Scientist"
EXPAction1="Dealing Scientist weapon damage"
EXPAction2="Head shots with Scientist weapons"

SkillCatagories[0]="I'm Helping"
SkillCatagories[1]="Gene Therapy"
SkillCatagories[2]="Rx"
SkillCatagories[3]="Chemistry"
SkillCatagories[4]="Zedxperiments"

//Passives[0]=(Title="Perk Weapon Damage",Description="Increase perk weapon damage %x% per level");
//Passives[1]=(Title="Bullet Resistance",Description="Increase resistance to projectile damage 5% plus %x% per level");
//Passives[2]=(Title="Movement Speed",Description="Increase movement speed %x% every five levels");
//Passives[3]=(Title="Recoil",Description="Reduce perk weapon recoil %x% per level");
//Passives[4]=(Title="Zedtime Reload",Description="Increase reload speed in Zed time %x% per level");

Bobbleheads="Bobbleheads"
BobbleheadsDescription="Darting heads of Zeds will inflate them"

Mudskipper="Mudskipper"
MudskipperDescription="Darting legs of Zeds will slow movement by 30%"

Pharming="Pharming"
PharmingDescription="80% of darted trash zeds release healing clouds upon death"

Overdose="Overdose"
OverdoseDescription="80% of darted trash zeds will explode upon death"

EyeBleach="Eye Bleach"
EyeBleachDescription="Darted players reduce visual effects of explosions, bile and fire."

SteadyHands="Steady Hands"
SteadyHandsDescription="Darted players reduce recoil, firing speed and increase damage up to 20%"

YourMineMine="Your Mine Mine"
YourMineMineDescription="Darted bloats upon explosive death will release mines that explode on zed contact"

SmellsLikeRoses="Smells Like Roses"
SmellsLikeRosesDescription="Darted bloats upon explosive death will release mines that release a healing cloud on contact"

RealityDistortion="ZED TIME - Reality Distortion Field"
RealityDistortionDescription="Bodyshots will be treated as headshots"

LoversQuarrel="ZED TIME - Lover's Qurarrel"
LoversQuarrelDescription="Dart headshots will cause zeds to attack other zeds"
"""

current_module = ''

for l in localize.split('\n'):
    m = re.search('^\[(.*)\]$',l)
    if m:
        current_module = m.group(1)
        continue

    m = re.search('^(\w+)(\[(\d+)])?=(.*)',l)
    if m:
        varname = m.group(1)
        val = m.group(4)
        if m.group(2):
            varindex = m.group(3)
            varname += varindex
        print 'YHStrings.Add( (m="{m}",k="{k}",s={s}) )'.format(m=current_module,k=varname,s=val)

