class YHGFxMoviePlayer_ScoreBoard extends KFGFxMoviePlayer_ScoreBoard;

defaultproperties
{
    WidgetBindings.Remove((WidgetName="ScoreboardWidgetMC",WidgetClass=class'KFGFxHUD_ScoreboardWidget'))
    WidgetBindings.Add((WidgetName="ScoreboardWidgetMC",WidgetClass=class'YHGFxHUD_ScoreboardWidget'))
}

