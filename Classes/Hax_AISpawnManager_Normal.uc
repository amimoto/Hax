class Hax_AISpawnManager_Normal extends KFAISpawnManager_Normal;

function int GetMaxMonsters()
{
    return 20 + GetLivingPlayerCount() * 32;
}