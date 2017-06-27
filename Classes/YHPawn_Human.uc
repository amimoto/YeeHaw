class YHPawn_Human extends KFPawn_Human;

function AddDefaultInventory()
{
    `log("->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->-> AddDefaultInventory");
    ScriptTrace();
    super.AddDefaultInventory();
}

defaultproperties
{
    InventoryManagerClass=class'YHInventoryManager'
}

