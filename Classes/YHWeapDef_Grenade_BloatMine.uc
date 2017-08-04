class YHWeapDef_Grenade_BloatMine extends KFWeaponDefinition
    abstract
    hidedropdown;

`include(YH_Log.uci)

static function string GetItemLocalization(string KeyName)
{
    local array<string> Strings;
    local string LocalizedString;
    ParseStringIntoArray(default.WeaponClassPath, Strings, ".", true);
    LocalizedString = Localize(Strings[1], KeyName, Strings[0]);
    LocalizedString = `yhLocalize(
              LocalizedString,
              Strings[1],
              KeyName
          );
    return LocalizedString;
}

DefaultProperties
{
    /*
    BuyPrice=0
    AmmoPricePerMag=10*/
    WeaponClassPath="YeeHaw.YHProj_BloatMineGrenade"
    ImagePath="WEP_UI_Molotov_TEX.UI_WeaponSelect_MolotovCocktail"
}

