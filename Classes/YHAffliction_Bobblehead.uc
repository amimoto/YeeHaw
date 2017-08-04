class YHAffliction_Bobblehead extends YHAfflictionBase;

`include(YH_Log.uci)

var float GrowthTime;
var float ShrinkTime;
var float HeadScaleTime;
var float HeadMaxScale;

function Activate()
{
    Super.Activate();
    YHPawn_Monster_Interface(MonsterOwner).SetBobbleheaded(True);
    GrowthTime = HeadScaleTime;
}

function DeActivate()
{
    Super.DeActivate();
    YHPawn_Monster_Interface(MonsterOwner).SetBobbleheaded(False);
    ShrinkTime = HeadScaleTime;
}

function float MyLerp( float a, float b, float alpha )
{
    local float delta;
    delta = b-a;
    return a+delta*alpha;
}

event Tick(float DeltaTime)
{
/*
    if ( GrowthTime > 0 )
    {
        GrowthTime -= DeltaTime;
        if ( GrowthTime < 0 ) GrowthTime = 0;
        `yhLog("HeadScale:"@MonsterOwner.CurrentHeadScale@"Alpha:"@(HeadScaleTime-GrowthTime)/HeadScaleTime);
        MonsterOwner.IntendedHeadScale = MyLerp(1,HeadMaxScale,(HeadScaleTime-GrowthTime)/HeadScaleTime);
        `yhLog("IntendedHeadScale"@MonsterOwner.IntendedHeadScale);
        MonsterOwner.SetHeadScale(MonsterOwner.IntendedHeadScale,MonsterOwner.CurrentHeadScale);
    }
    else if ( ShrinkTime > 0 && !MonsterOwner.bIsHeadless )
    {
        ShrinkTime -= DeltaTime;
        if ( ShrinkTime < 0 ) ShrinkTime = 0;
        MonsterOwner.IntendedHeadScale = MyLerp(1,HeadMaxScale,ShrinkTime/HeadScaleTime);
        MonsterOwner.SetHeadScale(MonsterOwner.IntendedHeadScale,MonsterOwner.CurrentHeadScale);
    }
    */
    super.Tick(DeltaTime);
}

defaultproperties
{
    GrowthTime=0
    ShrinkTime=0
    HeadMaxScale=2.0
    HeadScaleTime=0.5
}

