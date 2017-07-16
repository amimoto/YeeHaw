class YHGFxPerksContainer_Skills extends KFGFxPerksContainer_Skills;

`include(YH_Log.uci)

function UpdateSkills( class<KFPerk> PerkClass, const out byte SelectedSkills[`MAX_PERK_SKILLS] )
{
    local KFPlayerController KFPC;
    local bool bShouldUnlock;
    local byte i, j, UnlockLevel;
    local GFxObject DataProvider,TempObj;
    local int PerkLevel;

    KFPC = KFPlayerController( GetPC() );

    DataProvider = CreateArray();

    for ( i = 0; i < `MAX_PERK_SKILLS; i++ )
    {
        TempObj = CreateObject( "Object" );
        TempObj.SetString( "label", `yhLocalizeObject(PerkClass.default.SkillCatagories[i],PerkClass,"SkillCatagories"$i ) );
        UnlockLevel = class'KFPerk'.const.RANK_1_LEVEL + ( class'KFPerk'.const.UNLOCK_INTERVAL * i );
        TempObj.SetString( "unlockLevel", LevelString@ UnlockLevel );
        PerkLevel = KFPC.GetPerkLevelFromPerkList( PerkClass );
        bShouldUnlock = ( UnlockLevel <= PerkLevel );
        TempObj.SetBool( "bUnlocked", bShouldUnlock );
        TempObj.SetInt( "selectedSkill", SelectedSkills[i] );

        for (j = 0; j < MAX_SLOTS; j++)
        {
            TempObj.SetObject("skill"$j,  GetSkillObject(i, j, bShouldUnlock, PerkClass));  
        }

        DataProvider.SetElementObject( i, TempObj );
    }

    SetObject("skillList", DataProvider);
}


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
    if ( Left(PerkClass.Name,3) == "YHP" )
    {
        PerkClassName = "KFPerk_"$Mid(PerkClass.Name,7);
    }
    else
    {
        PerkClassName = String(PerkClass.Name);
    }

    if(PerkSkillIndex < PerkClass.Default.PerkSkills.length )
    {
        SkillObject = CreateObject( "Object" );
        SkillName = Localize(PerkClassName, PerkSkillArr[PerkSkillIndex].Name, PackageName);
        SkillName = `yhLocalize(SkillName,PerkClassName,PerkSkillArr[PerkSkillIndex].Name);
        SkillObject.SetString("label", SkillName);

        SkillDescription = Localize(PerkClassName, PerkSkillArr[PerkSkillIndex].Name$"Description", PackageName);
        SkillDescription = `yhLocalize(SkillDescription,PerkClassName,PerkSkillArr[PerkSkillIndex].Name$"Description");
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

