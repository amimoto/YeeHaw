class YHPlayerController extends CD_PlayerController;

var YHGFxMoviePlayer_Manager      MyYHGFxManager;

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
}

/*
reliable client function ReapplySkills()
{
    local byte SelectedSkillsHolder[`MAX_PERK_SKILLS];
    local KFPerk MyPerk;
    local int NewPerkBuild;

    YHGameReplicationInfo(WorldInfo.GRI).AllowPerkChanging(true);
    MyPerk = GetPerk();
    NewPerkBuild = GetPerkBuildByPerkClass(MyPerk.Class);
    MyPerk.GetUnpackedSkillsArray( MyPerk.Class, NewPerkBuild,  SelectedSkillsHolder);
    MyPerk.UpdatePerkBuild(SelectedSkillsHolder, MyPerk.Class );
    YHGameReplicationInfo(WorldInfo.GRI).AllowPerkChanging(false);
}
*/


/** Makes sure we always spawn in with a valid perk */
function WaitForPerkAndRespawn()
{
    // Check on next frame, don't use looping timer because we don't need overlaps here
    SetTimer( 0.01f, false, nameOf(Timer_CheckForValidPerk) );
    bWaitingForClientPerkData = true;
}

function Timer_CheckForValidPerk()
{
    local YHPlayerReplicationInfo YHPRI;
    local KFPerk MyPerk;

    `log("!!!!!!!!!!!!!!!!!!!!!!!!!!"@Timer_CheckForValidPerk);

    YHPRI = YHPlayerReplicationInfo(PlayerReplicationInfo);
    MyPerk = GetPerk();
    if( MyPerk != none && MyPerk.bInitialized && YHPRI.PerkBuildCacheLoaded )
    {
        // Make sure that readiness state didn't change while waiting
        if( CanRestartPlayer() )
        {
            WorldInfo.Game.RestartPlayer( self );
        }
        bWaitingForClientPerkData = false;
        return;
    }

    // Check again next frame
    SetTimer( 0.01f, false, nameOf(Timer_CheckForValidPerk) );
}

reliable client function ReapplySkills()
{
    local KFPerk MyPerk;
    local int NewPerkBuild;

    MyPerk = GetPerk();
    NewPerkBuild = GetPerkBuildByPerkClass(MyPerk.Class);
    ChangeSkills(NewPerkBuild);
}


reliable client function ReapplyDefaults()
{
    local KFPerk MyPerk;
    MyPerk = GetPerk();
    MyPerk.SetPlayerDefaults(KFPawn(Pawn));
    MyPerk.AddDefaultInventory(KFPawn(Pawn));
}

reliable server function PRICacheLoad(int PerkIndex, int NewPerkBuild)
{
    local YHPlayerReplicationInfo YHPRI;
    YHPRI = YHPlayerReplicationInfo(PlayerReplicationInfo);
    YHPRI.PerkBuildCache[PerkIndex] = NewPerkBuild;
}

reliable server function PRICacheCompleted()
{
    local YHPlayerReplicationInfo YHPRI;
    YHPRI = YHPlayerReplicationInfo(PlayerReplicationInfo);
    YHPRI.PerkBuildCacheLoaded = true;
}

function bool IsPerkBuildCacheLoaded()
{
    return YHPlayerReplicationInfo(PlayerReplicationInfo).PerkBuildCacheLoaded;
}

function int GetPerkBuildByPerkClass(class<KFPerk> PerkClass)
{
    local int i;
    local int MyPerkBuild;
    local PerkInfo MyPerkInfo;
    local class<KFPerk> MyPerkClass;
    local string BasePerkClassName;
    local int PerkIndex;
    local int RequestedPerkBuild;

    local YHPlayerReplicationInfo YHPRI;

    YHPRI = YHPlayerReplicationInfo(PlayerReplicationInfo);
    `log("???????????????????????????????????????????????"@GetPerkBuildByPerkClass@"for"@PerkClass);
    PerkIndex = PerkList.Find('PerkClass', PerkClass);

    // If we have the values cached, immediately return them
    if ( YHPRI.PerkBuildCacheLoaded )
    {
        if ( PerkIndex < 0 )
              return 0;
        return YHPRI.PerkBuildCache[PerkIndex];
    }

    RequestedPerkBuild = 0;
    for ( i=0; i<PerkList.Length; i++ )
    {
        MyPerkInfo = PerkList[i];
        MyPerkClass = MyPerkInfo.PerkClass;
        if ( Left(MyPerkClass.Name,2) == "YH" )
        {
            BasePerkClassName = "KFGame.KFPerk_"$Mid(MyPerkClass.Name,7);
            MyPerkClass = class<KFPerk>(DynamicLoadObject(BasePerkClassName, class'Class'));
        }

        MyPerkBuild = super.GetPerkBuildByPerkClass(MyPerkClass);
        if ( PerkIndex == i )
        {
            RequestedPerkBuild = MyPerkBuild;
        }

        PRICacheLoad(i,MyPerkBuild);
    }
    PRICacheCompleted();

    return RequestedPerkBuild;
}


/************************************************************************* 
   As the binary perk/skills changing is causing us some grief, we'll
   build around. it.
 *************************************************************************/

reliable server function ChangePerk( int NewPerkIndex )
{
    local YHPlayerReplicationInfo YHPRI;
    YHPRI = YHPlayerReplicationInfo(PlayerReplicationInfo);
    YHPRI.PerkIndexCurrent = NewPerkIndex;
    YHPRI.PerkIndexRequested= NewPerkIndex;

    YHPRI.NetPerkIndex = NewPerkIndex;
    YHPRI.CurrentPerkClass = PerkList[NewPerkIndex].PerkClass;
}

reliable server function ChangeSkills( int NewPerkBuild )
{
    local YHPlayerReplicationInfo YHPRI;
    YHPRI = YHPlayerReplicationInfo(PlayerReplicationInfo);
    YHPRI.PerkBuildCurrent = NewPerkBuild;
    YHPRI.PerkBuildRequested = NewPerkBuild;
    GetPerk().SetPerkBuild(NewPerkBuild);
}

DefaultProperties
{
    //defaults
    PerkList.Empty()
    PerkList.Add((PerkClass=class'YHPerk_Berserker'))
    PerkList.Add((PerkClass=class'YHPerk_Commando')
    PerkList.Add((PerkClass=class'YHPerk_Support')
    PerkList.Add((PerkClass=class'YHPerk_FieldMedic'))
    PerkList.Add((PerkClass=class'YHPerk_Demolitionist'))
    PerkList.Add((PerkClass=class'YHPerk_Firebug'))
    PerkList.Add((PerkClass=class'YHPerk_Gunslinger'))
    PerkList.Add((PerkClass=class'YHPerk_Sharpshooter'))
    PerkList.Add((PerkClass=class'YHPerk_Survivalist'))
    PerkList.Add((PerkClass=class'YHPerk_SWAT'))

}
