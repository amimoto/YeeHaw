class YHWeapDef_MedicSMG extends KFWeapDef_MedicSMG;

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


defaultproperties
{
    WeaponClassPath="YeeHaw.YHWeap_SMG_Medic"
}