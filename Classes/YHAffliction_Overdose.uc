class YHAffliction_Overdose extends YHAfflictionBase;

function Activate()
{
    Super.Activate();
    YHPawn_Monster_Interface(MonsterOwner).SetOverdosed(True);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetOverdosed(False);
}

