interface YHPawn_Monster_Interface;

function bool IsBobbleheaded();
function bool IsSensitive();
function bool IsPharmed();
function bool IsOverdosed();
function bool IsZedWhispered();
function bool IsYourMineMined();
function bool IsSmellsLikeRoses();

function SetBobbleheaded( bool active );
function SetSensitive( bool active );
function SetPharmed( bool active, Controller AfflictionInstigator );
function SetOverdosed( bool active );
function SetZedWhispered( bool active );
function SetYourMineMined( bool active, Controller AfflictionInstigator );
function SetSmellsLikeRoses( bool active, Controller AfflictionInstigator );

simulated function MyAdjustAffliction(out float AfflictionPower,EYHAfflictionType Type);

