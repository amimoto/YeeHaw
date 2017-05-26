class YHGFxMoviePlayer_HUD extends KFGFxMoviePlayer_HUD;

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    switch(WidgetName)
    {

    // In YeeHaw, trader is meaningless
    case 'CompassContainer':
        if ( TraderCompassWidget == none )
        {
            TraderCompassWidget = KFGFxHUD_TraderCompass(Widget);
            TraderCompassWidget.InitializeHUD();
            SetWidgetPathBinding( Widget, WidgetPath );
            TraderCompassWidget.SetVisible(false);
        }
        return true;
    }

    return Super.WidgetInitialized(WidgetName,WidgetPath,Widget);
}

