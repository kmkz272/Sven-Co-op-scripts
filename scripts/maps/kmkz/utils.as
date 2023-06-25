
bool debug_mode;

float Q_PI = 3.14159265358979323846;

int iLanguage;
bool SaveAllowed ;
bool LoadAllowed ;
bool SaveVoteAlowed ;
bool LoadVoteAlowed ;
float SaveVotePercentage;
float LoadVotePercentage;
float SaveVoteTime;
float LoadVoteTime;

enum EnumLanguage
	{
		LANGUAGE_SPANISH		= 0 ,
		LANGUAGE_ENGLISH			,
		LANGUAGE_3					,
		LANGUAGE_4					,
		LANGUAGE_5					,
		LANGUAGE_6					,
		LANGUAGE_7					,
		LANGUAGE_8					,
	}
	
	int StringToInt(string Sttext)
	{	
		int intext = 0;
		uint i = 0;
		int p = 1;
		
		i = Sttext.Length();
		
		while ( i > 0 )
		{
			intext = intext + (int(Sttext[i-1]) - 48) * p;
			i = i -1;
			p = p * 10;
		}
		
		return intext;
	}


	
