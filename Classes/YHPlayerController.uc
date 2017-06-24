class YHPlayerController extends CD_PlayerController;

var YHGFxMoviePlayer_Manager      MyYHGFxManager;

// FIXME: Make this a constant
var int PerkBuildCache[20];
var bool PerkBuildCacheLoaded;

simulated event PreBeginPlay()
{
    PerkBuildCacheLoaded = false;
    super.PreBeginPlay();
}

reliable client function ReapplySkills()
{
    local byte SelectedSkillsHolder[`MAX_PERK_SKILLS];
    local KFPerk MyPerk;
    local int NewPerkBuild;

    MyPerk = GetPerk();
    NewPerkBuild = GetPerkBuildByPerkClass(MyPerk.Class);
    MyPerk.GetUnpackedSkillsArray( MyPerk.Class, NewPerkBuild,  SelectedSkillsHolder);
    MyPerk.UpdatePerkBuild(SelectedSkillsHolder, MyPerk.Class );

    `log("THE PERK BUILD IS:"@NewPerkBuild);
    ScriptTrace();
}

reliable client function ReapplyDefaults()
{
    local KFPerk MyPerk;
    MyPerk = GetPerk();
    MyPerk.SetPlayerDefaults(MyPerk.OwnerPawn);
}

reliable server function ServerCacheSync(int NewPerkBuildCache[20])
{
    local int i;
    for ( i=0; i<PerkList.Length; i++ )
    {
        `log("??????????????????????????????????? UPDATING SERVERCACHCESYNC"@NewPerkBuildCache[i]);
        PerkBuildCache[i] = NewPerkBuildCache[i];
    }
    PerkBuildCacheLoaded = true;
}

function int GetPerkBuildByPerkClass(class<KFPerk> PerkClass)
{
    local int i;
    local int MyPerkBuild;
    local PerkInfo MyPerkInfo;
    local class<KFPerk> MyPerkClass;
    local string BasePerkClassName;
    local int PerkIndex;

    `log("++++++++++++++++++++++++++++++++++ GetPerkBuildByPerkClass"@PerkClass);
    ScriptTrace();
    if ( !PerkBuildCacheLoaded )
    {
        for ( i=0; i<PerkList.Length; i++ )
        {
            MyPerkInfo = PerkList[i];
            MyPerkClass = MyPerkInfo.PerkClass;
            if ( Left(MyPerkClass.Name,2) == "YH" )
            {
                BasePerkClassName = "KFGame.KFPerk_"$Mid(MyPerkClass.Name,7);
                MyPerkClass = class<KFPerk>(DynamicLoadObject(BasePerkClassName, class'Class'));
            }

            `log("CALLED GetPerkBuildByPerkClass for"@BasePerkClassName);
            MyPerkBuild = super.GetPerkBuildByPerkClass(MyPerkClass);

            PerkBuildCache[i] = (MyPerkBuild);
        }
        PerkBuildCacheLoaded = True;
        ServerCacheSync(PerkBuildCache);
    }

    PerkIndex = PerkList.Find('PerkClass', PerkClass);
    `log("CALLED GetPerkBuildByPerkClass with argument"@PerkClass);
    if ( PerkIndex < 0 )
          return 0;
    `log("PERKBUILD FOR"@PerkClass@"is"@PerkBuildCache[PerkIndex]);
    ScriptTrace();
    return PerkBuildCache[PerkIndex];
}

function CachePerkBuild( class<KFPerk> PerkClass, int NewPerkBuild )
{
    local int PerkIndex;
    PerkIndex = PerkList.Find('PerkClass', PerkClass);
    PerkBuildCache[PerkIndex] = NewPerkBuild;
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
