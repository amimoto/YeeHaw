class YHPlayerController extends KFPlayerController;

var YHGFxMoviePlayer_Manager      MyYHGFxManager;

// Players may not throw their weapons
exec function ThrowWeapon()
{
}

DefaultProperties
{
    //defaults
    PerkList.Empty()
    PerkList.Add((PerkClass=class'YHPerk_Gunslinger'))
}
