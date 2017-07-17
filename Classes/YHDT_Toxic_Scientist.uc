class YHDT_Toxic_Scientist extends KFDT_Toxic
    abstract;

`include(KFGameDialog.uci)

static function bool AlwaysPoisons()
{
    return true;
}

defaultproperties
{
    KDamageImpulse=0

    DoT_Type=DOT_Toxic
    DoT_Duration=5.0
    DoT_Interval=1.0 //1.0
    DoT_DamageScale=0.15 //0.1

    PoisonPower=200 //33
}

