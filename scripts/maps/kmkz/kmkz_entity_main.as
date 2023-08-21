#include "data_loadstate"
#include "env_model_coop"
#include "env_render_progressive"
#include "env_warpball"
#include "utils"

void LoadSettings() 
{
	// Language settings. Change to LANGUAGE_ENGLISH For english language.
	
	iLanguage = LANGUAGE_ENGLISH; //LANGUAGE_ENGLISH or LANGUAGE_SPANISH
	
	// Change level sprite settings. Disabled by default.

	ChangeLevelSpriteAllow =false;
	
	// data_savestate settings
	
	SaveAllowed =			false;
	SaveVoteAlowed = 		true;	// "false" value allows to directly save at the slot chosen|| "true" value calls a vote to chose if you all want to save in that slot or not.
	SaveVotePercentage =	70; 	// chose a value between 0 and 100 as percentage to pass the vote.
	SaveVoteTime =			8;
	// data_loadstate settings
	
	LoadAllowed =			false;
	LoadVoteAlowed =		true; 	// "false" value allows to directly load the map from the slot chosen|| "true"  calls a vote to chose if you all want to load map from that slot or not.
	LoadVotePercentage =	70; 	// chose a value between 0 and 100 as percentage to pass the vote.
	LoadVoteTime =			8;
	
	
	//---------------------------------------------------------------------------//
	
	if (ChangeLevelSpriteAllow == false){g_EntityFuncs.FireTargets("cl_sprite", null, null, USE_OFF, 0.0f, 5.0f);}	
}

void MapInit()
{
	RegisterDataSavestate();
	RegisterDataLoadstate();
	RegisterDataGlobal();
	RegisterEnvModelCoop();
	GameSpritetext::Register();
	RegisterGameSpriteTextButton();
	EnvRenderProgressive::Register();
	RegisterEnvWarpball();
	LoadSettings();
}