class BaseLevel
{
	public static var timer:Float;
	public static var beat:Float;
	public static var prev_beat:Int;
	public static var shortest_notes_elpsd:Int;
	public static var prev_sne:Int;

	public static var bpm:Float;
	public static var qtr_note:Float;
	public static var shortest_note:LevelState.NoteType;
	public static var snpq:Int;

	public static function base_initialize()
	{
		timer = 0;
		beat = 0;
		prev_beat = 0;
		shortest_notes_elpsd = 0;
	}
}
