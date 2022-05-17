import LevelState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.*;
import flixel.addons.display.shapes.FlxShapeArrow;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	private var _health:FlxText;
	private var _hp_bar:FlxBar;
	private var _energy:FlxText;
	private var timeline_box:FlxShapeBox;
	private var _timeline_arw:FlxShapeBox; // FlxShapeArrow;
	private var _ticks:Array<Tick>;
	private var _boss_hp:FlxBar;

	// supposed boundaries of timeline display
	private var TIMELINE_LEFT = 100;
	private var TIMELINE_RIGHT = 1060;
	private var TIMELINE_TOP = 0;
	private var TIMELINE_BOTTOM = FlxG.height / 6;
	private var ENCHANT_CHANCE:Float = 0.25;
	private var SCROLL_MUL = 350;

	public function new(player:Player, tick_format:Array<AttackType>, shortest_note_len:Float)
	{
		super();
		// TODO: do we need another health and energy bar below the timeline (always on screen) when they're already
		// two near the player?
		_health = new FlxText(200, 650, 0, "Health: ", 10);
		_health.setFormat("assets/font.ttf", 20, FlxColor.WHITE, LEFT);
		_health.setBorderStyle(OUTLINE, FlxColor.GREEN, 1);
		add(_health);

		_energy = new FlxText(400, 650, 0, "Energy: ", 10);
		_energy.setFormat("assets/font.ttf", 20, FlxColor.WHITE, LEFT);
		_energy.setBorderStyle(OUTLINE, FlxColor.BLUE, 1);
		add(_energy);

		var lineStyle:LineStyle = {color: FlxColor.BLACK /**FlxColor.RED**/, thickness: 1};

		timeline_box = new FlxShapeBox(0, 0, FlxG.width, TIMELINE_BOTTOM - TIMELINE_TOP, lineStyle, FlxColor.GRAY);
		// timeline_box = new FlxShapeBox(TIMELINE_LEFT, TIMELINE_TOP, TIMELINE_RIGHT - TIMELINE_LEFT, TIMELINE_BOTTOM - TIMELINE_TOP, lineStyle, FlxColor.BLACK);
		// timeline_box.alpha = 0.2;
		add(timeline_box);

		var line_style_2 = {color: FlxColor.BLACK, thickness: 1.0}; // 4.0};
		// _timeline_arw = new FlxShapeArrow(FlxG.width / 2, 100, new FlxPoint(10, 50), new FlxPoint(10, 0), 15, line_style_2);
		_timeline_arw = new FlxShapeBox(FlxG.width / 2, 0, 10, TIMELINE_BOTTOM - TIMELINE_TOP, line_style_2, FlxColor.BLACK);
		add(_timeline_arw);

		forEach((sprite:FlxSprite) -> sprite.scrollFactor.set(0, 0));
	}

	public function updateHUD(health:Float, energy:Float)
	{
		if (health > 0)
		{
			_health.text = 'Health: ${health}';
		}
		else
		{
			_health.text = 'Health: DEAD';
		}

		_energy.text = 'Energy: ${energy}';

		if (_boss_hp != null) {}
	}

	// boss hp bar will only appear when in a specific room designated as a boss arena
	// (mostly blocked until boss is implemented)
	public function spawnBossBar()
	{
		_boss_hp = new FlxBar(0, 100, LEFT_TO_RIGHT);
	}
}
