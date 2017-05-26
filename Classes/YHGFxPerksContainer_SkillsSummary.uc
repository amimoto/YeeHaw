class YHGFxPerksContainer_SkillsSummary extends KFGFxPerksContainer_SkillsSummary;

function UpdateSkills( class<KFPerk> PerkClass, const out byte SelectedSkills[`MAX_PERK_SKILLS] )
{
    local bool bShouldUnlock;
    local byte i, UnlockLevel, bTierUnlocked;
    local GFxObject DataProvider,TempObj;
    local string SkillName;
    local string   IconPath;
    local int PerkSkillIndex;
    local array<PerkSkill> PerkSkillArr;
    local int UnlockedPerkLevel;
    local KFPlayerController KFPC;
    local string PackageName;

    PerkSkillArr = PerkClass.default.PerkSkills;
    KFPC = KFPlayerController(GetPC());

    DataProvider = CreateArray();
    PackageName = Left(PerkClass.Name,2) $ "Game";

    for ( i = 0; i < `MAX_PERK_SKILLS; i++ )
    {
        PerkSkillIndex = (i * 2) + (SelectedSkills[i]-1);
        TempObj = CreateObject( "Object" );
        UnlockLevel = class'KFPerk'.const.RANK_1_LEVEL + (class'KFPerk'.const.UNLOCK_INTERVAL * i);
        bShouldUnlock = SelectedSkills[i] > 0;
        if(bShouldUnlock)
        {
            SkillName = Localize(String(PerkClass.Name), PerkSkillArr[PerkSkillIndex].Name, PackageName);;
            IconPath = PerkSkillArr[PerkSkillIndex].IconPath;
            if(IconPath == "")
            {
                IconPath = PerkClass.static.GetPerkIconPath();
            }
        }
        else
        {
            SkillName = LevelString@ UnlockLevel;
            IconPath = KFGFxMenu_Perks(ParentMenu).LockIconPath;
        }
        TempObj.SetBool("unlocked", bShouldUnlock);
        TempObj.SetString("Title", SkillName);
        TempObj.SetString("iconSource", "img://"$IconPath);

        DataProvider.SetElementObject( i, TempObj );
    }
    class'KFPerk'.static.LoadTierUnlockFromConfig(PerkClass, bTierUnlocked, UnlockedPerkLevel);
    SetBool("bTierUnlocked" , bool(bTierUnlocked) && KFPC.GetPerkLevelFromPerkList( PerkClass ) >= UnlockedPerkLevel   );
    SetObject("skillsData", DataProvider);
}

