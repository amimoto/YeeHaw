class YHCPerk_Scientist extends KFPerk
    implements(YHPerk_Interface);

`include(YH_Log.uci)

/** Passive skills */
var private const   PerkSkill       EnemyHPDetection;              // Can see cloaked zeds x UUs far (100UUs = 100cm = 1m)

var             GameExplosion       ExplosionTemplate;

var private     const   array<byte>             MudskipperBodyParts;

var private     const   float                   SnarePower;

var             Texture2d       WhiteMaterial;

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
 * @brief The Zed shrapnel skill can spawn an explosion, this function delivers the template
 *
 * @return A game explosion template
 */
function GameExplosion GetExplosionTemplate()
{
    return default.ExplosionTemplate;
}


simulated function float GetSnarePowerModifier( optional class<DamageType> DamageType, optional byte HitZoneIdx )
{
    if ( IsMudskipperActive() )
    {
        return 1.f;
    }
    return 0;
};

function float GetBobbleheadPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    `yhLog("HitZoneIdx"@HitZoneIdx@"IsBobbleHeadsActive"@IsBobbleHeadsActive());
    if ( HitZoneIdx == HZI_Head && IsBobbleHeadsActive() )
    {
        return 1.f;
    }
    return 0.f;
};

function float GetPharmPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    if ( IsPharmingActive() )
    {
        return 1.f;
    }
    return 0;
};

function float GetOverdosePowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    if ( IsOverdoseActive() )
    {
        return 1.f;
    }
    return 0;
};

function float GetYourMineMinePowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    if ( IsYourMineMineActive() )
    {
        return 1.f;
    }
    return 0;
};

function float GetSmellsLikeRosesPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    if ( IsSmellsLikeRosesActive() )
    {
        return 1.f;
    }
    return 0;
};

simulated function ApplyDartHeadshotAfflictions(
                          KFPlayerController DamageInstigator,
                          byte HitZoneIdx,
                          KFPawn_Monster Monster
                      )
{
}

simulated function ApplyDartBodyshotAfflictions(
                          KFPlayerController DamageInstigator,
                          byte HitZoneIdx,
                          KFPawn_Monster Monster
                      )
{
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

/*********************************************************************************************
* @name  Temp Hud things
********************************************************************************************* */
simulated function DrawSpecialPerkHUD(Canvas C)
{
    local KFPawn_Monster KFPM;
    local vector ViewLocation, ViewDir;
    local float DetectionRangeSq, ThisDot;
    local float HealthBarLength, HealthbarHeight;

    if( CheckOwnerPawn() )
    {
        DetectionRangeSq = Square( GetPassiveValue(EnemyHPDetection, CurrentLevel) );

        HealthbarLength = FMin( 50.f * (float(C.SizeX) / 1024.f), 50.f );
        HealthbarHeight = FMin( 6.f * (float(C.SizeX) / 1024.f), 6.f );

        ViewLocation = OwnerPawn.GetPawnViewLocation();
        ViewDir = vector( OwnerPawn.GetViewRotation() );

        foreach WorldInfo.AllPawns( class'KFPawn_Monster', KFPM )
        {
            if( !KFPM.CanShowHealth()
                || !KFPM.IsAliveAndWell()
                || `TimeSince(KFPM.Mesh.LastRenderTime) > 0.1f
                || VSizeSQ(KFPM.Location - OwnerPawn.Location) > DetectionRangeSq
                )
            {
                continue;
            }

            ThisDot = ViewDir dot Normal( KFPM.Location - OwnerPawn.Location );
            if( ThisDot > 0.f )
            {
                DrawZedHealthbar( C, KFPM, ViewLocation, HealthbarHeight, HealthbarLength );
            }
        }
    }
}

simulated function DrawZedHealthbar(Canvas C, KFPawn_Monster KFPM, vector CameraLocation, float HealthbarHeight, float HealthbarLength )
{
    local vector ScreenPos, TargetLocation;
    local float HealthScale;

    if( KFPM.bCrawler && KFPM.Floor.Z <=  -0.7f && KFPM.Physics == PHYS_Spider )
    {
        TargetLocation = KFPM.Location + vect(0,0,-1) * KFPM.GetCollisionHeight() * 1.2 * KFPM.CurrentBodyScale;
    }
    else
    {
        TargetLocation = KFPM.Location + vect(0,0,1) * KFPM.GetCollisionHeight() * 1.2 * KFPM.CurrentBodyScale;
    }

    ScreenPos = C.Project( TargetLocation );
    if( ScreenPos.X < 0 || ScreenPos.X > C.SizeX || ScreenPos.Y < 0 || ScreenPos.Y > C.SizeY )
    {
        return;
    }

    if( `FastTracePhysX(TargetLocation,  CameraLocation) )
    {
        HealthScale = FClamp( float(KFPM.Health) / float(KFPM.HealthMax), 0.f, 1.f );

        C.EnableStencilTest( true );
        C.SetDrawColor(0, 0, 0, 255);
        C.SetPos( ScreenPos.X - HealthBarLength * 0.5, ScreenPos.Y );
        C.DrawTile( WhiteMaterial, HealthbarLength, HealthbarHeight, 0, 0, 32, 32 );

        C.SetDrawColor( 237, 8, 0, 255 );
        C.SetPos( ScreenPos.X - HealthBarLength * 0.5 + 1.0, ScreenPos.Y + 1.0 );
        C.DrawTile( WhiteMaterial, (HealthBarLength - 2.0) * HealthScale, HealthbarHeight - 2.0, 0, 0, 32, 32 );
        C.EnableStencilTest( false );
    }
}


defaultproperties
{

    // Skill tracking
    SnarePower=100 //this is for the leg darts

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

    EnemyHPDetection=(Name="Enemy HP Detection Range",Increment=200.f,Rank=0,StartingValue=1000.f,MaxValue=6000.f)

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

    Begin Object Class=KFGameExplosion Name=ExploTemplate0
        Damage=230  //231  //120
        DamageRadius=200   //840  //600
        DamageFalloffExponent=1
        DamageDelay=0.f
        MyDamageType=class'KFDT_Explosive_Shrapnel'

        // Damage Effects
        //KnockDownStrength=0
        FractureMeshRadius=200.0
        FracturePartVel=500.0
        ExplosionEffects=KFImpactEffectInfo'FX_Explosions_ARCH.FX_Combustion_Explosion'
        ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Frag.Play_WEP_EXP_Grenade_Frag_Explosion'

        // Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Perk_ShrapnelCombustion'
        CamShakeInnerRadius=450
        CamShakeOuterRadius=900
        CamShakeFalloff=1.f
        bOrientCameraShakeTowardsEpicenter=true
    End Object
    ExplosionTemplate=ExploTemplate0


    WhiteMaterial=Texture2D'EngineResources.WhiteSquareTexture'
}

