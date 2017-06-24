class YHGFxMenu_Trader extends KFGfxMenu_Trader;

defaultproperties
{
    SubWidgetBindings.Remove((WidgetName="shopContainer",WidgetClass=class'KFGFxTraderContainer_Store'))
    SubWidgetBindings.Add((WidgetName="shopContainer",WidgetClass=class'YHGFxTraderContainer_Store'))
}

