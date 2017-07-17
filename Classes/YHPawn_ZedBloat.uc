class YHPawn_ZedBloat extends KFPawn_ZedBloat;

`include(YH_Log.uci)

event TakeDamage(int Damage,
                 Controller InstigatedBy,
                 vector HitLocation,
                 vector Momentum,
                 class<DamageType> DamageType,
                 optional TraceHitInfo HitInfo,
                 optional Actor DamageCauser)
{
    local int HitZoneIdx;
    local KFPlayerController InstigatorKFPC;
    local KFPerk InstigatorPerk;


    `yhLog("Took Damage:"@Damage@"Instigated By"@InstigatedBy@"Damage Type"@DamageType);

    // Damage is actually reduced in KFPawn.TakeDamage
    // we're just going to apply the toxicity affliction after the fact

    // When it's the medic dart, it's DamageType = YH_Dart_Scientist
    super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

    // Do nothing if dead
    if ( DamageType != class'YHDT_Dart_Scientist' || Health <= 0 )
    {
        return;
    }

    InstigatorKFPC = KFPlayerController(InstigatedBy);
    if ( InstigatorKFPC == None ) return;

    InstigatorPerk = InstigatorKFPC.GetPerk();

    HitZoneIdx = HitZones.Find('ZoneName', HitInfo.BoneName);
    if ( HitZoneIdx == HZI_HEAD )
    {
        SetHeadScale(1.5,CurrentHeadScale);
        `yhLog("DOOT by"@InstigatorPerk);
    }
    else
    {
        `yhLog("SMHA by"@InstigatorPerk);
    }

}
