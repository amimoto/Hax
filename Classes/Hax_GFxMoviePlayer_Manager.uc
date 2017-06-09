class Hax_GFxMoviePlayer_Manager extends KFGfxMoviePlayer_Manager;

defaultproperties
{
    WidgetBindings.Remove((WidgetName="PerksMenu",WidgetClass=class'KFGFxMenu_Perks'))
    WidgetBindings.Add((WidgetName="PerksMenu",WidgetClass=class'Hax_GFxMenu_Perks'))
    WidgetBindings.Remove((WidgetName="traderMenu",WidgetClass=class'KFGFxMenu_Trader'))
    WidgetBindings.Add((WidgetName="traderMenu",WidgetClass=class'Hax_GFxMenu_Trader'))
}
