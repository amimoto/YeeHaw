class YHAffliction_Sensitive extends YHAfflictionBase;

`include(YH_Log.uci)

function Activate()
{
    Super.Activate();
    `yhLog("Activating Sensitive on"@MonsterOwner);
    YHPawn_Monster_Interface(MonsterOwner).SetSensitive(True);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetSensitive(False);
}

defaultproperties
{
    DissipationRate=10
    bNeedsTick=True
}


