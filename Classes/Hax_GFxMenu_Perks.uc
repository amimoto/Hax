class Hax_GFxMenu_Perks extends KFGFxMenu_Perks;

defaultproperties
{
    SubWidgetBindings.Remove((WidgetName="SkillsContainer",WidgetClass=class'KFGFxPerksContainer_Skills'))
    SubWidgetBindings.Add((WidgetName="SkillsContainer",WidgetClass=class'Hax_GFxPerksContainer_Skills'))
    SubWidgetBindings.Remove((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'KFGFxPerksContainer_SkillsSummary'))
    SubWidgetBindings.Add((WidgetName="SelectedPerkSummaryContainer",WidgetClass=class'Hax_GFxPerksContainer_SkillsSummary'))
}

