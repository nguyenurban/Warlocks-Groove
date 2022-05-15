import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class RoomTwo extends LevelState
{
	var metronome:Enemy;

	override public function create()
	{
		super.create();
		FlxG.fixedTimestep = false;

		bgColor = 0xffcccccc;
		createLevel();
		nextLevel = RoomThree;
		map.loadEntities(placeEntities, "player");
		map.loadEntities(placeEntities, "monsters");
		map.loadEntities(placeEntities, "mechanics");
		_projectiles = new FlxTypedGroup<Projectile>();
		add(_projectiles);

		beat_sound = FlxG.sound.load("assets/sounds/beat.wav");
		beat_sound.volume = 0.3;

		// setShortestNote();

		// var line_style_2 = {color: FlxColor.BLACK, thickness: 3.0};
		// timeline_arw = new FlxShapeArrow(-5, -50, new FlxPoint(10, 50), new FlxPoint(10, 0), 15, line_style_2);
		// add(timeline_arw);
		// var draw_style = {smoothing: true};

		// level_bounds = FlxCollision.createCameraWall(FlxG.camera, true, 1);
		_hud = new HUD(_player, LevelStats.tick_format, LevelStats.shortest_note_len);
		_hud.updateHUD(100, 100);
		add(_hud);

		// timer = 0;
		// beat = 0;
		// shortest_notes_elpsd = 0;
		// prev_sne = 0;
		// FlxG.sound.playMusic("assets/music/test.mp3", 0.6, true);
	}

	function createLevel()
	{
		map = new FlxOgmo3Loader(AssetPaths.map1__ogmo, AssetPaths.room2__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		interactables = map.loadTilemap(AssetPaths.tiles__png, "Interactables");
		add(walls);
		add(interactables);
		loadTutorial();
		metronome = new Metronome(350, 15, _player);
		_monsters.add(metronome);
		var metro_health = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, metronome, "health", 0, 15, true);
		metro_health.createFilledBar(FlxColor.RED, FlxColor.GREEN, true);
		metro_health.trackParent(-10, 50);
		add(metro_health);
	}

	function loadTutorial()
	{
		var mouse = new FlxSprite(70, 200);
		mouse.loadGraphic("assets/images/mouse.png", false, 80, 64, true);
		add(mouse);
		var instr = new FlxText(50, 360, 0, "FIRE ON BEAT", 10);
		instr.setFormat("assets/font.ttf", 20, FlxColor.RED, LEFT);
		instr.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(instr);
		final MagMissilePopup = new MagMissileObtained();
		openSubState(MagMissilePopup);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(_player, metronome);
	}
}

// TODO: metronome needs opaque hitbox
class Metronome extends Enemy
{
	private var _timer:Float;
	private var beat:Int;
	private var prev_beat:Int;
	private var QTR_BEAT = 130 / 60;

	public function new(x:Float, y:Float, target:Player)
	{
		super(x, y, target);
		// Set stats here
		health = 15;
		_speed = 0;
		_dps = 0;
		_timer = 0;
		beat = 0;
		prev_beat = 0;
		immovable = true;
		loadGraphic("assets/images/metronome.png", true, 400, 400);
		setGraphicSize(64, 64);
		updateHitbox();

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("idle", [0, 1, 2, 3], 2, false);
	}

	override function update(elapsed:Float)
	{
		_timer += elapsed;
		beat = Std.int(_timer / QTR_BEAT);
		if (beat > prev_beat)
		{
			animation.play("idle", beat % 4);
		}
		super.update(elapsed);
		// animation.play("idle");
		prev_beat = beat;
	}
}

class MagMissileObtained extends FlxSubState
{
	public function new()
	{
		super(0x61000000);
	}

	override public function create()
	{
		super.create();
		final boundingBox = new FlxSprite();
		boundingBox.makeGraphic(460, 197, 0xff428bbf);
		boundingBox.screenCenter(XY);
		add(boundingBox);

		final text = new FlxText(0, (boundingBox.y + 45), 0, "Magic Missile Obtained!", 25);
		text.screenCenter(X);
		add(text);

		final endText = new FlxText(0, (boundingBox.y + 135), 0, "Press SPACE to continue", 15);
		endText.screenCenter(X);
		add(endText);

		final im = new FlxSprite();
		im.loadGraphic("assets/images/magic_missile.png", false, 80, 64, true);
		im.setGraphicSize(48, 28);
		im.x = 260;
		im.y = 210;
		add(im);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE)
		{
			close();
		}
	}
}
