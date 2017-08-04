class YHCPerk_Scientist extends KFPerk
    DependsOn(YHLocalization)
    implements(YHPerk_Interface);

`include(YH_Log.uci)

/** Passive skills */
var private const   PerkSkill       WeaponDamage;                  // weapon dmg modifier
var private const   PerkSkill       EnemyHPDetection;              // Can see cloaked zeds x UUs far (100UUs = 100cm = 1m)
var const PerkSkill                 HealerRecharge;

var             GameExplosion       ExplosionTemplate;
var class<KFWeaponDefinition>       ZTGrenadeWeaponDef;

var             Texture2d           WhiteMaterial;

enum EScientistPerkSkills
{
    EScientistBobbleheads, // TODO: multiple darts?
    EScientistSensitive, // TODO: multiple darts?
    EScientistPharming, // TODO: multiple darts?
    EScientistOverdose, // TODO: multiple darts?
    EScientistNoPainNoGain, // TODO: balance?
    EScientistZedWhisperer, // TODO: balance?
    EScientistSmellsLikeRoses, // TODO: Animations
    EScientistYourMineMine, // TODO: Animations
    EScientistZTGrenades, // TODO: Code
    EScientistZTRealityDistortion // DONE
};


/**
 * @brief Modifies how long one recharge cycle takes
 *
 * @param RechargeRate charging rate per sec
  */
simulated function ModifyHealerRechargeTime( out float RechargeRate )
{
    local float HealerRechargeTimeMod;

    HealerRechargeTimeMod = GetPassiveValue( HealerRecharge, GetLevel() );
    `QALog( "HealerRecharge" @ HealerRechargeTimeMod, bLogPerk );
    RechargeRate /= HealerRechargeTimeMod;
}

/**
 * @brief The Zed shrapnel skill can spawn an explosion, this function delivers the template
 *
 * @return A game explosion template
 */
function GameExplosion GetExplosionTemplate()
{
    return default.ExplosionTemplate;
}

function float GetBobbleheadPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    `yhLog("HitZoneIdx"@HitZoneIdx@"IsBobbleHeadsActive"@IsBobbleHeadsActive());
    if ( HitZoneIdx == HZI_Head && IsBobbleHeadsActive() )
    {
        return 1.f;
    }
    return 0.f;
};

function float GetSensitivePowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    if ( IsSensitiveActive() )
    {
        return 1.f;
    }
    return 0;
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


function float GetNoPainNoGainPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    if ( IsNoPainNoGainActive() )
    {
        return 1.f;
    }
    return 0;
};

function float GetZedWhispererPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    if ( IsZedWhispererActive() )
    {
        return 1.f;
    }
    return 0;
};


function float GetExtraStrengthPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx ) {
    if ( IsExtraStrengthActive() )
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

// Add to player's ammo count
reliable server function AddAmmo(KFWeapon KFW)
{
    if (KFW.MagazineCapacity[0] >= KFW.AmmoCount[0] )
    {
        KFW.AmmoCount[0]++;
        KFW.ClientForceAmmoUpdate(KFW.AmmoCount[0],KFW.SpareAmmoCount[0]);
        KFW.bNetDirty = true;
    }
    else if ( KFW.SpareAmmoCapacity[0] > KFW.SpareAmmoCount[0] )
    {
        KFW.SpareAmmoCount[0]++;
        KFW.ClientForceAmmoUpdate(KFW.AmmoCount[0],KFW.SpareAmmoCount[0]);
        KFW.bNetDirty = true;
    }

}

// Where we determine if the play has got a headshot. If it does turn out
// that they did, we return ammo to their magazine... if the magazine is
// full, we'll just put another round into their spare ammo pool
simulated function ModifyDamageGiven( out int InDamage,
                                      optional Actor DamageCauser,
                                      optional KFPawn_Monster MyKFPM,
                                      optional KFPlayerController DamageInstigator,
                                      optional class<KFDamageType> DamageType,
                                      optional int HitZoneIdx )
{
    local KFWeapon KFW;
    local YHEAmmoMode AmmoMode;

    AmmoMode = YHGameReplicationInfo(MyKFGRI).AmmoMode;

    if( DamageCauser != none )
    {
        KFW = GetWeaponFromDamageCauser( DamageCauser );
    }

    if( (KFW != none && IsWeaponOnPerk( KFW,, self.class )) || (DamageType != none && IsDamageTypeOnPerk( DamageType )) )
    {
        InDamage += InDamage * GetPassiveValue( WeaponDamage, CurrentLevel );
    }

    if ( AmmoMode == AM_YEEHAW )
    {
        // Only reward ammo when it's a headshot
        if( KFW != none && IsWeaponOnPerk( KFW,, self.class ) && HitZoneIdx == HZI_HEAD )
        {
            // Make sure we're not doing the second round do blow off the head
            if ( MyKFPM != none && !MyKFPM.bCheckingExtraHeadDamage )
            {
                AddAmmo(KFW);
            }
        }
    }

    super.ModifyDamageGiven(InDamage,DamageCauser,MyKFPM,DamageInstigator,DamageType,HitZoneIdx);
}

simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    if ( YHGameReplicationInfo(MyKFGRI).AmmoMode==AM_UBERAMMO )
    {
        return true;
    }
    return IsWeaponOnPerk( KFW,, self.class ) && IsRealityDistortionActive() && WorldInfo.TimeDilation < 1.f;
}

/*********************************************************************************
 ** Skill status getters
 *********************************************************************************/

simulated function bool IsBobbleheadsActive()
{
    return PerkSkills[EScientistBobbleheads].bActive && IsPerkLevelAllowed(EScientistBobbleheads);
}

simulated function bool IsSensitiveActive()
{
    return PerkSkills[EScientistSensitive].bActive && IsPerkLevelAllowed(EScientistSensitive);
}

simulated function bool IsPharmingActive()
{
    return PerkSkills[EScientistPharming].bActive && IsPerkLevelAllowed(EScientistPharming);
}

simulated function bool IsOverdoseActive()
{
    return PerkSkills[EScientistOverdose].bActive && IsPerkLevelAllowed(EScientistOverdose);
}

simulated function bool IsNoPainNoGainActive()
{
    return PerkSkills[EScientistNoPainNoGain].bActive && IsPerkLevelAllowed(EScientistNoPainNoGain);
}

simulated function bool IsZedWhispererActive()
{
    return PerkSkills[EScientistZedWhisperer].bActive && IsPerkLevelAllowed(EScientistZedWhisperer);
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

simulated function bool IsExtraStrengthActive()
{
    return false;
}

simulated function bool IsZTGrenadesActive()
{
    return PerkSkills[EScientistZTGrenades].bActive && IsPerkLevelAllowed(EScientistZTGrenades);
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

simulated function string GetGrenadeImagePath()
{
    if( IsZTGrenadesActive() )
    {
        return default.ZTGrenadeWeaponDef.Static.GetImagePath();
    }

    return default.GrenadeWeaponDef.Static.GetImagePath();
}


simulated function class<KFWeaponDefinition> GetGrenadeWeaponDef()
{
    if( IsZTGrenadesActive() )
    {
        `yhLog("Tossing ZEDTIME GRENADES");
        return default.ZTGrenadeWeaponDef;
    }
    `yhLog("Tossing NORMAL GRENADES");

    return default.GrenadeWeaponDef;
}


/* Returns the grenade class for this perk */
simulated function class< KFProj_Grenade > GetGrenadeClass()
{
    if( IsZTGrenadesActive() )
    {
        return class<KFProj_Grenade>(DynamicLoadObject(ZTGrenadeWeaponDef.default.WeaponClassPath, class'Class'));
    }

    return GrenadeClass;
}

simulated static function GetPassiveStrings( out array<string> PassiveValues, out array<string> Increments, byte Level )
{
    PassiveValues[0] = Round( GetPassiveValue( default.WeaponDamage, Level) * 100 ) $ "%";
    PassiveValues[1] = Round(default.HealerRecharge.Increment * Level * 100) $ "%";
    PassiveValues[2] = Round( GetPassiveValue( default.EnemyHPDetection, Level ) / 100 ) $ "m";     // Divide by 100 to convert unreal units to meters

    Increments[0] = "["@Left( string( default.WeaponDamage.Increment * 100 ), InStr(string(default.WeaponDamage.Increment * 100), ".") + 2 )    $"% /" @default.LevelString @"]";
    Increments[1] = "[" @ Left( string( default.HealerRecharge.Increment * 100 ), InStr(string(default.HealerRecharge.Increment * 100), ".") + 2 )   $"% /" @ default.LevelString @"]";
    Increments[2] = "["@ Int(default.EnemyHPDetection.StartingValue / 100 ) @"+" @Int(default.EnemyHPDetection.Increment / 100 )       $"m /" @default.LevelString @"]";
}

defaultproperties
{

    //PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_PerkIcon_Scientist'
    PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'

    ProgressStatID=STATID_Surv_Progress
    PerkBuildStatID=STATID_Surv_Build

    PrimaryWeaponDef=class'YHWeapDef_MedicPistol'
    //PrimaryWeaponDef=class'YHWeapDef_MedicRifle'
    KnifeWeaponDef=class'KFWeapDef_Knife_Medic'
    // GrenadeWeaponDef=class'YHWeapDef_Grenade_Scientist'
    GrenadeWeaponDef=class'YHWeapDef_Grenade_BloatMine'

    /** Passive skills */
    EnemyHPDetection=(Name="Enemy HP Detection Range",Increment=200.f,Rank=0,StartingValue=1000.f,MaxValue=6000.f)
    HealerRecharge=(Name="Healer Recharge",Increment=0.04f,Rank=0,StartingValue=1.f,MaxValue=3.f)
    WeaponDamage=(Name="Weapon Damage",Increment=0.005,Rank=0,StartingValue=0.0f,MaxValue=0.125)

    PerkSkills(EScientistBobbleheads)        =(Name="Bobbleheads",      IconPath="UI_PerkTalent_TEX.Gunslinger.UI_Talents_Gunslinger_RackEmUp",     Increment=0.f,Rank=0,StartingValue=0.25,MaxValue=0.25)
    PerkSkills(EScientistSensitive)          =(Name="Sensitive",        IconPath="UI_PerkTalent_TEX.Gunslinger.UI_Talents_Gunslinger_KnockEmDown",  Increment=0.f,Rank=0,StartingValue=2.5f,MaxValue=2.5f)
    PerkSkills(EScientistPharming)           =(Name="Pharming",         IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_FieldMedic", Increment=0.f,Rank=0,StartingValue=0.25f,MaxValue=0.25f)
    PerkSkills(EScientistOverdose)           =(Name="Overdose",         IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Shrapnel",   Increment=0.f,Rank=0,StartingValue=0.1f,MaxValue=0.1f)
    PerkSkills(EScientistNoPainNoGain)       =(Name="NoPainNoGain",     IconPath="UI_PerkTalent_TEX.Medic.UI_Talents_Medic_HealingSurge",           Increment=0.f,Rank=0,StartingValue=0.15f,MaxValue=0.15f)
    PerkSkills(EScientistYourMineMine)       =(Name="YourMineMine",     IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Boom",       Increment=0.f,Rank=0,StartingValue=2.f,MaxValue=2.f)
    PerkSkills(EScientistSmellsLikeRoses)    =(Name="SmellsLikeRoses",  IconPath="UI_perktalent_TEX.Medic.UI_Talents_Medic_AirborneAgent",          Increment=0.f,Rank=0,StartingValue=1.25f,MaxValue=1.25f)
    PerkSkills(EScientistZedWhisperer)       =(Name="ZedWhisperer",     IconPath="UI_perktalent_TEX.Medic.UI_Talents_Medic_Zedative",               Increment=0.f,Rank=0,StartingValue=1.25f,MaxValue=1.25f)
    PerkSkills(EScientistZTRealityDistortion)=(Name="RealityDistortion",IconPath="UI_PerkTalent_TEX.Survivalist.UI_Talents_Survivalist_Madman",     Increment=0.f,Rank=0,StartingValue=0.5f,MaxValue=0.5f)
    PerkSkills(EScientistZTGrenades)         =(Name="ZedTimeGrenades",  IconPath="UI_PerkTalent_TEX.demolition.UI_Talents_Demolition_Professional", Increment=0.f,Rank=0,StartingValue=5.f,MaxValue=5.f)

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

    ZTGrenadeWeaponDef=class'YHWeapDef_Grenade_Scientist';
}

