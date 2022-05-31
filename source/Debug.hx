/**
 * Static class holding variables meant for debugging purposes.
 * MAKE SURE TO TURN ALL OF THESE OFF IN THE LIVE VERSION.
 */
class Debug
{
	/**
	 * Enables the room select menu.
	 */
	public static var ROOM_SELECT = true;

	/**
	 * Respawn at the same room you died in, as opposed to the last checkpoint.
	 */
	public static var RESPAWN_AT_SAME_ROOM = true;

	/**
	 * Keeps score upon death.
	 */
	public static var KEEP_SCORE = true;

	/**
	 * Enable the metronome-like SFX that plays to the beat.
	 */
	public static var PLAY_BEAT = true;

	/**
	 * Whether to start the game by deleting any existing saved data first.
	 */
	public static var DELETE_SAVE = true;

	/**
	 * Whether or not to force the game to assign this session to a specific play-testing group for the health
	 * restoration mechanic.
	 * `0 =` random,
	 * `1 =` group A: use fixed health pickups
	 * `2 =` group B: use health pellets dropped on kill
	 */
	public static var AB_GROUP = 1;
}
