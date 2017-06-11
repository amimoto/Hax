class Hax_DifficultyInfo extends KFGameDifficulty_Survival;

var() byte ZedHealthScale;
var() byte BossHealthScale;

/**
Scale health by the number of players.  This is applied as a bonus (zero is valid) for each player behind one.

The boss is treated differently in that it will allow the independant scaling of Volter's and Patty's HP.

This should make it okay for the future should new bosses be brought into the game.
*/
function float GetNumPlayersHealthModMonsterType( byte NumLivingPlayers, float HealthScale, optional KFPawn_Monster P )
{
    if ( P == none || KFPawn_MonsterBoss(P) == none )
    {
        if ( ZedHealthScale == 0 )
        {
            return Super.GetNumPlayersHealthMod(NumLivingPlayers,HealthScale);
        }
        else
        {
            return Super.GetNumPlayersHealthMod(ZedHealthScale,HealthScale);
        }
    }
    else
    {
        if ( BossHealthScale == 0 )
        {
            return Super.GetNumPlayersHealthMod(NumLivingPlayers,HealthScale);
        }
        else
        {
            return Super.GetNumPlayersHealthMod(BossHealthScale,HealthScale);
        }
    }
}

/** Scales the health this Zed has by the difficulty level */
function GetAIHealthModifier(KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers, out float HealthMod, out float HeadHealthMod, optional bool bApplyDifficultyScaling=true)
{
    if ( P != none )
    {
        // Global mod * character mod
        if( bApplyDifficultyScaling )
        {
            HealthMod = GetGlobalHealthMod() * GetCharHealthModDifficulty(P, GameDifficulty);
            HeadHealthMod = GetGlobalHealthMod() * GetCharHeadHealthModDifficulty(P, GameDifficulty);
        }

        // invalid scaling?
        if ( HealthMod <= 0 )
        {
            HealthMod = 1.f;
            if( HeadHealthMod <= 0 )
            {
                HeadHealthMod = 1.f;
            }
            return;
        }

        // Add another multiplier based on the number of players and the zeds character info scalers
        HealthMod *= 1.0 + (GetNumPlayersHealthModMonsterType( NumLivingPlayers, P.DifficultySettings.default.NumPlayersScale_BodyHealth, P ));
        HeadHealthMod *= 1.0 + (GetNumPlayersHealthModMonsterType( NumLivingPlayers, P.DifficultySettings.default.NumPlayersScale_HeadHealth, P ));
    }
}

/** Returns adjusted total num AI modifier for this wave's difficulty */
function float GetDifficultyMaxAIModifier()
{
    return 4;
}

function float GetSpawnRateModifier()
{
    return 0;
}


defaultproperties
{
    ZedHealthScale = 6
    BossHealthScale = 0
}
