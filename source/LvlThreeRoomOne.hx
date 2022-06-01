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

class LvlThreeRoomOne extends LevelState
{
	override public function create()
	{
		super.create();
		room_no = RoomNo.L3R1;
		FlxG.fixedTimestep = false;

		end_of_level = false;
		bgColor = 0xffcccccc;
		createLevel();
		nextLevel = LvlThreeRoomTwo;
		currLevel = LvlThreeRoomOne;

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
		map = new FlxOgmo3Loader(AssetPaths.map1__ogmo, AssetPaths.lvl3room1__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		interactables = map.loadTilemap(AssetPaths.tiles__png, "Interactables");
		add(walls);
		add(interactables);
		loadTutorial();
	}

	function loadTutorial()
	{
		final windBlastPopup = new WindBlastObtained();
		openSubState(windBlastPopup);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

class WindBlastObtained extends FlxSubState
{
	public function new()
	{
		super(0x61000000);
	}

	override public function create()
	{
		super.create();
		final boundingBox = new FlxSprite();
		boundingBox.makeGraphic(490, 230, 0xff428bbf);
		boundingBox.screenCenter(XY);
		boundingBox.x -= 140;
		add(boundingBox);

		final text = new FlxText(0, (boundingBox.y + 45), 0, "Wind Blast Obtained!", 25);
		text.screenCenter(X);
		text.x -= 140;
		add(text);

		final midTextOne = new FlxText(0, (boundingBox.y + 125), 0, "Attack precisely on the GREEN beats to fire a short-ranged cone attack!", 10);
		midTextOne.screenCenter(X);
		midTextOne.x -= 140;
		add(midTextOne);
		final midTextTwo = new FlxText(0, (boundingBox.y + 140), 0, "Enchanted ticks make the attack wider and more effective.", 10);
		midTextTwo.screenCenter(X);
		midTextTwo.x -= 140;
		add(midTextTwo);
		final midTextThree = new FlxText(0, (boundingBox.y + 175), 0, "TIP: This attack also knockbacks the player and enemies!", 10);
		midTextThree.screenCenter(X);
		midTextThree.x -= 140;
		add(midTextThree);
		final endText = new FlxText(0, (boundingBox.y + 200), 0, "Press SPACE to continue", 15);
		endText.screenCenter(X);
		endText.x -= 140;
		add(endText);

		final im = new FlxSprite();
		im.loadGraphic("assets/images/wind_blast_thumb.png", false, 48, 48, true);
		im.setGraphicSize(60, 60);
		im.x = 365;
		im.y = 320;
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
