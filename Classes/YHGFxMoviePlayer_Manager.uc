class YHGFxMoviePlayer_Manager extends KFGfxMoviePlayer_Manager;

function Init(optional LocalPlayer LocPlay)
{
    super.Init(LocPlay);
}

function OnProfileSettingsRead()
{
    super.OnProfileSettingsRead();
}

function OpenMenu( byte NewMenuIndex, optional bool bShowWidgets = true )
{
    super.OpenMenu(NewMenuIndex, bShowWidgets);
}

function LaunchMenus( optional bool bForceSkipLobby )
{
    super.LaunchMenus(bForceSkipLobby);
}

function OnMenuOpen( name WidgetPath, KFGFxObject_Menu Widget )
{
    super.OnMenuOpen(WidgetPath,Widget);
}


/** Ties the GFxClikWidget variables to the .swf components and handles events */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    return super.WidgetInitialized(WidgetName,WidgetPath,Widget);
}

defaultproperties
{
    WidgetBindings.Remove((WidgetName="PerksMenu",WidgetClass=class'KFGFxMenu_Perks'))
    WidgetBindings.Add((WidgetName="PerksMenu",WidgetClass=class'YHGFxMenu_Perks'))
    WidgetBindings.Remove((WidgetName="traderMenu",WidgetClass=class'KFGFxMenu_Trader'))
    WidgetBindings.Add((WidgetName="traderMenu",WidgetClass=class'YHGFxMenu_Trader'))

    InGamePartyWidgetClass=class'YHGFxWidget_PartyInGame'

}
