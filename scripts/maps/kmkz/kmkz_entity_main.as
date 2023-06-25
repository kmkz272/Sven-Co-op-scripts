#include "env_model_coop"
#include "env_render_progressive"
#include "env_warpball"
#include "game_spritetext_button"
#include "game_spritetext"
#include "utils"

void LoadSettings() 
{
	// Language setting. Change to LANGUAGE_ENGLISH For english language.
	
	iLanguage = LANGUAGE_ENGLISH;
	
	////////////////////////////////////////////
	
	// data_savestate settings
	
	SaveAllowed =			true;
	SaveVoteAlowed = 		true;	// "false" value allows to directly save at the slot chosen|| "true" value calls a vote to chose if you all want to save in that slot or not.
	SaveVotePercentage =	90; 	// chose a value between 0 and 100 as percentage to pass the vote.
	SaveVoteTime =			5;
	// data_loadstate settings
	
	LoadAllowed =			true;
	LoadVoteAlowed =		true; 	// "false" value allows to directly load the map from the slot chosen|| "true"  calls a vote to chose if you all want to load map from that slot or not.
	LoadVotePercentage =	90; 	// chose a value between 0 and 100 as percentage to pass the vote.
	LoadVoteTime =			5;
}

void MapInit()
{
	EnvRenderProgressive::Register();
	GameSpritetext::Register();
	RegisterEnvModelCoop();
	RegisterEnvWarpball();
	RegisterGameSpriteTextButton();
}