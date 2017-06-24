class YH_Survival extends CD_Survival;

function RestartPlayer(Controller NewPlayer)
{
    local YHPlayerController YHPC;

    `log("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS CALLED:"@GetFuncName());ScriptTrace();

    YHPC = YHPlayerController(NewPlayer);
    if( YHPC != none && YHPC.GetTeamNum() != 255 )
    {
        `log("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR ReapplyingSkills!");
        YHPC.ReapplySkills();
    }

    super.RestartPlayer(NewPlayer);

    if( YHPC != none && YHPC.GetTeamNum() != 255 )
    {
        `log("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR ReapplyingDefaults!");
        YHPC.ReapplyDefaults();
    }


}

/*
State TraderOpen
{
    function BeginState( Name PreviousStateName )
    {
        local YHPlayerController YHPC;

        super.BeginState(PreviousStateName);

        // Reapply the skills for the player
        ForEach WorldInfo.AllControllers(class'YHPlayerController', YHPC)
        {
            YHPC.ReapplySkills();
        }

    }
}
*/

function StartHumans()
{
    `log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! StartHumans");
    ScriptTrace();
    super.StartHumans();
}

defaultproperties
{

    HUDType=class'YHGFxHudWrapper'

    GameReplicationInfoClass = class'YHGameReplicationInfo'
    PlayerControllerClass=class'YHPlayerController'
    KFGFxManagerClass=class'YHGFxMoviePlayer_Manager'
}
