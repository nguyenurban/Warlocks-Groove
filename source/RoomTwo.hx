import flixel.FlxG;
import flixel.FlxObject;
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
	var metro_health:FlxBar;
	private var perfect_count = 0;
	private var hit_count = 0;

	override public function create()
	{
		super.create();
		room_no = RoomNo.L1R2;
		LevelStats.bgm.pause();
		FlxG.fixedTimestep = false;

		bgColor = 0xffcccccc;
		createLevel();
		nextLevel = RoomThree;
		currLevel = RoomTwo;

		// LevelStats.startMusic();
		beat_sound = FlxG.sound.load("assets/sounds/beat.wav");
		beat_sound.volume = 0.3;
		createHUDandTicks();
		levelUpdate();
		// setShortestNote();

		// var line_style_2 = {color: FlxColor.BLACK, thickness: 3.0};
		// timeline_arw = new FlxShapeArrow(-5, -50, new FlxPoint(10, 50), new FlxPoint(10, 0), 15, line_style_2);
		// add(timeline_arw);
		// var draw_style = {smoothing: true};

		// level_bounds = FlxCollision.createCameraWall(FlxG.camera, true, 1);

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
		metronome = new Metronome(355, 25, _player);
		_monsters.add(metronome);
		metro_health = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, metronome, "health", 0, 15, true);
		metro_health.createFilledBar(FlxColor.RED, FlxColor.GREEN, true);
		metro_health.trackParent(-20, 50);
		add(metro_health);
	}

	function loadTutorial()
	{
		var WASD = new FlxSprite(70, 200);
		WASD.loadGraphic("assets/images/WASD.png", false, 80, 64, true);
		WASD.setGraphicSize(120, 96);
		add(WASD);
		var instr_wasd = new FlxText(40, 280, 0, "to Move Around", 10);
		instr_wasd.setFormat("assets/font.ttf", 30, FlxColor.WHITE, LEFT);
		instr_wasd.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(instr_wasd);
		var mouse = new FlxSprite(70, 350);
		mouse.loadGraphic("assets/images/mouse.png", false, 80, 64, true);
		add(mouse);
		var instr = new FlxText(50, 510, 0, "Fire on Beat", 10);
		instr.setFormat("assets/font.ttf", 30, FlxColor.WHITE, LEFT);
		instr.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(instr);
		final MagMissilePopup = new MagMissileObtained();
		openSubState(MagMissilePopup);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!metronome.alive)
		{
			metro_health.kill();
		}
		FlxG.collide(_player, metronome);
	}

	override public function handleMonsterProjectileCollisions(monster:FlxObject, projectile:Projectile)
	{
		super.handleMonsterProjectileCollisions(monster, projectile);
		if (projectile._timing == LevelState.JudgeType.PERFECT)
		{
			perfect_count++;
		}
		hit_count++;
	}

	override public function levelComplete(p:Player, d:Door)
	{
		LevelStats.hard_mode = perfect_count / hit_count >= 0.6;
		super.levelComplete(p, d);
	}
}

// TODO: metronome needs opaque hitbox
class Metronome extends Enemy
{
	private var _timer:Float;
	private var beat:Int;
	private var prev_beat:Int;
	private var QTR_BEAT = 130 / 60;

	public var perfect_count = 0;
	public var hit_count = 0;

	public function new(x:Float, y:Float, target:Player)
	{
		super(x, y, target);
		// Set stats here
		health = 15;
		BASE_SPEED = 0;
		_dps = 0;
		_timer = 0;
		beat = 0;
		prev_beat = 0;
		immovable = true;
		pellet_drop = 0;
		pd_25_combo = 0;
		pd_100_combo = 0;
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
		boundingBox.makeGraphic(460, 250, 0xff428bbf);
		boundingBox.screenCenter(XY);
		boundingBox.x -= 140;
		add(boundingBox);

		final text = new FlxText(0, (boundingBox.y + 25), 0, "Magic Missile Obtained!", 25);
		text.screenCenter(X);
		text.x -= 140;
		add(text);

		final midTextOne = new FlxText(0, (boundingBox.y + 120), 0, "Attack precisely on beat to fire a powerful homing missile", 10);
		midTextOne.screenCenter(X);
		midTextOne.x -= 140;
		add(midTextOne);
		final midTextTwo = new FlxText(0, (boundingBox.y + 135), 0, "to destroy enemies and reach the goal door!", 10);
		midTextTwo.screenCenter(X);
		midTextTwo.x -= 140;
		add(midTextTwo);
		final midTextThree = new FlxText(0, boundingBox.y + 150, 0, "The better the timing, the more powerful.", 10);
		midTextThree.screenCenter(X);
		midTextThree.x -= 140;
		add(midTextThree);
		final midTextFour = new FlxText(0, boundingBox.y + 180, 0, "Tip: Getting a Perfect rating on ticks with green auras", 10);
		midTextFour.screenCenter(X);
		midTextFour.x -= 140;
		add(midTextFour);
		final midTextFive = new FlxText(0, boundingBox.y + 195, 0, "will make it even more powerful!", 10);
		midTextFive.screenCenter(X);
		midTextFive.x -= 140;
		add(midTextFive);
		final endText = new FlxText(0, (boundingBox.y + 220), 0, "Press SPACE to continue", 15);
		endText.screenCenter(X);
		endText.x -= 140;
		add(endText);

		final im = new FlxSprite();
		im.loadGraphic("assets/images/magic_missile.png", false, 80, 64, true);
		im.setGraphicSize(48, 28);
		im.x = 120;
		im.y = 160;
		add(im);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE)
		{
			// LevelStats.startMusic();
			close();
			LevelStats.bgm.resume();
		}
	}
}
