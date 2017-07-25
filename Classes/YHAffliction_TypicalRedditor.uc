class YHAffliction_TypicalRedditor extends YHAfflictionBase;

function Activate()
{
    Super.Activate();
    YHPawn_Monster_Interface(MonsterOwner).SetTypicalRedditor(True);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetTypicalRedditor(False);
}

defaultproperties
{
    DissipationRate=10
    bNeedsTick=True
}



