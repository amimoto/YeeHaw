interface YHPerk_Interface;

simulated function ApplyDartHeadshotAfflictions(
                          KFPlayerController DamageInstigator,
                          byte HitZoneIdx,
                          KFPawn_Monster Monster
                      );


simulated function ApplyDartBodyshotAfflictions(
                          KFPlayerController DamageInstigator,
                          byte HitZoneIdx,
                          KFPawn_Monster Monster
                      );

function float GetBobbleheadPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx );
function float GetPharmPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx );
function float GetOverdosePowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx );
function float GetYourMineMinePowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx );
function float GetSmellsLikeRosesPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx );
function float GetExtraStrengthPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx );
function float GetSensitivePowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx );
function float GetZedWhispererPowerModifier( class<YHDamageType> DamageType, byte HitZoneIdx );

simulated function bool IsNoPainNoGainActive();

