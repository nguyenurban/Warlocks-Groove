class Logger
{ // LOGGING
	private static var GAME_KEY = "8dbec9d91700db8b32c0b2a1028499a9";
	private static var GAME_NAME = "warlock";
	private static var GAME_ID = 202201;
	// should use static functions instead of directly accessing logger's methods in case
	// logger is null
	private static var _logger:CapstoneLogger;

	// test categories: 0 = debugging
	// 1 = 1st iteration
	private static var TEST_CATEGORY = 0;

	public static function createLogger()
	{
		_logger = new CapstoneLogger(GAME_ID, GAME_NAME, GAME_KEY, TEST_CATEGORY);
		var uid = _logger.getSavedUserId();
		if (uid == null)
		{
			uid = _logger.generateUuid();
			_logger.setSavedUserId(uid);
		}

		/**
		 * Code to be changed when levels are added
		 */
		_logger.startNewSession(uid, disable); // should callback be something different?

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
		}
	}

	public static function startLevel(level:Int)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelStart(level);
		}
	}

	public static function nextRoom(n_room:Class<LevelState>)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelAction(LoggingActions.NEXT_ROOM, Std.string(n_room));
		}
	}

	public static function playerDeath(curr_room:LevelState, cause:Dynamic)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelAction(LoggingActions.PLAYER_DEATH, Std.string(curr_room) + ", " + Std.string(cause));
		}
	}

	public static function levelEnd(cause:String)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelEnd(cause);
		}
	}

	public static function playerShot(type:String, timing:String)
	{
		if (_logger != null)
		{
			Logger._logger.logLevelAction(LoggingActions.PLAYER_SHOOT, type + ", " + timing);
		}
	}
}
