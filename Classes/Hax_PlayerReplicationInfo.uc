class Hax_PlayerReplicationInfo extends KFPlayerReplicationInfo;

/** Called on server to +/- dosh.  Do not modify score directly */
function SetMinimumDosh( int DoshAmount )
{
    // Dosh is stored in PRI->Score
    Score = Max(Score, DoshAmount);

    // If the trader menu is open, update our menus dosh
    if ( WorldInfo.NetMode == NM_ListenServer )
    {
        UpdateTraderDosh();
    }
}

