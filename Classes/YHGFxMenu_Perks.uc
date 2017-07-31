class YHGFxMenu_Perks extends KFGFxMenu_Perks;

`include(YH_Log.uci)

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

function CheckTiersForPopup()
{
    local array<string> UnlockedPerkNames;
    local byte bTierUnlocked;
    local string SecondaryPopupText;
    local byte i;
    local class<KFPerk> PerkClass;
    local int UnlockedPerkLevel;

    for (i = 0; i < KFPC.PerkList.Length; i++)
    {
        PerkClass = KFPC.PerkList[i].PerkClass;
        class'KFPerk'.static.LoadTierUnlockFromConfig(PerkClass, bTierUnlocked, UnlockedPerkLevel);
        if( bool(bTierUnlocked) && KFPC.PerkList[i].PerkLevel >= UnlockedPerkLevel )
        {
            UnlockedPerkNames.AddItem(`yhLocalizeObject(PerkClass.default.PerkName,PerkClass,"PerkName"));
        }
    }

    if(UnlockedPerkNames.length > 0)
    {
        for (i = 0; i < UnlockedPerkNames.length; i++)
        {
            if( i > 0 )
            {
                SecondaryPopupText = SecondaryPopupText $"," @UnlockedPerkNames[i];
            }
            else
            {
                SecondaryPopupText = TierUnlockedSecondaryText @UnlockedPerkNames[i];
            }
        }

        KFPC.MyGFxManager.DelayedOpenPopup(ENotification, EDPPID_Misc, TierUnlockedText, SecondaryPopupText, class'KFCommon_LocalizedStrings'.default.OKString,,,,,,PerkLevelupSound);
    }
}


defaultproperties
{
    SubWidgetBindings.Remove((WidgetName="SkillsContainer",WidgetClass=class'KFGFxPerksContainer_Skills'))
    SubWidgetBindings.Add((WidgetName="SkillsContainer",WidgetClass=class'YHGFxPerksContainer_Skills'))
    SubWidgetBindings.Remove((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'KFGFxPerksContainer_SkillsSummary'))
    SubWidgetBindings.Add((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'YHGFxPerksContainer_SkillsSummary'))
    SubWidgetBindings.Remove((WidgetName="SelectionContainer",WidgetClass=class'KFGFxPerksContainer_Selection'))
    SubWidgetBindings.Add((WidgetName="SelectionContainer",WidgetClass=class'YHGFxPerksContainer_Selection'))
    SubWidgetBindings.Remove((WidgetName="HeaderContainer",WidgetClass=class'KFGFxPerksContainer_Header'))
    SubWidgetBindings.Add((WidgetName="HeaderContainer",WidgetClass=class'YHGFxPerksContainer_Header'))
    SubWidgetBindings.Remove((WidgetName="DetailsContainer",WidgetClass=class'KFGFxPerksContainer_Details'))
    SubWidgetBindings.Add((WidgetName="DetailsContainer",WidgetClass=class'YHGFxPerksContainer_Details'))

}

