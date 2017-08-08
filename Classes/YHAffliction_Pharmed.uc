class YHAffliction_Pharmed extends YHAfflictionBase;

`include(YH_Log.uci)

function Activate()
{
    Super.Activate();
    `yhLog("Activating Pharmed on"@MonsterOwner);
    YHPawn_Monster_Interface(MonsterOwner).SetPharmed(True,CachedInstigator);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetPharmed(False,None);
}

defaultproperties
{
    DissipationRate=10
    bNeedsTick=True
}


