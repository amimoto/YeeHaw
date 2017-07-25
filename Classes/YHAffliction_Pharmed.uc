class YHAffliction_Pharmed extends YHAfflictionBase;

`include(YH_Log.uci)

function Activate()
{
    Super.Activate();
    `yhLog("Activating Pharmed on"@MonsterOwner);
    YHPawn_Monster_Interface(MonsterOwner).SetPharmed(True);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetPharmed(False);
}

defaultproperties
{
    DissipationRate=10
    bNeedsTick=True
}


