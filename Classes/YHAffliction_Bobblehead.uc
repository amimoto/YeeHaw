class YHAffliction_Bobblehead extends YHAfflictionBase;

`include(YH_Log.uci)

function Activate()
{
    Super.Activate();
    YHPawn_Monster_Interface(MonsterOwner).SetBobbleheaded(True);
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetBobbleheaded(False);
}

