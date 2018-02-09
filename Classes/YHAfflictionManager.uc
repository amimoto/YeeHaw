class YHAfflictionManager extends KFAfflictionManager
    DependsOn(YHDamageType);

`include(YH_Log.uci)

/* Types of stacking afflictions that are used to index the IncapSettings array */
enum EYHAfflictionType
{
    /** Place most common afflictions at top because array will resize up to the enum value */

    /** All Pawns */
    YHAF_EMP,
    YHAF_FirePanic,

    /** hit reactions (flinch) */
    YHAF_MeleeHit,
    YHAF_GunHit,

    /** common  */
    YHAF_Stumble,
    YHAF_Stun,
    YHAF_Poison,
    YHAF_Snare,

    /** uncommon */
    YHAF_Knockdown,
    YHAF_Freeze,
    YHAF_Microwave,
    YHAF_Bleed,

    YHAF_Custom1,
    YHAF_Custom2,
    YHAF_Custom3,

    /** Dummy entry to avoid AF_MAX native collision */
    YHEAfflictionType_Blank,

    /* YeeHaws */
    YHAF_Bobblehead,
    YHAF_Sensitive,
    YHAF_Overdose,
    YHAF_Pharmed,
    YHAF_ZedWhisperer,
    YHAF_SmellsLikeRoses,
    YHAF_YourMineMine

};

function EAfflictionType ConvertAfflictionEnum(EYHAfflictionType EYHAT)
{
    switch (EYHAT)
    {

        case YHAF_EMP: return AF_EMP;
        case YHAF_FirePanic: return AF_FirePanic;
        case YHAF_MeleeHit: return AF_MeleeHit;
        case YHAF_GunHit: return AF_GunHit;
        case YHAF_Stumble: return AF_Stumble;
        case YHAF_Stun: return AF_Stun;
        case YHAF_Poison: return AF_Poison;
        case YHAF_Snare: return AF_Snare;
        case YHAF_Knockdown: return AF_Knockdown;
        case YHAF_Freeze: return AF_Freeze;
        case YHAF_Microwave: return AF_Microwave;
        case YHAF_Bleed: return AF_Bleed;
        case YHAF_Custom1: return AF_Custom1;
        case YHAF_Custom2: return AF_Custom2;
        case YHAF_Custom3: return AF_Custom3;
        case YHEAfflictionType_Blank: return EAfflictionType_Blank;
        case YHAF_Bobblehead: return AF_Custom1;
        case YHAF_Overdose: return AF_Custom1;
        case YHAF_Sensitive: return AF_Custom1;
        case YHAF_Pharmed: return AF_Custom1;
        case YHAF_ZedWhisperer: return AF_Custom1;
        case YHAF_SmellsLikeRoses: return AF_Custom1;
        case YHAF_YourMineMine: return AF_Custom1;
    }
    return EAfflictionType_Blank;
}

/**
 * Adds StackedPower
 * @return true if the affliction effect should be applied
 */
function YHAccrueAffliction(Controller DamageInstigator, EYHAfflictionType Type, float InPower, optional EHitZoneBodyPart BodyPart)
{
    local YHAfflictionBase YHAffliction;

    `yhLog("InPower"@InPower@"Type"@Type@"IncapSettings.Length"@IncapSettings.Length@"DamageInstigator"@DamageInstigator);
    if ( InPower <= 0 || Type >= IncapSettings.Length )
    {
        `yhLog("Immune");
        return; // immune
    }

    if ( !YHVerifyAfflictionInstance(Type) )
    {
        `yhLog("Cannot create instance");
        return; // cannot create instance
    }

    // for radius damage apply falloff using most recent HitFxInfo
    if ( HitFxInfo.bRadialDamage && HitFxRadialInfo.RadiusDamageScale != 255 )
    {
        InPower *= ByteToFloat(HitFxRadialInfo.RadiusDamageScale);
        `yhLog(Type@"Applied damage falloff modifier of"@ByteToFloat(HitFxRadialInfo.RadiusDamageScale));
    }

    // scale by character vulnerability
    if ( IncapSettings[Type].Vulnerability.Length > 0 )
    {
        InPower *= YHGetAfflictionVulnerability(Type, BodyPart);
        // `yhLog(Type@"Applied hit zone vulnerability modifier of"@GetAfflictionVulnerability(Type, BodyPart)@"for"@BodyPart);
    }

    // allow owning pawn final adjustment
    YHPawn_Monster_Interface(Outer).MyAdjustAffliction(InPower,Type);

    if ( InPower > 0 )
    {
        `yhLog("Accrueing Affliction"@Afflictions[Type]@"With Power:"@InPower);
        YHAffliction = YHAfflictionBase(Afflictions[Type]);
        if ( YHAffliction != None )
        {
            YHAffliction.YHAccrue(InPower,DamageInstigator);
        }
        else
        {
            Afflictions[Type].Accrue(InPower);
        }
    }
}


/** Returns an index into the vulnerabilities array based on what part of the body was hit */
simulated function float YHGetAfflictionVulnerability(EYHAfflictionType i, EHitZoneBodyPart BodyPart)
{
    local EAfflictionVulnerabilityType j;

    switch(BodyPart)
    {
        case BP_Head:
            j = AV_Head;
            break;
        case BP_LeftArm:
        case BP_RightArm:
            j = AV_Arms;
            break;
        case BP_LeftLeg:
        case BP_RightLeg:
            j = AV_Legs;
            break;
        case BP_Special:
            j = AV_Special;
            break;
    }

    if ( j > AV_Default && j < IncapSettings[i].Vulnerability.Length )
    {
        return IncapSettings[i].Vulnerability[j];
    }

    return IncapSettings[i].Vulnerability[AV_Default];
}

/** Called whenever we need may need to initiatize the affliction class instance */
simulated function bool YHVerifyAfflictionInstance(EYHAfflictionType Type)
{
    if( Type >= Afflictions.Length || Afflictions[Type] == None )
    {
        if( Type < AfflictionClasses.Length && AfflictionClasses[Type] != None )
        {
            Afflictions[Type] = new(Outer) AfflictionClasses[Type];

            // Cache a reference to the owner to avoid passing parameters around.
            if ( Type > YHEAfflictionType_Blank )
            {
                YHAfflictionBase(Afflictions[Type]).YHInit(Outer, Type);
            }
            else
            {
                Afflictions[Type].Init(Outer,ConvertAfflictionEnum(Type));
            }

        }
        else
        {
            `log(GetFuncName() @ "Failed with afflication:" @ Type @ "class:" @ AfflictionClasses[Type] @ Self);
            Afflictions[Type] = None;
            return FALSE;
        }
    }

    return true;
}


/** Check, and if needed activate afflictions after being hit (Server only) */
function NotifyTakeHit(Controller DamageInstigator, vector HitDir, class<KFDamageType> DamageType, Actor DamageCauser)
{
    local KFPerk InstigatorPerk;

    if( DamageType == none )
    {
        return;
    }

    // Allow damage instigator perk to modify reaction
    if ( DamageInstigator != None && DamageInstigator.bIsPlayer )
    {
        InstigatorPerk = KFPlayerController(DamageInstigator).GetPerk();
    }

    // For now all below effects are for Zeds
    if( GetTeamNum() > 254 && !bPlayedDeath )
    {
        YHProcessSpecialMoveAfflictions(DamageInstigator, InstigatorPerk, HitDir, DamageType, DamageCauser);
        ProcessHitReactionAfflictions(InstigatorPerk, DamageType);
    }

    ProcessEffectBasedAfflictions(InstigatorPerk, DamageType);
}

protected function YHProcessSpecialMoveAfflictions(Controller DamageInstigator, KFPerk InstigatorPerk, vector HitDir, class<KFDamageType> DamageType, Actor DamageCauser)
{
    local EHitZoneBodyPart BodyPart;
    local byte HitZoneIdx;
    local float KnockdownPower, StumblePower, StunPower, SnarePower, SensitivePower;
    local float BobbleheadPower, PharmPower, OverdosePower, YourMineMinePower;
    local float SmellsLikeRosesPower, ZedWhispererPower;
    local float KnockdownModifier, StumbleModifier, StunModifier;
    local KFInterface_DamageCauser KFDmgCauser;

    local float BobbleheadModifier, PharmModifier, OverdoseModifier, YourMineMineModifier;
    local float SmellsLikeRosesModifier, SensitiveModifier, ZedWhispererModifier;

    local class<YHDamageType> DT;
    local YHPerk_Interface YHInstigatorPerk;

    `yhLog("ProcessSpecialMoveAfflictions"@InstigatorPerk@"DT"@DamageType);

    // This is for damage over time, DoT shall never have momentum
    if( IsZero( HitDir ) )
    {
        return;
    }

    HitZoneIdx = HitFxInfo.HitBoneIndex;
    BodyPart = (HitZoneIdx != 255) ? HitZones[HitZoneIdx].Limb : BP_Torso;

    // Grab defaults for perk ability scaling
    KnockdownPower = DamageType.default.KnockdownPower;
    StumblePower = DamageType.default.StumblePower;
    StunPower = DamageType.default.StunPower;
    SnarePower = DamageType.default.SnarePower;

    KFDmgCauser = KFInterface_DamageCauser(DamageCauser);
    if (KFDmgCauser != None)
    {
        KnockdownPower *= KFDmgCauser.GetIncapMod();
        StumblePower *= KFDmgCauser.GetIncapMod();
        StunPower *= KFDmgCauser.GetIncapMod();
        SnarePower *= KFDmgCauser.GetIncapMod();
    }

    KnockdownModifier = 1.f;
    StumbleModifier = 1.f;
    StunModifier = 1.f;

    // Allow for known afflictions to adjust reaction
    KnockdownModifier += GetAfflictionKnockdownModifier();
    StumbleModifier += GetAfflictionStumbleModifier();
    StunModifier += GetAfflictionStunModifier();

	// Allow damage instigator perk to modify reaction
    if ( InstigatorPerk != None )
    {
        KnockdownModifier += InstigatorPerk.GetKnockdownPowerModifier( DamageType, BodyPart, bIsSprinting );
        StumbleModifier += InstigatorPerk.GetStumblePowerModifier( Outer, DamageType,, BodyPart );
        StunModifier += InstigatorPerk.GetStunPowerModifier( DamageType, HitZoneIdx );

        //Snare power doesn't scale DT, it exists on its own (Ex: Gunslinger Skullcracker)
        SnarePower += InstigatorPerk.GetSnarePowerModifier( DamageType, HitZoneIdx );
    }

    KnockdownPower *= KnockdownModifier;
    StumblePower *= StumbleModifier;
    StunPower *= StunModifier;

    // increment affliction power
    if ( KnockdownPower > 0 && CanDoSpecialmove(SM_Knockdown) )
    {
        AccrueAffliction(AF_Knockdown, KnockdownPower, BodyPart);
    }
    if ( StunPower > 0 && CanDoSpecialmove(SM_Stunned) )
    {
        AccrueAffliction(AF_Stun, StunPower, BodyPart);
    }
    if ( StumblePower > 0 && CanDoSpecialmove(SM_Stumble) )
    {
        AccrueAffliction(AF_Stumble, StumblePower, BodyPart);
    }
    if ( DamageType.default.FreezePower > 0 && CanDoSpecialMove(SM_Frozen) )
    {
        AccrueAffliction(AF_Freeze, DamageType.default.FreezePower, BodyPart);
    }
    if( SnarePower > 0 )
    {
        AccrueAffliction(AF_Snare, SnarePower, BodyPart);
    }

    DT = class<YHDamageType>(DamageType);
    if ( DT != None )
    {
        BobbleheadPower = DT.default.BobbleheadPower;
        PharmPower = DT.default.PharmPower;
        OverdosePower = DT.default.OverdosePower;
        YourMineMinePower = DT.default.YourMineMinePower;
        SmellsLikeRosesPower = DT.default.SmellsLikeRosesPower;
        SensitivePower = DT.default.SensitivePower;
        ZedWhispererPower = DT.default.ZedWhispererPower;
     }
    else
    {
        BobbleheadPower = 0;
        PharmPower = 0;
        OverdosePower = 0;
        YourMineMinePower = 0;
        SmellsLikeRosesPower = 0;
        SensitivePower = 0;
        ZedWhispererPower = 0;
    }

    BobbleheadModifier = 0;
    PharmModifier = 0;
    OverdoseModifier = 0;
    YourMineMineModifier = 0;
    SmellsLikeRosesModifier = 0;
    SensitiveModifier = 0;
    ZedWhispererModifier = 0;

    YHInstigatorPerk = YHPerk_Interface(InstigatorPerk);
    if ( DT == None || YHInstigatorPerk == None )
    {
        BobbleheadModifier = 0.f;
        PharmModifier = 0.f;
        OverdoseModifier = 0.f;
        YourMineMineModifier = 0.f;
        SmellsLikeRosesModifier = 0.f;
    }
    else
    {
        BobbleheadModifier = YHInstigatorPerk.GetBobbleheadPowerModifier( DT, HitZoneIdx );
        PharmModifier = YHInstigatorPerk.GetPharmPowerModifier( DT, HitZoneIdx );
        OverdoseModifier = YHInstigatorPerk.GetOverdosePowerModifier( DT, HitZoneIdx );
        YourMineMineModifier = YHInstigatorPerk.GetYourMineMinePowerModifier( DT, HitZoneIdx );
        SmellsLikeRosesModifier = YHInstigatorPerk.GetSmellsLikeRosesPowerModifier( DT, HitZoneIdx );
        SensitiveModifier = YHInstigatorPerk.GetSensitivePowerModifier( DT, HitZoneIdx );
        ZedWhispererModifier = YHInstigatorPerk.GetZedWhispererPowerModifier( DT, HitZoneIdx );

    }

    BobbleheadPower *= BobbleheadModifier;
    PharmPower *= PharmModifier;
    OverdosePower *= OverdoseModifier;
    YourMineMinePower *= YourMineMineModifier;
    SmellsLikeRosesPower *= SmellsLikeRosesModifier;
    SensitivePower *= SensitiveModifier;
    ZedWhispererPower *= ZedWhispererModifier;

    // increment affliction power
    if ( BobbleheadPower > 0 )
    {
        YHAccrueAffliction(DamageInstigator, YHAF_Bobblehead, BobbleheadPower, BodyPart);
    }
    if ( PharmPower > 0 )
    {
        YHAccrueAffliction(DamageInstigator, YHAF_Pharmed, PharmPower, BodyPart);
    }
    if ( OverdosePower > 0 )
    {
        YHAccrueAffliction(DamageInstigator, YHAF_Overdose, OverdosePower, BodyPart);
    }
    if ( YourMineMinePower > 0 )
    {
        YHAccrueAffliction(DamageInstigator, YHAF_YourMineMine, YourMineMinePower, BodyPart);
    }
    if ( SmellsLikeRosesPower > 0 )
    {
        YHAccrueAffliction(DamageInstigator, YHAF_SmellsLikeRoses, SmellsLikeRosesPower, BodyPart);
    }
    if ( SensitivePower > 0 )
    {
        YHAccrueAffliction(DamageInstigator, YHAF_Sensitive, SensitivePower, BodyPart);
    }
    if ( ZedWhispererPower > 0 )
    {
        YHAccrueAffliction(DamageInstigator, YHAF_ZedWhisperer, ZedWhispererPower, BodyPart);
    }
}

/** Effect based afflictions can apply even on dead bodies */
protected function ProcessEffectBasedAfflictions(KFPerk InstigatorPerk, class<KFDamageType> DamageType)
{
    // local class<YHDamageType> DT;

    // these afflictions can apply on killing blow, but fire can apply after death
    if ( bPlayedDeath && WorldInfo.TimeSeconds > TimeOfDeath )
    {
        // If we're already dead, go ahead and apply burn stacking power, just
        // so we can do the burn effects
        if ( DamageType.default.BurnPower > 0 )
        {
            AccrueAffliction(AF_FirePanic, DamageType.default.BurnPower);
        }
        return;
    }

    if ( DamageType.default.EMPPower > 0 )
    {
        AccrueAffliction(AF_EMP, DamageType.default.EMPPower);
    }
    else if( InstigatorPerk != none && InstigatorPerk.ShouldGetDaZeD( DamageType ) )
    {
        AccrueAffliction(AF_EMP, InstigatorPerk.GetDaZedEMPPower() );
    }
    if ( DamageType.default.BurnPower > 0 )
    {
        AccrueAffliction(AF_FirePanic, DamageType.default.BurnPower);
    }
    if ( DamageType.default.PoisonPower > 0 && DamageType.static.AlwaysPoisons() )
    {
        AccrueAffliction(AF_Poison, DamageType.default.PoisonPower);
    }
    if ( DamageType.default.MicrowavePower > 0 )
    {
        AccrueAffliction(AF_Microwave, DamageType.default.MicrowavePower);
    }
    if (DamageType.default.BleedPower > 0)
    {
        AccrueAffliction(AF_Bleed, DamageType.default.BleedPower);
    }

    // Now for our custom damage types
    // DT = class<YHDamageType>(DamageType);

}


defaultproperties
{
    AfflictionClasses(YHAF_Bobblehead)=class'YHAffliction_Bobblehead'
    AfflictionClasses(YHAF_Overdose)=class'YHAffliction_Overdose'
    AfflictionClasses(YHAF_Pharmed)=class'YHAffliction_Pharmed'
    AfflictionClasses(YHAF_SmellsLikeRoses)=class'YHAffliction_SmellsLikeRoses'
    AfflictionClasses(YHAF_YourMineMine)=class'YHAffliction_YourMineMine'

    AfflictionClasses(YHAF_Sensitive)=class'YHAffliction_Sensitive'
    AfflictionClasses(YHAF_ZedWhisperer)=class'YHAffliction_ZedWhispered'
}

