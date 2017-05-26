class YHGFxPerksContainer_Skills extends KFGFxPerksContainer_Skills;

function GFxObject GetSkillObject(byte TierIndex, byte SkillIndex, bool bShouldUnlock, class<KFPerk> PerkClass)
{
    local GFxObject SkillObject;
    local string SkillName, SkillDescription;
    local string IconPath;
    local int PerkSkillIndex;
    local array<PerkSkill> PerkSkillArr;
    local string PackageName;

    PerkSkillArr = PerkClass.default.PerkSkills;
    PerkSkillIndex = (TierIndex * 2) + (SkillIndex);

    PackageName = Left(PerkClass.Name,2) $ "Game";

    if(PerkSkillIndex < PerkClass.Default.PerkSkills.length )
    {
        SkillObject = CreateObject( "Object" );
        SkillName = Localize(String(PerkClass.Name), PerkSkillArr[PerkSkillIndex].Name, PackageName);
        SkillObject.SetString("label", SkillName);
        SkillDescription = Localize(String(PerkClass.Name), PerkSkillArr[PerkSkillIndex].Name$"Description", PackageName);
        SkillObject.SetString("description", SkillDescription);

        if(bShouldUnlock)
        {
            IconPath = PerkSkillArr[PerkSkillIndex].IconPath;
        }
        else
        {
            IconPath =  KFGFxMenu_Perks(ParentMenu).LockIconPath;
        }
    }

    if(IconPath == "")
    {
        IconPath = PerkClass.static.GetPerkIconPath();
    }

    SkillObject.SetString("iconSource", "img://"$IconPath);
    return SkillObject;
}

