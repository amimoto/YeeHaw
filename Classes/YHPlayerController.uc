class YHPlayerController extends CD_PlayerController;

var YHGFxMoviePlayer_Manager      MyYHGFxManager;

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
}

reliable client function RestartPlayer()
{
    local KFPerk MyPerk;
    local int NewPerkBuild;

    MyPerk = GetPerk();
    NewPerkBuild = GetPerkBuildByPerkClass(MyPerk.Class);
    ChangeSkills(NewPerkBuild, true);
}

reliable client function AddDefaultInventory()
{
    local KFPerk MyPerk;

    MyPerk = GetPerk();
    `log("CLIENT MyPerk.OwnerPawn:"@MyPerk.OwnerPawn);
    `log("CLIENT UsablePawn:"@UsablePawn);
    `log("CLIENT Pawn:"@Pawn);

    YHPawn_Human(UsablePawn).AddDefaultInventory();
}

// We call this from the client as only the client actually knows
// what the proper PerkBuild happens to be. This way we can capture
// the PerkBuild from the client and pass it back to the server via
// replication.
reliable client function ReapplySkills(optional bool bInitialLoad)
{
    local KFPerk MyPerk;
    local int NewPerkBuild;

    MyPerk = GetPerk();
    NewPerkBuild = GetPerkBuildByPerkClass(MyPerk.Class);
    ChangeSkills(NewPerkBuild, bInitialLoad);
}


reliable client function ReapplyDefaults()
{
    local KFPerk MyPerk;
    MyPerk = GetPerk();
    MyPerk.SetPlayerDefaults(MyPerk.OwnerPawn);
    // MyPerk.AddDefaultInventory(MyPerk.OwnerPawn);
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

reliable server function ChangeSkills( int NewPerkBuild, optional bool bInitialLoad )
{
    local YHPlayerReplicationInfo YHPRI;
    local KFPerk MyPerk;
    YHPRI = YHPlayerReplicationInfo(PlayerReplicationInfo);
    YHPRI.PerkBuildCurrent = NewPerkBuild;
    YHPRI.PerkBuildRequested = NewPerkBuild;

    `log("SSSSSSSSSSSSSSSSSSSSSSSSSSSSS CHANGESKILLS"@NewPerkBuild@"INitialLoad"@bInitialLoad);

    MyPerk = GetPerk();
    MyPerk.SetPerkBuild(NewPerkBuild);
    MyPerk.UpdateSkills();

    if ( bInitialLoad )
    {
        `log("MyPerk.OwnerPawn:"@MyPerk.OwnerPawn);
        `log("UsablePawn:"@UsablePawn);
        `log("Pawn:"@Pawn);
        // MyPerk.SetPlayerDefaults(MyPerk.OwnerPawn);
        //YHPawn_Human(MyPerk.OwnerPawn).AddDefaultInventory();
    }
    // MyPerk.PostLevelUp();
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
