class YHPawn_ZedHuskFriendlyTest extends KFPawn_ZedHuskFriendlyTest;

`include(YH_Log.uci)

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    `yhLog("Took Damage:"@Damage@"Instigated By"@InstigatedBy);
    super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}
