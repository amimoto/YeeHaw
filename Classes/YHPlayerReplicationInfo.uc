class YHPlayerReplicationInfo extends KFPlayerReplicationInfo;

// FIXME: Make this a constant
var repnotify int PerkBuildCache[20];
var repnotify bool PerkBuildCacheLoaded;

/* Replicated Perk Changes */
var repnotify int PerkBuildRequested;


replication
{
    if (bNetDirty)
        PerkBuildCache, PerkBuildCacheLoaded, PerkBuildRequested;
}

simulated event ReplicatedEvent(name VarName)
{
    if ( VarName == 'PerkIndexRequested' )
    {
        `log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PERKINDEXREQUESTED");
    }
    else if ( VarName == 'PerkBuildRequested' )
    {
        SetPerkBuild();
    }

    super.ReplicatedEvent(VarName);
}

simulated function SetPerkBuild()
{
    local byte SelectedSkillsHolder[`MAX_PERK_SKILLS];
    local YHPlayerController LocalPC;
    local KFPerk MyPerk;

    LocalPC = YHPlayerController(Owner);
    MyPerk = LocalPC.GetPerk();

    `log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SetPerkBuild"@PerkBuildRequested);
    ScriptTrace();

    MyPerk.GetUnpackedSkillsArray( MyPerk.Class, PerkBuildRequested,  SelectedSkillsHolder);
    MyPerk.UpdatePerkBuild(SelectedSkillsHolder, MyPerk.Class );

    //MyPerk.SetPerkBuild(PerkBuildRequested);
}

defaultproperties
{
    PerkBuildCacheLoaded = false
}
