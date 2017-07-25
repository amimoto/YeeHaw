class YHDT_Dart_Scientist extends YHDamageType
    abstract
    hidedropdown;

`include(KFGameDialog.uci)

/** Returns ID of dialog event for killer to speak after killing a zed using this damage type */
static function int GetKillerDialogID()
{
    return `KILL_Toxic;
}

/** Returns ID of dialog event for damager to speak after damaging a zed using this damage type */
static function int GetDamagerDialogID()
{
    return `DAMZ_Toxic;
}

/** Returns ID of dialog event for damagee to speak after getting damaged by a zed using this damage type */
static function int GetDamageeDialogID()
{
    return `DAMP_Toxic;
}

defaultproperties
{
    KDamageImpulse=0

    ScreenMaterialName=Effect_Puke
    CameraLensEffectTemplate=class'KFCameraLensEmit_Puke'
    AltCameraLensEffectTemplate=class'KFCameraLensEmit_Puke_Light'

    EffectGroup=FXG_Toxic

    DoT_Type=DOT_Toxic
    DoT_Duration=10.0
    DoT_Interval=1.0
    DoT_DamageScale=0.1

    PoisonPower=33.f
    BobbleheadPower=100.f
    PharmPower=100.f
    SnarePower=100.f
    OverdosePower=100.f
    YourMineMinePower=100.f
    SmellsLikeRosesPower=100.f

    WeaponDef=class'KFWeapDef_Healer'
}



