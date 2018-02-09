class YHTraderDialogManager extends KFTraderDialogManager;


simulated function PlayDialog( int EventID, Controller C, bool bInterrupt = false )
{
// We don't play no dialog
}

static function PlayGlobalDialog( int EventID, WorldInfo WI, bool bInterrupt = false )
{
}

static function PlayGlobalWaveProgressDialog( int ZedsRemaining, int ZedsTotal, WorldInfo WI )
{
}
