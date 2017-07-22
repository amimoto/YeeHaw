class YHPawn_ZedFleshpoundKing extends KFPawn_ZedFleshpoundKing
    implements(YHPawn_Monster_Interface)
    ;

`include(YH_Log.uci)

var repnotify bool bPharmed;
var repnotify bool bOverdosed;
var repnotify bool bYourMineMined;
var repnotify bool bSmellsLikeRoses;
var repnotify bool bTypicalRedditor;

replication
{
    if (bNetDirty)
        bPharmed, bOverdosed, bYourMineMined, bSmellsLikeRoses, bTypicalRedditor;
}

simulated function ApplyDartAfflictions(int Damage,
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
    local YHPerk_Interface InstigatorPerkInterface;

    // Ensure it's a player that instigated
    InstigatorKFPC = KFPlayerController(InstigatedBy);
    if ( InstigatorKFPC == None ) return;

    // And that it's the scientist that caused it
    InstigatorPerk = InstigatorKFPC.GetPerk();
    InstigatorPerkInterface = YHPerk_Interface(InstigatorPerk);
    if ( InstigatorPerkInterface == None ) return;

    // What did they dart?
    HitZoneIdx = HitZones.Find('ZoneName', HitInfo.BoneName);
    if ( HitZoneIdx == HZI_HEAD )
    {
        InstigatorPerkInterface.ApplyDartHeadshotAfflictions(
            InstigatorKFPC,
            HitZoneIdx,
            self
        );
    }
    else
    {
        InstigatorPerkInterface.ApplyDartBodyshotAfflictions(
            InstigatorKFPC,
            HitZoneIdx,
            self
        );
    }

}

event TakeDamage(int Damage,
                 Controller InstigatedBy,
                 vector HitLocation,
                 vector Momentum,
                 class<DamageType> DamageType,
                 optional TraceHitInfo HitInfo,
                 optional Actor DamageCauser)
{

    `yhLog("Took Damage:"@Damage@"Instigated By"@InstigatedBy@"Damage Type"@DamageType);

    // Damage is actually reduced in KFPawn.TakeDamage
    // we're just going to apply the toxicity affliction after the fact

    // When it's the medic dart, it's DamageType = YH_Dart_Scientist
    super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

    // Apply dart afflictions if required
    if ( DamageType == class'YHDT_Dart_Scientist' && Health > 0 )
    {
        ApplyDartAfflictions(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
    }
}

defaultproperties
{

    // ---------------------------------------------
    // Afflictions
    Begin Object Class=YHAfflictionManager Name=Afflictions_1
        FireFullyCharredDuration=2.5
        FireCharPercentThreshhold=0.25
    End Object
    AfflictionHandler=Afflictions_1

}



