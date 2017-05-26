class YHGFxPerksContainer_Skills extends KFGFxPerksContainer_Skills;

function GFxObject GetSkillObject(byte TierIndex, byte SkillIndex, bool bShouldUnlock, class<KFPerk> PerkClass)
{
    local GFxObject SkillObject;
    local string SkillName, SkillDescription;
    local string IconPath;
    local int PerkSkillIndex;
    local array<PerkSkill> PerkSkillArr;
    local string PackageName;
    local string PerkClassName;

    PerkSkillArr = PerkClass.default.PerkSkills;
    PerkSkillIndex = (TierIndex * 2) + (SkillIndex);

    // Deal with Localization files later
    // PackageName = Left(PerkClass.Name,2) $ "Game";
    PackageName = "KFGame";
    PerkClassName = String(PerkClass.Name) == "YHPerk_Gunslinger" ? "KFPerk_Gunslinger" : String(PerkClass.Name);

    if(PerkSkillIndex < PerkClass.Default.PerkSkills.length )
    {
        SkillObject = CreateObject( "Object" );
        SkillName = Localize(PerkClassName, PerkSkillArr[PerkSkillIndex].Name, PackageName);
        SkillObject.SetString("label", SkillName);
        SkillDescription = Localize(PerkClassName, PerkSkillArr[PerkSkillIndex].Name$"Description", PackageName);
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

