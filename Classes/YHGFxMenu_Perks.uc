class YHGFxMenu_Perks extends KFGFxMenu_Perks;

defaultproperties
{
    SubWidgetBindings.Remove((WidgetName="SkillsContainer",WidgetClass=class'KFGFxPerksContainer_Skills'))
    SubWidgetBindings.Add((WidgetName="SkillsContainer",WidgetClass=class'YHGFxPerksContainer_Skills'))
    SubWidgetBindings.Remove((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'KFGFxPerksContainer_SkillsSummary'))
    SubWidgetBindings.Add((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'YHGFxPerksContainer_SkillsSummary'))
}

