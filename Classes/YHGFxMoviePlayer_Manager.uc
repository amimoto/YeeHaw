class YHGFxMoviePlayer_Manager extends KFGfxMoviePlayer_Manager;

function Init(optional LocalPlayer LocPlay)
{
    local YHPlayerController YHPC;
    local class<KFPerk> MyPerkClass;
    local int PerkBuild;
    local byte SelectedSkillsHolder[`MAX_PERK_SKILLS];

    `log("###################################################################################### Init");

    super.Init(LocPlay);
}

function OnProfileSettingsRead()
{
    `log("###################################################################################### OnProfileSettingsRead");
    super.OnProfileSettingsRead();
}

function OpenMenu( byte NewMenuIndex, optional bool bShowWidgets = true )
{
    super.OpenMenu(NewMenuIndex, bShowWidgets);
}

function LaunchMenus( optional bool bForceSkipLobby )
{

    `log("###################################################################################### LaunchMenus");
    super.LaunchMenus(bForceSkipLobby);
}

function OnMenuOpen( name WidgetPath, KFGFxObject_Menu Widget )
{
    super.OnMenuOpen(WidgetPath,Widget);
    `log("###################################################################################### OnMenuOpen");
}


/** Ties the GFxClikWidget variables to the .swf components and handles events */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    `log("###################################################################################### WidgetInitialized");
    return super.WidgetInitialized(WidgetName,WidgetPath,Widget);
}

defaultproperties
{
    WidgetBindings.Remove((WidgetName="PerksMenu",WidgetClass=class'KFGFxMenu_Perks'))
    WidgetBindings.Add((WidgetName="PerksMenu",WidgetClass=class'YHGFxMenu_Perks'))
    WidgetBindings.Remove((WidgetName="traderMenu",WidgetClass=class'KFGFxMenu_Trader'))
    WidgetBindings.Add((WidgetName="traderMenu",WidgetClass=class'YHGFxMenu_Trader'))

}
