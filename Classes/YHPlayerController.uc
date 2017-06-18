class YHPlayerController extends CD_PlayerController;

var YHGFxMoviePlayer_Manager      MyYHGFxManager;

var array<int>  PerkBuildCache;

function int GetPerkBuildByPerkClass(class<KFPerk> PerkClass)
{
    local int i;
    local int MyPerkBuild;
    local PerkInfo MyPerkInfo;
    local class<KFPerk> MyPerkClass;
    local string TruePerkClassName;
    local int PerkIndex;

    if ( PerkBuildCache.Length == 0 )
    {
        for ( i=0; i<PerkList.Length; i++ )
        {
            MyPerkInfo = PerkList[i];
            MyPerkClass = MyPerkInfo.PerkClass;
            if ( Left(MyPerkClass.Name,2) == "YH" )
            {
                TruePerkClassName = "KFGame.KFPerk_"$Mid(MyPerkClass.Name,7);
                MyPerkClass = class<KFPerk>(DynamicLoadObject(TruePerkClassName, class'Class'));
            }

            MyPerkBuild = super.GetPerkBuildByPerkClass(MyPerkClass);

            PerkBuildCache.AddItem(MyPerkBuild);
        }
    }

    PerkIndex = PerkList.Find('PerkClass', PerkClass);
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
    PerkList.Add((PerkClass=class'KFPerk_Support')
    PerkList.Add((PerkClass=class'YHPerk_FieldMedic'))
    PerkList.Add((PerkClass=class'KFPerk_Demolitionist'))
    PerkList.Add((PerkClass=class'KFPerk_Firebug'))
    PerkList.Add((PerkClass=class'YHPerk_Gunslinger'))
    PerkList.Add((PerkClass=class'YHPerk_Sharpshooter'))
    PerkList.Add((PerkClass=class'KFPerk_Survivalist'))
    PerkList.Add((PerkClass=class'YHPerk_SWAT'))

}
