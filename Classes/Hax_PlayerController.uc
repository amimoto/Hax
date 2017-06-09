class Hax_PlayerController extends CD_PlayerController;

var Hax_GFxMoviePlayer_Manager      MyHax_GFxManager;

// Players may not throw their weapons
exec function ThrowWeapon()
{
}

DefaultProperties
{
    //defaults
    PerkList.Empty()
    PerkList.Add((PerkClass=class'Hax_Perk_Gunslinger'))
    PerkList.Add((PerkClass=class'Hax_Perk_Berserker'))
    PerkList.Add((PerkClass=class'Hax_Perk_Commando')
    PerkList.Add((PerkClass=class'Hax_Perk_Support')
    PerkList.Add((PerkClass=class'Hax_Perk_FieldMedic'))
    PerkList.Add((PerkClass=class'Hax_Perk_Demolitionist'))
    PerkList.Add((PerkClass=class'Hax_Perk_Firebug'))
    PerkList.Add((PerkClass=class'Hax_Perk_Sharpshooter'))
    PerkList.Add((PerkClass=class'Hax_Perk_Survivalist'))
    PerkList.Add((PerkClass=class'Hax_Perk_SWAT'))

}
