class YHGFxMoviePlayer_HUD extends KFGFxMoviePlayer_HUD;

defaultproperties
{
    ScoreBoardClass=class'YHGFxMoviePlayer_ScoreBoard'

    WidgetBindings.Remove((WidgetName="SpectatorInfoWidget",WidgetClass=class'KFGFxHUD_SpectatorInfo'))
    WidgetBindings.Add((WidgetName="SpectatorInfoWidget",WidgetClass=class'YHGFxHUD_SpectatorInfo'))
}

