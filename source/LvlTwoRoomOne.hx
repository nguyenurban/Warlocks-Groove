import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.shapes.*;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import howler.Howl;
import howler.Howler;
import js.html.idb.Factory;

using flixel.util.FlxSpriteUtil;

class LvlTwoRoomOne extends LevelState
{
	override public function create()
	{
		super.create();
		room_no = RoomNo.L2R1;
		LevelStats.changeTickFormat(2);
		LevelStats.bgm.pause();
		FlxG.fixedTimestep = false;

		bgColor = 0xffcccccc;
		createLevel();
		nextLevel = LvlTwoRoomTwo;
		currLevel = LvlTwoRoomOne;

		// beat_sound = FlxG.sound.load("assets/sounds/beat.wav");
		// beat_sound.volume = 0.3;

		// setShortestNote();

		// var line_style_2 = {color: FlxColor.BLACK, thickness: 3.0};
		// timeline_arw = new FlxShapeArrow(-5, -50, new FlxPoint(10, 50), new FlxPoint(10, 0), 15, line_style_2);
		// add(timeline_arw);
		// var draw_style = {smoothing: true};

		// level_bounds = FlxCollision.createCameraWall(FlxG.camera, true, 1);
		createHUDandTicks();
		levelUpdate();

		// timer = 0;
		// beat = 0;
		// shortest_notes_elpsd = 0;
		// prev_sne = 0;
		// FlxG.sound.playMusic("assets/music/test.mp3", 0.6, true);
	}

	function createLevel()
	{
		map = new FlxOgmo3Loader(AssetPaths.map1__ogmo, AssetPaths.lvl2room1__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		interactables = map.loadTilemap(AssetPaths.tiles__png, "Interactables");
		add(walls);
		add(interactables);
		loadTutorial();
	}

	function loadTutorial()
	{
		final iceLaserPopup = new IceLaserObtained();
		openSubState(iceLaserPopup);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

class IceLaserObtained extends FlxSubState
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
		boundingBox.x -= 140;
		add(boundingBox);

		final text = new FlxText(0, (boundingBox.y + 45), 0, "Ice Laser Obtained!", 25);
		text.screenCenter(X);
		text.x -= 140;
		add(text);

		final midTextOne = new FlxText(0, (boundingBox.y + 120), 0, "Attack precisely on the PURPLE beats to fire a long-ranged instaneous laser!", 10);
		midTextOne.screenCenter(X);
		midTextOne.x -= 140;
		add(midTextOne);
		final midTextTwo = new FlxText(0, (boundingBox.y + 135), 0, "Best used for particularly slippery enemies.", 10);
		midTextTwo.screenCenter(X);
		midTextTwo.x -= 140;
		add(midTextTwo);
		final endText = new FlxText(0, (boundingBox.y + 150), 0, "Press SPACE to continue", 15);
		endText.screenCenter(X);
		endText.x -= 140;
		add(endText);

		final im = new FlxSprite();
		im.loadGraphic("assets/images/laser.png", false, 80, 64, true);
		im.setGraphicSize(48, 28);
		im.x = 400;
		im.y = 360;
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
