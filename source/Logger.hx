import haxe.Timer;

class Logger
{ // LOGGING
	private static var GAME_KEY = "8dbec9d91700db8b32c0b2a1028499a9";
	private static var GAME_NAME = "warlock";
	private static var GAME_ID = 202201;
	// should use static functions instead of directly accessing logger's methods in case
	// logger is null
	private static var _logger:CapstoneLogger;
	private static var user_id:String;
	// test categories: 0 = debugging
	// 1 = 1st iteration
	private static var TEST_CATEGORY = 0;
	public static var active = false;
	public static var last_player_action:Float;
	private static var timer:Timer;
	private static var SESSION_TIMEOUT = 300;

	public static function createLogger()
	{
		_logger = new CapstoneLogger(GAME_ID, GAME_NAME, GAME_KEY, TEST_CATEGORY);
		newSession();

		last_player_action = Timer.stamp();
	}

	/**
	 * Call this whenever the player did anything in-game in order to measure inactivity
	 */
	public static function checkTimeout()
	{
		var now = Timer.stamp();
		if (now - SESSION_TIMEOUT > last_player_action)
		{
			newSession();
			if (LevelStats.initialized)
			{
				levelEnd("timed out at least " + SESSION_TIMEOUT + " seconds ago");
				startLevel(LevelStats.curr_level, "resume from timeout");
			}
		}
		last_player_action = now;
	}

	// if unable to start new session in logger, disable it
	private static function disable(res:Bool)
	{
		if (!res)
		{
			_logger = null;
			trace("logger failed");
		}
		else
		{
			trace("logger started");
			active = true;
		}
	}

	public static function newSession()
	{
		var uid = _logger.getSavedUserId();
		if (uid == null)
		{
			uid = _logger.generateUuid();
			_logger.setSavedUserId(uid);
		}
		user_id = uid;

		_logger.startNewSession(user_id, disable); // should callback be something different?
	}

	/**
	 * Calls the logger to start a level.
	 * @param room Room number, as specified in `RoomNo.hx`.
	 * @param details Details to include, including if it's a retry 
	 */
	public static function startLevel(room:Int, ?details:String)
	{
		if (_logger != null)
		{
			if (details != null)
			{
				Logger._logger.logLevelStart(room, details);
			}
			else
			{
				Logger._logger.logLevelStart(room);
			}
		}
	}

	public static function nextRoom(n_room:Class<LevelState>)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelAction(LoggingActions.NEXT_ROOM, Std.string(n_room));
		}
	}

	// public static function playerDeath(curr_room:LevelState, cause:Dynamic)

	public static function playerDeath(cause:Dynamic)
	{
		if (_logger != null)
		{
			// Logger._logger.logLevelAction(LoggingActions.PLAYER_DEATH, Std.string(curr_room) + ", " + Std.string(cause));
			Logger._logger.logLevelAction(LoggingActions.PLAYER_DEATH, Std.string(cause));
		}
	}

	public static function levelEnd(cause:String)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelEnd(cause);
		}
	}

	public static function playerShot(type:String, judge:String, timing:String)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelAction(LoggingActions.PLAYER_SHOOT, type + ", " + judge + ", " + timing);
		}
	}

	public static function tookDamage(curr_room:LevelState, cause:Dynamic, dmg:Float)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelAction(LoggingActions.TOOK_DAMAGE, Std.string(curr_room) + ", " + cause + ", " + dmg);
		}
	}
}
