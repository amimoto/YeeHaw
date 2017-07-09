class YHGFxMenu_Perks extends KFGFxMenu_Perks;

/** Saves the modified perk data */
function SavePerkData()
{
    local int NewPerkBuild;

    if( KFPC != none )
    {
        if( bModifiedSkills )
        {
            // Update our previous build
            KFPC.CurrentPerk.PackPerkBuild( NewPerkBuild, SelectedSkillsHolder );
            YHPlayerController(KFPC).PRICacheLoad(LastPerkIndex,NewPerkBuild);
            KFPC.CurrentPerk.UpdatePerkBuild( SelectedSkillsHolder, KFPC.PerkList[LastPerkIndex].PerkClass );

            // Send a notify if we can't currently switch our build
            if( !KFPC.CanUpdatePerkInfo() )
            {
                KFPC.NotifyPendingPerkChanges();
            }

            bModifiedSkills = false;
        }

        KFPC.ClientWriteAndFlushStats();
    }

    super.SavePerkData();
}

defaultproperties
{
    SubWidgetBindings.Remove((WidgetName="SkillsContainer",WidgetClass=class'KFGFxPerksContainer_Skills'))
    SubWidgetBindings.Add((WidgetName="SkillsContainer",WidgetClass=class'YHGFxPerksContainer_Skills'))
    SubWidgetBindings.Remove((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'KFGFxPerksContainer_SkillsSummary'))
    SubWidgetBindings.Add((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'YHGFxPerksContainer_SkillsSummary'))
    SubWidgetBindings.Remove((WidgetName="SelectionContainer",WidgetClass=class'KFGFxPerksContainer_Selection'))
    SubWidgetBindings.Add((WidgetName="SelectionContainer",WidgetClass=class'YHGFxPerksContainer_Selection'))
}

