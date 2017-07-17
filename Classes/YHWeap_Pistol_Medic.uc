class YHWeap_Pistol_Medic extends KFWeap_Pistol_Medic;

`include(YH_Log.uci)

// Disable Lock-on
function bool AllowTargetLockOn()
{
    // `yhLog("AllowTargetLockOn Instigator"@Instigator);
    // Instigator = KF_Human_Pawn0
    return false;
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

    HealTarget = KFPawn(Impact.HitActor);
    Healer = KFPlayerController(Instigator.Controller);

    `yhLog("ProcessInstantHitEx"@FiringMode);

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

        HealTarget.HealDamage(HealAmount, Instigator.Controller, HealingDartDamageType);

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

    AssociatedPerkClasses.Add(class'YHCPerk_Scientist')
}