class YHGFxMoviePlayer_Manager extends KFGfxMoviePlayer_Manager;

defaultproperties
{
    WidgetBindings.Remove((WidgetName="PerksMenu",WidgetClass=class'KFGFxMenu_Perks'))
    WidgetBindings.Add((WidgetName="PerksMenu",WidgetClass=class'YHGFxMenu_Perks'))
}
