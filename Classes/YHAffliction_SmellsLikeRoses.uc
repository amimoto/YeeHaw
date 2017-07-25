class YHAffliction_SmellsLikeRoses extends YHAfflictionBase;

function Activate()
{
    Super.Activate();
    YHPawn_Monster_Interface(MonsterOwner).SetSmellsLikeRoses(True);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetSmellsLikeRoses(False);
}

defaultproperties
{
    DissipationRate=10
    bNeedsTick=True
}



