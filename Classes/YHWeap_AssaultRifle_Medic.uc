class YHWeap_AssaultRifle_Medic extends KFWeap_AssaultRifle_Medic;

var int NoPainNoGainDamage;

`include(YH_Log.uci)

// Disable Lock-on
function bool AllowTargetLockOn()
{
    local KFPerk InstigatorPerk;
    InstigatorPerk = GetPerk();

    // Disable homing for Horzine Scientist
    if ( InstigatorPerk != none && YHCPerk_Scientist(InstigatorPerk) != none )
    {
        return False;
    }

    // `yhLog("AllowTargetLockOn Instigator"@Instigator);
    // Instigator = KF_Human_Pawn0
    return super.AllowTargetLockOn();
}

/**
 * See Pawn.ProcessInstantHit
 * @param DamageReduction: Custom KF parameter to handle penetration damage reduction
 */
simulated function ProcessInstantHitEx( byte FiringMode, ImpactInfo Impact, optional int NumHits, optional out float out_PenetrationVal, optional int ImpactNum )
{
    local KFPawn HealTarget;
    local KFPlayerController Healer;
    local KFPerk InstigatorPerk;
    local int HitZoneIdx;

    local YHPerk_Interface YHPI;
    local YHPawn_Human Human_HealTarget;


    HealTarget = KFPawn(Impact.HitActor);
    Healer = KFPlayerController(Instigator.Controller);

    `yhLog("ProcessInstantHitEx"@FiringMode@"Hit:"@HealTarget@"Actor:"@Impact.HitActor@"HIT:"@Impact.HitInfo.BoneName);
    `yhScriptTrace();

    InstigatorPerk = GetPerk();
    if( InstigatorPerk != none )
    {
        InstigatorPerk.UpdatePerkHeadShots( Impact, InstantHitDamageTypes[FiringMode], ImpactNum );
    }

    if (FiringMode == ALTFIRE_FIREMODE && HealTarget != none && WorldInfo.GRI.OnSameTeam(Instigator,HealTarget) )
    {
        // Let the accuracy system know that we hit someone
        if( Healer != none )
        {
            Healer.AddShotsHit(1);
        }

        // Figure if we need to deal with NoPainNoGain
        YHPI = YHPerk_Interface(InstigatorPerk);
        Human_HealTarget = YHPawn_Human(HealTarget);
        if ( YHPI != none && YHPI.IsNoPainNoGainActive() && Human_HealTarget != none )
        {
            HitZoneIdx = HealTarget.HitZones.Find('ZoneName', Impact.HitInfo.BoneName);
            if ( HitZoneIdx != HZI_HEAD )
            {
                HealTarget.TakeDamage(
                    NoPainNoGainDamage,
                    Instigator.Controller,
                    Impact.HitLocation,
                    InstantHitMomentum[FiringMode] * Impact.RayDir,
                    class'YHDT_Medic_Pain',
                    Impact.HitInfo,
                    Instigator
                );
            }
            Human_HealTarget.HealDamageFast(HealAmount+NoPainNoGainDamage, Instigator.Controller, HealingDartDamageType);
        }
        else
        {
            HealTarget.HealDamage(HealAmount, Instigator.Controller, HealingDartDamageType);
        }

        // Play a healed impact sound for the healee
        if( HealImpactSoundPlayEvent != None && HealTarget != None && !bSuppressSounds  )
        {
            HealTarget.PlaySoundBase(HealImpactSoundPlayEvent, false, false,,Impact.HitLocation);
        }
    }
    else
    {
        // Play a hurt impact sound for the hurt
        if( HurtImpactSoundPlayEvent != None && HealTarget != None && !bSuppressSounds  )
        {
            HealTarget.PlaySoundBase(HurtImpactSoundPlayEvent, false, false,,Impact.HitLocation);
        }
        Super.ProcessInstantHitEx(FiringMode, Impact, NumHits, out_PenetrationVal);
    }
}

defaultproperties
{
    WeaponProjectiles(ALTFIRE_FIREMODE)=class'YHProj_ScientistDart'

    InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'YHDT_Dart_Scientist'

    AssociatedPerkClasses.Add(class'YeeHaw.YHCPerk_Scientist')

    NoPainNoGainDamage = 15
}