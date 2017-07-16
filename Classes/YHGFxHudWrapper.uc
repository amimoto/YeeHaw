class YHGFxHudWrapper extends KFGFxHudWrapper;

`include(YH_Log.uci)

/**
 * @brief Draws name, perk etc over a human player's head
 * 
 * @param KFPH Human player's pawn
 * @return true if draw was successful
 */
simulated function bool DrawFriendlyHumanPlayerInfo( KFPawn_Human KFPH )
{
    local float Percentage;
    local float BarHeight, BarLength;
    local vector ScreenPos, TargetLocation;
    local KFPlayerReplicationInfo KFPRI;
    local FontRenderInfo MyFontRenderInfo;
    local float FontScale;
    local color TempColor;
    local string PerkName;

    KFPRI = KFPlayerReplicationInfo(KFPH.PlayerReplicationInfo);

    if( KFPRI == none )
    {
        return false;
    }

    MyFontRenderInfo = Canvas.CreateFontRenderInfo( true );
    BarLength = FMin(PlayerStatusBarLengthMax * (float(Canvas.SizeX) / 1024.f), PlayerStatusBarLengthMax) * FriendlyHudScale;
    BarHeight = FMin(8.f * (float(Canvas.SizeX) / 1024.f), 8.f) * FriendlyHudScale;

    TargetLocation = KFPH.Mesh.GetPosition() + ( KFPH.CylinderComponent.CollisionHeight * vect(0,0,2.2f) );

    ScreenPos = Canvas.Project( TargetLocation );
    if( ScreenPos.X < 0 || ScreenPos.X > Canvas.SizeX || ScreenPos.Y < 0 || ScreenPos.Y > Canvas.SizeY )
    {
        return false;
    }

    //Draw health bar
    Percentage = FMin(float(KFPH.Health) / float(KFPH.HealthMax), 100);
    DrawKFBar(Percentage, BarLength, BarHeight, ScreenPos.X - (BarLength * 0.5f), ScreenPos.Y, HealthColor);

    //Draw armor bar
    Percentage = FMin(float(KFPH.Armor) / float(KFPH.MaxArmor), 100);
    DrawKFBar(Percentage, BarLength, BarHeight, ScreenPos.X - (BarLength * 0.5f), ScreenPos.Y - BarHeight, ArmorColor);

    //Draw player name (Top)
    FontScale = class'KFGameEngine'.Static.GetKFFontScale();
    Canvas.Font = class'KFGameEngine'.Static.GetKFCanvasFont();
    Canvas.SetDrawColorStruct(PlayerBarTextColor);
    Canvas.SetPos(ScreenPos.X - (BarLength * 0.5f), ScreenPos.Y - BarHeight * 3.8);
    Canvas.DrawText( KFPRI.PlayerName,,FontScale * FriendlyHudScale,FontScale * FriendlyHudScale, MyFontRenderInfo );

    if( KFPRI.CurrentPerkClass == none )
    {
        return false;
    }

    //draw perk icon
    Canvas.SetDrawColorStruct(PlayerBarIconColor);
    Canvas.SetPos(ScreenPos.X - (BarLength * 0.75), ScreenPos.Y - BarHeight * 2.0);
    Canvas.DrawTile(KFPRI.CurrentPerkClass.default.PerkIcon, PlayerStatusIconSize * FriendlyHudScale, PlayerStatusIconSize * FriendlyHudScale, 0, 0, 256, 256 );

    //Draw perk level and name text
    Canvas.SetDrawColorStruct(PlayerBarTextColor);
    Canvas.SetPos(ScreenPos.X - (BarLength * 0.5f), ScreenPos.Y + BarHeight * 0.6);
    PerkName = `yhLocalizeObject(KFPRI.CurrentPerkClass.default.PerkName,KFPRI.CurrentPerkClass,"PerkName");
    Canvas.DrawText( KFPRI.GetActivePerkLevel() @PerkName,,FontScale * FriendlyHudScale, FontScale * FriendlyHudScale, MyFontRenderInfo );

    if( KFPRI.PerkSupplyLevel > 0 && KFPRI.CurrentPerkClass.static.GetInteractIcon() != none )
    {
        if( KFPRI.PerkSupplyLevel == 2 )
        {
            if( KFPRI.bPerkPrimarySupplyUsed && KFPRI.bPerkSecondarySupplyUsed )
            {
                TempColor = SupplierActiveColor;
            }
            else if( KFPRI.bPerkPrimarySupplyUsed || KFPRI.bPerkSecondarySupplyUsed )
            {
                TempColor = SupplierHalfUsableColor;
            }
            else
            {
                TempColor = SupplierUsableColor;
            }
        }
        else if( KFPRI.PerkSupplyLevel == 1 )
        {
            TempColor = KFPRI.bPerkPrimarySupplyUsed ? SupplierActiveColor : SupplierUsableColor;
        }

        Canvas.SetDrawColorStruct( TempColor );
        Canvas.SetPos( ScreenPos.X + BarLength * 0.5f, ScreenPos.Y - BarHeight * 2 );
        Canvas.DrawTile( KFPRI.CurrentPerkClass.static.GetInteractIcon(), PlayerStatusIconSize * FriendlyHudScale, PlayerStatusIconSize * FriendlyHudScale, 0, 0, 256, 256); 
    }

    return true;
}

defaultproperties
{
    HUDClass=class'YHGFxMoviePlayer_HUD'
}


