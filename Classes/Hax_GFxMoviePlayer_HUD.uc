class Hax_GFxMoviePlayer_HUD extends KFGFxMoviePlayer_HUD;

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    switch(WidgetName)
    {

    // In YeeHaw, trader is meaningless
    case 'CompassContainer':
        if ( TraderCompassWidget == none )
        {
            TraderCompassWidget = KFGFxHUD_TraderCompass(Widget);
            TraderCompassWidget.InitializeHUD();
            SetWidgetPathBinding( Widget, WidgetPath );
            // FIXME: This isn't really relevant
            // TraderCompassWidget.SetVisible(false);
        }
        return true;
    }

    return Super.WidgetInitialized(WidgetName,WidgetPath,Widget);
}

defaultproperties
{
    WidgetBindings.Remove((WidgetName="CompassContainer",WidgetClass=class'KFGFxHUD_TraderCompass'))
    WidgetBindings.Add((WidgetName="CompassContainer",WidgetClass=class'Hax_GFxHUD_TraderCompass'))
    WidgetBindings.Remove((WidgetName="WaveInfoContainer",WidgetClass=class'KFGFxHUD_WaveInfo'))
    WidgetBindings.Add((WidgetName="WaveInfoContainer",WidgetClass=class'Hax_GFxHUD_WaveInfo'))
}
