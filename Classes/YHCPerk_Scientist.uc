class YHCPerk_Scientist extends KFPerk;

`include(YH_Log.uci)

/** Passive skills */
var const PerkSkill                 MovementSpeed;

enum EScientistPerkSkills
{
    EScientistBobbleheads,
    EScientistMudskipper,
    EScientistPharming,
    EScientistOverdose,
    EScientistEyeBleach,
    EScientistSteadyHands,
    EScientistYourMineMine,
    EScientistSmellsLikeRoses,
    EScientistZTRealityDistortion,
    EScientistZTLoversQuarrel
};



/**
 * @brief Weapons and perk skills can affect the jog/sprint speed
 *
 * @param Speed jog/sprint speed
  */
simulated function ModifySpeed( out float Speed )
{
    local float TempSpeed;
    TempSpeed = Speed - 0.025 + Speed * GetPassiveValue( MovementSpeed, GetLevel() );
    Speed = TempSpeed;
}

defaultproperties
{
    //PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_PerkIcon_Scientist'
    PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'

    ProgressStatID=STATID_Surv_Progress
    PerkBuildStatID=STATID_Surv_Build

    //PrimaryWeaponDef=class'YHWeapDef_MedicPistol'
    PrimaryWeaponDef=class'YHWeapDef_MedicRifle'
    KnifeWeaponDef=class'KFWeapDef_Knife_Medic'
    GrenadeWeaponDef=class'YHWeapDef_Grenade_Scientist'

    MovementSpeed=(Name="Movement Speed",Increment=0.004f,Rank=0,StartingValue=0.f,MaxValue=0.1f)

    PerkSkills(EScientistBobbleheads)=(Name="Bobbleheads",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_TacticalReload", Increment=0.f,Rank=0,StartingValue=0.25,MaxValue=0.25)    //0.1
    PerkSkills(EScientistMudskipper)=(Name="Mudskipper",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_HeavyWeapons", Increment=0.f,Rank=0,StartingValue=2.5f,MaxValue=2.5f)
    PerkSkills(EScientistPharming)=(Name="Pharming",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_FieldMedic", Increment=0.f,Rank=0,StartingValue=0.25f,MaxValue=0.25f)
    PerkSkills(EScientistOverdose)=(Name="Overdose",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_MeleeExpert", Increment=0.f,Rank=0,StartingValue=0.1f,MaxValue=0.1f)
    PerkSkills(EScientistEyeBleach)=(Name="EyeBleach",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_AmmoVest", Increment=0.f,Rank=0,StartingValue=0.15f,MaxValue=0.15f)
    PerkSkills(EScientistSteadyHands)=(Name="SteadyHands",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_BigPockets", Increment=0.f,Rank=0,StartingValue=5.f,MaxValue=5.f)
    PerkSkills(EScientistYourMineMine)=(Name="YourMineMine",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Shrapnel", Increment=0.f,Rank=0,StartingValue=2.f,MaxValue=2.f)
    PerkSkills(EScientistSmellsLikeRoses)=(Name="SmellsLikeRoses",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Boom", Increment=0.f,Rank=0,StartingValue=1.25f,MaxValue=1.25f)
    PerkSkills(EScientistZTRealityDistortion)=(Name="RealityDistortion",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Madman", Increment=0.f,Rank=0,StartingValue=0.5f,MaxValue=0.5f)
    PerkSkills(EScientistZTLoversQuarrel)=(Name="LoversQuarrel",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_IncapMaster", Increment=0.f,Rank=0,StartingValue=1.f,MaxValue=1.f)


}

