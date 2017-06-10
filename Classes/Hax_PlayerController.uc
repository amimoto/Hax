class Hax_PlayerController extends KFPlayerController;

var Hax_GFxMoviePlayer_Manager      MyHax_GFxManager;
var array<int>  PerkBuildCache;

function int GetPerkBuildByPerkClass(class<KFPerk> PerkClass)
{
    local int i;
    local int MyPerkBuild;
    local PerkInfo MyPerkInfo;
    local class<KFPerk> MyPerkClass;
    local string TruePerkClassName;
    local int PerkIndex;

    if ( PerkBuildCache.Length == 0 )
    {
        for ( i=0; i<PerkList.Length; i++ )
        {
            MyPerkInfo = PerkList[i];
            MyPerkClass = MyPerkInfo.PerkClass;
            if ( Left(MyPerkClass.Name,4) == "Hax_" )
            {
                TruePerkClassName = "KFGame.KFPerk_"$Mid(MyPerkClass.Name,9);
                MyPerkClass = class<KFPerk>(DynamicLoadObject(TruePerkClassName, class'Class'));
            }

            `log("Looking for PERK"@MyPerkClass);
            MyPerkBuild = super.GetPerkBuildByPerkClass(MyPerkClass);

            PerkBuildCache.AddItem(MyPerkBuild);
        }
    }

    PerkIndex = PerkList.Find('PerkClass', PerkClass);
    return PerkBuildCache[PerkIndex];
}

function CachePerkBuild( class<KFPerk> PerkClass, int NewPerkBuild )
{
    local int PerkIndex;
    PerkIndex = PerkList.Find('PerkClass', PerkClass);
    PerkBuildCache[PerkIndex] = NewPerkBuild;
}

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
