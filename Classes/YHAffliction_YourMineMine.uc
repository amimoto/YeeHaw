class YHAffliction_YourMineMine extends YHAfflictionBase;

function Activate()
{
    Super.Activate();
    YHPawn_Monster_Interface(MonsterOwner).SetYourMineMined(True,CachedInstigator);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetYourMineMined(False,None);
}

