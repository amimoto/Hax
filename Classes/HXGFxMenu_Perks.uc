class HXGFxMenu_Perks extends KFGFxMenu_Perks;

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
            HXPlayerController(KFPC).PRICacheLoad(LastPerkIndex,NewPerkBuild);
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
    SubWidgetBindings.Add((WidgetName="SkillsContainer",WidgetClass=class'HXGFxPerksContainer_Skills'))
    SubWidgetBindings.Remove((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'KFGFxPerksContainer_SkillsSummary'))
    SubWidgetBindings.Add((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'HXGFxPerksContainer_SkillsSummary'))
    SubWidgetBindings.Remove((WidgetName="SelectionContainer",WidgetClass=class'KFGFxPerksContainer_Selection'))
    SubWidgetBindings.Add((WidgetName="SelectionContainer",WidgetClass=class'HXGFxPerksContainer_Selection'))
}

