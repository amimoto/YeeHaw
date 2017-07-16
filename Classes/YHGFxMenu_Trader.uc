class YHGFxMenu_Trader extends KFGfxMenu_Trader;

defaultproperties
{
    SubWidgetBindings.Remove((WidgetName="shopContainer",WidgetClass=class'KFGFxTraderContainer_Store'))
    SubWidgetBindings.Add((WidgetName="shopContainer",WidgetClass=class'YHGFxTraderContainer_Store'))
    SubWidgetBindings.Remove((WidgetName="filterContainer",WidgetClass=class'KFGFxTraderContainer_Filter'))
    SubWidgetBindings.Add((WidgetName="filterContainer",WidgetClass=class'YHGFxTraderContainer_Filter'))
    SubWidgetBindings.Remove((WidgetName="playerInfoContainer",WidgetClass=class'KFGFxTraderContainer_PlayerInfo'))
    SubWidgetBindings.Add((WidgetName="playerInfoContainer",WidgetClass=class'YHGFxTraderContainer_PlayerInfo'))
}

