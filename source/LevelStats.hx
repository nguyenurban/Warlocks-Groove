import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import howler.Howl;
import openfl.media.Sound;
import openfl.utils.IAssetCache;

class LevelStats extends BaseLevel
{
	public static var curr_level:Int;
	public static var curr_room:Int;
	public static var timer:Float;
	public static var beat:Float;
	public static var prev_beat:Int;
	public static var shortest_notes_elpsd:Int;
	public static var prev_sne:Int;
	public static var shortest_note_len:Float;
	public static var ticks_len:Int;
	public static var _ticks:Array<Tick>;
	public static var scroll_mul:Int;

	/**
	 * Current checkpoint. Because I'm lazy, the default is level one, room one. Make sure to set checkpoints
	 * on the first room of each level.
	 */
	public static var chkpt:Class<LevelState> = RoomOne;

	public static var chkpt_no = 101;
	public static var score = 0;

	/**
	 * Score attained at last checkpoint.
	 */
	public static var chkpt_score = 0;

	public static var combo = 0;
	public static var max_combo = 0;
	public static var num_deaths = 0;

	/**
	 * EX Score:
	 * Perfect = +3
	 * Great = +2
	 * O.K. = 0
	 * Misfire = -1 (EX score cannot drop below 0)
	 * Used to keep track of accuracy bonus in conjunction with `shots_landed`.
	 */
	public static var ex_score = 0;

	/**
	 * How many times the player hits an enemy (not how many times they fired,
	 * though misfires will increment this by one).
	 */
	public static var shots_landed = 0;

	/**
	 * Timer that doesn't reset on death; only on starting a new level.
	 */
	public static var cumul_timer = 0.0;

	/**
	 * How much max combo needs to be in order to get the highest combo bonus
	 * (default is 100).
	 */
	public static var max_combo_bonus = 100;

	public static var max_combo_bonus_value = 50000;

	/**
	 * How long the user needs to take in seconds to complete a level in order to get the highest
	 * time bonus (default is 60).
	 */
	public static var quickest_time_bonus = 60;

	public static var quickest_time_bonus_val = 10000;

	/**
	 * How many points are deducted from the time bonus per second (default is 10 / sec).
	 */
	public static var time_bonus_penalty = 10;

	/**
	 * Whether or note `LevelStats.initialize()` has been called yet. Resets
	 * upon calling `stopMusic()`.
	 */
	public static var initialized:Bool;

	/**
	 * If music (and timer) has started already
	 */
	public static var started:Bool;

	// PURELY FOR TESTING
	public static var enchant_chance:Float;

	public static var bpm:Float;

	/**
	 * Duration of one quarter note.
	 */
	public static var qtr_note:Float;

	public static var shortest_note:LevelState.NoteType;

	/**
	 * (shortest notes per quarter note)
	 */
	public static var snpq:Int;

	/**
	 * Represents one measure's worth of timing
	 */
	public static var tick_format:Array<LevelState.AttackType>;

	// supposed boundaries of timeline display
	public static var TIMELINE_LEFT = 100;
	public static var TIMELINE_RIGHT = 1060;
	public static var TIMELINE_TOP = 0;
	public static var TIMELINE_BOTTOM = 50;
	public static var TICK_X_OFFSET:Int;

	// public static var bgm_loop:Howl;
	// public static var bgm:Howl;
	public static var bgm:FlxSound;
	public static var intro_beats:Int;
	public static var looping_beats:Int;
	public static var inIntro:Bool;
	public static var loop_timer:Float;

	/**
	 * Starts keeping track of stats for current level (but doesn't start music).
	 * @param level_no Level number (not room number, or the numbers mentioned in `RoomNo.hx`).
	 * @param retry Whether or not this initialization is from retrying from a death (i.e. resets score to score at checkpoint, still keeps track of time).
	 */
	public static function initialize(level_no:Int, retry:Bool)
	{
		curr_level = level_no;
		curr_room = 0;
		timer = 0;
		beat = 0;
		prev_beat = 0;
		shortest_notes_elpsd = 0;
		prev_sne = 0;
		TICK_X_OFFSET = Std.int(FlxG.width / 2);
		switch (level_no)
		{
			case 1:
				bpm = 130;
				tick_format = [RED, RED, RED, RED];
				shortest_note = QUARTER;
				snpq = 1;
				scroll_mul = 350;
				enchant_chance = 0.25;
				ticks_len = 16;
				bgm = FlxG.sound.load("assets/music/stg1.wav", 0.5);
				bgm.persist = true;
				// bgm = setupSound("assets/music/stg1_intro.mp3", true);
				// bgm_loop = setupSound("assets/music/stg1.mp3", false);
				intro_beats = 32;
				looping_beats = 24 * 4;
			case 2:
				bpm = 130;
				tick_format = [RED, PURPLE, RED, PURPLE, RED, PURPLE, RED, PURPLE];
				shortest_note = EIGHTH;
				snpq = 2;
				scroll_mul = 350;
				enchant_chance = 0.25;
				ticks_len = 16;
				bgm = FlxG.sound.load("assets/music/stg1.wav", 0.5);
				bgm.persist = true;
				// bgm = setupSound("assets/music/stg1_intro.mp3", true);
				// bgm_loop = setupSound("assets/music/stg1.mp3", false);
				intro_beats = 32;
				looping_beats = 24 * 4;
			default:
		}
		inIntro = true;
		loop_timer = 0;
		qtr_note = 60 / bpm;

		switch (shortest_note)
		{
			case QUARTER:
				shortest_note_len = qtr_note;
			case EIGHTH:
				shortest_note_len = qtr_note / 2;
			case SIXTEENTH:
				shortest_note_len = qtr_note / 4;
		}
		initialized = true;
		started = false;
		if (retry)
		{
			if (!Debug.KEEP_SCORE)
			{
				score = chkpt_score;
			}
		}
		else
		{
			score = 0;
			chkpt_score = 0;
			num_deaths = 0;
			cumul_timer = 0;
			max_combo = 0;
			ex_score = 0;
			shots_landed = 0;
		}
		combo = 0;
	}

	public static function changeTickFormat(level_no:Int)
	{
		switch (level_no)
		{
			case 1:
				tick_format = [RED, RED, RED, RED];
			case 2:
				tick_format = [RED, PURPLE, RED, PURPLE, RED, PURPLE, RED, PURPLE];
			case 3:
				tick_format = [RED, PURPLE, RED, PURPLE, RED, PURPLE, RED, PURPLE];
			default:
		}
	}

	public static function setupSound(url:String, isIntro:Bool)
	{
		// var out:Howl = null;
		// var options:HowlOptions = {html5: true};
		// options.preload = true;
		// options.src = [url];
		// options.autoplay = false;
		// options.loop = !isIntro;
		// options.volume = 0.6;
		// if (isIntro)
		// {
		// 	options.onend = function(dummy:Int)
		// 	{
		// 		loopMusic();
		// 	};
		// }
		// out = new Howl(options);
		// return out;
	}

	public static function calculateFinalScore():Array<Int>
	{
		var time_bonus = Std.int(Math.max(quickest_time_bonus_val - Std.int(Math.max(cumul_timer - quickest_time_bonus, 0)) * time_bonus_penalty, 0));
		var acc = ex_score / 5 / shots_landed;
		var acc_bonus = Std.int(score * acc * 0.5);
		var combo_bonus = Std.int(Math.min(max_combo_bonus, max_combo) * (max_combo_bonus_value / max_combo_bonus));
		return [score, time_bonus, acc_bonus, combo_bonus];
	}

	/**
	 * Only plays from the beginning (internal timer starts from 0). Creates ticks as well. 
	 */
	public static function startMusic()
	{
		createTicks();
		started = true;
		bgm.play();
		// new FlxTimer().start((intro_beats + looping_beats) * qtr_note, loopMusic);
	}

	// public static function loopMusic()
	// {
	// 	bgm = bgm_loop;
	// 	bgm.play();
	// }

	/**
	 * Stops music, resets timer, and kills ticks (if `started == true`).
	 */
	public static function stopMusic()
	{
		if (started)
		{
			bgm.stop();
			timer = 0;
			started = false;
			loop_timer = 0;
			inIntro = true;
			// stoppedOnce = true;
			for (tick in _ticks)
			{
				tick.kill();
			}
		}
		initialized = false;
	}

	public static function update(elapsed:Float)
	{
		if (started)
		{
			timer += elapsed;
			cumul_timer += elapsed;
			loop_timer += elapsed;
			beat = timer / qtr_note;
			shortest_notes_elpsd = Math.floor(timer / shortest_note_len);
			updateTicks();
			if (loop_timer > (looping_beats + (inIntro ? intro_beats : 0)) * qtr_note)
			{
				loop_timer = 0;
				inIntro = false;
				bgm.play(true, intro_beats * qtr_note * 1000);
			}
		}
	}

	/**
	 * Call this whenever a player attack hits an enemy to update combo and score.
	 */
	public static function hitOnce()
	{
		score += Std.int(10 * (1 + 0.1 * Math.min(50, ++combo)));
		max_combo = Std.int(Math.max(max_combo, combo));
	}

	private static function createTicks()
	{
		// if (_ticks != null)
		// {
		// 	for (i in 0...(tick_format.length * 4))
		// 	{
		// 		_ticks[i].revive();
		// 		_ticks[i].setType(tick_format[i % tick_format.length]);
		// 		_ticks[i].setTick(i);
		// 		_ticks[i].setJudge(NONE);
		// 		_ticks[i].setEnchanted(Math.random() <= enchant_chance);
		// 		_ticks[i].x = Std.int((i * shortest_note_len - timer) * scroll_mul) + TICK_X_OFFSET;
		// 		_ticks[i].y = 0;
		// 		_ticks[i].scrollFactor.set(0, 0);
		// 	}
		// }
		// else
		// {
		// 	_ticks = new Array();
		// 	for (i in 0...(tick_format.length * 4))
		// 	{
		// 		var tick = new Tick(tick_format[i % tick_format.length], i, Math.random() <= enchant_chance,
		// 			Std.int((i * shortest_note_len - timer) * scroll_mul) + TICK_X_OFFSET, TIMELINE_BOTTOM - TIMELINE_TOP);
		// 		_ticks[i] = tick;
		// 		// tick.makeGraphic(20, TIMELINE_BOTTOM - TIMELINE_TOP, temp_color, true);
		// 		// tick.x = (i * shortest_note_len - timer) * scroll_mul;
		// 		// tick.y = -150;
		// 		tick.scrollFactor.set(0, 0);
		// 	}
		// }
		_ticks = new Array();
		for (i in 0...(tick_format.length * 4))
		{
			var tick = new Tick(tick_format[i % tick_format.length], i, Math.random() <= enchant_chance,
				Std.int((i * shortest_note_len - timer) * scroll_mul) + TICK_X_OFFSET, TIMELINE_BOTTOM - TIMELINE_TOP);
			_ticks[i] = tick;
			// tick.makeGraphic(20, TIMELINE_BOTTOM - TIMELINE_TOP, temp_color, true);
			// tick.x = (i * shortest_note_len - timer) * scroll_mul;
			// tick.y = -150;
			tick.scrollFactor.set(0, 0);
		}
	}

	private static function updateTicks()
	{
		for (i in _ticks)
		{
			i.x = (i.getTick() * shortest_note_len - timer) * scroll_mul + TICK_X_OFFSET;
		}
		if (shortest_notes_elpsd >= Std.int(_ticks.length / 2))
		{
			if (shortest_notes_elpsd > prev_sne)
			{
				var recycled_tick = _ticks[(shortest_notes_elpsd - Std.int(_ticks.length / 2)) % _ticks.length];
				// TESTING ONLY; TO BE CHANGED LATER WHEN ENCHANTED MARKUP IS CREATED
				// (also, enchanted has to be set before judge in order for enchant glow to show up properly)
				recycled_tick.setType(tick_format[
					((shortest_notes_elpsd - Std.int(_ticks.length / 2)) % _ticks.length) % tick_format.length
				]);
				recycled_tick.setEnchanted(Math.random() <= enchant_chance);
				recycled_tick.setJudge(NONE);
				recycled_tick.setTick(shortest_notes_elpsd + Std.int(_ticks.length / 2));
				debugTickDisplay();
			}
		}
	}

	private static function debugTickDisplay()
	{
		var output = "";
		for (i in _ticks)
		{
			output += " " + i.getTick();
			switch (i.getJudge())
			{
				case NONE:
					output += "N";
				case PERFECT:
					output += "P";
				case GREAT:
					output += "G";
				case OK:
					output += "O";
				default:
			}
			if (i.getEnchanted())
			{
				output += "#";
			}
		}
		trace(output);
	}
}
