class YHAffliction_ZedWhispered extends YHAfflictionBase;

`include(YH_Log.uci)

function Activate()
{
    Super.Activate();
    `yhLog("Activating ZedWhispered on"@MonsterOwner);
    YHPawn_Monster_Interface(MonsterOwner).SetZedWhispered(True);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetZedWhispered(False);
}

defaultproperties
{
    DissipationRate=10
    bNeedsTick=True
}



