class HXGFxMenu_Trader extends KFGfxMenu_Trader;

defaultproperties
{
    SubWidgetBindings.Remove((WidgetName="shopContainer",WidgetClass=class'KFGFxTraderContainer_Store'))
    SubWidgetBindings.Add((WidgetName="shopContainer",WidgetClass=class'HXGFxTraderContainer_Store'))
}

