
class CEnvWarpball : ScriptBaseEntity
{
	CBeam @pBeam;
	string m_iszMaster;
	
	void Precache()
	{
		BaseClass.Precache();
		g_Game.PrecacheModel("sprites/lgtning.spr" );
		g_Game.PrecacheModel("sprites/Fexplo1.spr" );
		g_Game.PrecacheModel("sprites/XFlare1.spr" );
			
		g_SoundSystem.PrecacheSound( "debris/beamstart2.wav" );
		g_SoundSystem.PrecacheSound( "debris/beamstart7.wav" );
	}
	
	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if(szKey == "master")
		{
			m_iszMaster = szValue;
			return true;
		}
		else 
		{
			return BaseClass.KeyValue( szKey, szValue );
		}
	}
	
	void Spawn()
	{
		Precache();
	}
	
	int ObjectCaps()
	{
		return BaseClass.ObjectCaps() & ~FCAP_ACROSS_TRANSITION;
	}
	
	void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
	{
	
	if( !m_iszMaster.IsEmpty() && !g_EntityFuncs.IsMasterTriggered( m_iszMaster, self ) )
	{	
		return;
	}
	
	int iTimes = 0;
	int iDrawn = 0;
	TraceResult tr;
	Vector vecDest;
	while (iDrawn < int(self.pev.frags) && iTimes < int(self.pev.frags * 3)) // try to draw <frags> beams, but give up after 3x<frags> tries.
	{
		vecDest = self.pev.health * (Vector(Math.RandomFloat(-1,1), Math.RandomFloat(-1,1), Math.RandomFloat(-1,1)).Normalize());
		g_Utility.TraceLine( self.pev.origin, self.pev.origin + vecDest, ignore_monsters, null, tr);
		
		if (tr.flFraction != 1.0)
		{
			// we hit something.
			iDrawn++;
			@pBeam = g_EntityFuncs.CreateBeam("sprites/lgtning.spr",200);
			pBeam.PointsInit( self.pev.origin, tr.vecEndPos );
			pBeam.SetColor( 197, 243, 169 );
			pBeam.SetNoise( 65 );
			pBeam.SetBrightness( 150 );
			pBeam.SetWidth( 18 );
			g_Scheduler.SetTimeout( "BeamRemove", 1.0f, @pBeam); 
			pBeam.SetScrollRate( 35 );
		}
		iTimes++;
	}
	g_SoundSystem.EmitSound( self.edict(), CHAN_BODY, "debris/beamstart2.wav", 1.0f, ATTN_NORM );
	//g_SoundSystem.EmitSound( self.edict(), CHAN_STATIC, "../media/valve.mp3", 1.0f, ATTN_NONE );
	
	CSprite @pSpr = g_EntityFuncs.CreateSprite( "sprites/Fexplo1.spr", self.pev.origin, true );
	pSpr.AnimateAndDie( 10 );
	pSpr.SetTransparency(kRenderGlow,  77, 210, 130,  255, kRenderFxNoDissipation);

	CSprite @pSpr2 = g_EntityFuncs.CreateSprite( "sprites/XFlare1.spr", self.pev.origin, true );
	pSpr2.AnimateAndDie( 10 );
	pSpr2.SetTransparency(kRenderGlow,  184, 250, 214,  255, kRenderFxNoDissipation);
	
	g_Scheduler.SetTimeout( "WarpballThink", 0.5f, @self); 
	}
}

void BeamRemove(CBeam @pBeam)
{
	g_EntityFuncs.Remove( pBeam );
}
	
void WarpballThink(CBaseEntity @pEntity)
{
	g_SoundSystem.EmitSound( pEntity.edict(), CHAN_ITEM, "debris/beamstart7.wav", 1, ATTN_NORM );
	pEntity.SUB_UseTargets( @pEntity, USE_TOGGLE, 0);
}

bool gRegisterEnvWarpball = RegisterEnvWarpball();

bool RegisterEnvWarpball()
{
	if( !g_CustomEntityFuncs.IsCustomEntity( "env_warpball" ) )
		g_CustomEntityFuncs.RegisterCustomEntity("CEnvWarpball", "env_warpball");
    return true;
}
