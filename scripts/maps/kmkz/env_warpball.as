// Credits: kmkz, code taken from HL code. optimizations contributed by AK47toh and Mikk.

namespace EnvWarpball
{
const int SF_REMOVE_ON_FIRE	= 0x0001;

class env_warpball : ScriptBaseEntity
{
	string m_iszMaster;
	private float m_iScale = 1.0f;

	void Precache()
	{
		BaseClass.Precache();

		g_Game.PrecacheModel("sprites/lgtning.spr" );
		g_Game.PrecacheModel("sprites/fexplo1.spr" );
		g_Game.PrecacheModel("sprites/xflare1.spr" );

		g_SoundSystem.PrecacheSound( "debris/beamstart2.wav" );
		g_SoundSystem.PrecacheSound( "debris/beamstart7.wav" );
	}

	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if( szKey == "master" )
		{
			m_iszMaster = szValue;
			return true;
		}
		else if( szKey == "scale" )
		{
			m_iScale = atof(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Spawn()
	{
		Precache();

		self.pev.movetype	= MOVETYPE_NONE;
		self.pev.solid		= SOLID_NOT;
		self.pev.effects    |= EF_NODRAW;

		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	int ObjectCaps()
	{
		return BaseClass.ObjectCaps() & ~FCAP_ACROSS_TRANSITION;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if( !m_iszMaster.IsEmpty() && !g_EntityFuncs.IsMasterTriggered(m_iszMaster, self) )
			return;

		int iTimes = 0, iDrawn = 0;
		TraceResult tr;
		Vector vecDest;

		CBeam @pBeam;

		while( iDrawn < int(self.pev.frags) && iTimes < int(self.pev.frags * 3) ) // try to draw <frags> beams, but give up after 3x<frags> tries.
		{
			vecDest = self.pev.health * (Vector(Math.RandomFloat(-1,1), Math.RandomFloat(-1,1), Math.RandomFloat(-1,1)).Normalize());
			g_Utility.TraceLine( self.pev.origin, self.pev.origin + vecDest, ignore_monsters, null, tr);

			if( tr.flFraction != 1.0 )
			{
				// we hit something.
				iDrawn++;
				@pBeam = g_EntityFuncs.CreateBeam("sprites/lgtning.spr",200);
				pBeam.PointsInit( self.pev.origin, tr.vecEndPos );
				pBeam.SetColor( 197, 243, 169 );
				pBeam.SetNoise( 65 );
				pBeam.SetBrightness( 150 );
				pBeam.SetWidth( 18 );
				g_Scheduler.SetTimeout( "KillBeam", 1.0f, @pBeam); //Math.RandomFloat(0.5, 1.6)
				pBeam.SetScrollRate( 35 );
			}

			iTimes++;
		}

		g_SoundSystem.EmitSound( self.edict(), CHAN_BODY, "debris/beamstart2.wav", 1.0f, ATTN_NORM );

		CSprite @pSprite = g_EntityFuncs.CreateSprite( "sprites/fexplo1.spr", self.pev.origin, true );
		if( pSprite !is null )
		{
			pSprite.AnimateAndDie( 10 );
			pSprite.SetTransparency(kRenderGlow,  77, 210, 130,  255, kRenderFxNoDissipation);
			pSprite.pev.scale = self.pev.scale;
		}

		CSprite @pSprite2 = g_EntityFuncs.CreateSprite( "sprites/xflare1.spr", self.pev.origin, true );
		if( pSprite2 !is null )
		{
			pSprite2.AnimateAndDie( 10 );
			pSprite2.SetTransparency(kRenderGlow,  184, 250, 214,  255, kRenderFxNoDissipation);
			pSprite2.pev.scale = self.pev.scale;
		}

		NetworkMessage msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY );
			msg.WriteByte( TE_DLIGHT );
			msg.WriteCoord( self.pev.origin.x );
			msg.WriteCoord( self.pev.origin.y );
			msg.WriteCoord( self.pev.origin.z );
			msg.WriteByte( 16 ); // radius
			msg.WriteByte( 77 ); // red
			msg.WriteByte( 210 ); // green
			msg.WriteByte( 130 ); // blue
			msg.WriteByte( 8 ); // life
			msg.WriteByte( 0 ); // decay rate
		msg.End();

		SetThink( ThinkFunction(this.WarpballThink) );
		self.pev.nextthink = g_Engine.time + 0.5;
	}

	void WarpballThink( void )
	{
		self.SUB_UseTargets( self, USE_TOGGLE, 0 );

		g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "debris/beamstart7.wav", 1, ATTN_NORM );

		if( self.pev.SpawnFlagBitSet(SF_REMOVE_ON_FIRE) )
		{
			SetThink( ThinkFunction(this.ThinkRemove) );
			self.pev.nextthink = g_Engine.time + 0.1;
		}
	}

	void ThinkRemove( void )
	{
		self.SUB_Remove();
	}
}

void KillBeam( CBeam @pBeam )
{
	g_EntityFuncs.Remove( pBeam );
}

bool gRegisterEnvWarpball = RegisterEnvWarpball();

bool RegisterEnvWarpball()
{
	if( !g_CustomEntityFuncs.IsCustomEntity( "env_warpball" ) )
		g_CustomEntityFuncs.RegisterCustomEntity("CEnvWarpball", "env_warpball");
    return true;
}
