class YHDT_Medic_Pain extends KFDamageType
    abstract;

`include(KFGameDialog.uci)

/** Returns ID of dialog event for damagee to speak after getting damaged by a zed using this damage type */
static function int GetDamageeDialogID()
{
    return `DAMP_Toxic;
}

defaultproperties
{
    bShouldSpawnBloodSplat=true
    bShouldSpawnPersistentBlood=true
    BodyWoundDecalMaterials[0]=MaterialInstanceConstant'FX_Gore_MAT.FX_CH_Wound_01_Mic'

    bArmorStops=false
    EffectGroup=FXG_Ballistic

    // This will cause unnecessary hatred ;)
    //ScreenMaterialName=Effect_Poison
}

