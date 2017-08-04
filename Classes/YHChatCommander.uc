class YHChatCommander extends CD_ChatCommander
    within YH_Survival
    DependsOn(YH_Survival);

function SetupChatCommands()
{
    local array<string> n;
    local array<string> h;
    local StructChatCommand scc;

    super.SetupChatCommands();

    // Setup ammo commands
    n.Length = 2;
    h.Length = 0;
    n[0] = "!cdammonormal";
    n[1] = "!cdan";
    scc.Names = n;
    scc.ParamHints = h;
    scc.NullaryImpl = AmmoModeNormal;
    scc.ParamsImpl = None;
    scc.CDSetting = None;
    scc.Description = "Normal Ammo Handling";
    scc.AuthLevel = CDAUTH_WRITE;
    scc.ModifiesConfig = true;
    ChatCommands.AddItem( scc );

    // Setup ammo commands
    n.Length = 2;
    h.Length = 0;
    n[0] = "!cdammoyeehaw";
    n[1] = "!cday";
    scc.Names = n;
    scc.ParamHints = h;
    scc.NullaryImpl = AmmoModeYeeHaw;
    scc.ParamsImpl = None;
    scc.CDSetting = None;
    scc.Description = "YeeHaw Ammo Handling";
    scc.AuthLevel = CDAUTH_WRITE;
    scc.ModifiesConfig = true;
    ChatCommands.AddItem( scc );

    // Setup ammo commands
    n.Length = 2;
    h.Length = 0;
    n[0] = "!cdammouber";
    n[1] = "!cdau";
    scc.Names = n;
    scc.ParamHints = h;
    scc.NullaryImpl = AmmoModeUber;
    scc.ParamsImpl = None;
    scc.CDSetting = None;
    scc.Description = "YeeHaw UberAmmo";
    scc.AuthLevel = CDAUTH_WRITE;
    scc.ModifiesConfig = true;
    ChatCommands.AddItem( scc );
}
