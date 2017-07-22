class YHCPerk_Scientist extends KFPerk
    implements(YHPerk_Interface);

`include(YH_Log.uci)

/** Passive skills */
var const PerkSkill                 MovementSpeed;

var private     const   array<byte>             MudskipperBodyParts;

var private     const   float                   SnarePower;

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

function bool MudskipperBodyPart( byte BodyPart )
{
    return MudskipperBodyParts.Find( BodyPart ) != INDEX_NONE;
}

simulated function ApplyDartHeadshotAfflictions(
                          KFPlayerController DamageInstigator,
                          byte HitZoneIdx,
                          KFPawn_Monster Monster
                      )
{
    `yhLog("DOOT");
    Monster.SetHeadScale(1.5,Monster.CurrentHeadScale);
}


simulated function ApplyDartBodyshotAfflictions(
                          KFPlayerController DamageInstigator,
                          byte HitZoneIdx,
                          KFPawn_Monster Monster
                      )
{
    `yhLog("POOT");
    Monster.AfflictionHandler.AccrueAffliction(AF_Snare, SnarePower);
}

/* For debug purposes */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}

/*********************************************************************************
 ** Skill status getters
 *********************************************************************************/

simulated function bool IsBobbleheadsActive()
{
    return PerkSkills[EScientistBobbleheads].bActive && IsPerkLevelAllowed(EScientistBobbleheads);
}

simulated function bool IsMudskipperActive()
{
    return PerkSkills[EScientistMudskipper].bActive && IsPerkLevelAllowed(EScientistMudskipper);
}

simulated function bool IsPharmingActive()
{
    return PerkSkills[EScientistPharming].bActive && IsPerkLevelAllowed(EScientistPharming);
}

simulated function bool IsOverdoseActive()
{
    return PerkSkills[EScientistOverdose].bActive && IsPerkLevelAllowed(EScientistOverdose);
}

simulated function bool IsEyeBleachActive()
{
    return PerkSkills[EScientistEyeBleach].bActive && IsPerkLevelAllowed(EScientistEyeBleach);
}

simulated function bool IsSteadyHandsActive()
{
    return PerkSkills[EScientistSteadyHands].bActive && IsPerkLevelAllowed(EScientistSteadyHands);
}

simulated function bool IsYourMineMineActive()
{
    return PerkSkills[EScientistYourMineMine].bActive && IsPerkLevelAllowed(EScientistYourMineMine);
}

simulated function bool IsSmellsLikeRosesActive()
{
    return PerkSkills[EScientistSmellsLikeRoses].bActive && IsPerkLevelAllowed(EScientistSmellsLikeRoses);
}

simulated function bool IsRealityDistortionActive()
{
    return PerkSkills[EScientistZTRealityDistortion].bActive && IsPerkLevelAllowed(EScientistZTRealityDistortion);
}

simulated function bool IsLoversQuarrelActive()
{
    return PerkSkills[EScientistZTLoversQuarrel].bActive && IsPerkLevelAllowed(EScientistZTLoversQuarrel);
}

defaultproperties
{

    // Skill tracking
    SnarePower=1000 //this is for the leg darts

    MudskipperBodyParts(0)=2
    MudskipperBodyParts(1)=3
    MudskipperBodyParts(2)=4
    MudskipperBodyParts(3)=5


    //PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_PerkIcon_Scientist'
    PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'

    ProgressStatID=STATID_Surv_Progress
    PerkBuildStatID=STATID_Surv_Build

    //PrimaryWeaponDef=class'YHWeapDef_MedicPistol'
    PrimaryWeaponDef=class'YHWeapDef_MedicRifle'
    KnifeWeaponDef=class'KFWeapDef_Knife_Medic'
    GrenadeWeaponDef=class'YHWeapDef_Grenade_Scientist'

    ToxicDmgTypeClass=class'YHDT_Toxic_Scientist'

    MovementSpeed=(Name="Movement Speed",Increment=0.004f,Rank=0,StartingValue=0.f,MaxValue=0.1f)

    PerkSkills(EScientistBobbleheads)=(Name="Bobbleheads",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_TacticalReload", Increment=0.f,Rank=0,StartingValue=0.25,MaxValue=0.25)    //0.1
    PerkSkills(EScientistMudskipper)=(Name="Mudskipper",IconPath="UI_PerkTalent_TEX.Gunslinger.UI_Talents_Gunslinger_KnockEmDown", Increment=0.f,Rank=0,StartingValue=2.5f,MaxValue=2.5f)
    PerkSkills(EScientistPharming)=(Name="Pharming",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_FieldMedic", Increment=0.f,Rank=0,StartingValue=0.25f,MaxValue=0.25f)
    PerkSkills(EScientistOverdose)=(Name="Overdose",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_MeleeExpert", Increment=0.f,Rank=0,StartingValue=0.1f,MaxValue=0.1f)
    PerkSkills(EScientistEyeBleach)=(Name="EyeBleach",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_AmmoVest", Increment=0.f,Rank=0,StartingValue=0.15f,MaxValue=0.15f)
    PerkSkills(EScientistSteadyHands)=(Name="SteadyHands",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_BigPockets", Increment=0.f,Rank=0,StartingValue=5.f,MaxValue=5.f)
    PerkSkills(EScientistYourMineMine)=(Name="YourMineMine",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Shrapnel", Increment=0.f,Rank=0,StartingValue=2.f,MaxValue=2.f)
    PerkSkills(EScientistSmellsLikeRoses)=(Name="SmellsLikeRoses",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Boom", Increment=0.f,Rank=0,StartingValue=1.25f,MaxValue=1.25f)
    PerkSkills(EScientistZTRealityDistortion)=(Name="RealityDistortion",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Madman", Increment=0.f,Rank=0,StartingValue=0.5f,MaxValue=0.5f)
    PerkSkills(EScientistZTLoversQuarrel)=(Name="LoversQuarrel",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_IncapMaster", Increment=0.f,Rank=0,StartingValue=1.f,MaxValue=1.f)


}

