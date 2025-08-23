/*
game_text_custom
Author: kmkz (e-mail: al_basualdo@hotmail.com )
This works game_text but with language options included.
Depending on the language selected it will display the right message.
The host can set the language changing the value of iLanguage in the code of the main script
with the options of EnumLanguage
---------------------------------------
new important keyvalues
message:  "Message Text"  : message in LANGUAGE 1 (or LANGUAGE_SPANISH) 
message2: "Message Text2" : message in LANGUAGE 2 (or LANGUAGE_ENGLISH) 
message3: "Message Text3" : message in LANGUAGE 3 (or LANGUAGE_3) 
message4: "Message Text4" : message in LANGUAGE 4 (or LANGUAGE_4) 
message5: "Message Text5" : message in LANGUAGE 5 (or LANGUAGE_5) 
message6: "Message Text6" : message in LANGUAGE 6 (or LANGUAGE_6) 
message7: "Message Text7" : message in LANGUAGE 7 (or LANGUAGE_7) 
message8: "Message Text8" : message in LANGUAGE 8 (or LANGUAGE_8) 
---------------------------------------
flags:
1: "All players"
the message is shown to all players.
2: "No console echo"
to do: Console echo is not displayed yet (is this really needed?). 
*/

#include "extra_languages"
#include "string_escape_sequences"
#include "utils"

namespace GameTextCustom

{
	enum EnumSpawnFlags
	{
		SF_ALL_PLAYERS			= 1 << 0,
		//SF_NO_CONSOLE_ECHO 	= 2	<< 0,
	}
	 
	class game_text_custom : ScriptBaseEntity, ScriptBaseLanguagesKm
	{
		HUDTextParams textParams;
		string m_iszMaster;
		
		void Precache() 
		{
			BaseClass.Precache();
		}
		
		void Spawn() 
		{
			self.pev.movetype 		= MOVETYPE_NONE;
			self.pev.solid 			= SOLID_NOT;
			self.pev.framerate 		= 1.0f;
			
			g_EntityFuncs.SetOrigin( self, self.pev.origin );
			SetUse(UseFunction(this.TriggerUse));
			self.Precache();	
		}
		
		bool KeyValue( const string& in szKey, const string& in szValue )
		{
			if(szKey == "channel")
			{
			textParams.channel = atoi (szValue);
    		return true;
			}
			else if(szKey == "x")
			{
			textParams.x = atof (szValue);
    		return true;
			}
			else if(szKey == "y")
			{
				textParams.y = atof (szValue);
				return true;
			}
			else if(szKey == "effect")
			{
				textParams.effect = atoi(szValue );
				return true;
			}
			else if(szKey == "color")
			{
				string delimiter = " ";
				array<string> splitColor = {"","","",""};
				splitColor = szValue.Split(delimiter);
				array<uint8>result = {0,0,0,0};
				result[0] = atoi(splitColor[0]);
				result[1] = atoi(splitColor[1]);
				result[2] = atoi(splitColor[2]);
				result[3] = atoi(splitColor[3]);
				if (result[0] > 255) result[0] = 255;
				if (result[1] > 255) result[1] = 255;
				if (result[2] > 255) result[2] = 255;
				if (result[3] > 255) result[3] = 255;
				RGBA vcolor = RGBA(result[0],result[1],result[2],result[3]);
				textParams.r1 = vcolor.r;
				textParams.g1 = vcolor.g;
				textParams.b1 = vcolor.b;
				textParams.a1 = vcolor.a;
				return true;
			}
			else if(szKey == "color2")
			{
				string delimiter2 = " ";
				array<string> splitColor2 = {"","","",""};
				splitColor2 = szValue.Split(delimiter2);
				array<uint8>result2 = {0,0,0,0};
				result2[0] = atoi(splitColor2[0]);
				result2[1] = atoi(splitColor2[1]);
				result2[2] = atoi(splitColor2[2]);
				result2[3] = atoi(splitColor2[3]);
				if (result2[0] > 255) result2[0] = 255;
				if (result2[1] > 255) result2[1] = 255;
				if (result2[2] > 255) result2[2] = 255;
				if (result2[3] > 255) result2[3] = 255;
				RGBA vcolor2 = RGBA(result2[0],result2[1],result2[2],result2[3]);
				textParams.r2 = vcolor2.r;
				textParams.g2 = vcolor2.g;
				textParams.b2 = vcolor2.b;
				textParams.a2 = vcolor2.a;
				return true;
			}
			else if(szKey == "fadein")
			{
				textParams.fadeinTime = atof(szValue);
				return true;
			}
			else if(szKey == "fadeout")
			{
				textParams.fadeoutTime = atof(szValue);
				return true;
			}
			else if(szKey == "holdtime")
			{
				textParams.holdTime = atof(szValue);
				return true;
			}
			else if(szKey == "fxtime")
			{
				textParams.fxTime = atof(szValue);
				return true;
			}
			else if(szKey == "master")
			{
				m_iszMaster = szValue;
				return true;
			}
			Languages( szKey, szValue );
			{
				return BaseClass.KeyValue( szKey, szValue );
			}
		}
		
		void TriggerUse(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
		{
			string mtext;
			if (iLanguage == LANGUAGE_SPANISH) {mtext = message_spanish;}
			else {mtext = self.pev.message;}
			
			if( !m_iszMaster.IsEmpty() && !g_EntityFuncs.IsMasterTriggered( m_iszMaster, self ) )
			{	
				return;
			}
		
			CBasePlayer@ pPlayer = cast<CBasePlayer@>(pActivator);
				
			if ( self.pev.SpawnFlagBitSet (SF_ALL_PLAYERS) )
			{
				g_PlayerFuncs.HudMessageAll( textParams, mtext);
			}
			else
			{
				if ( pActivator.IsPlayer())
				{
					g_PlayerFuncs.HudMessage( pPlayer, textParams, self.pev.message);
				}
			}
		}
	}
	
	bool gRegister = Register();

	bool Register()
	{
		if( !g_CustomEntityFuncs.IsCustomEntity( "game_text_custom" ) )
			g_CustomEntityFuncs.RegisterCustomEntity("GameTextCustom::game_text_custom", "game_text_custom");
		return true;
	}
}