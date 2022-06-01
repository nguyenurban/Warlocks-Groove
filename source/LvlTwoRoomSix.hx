import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
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

class LvlTwoRoomSix extends LevelState
{
	override public function create()
	{
		super.create();
		room_no = RoomNo.L2R6;
		FlxG.fixedTimestep = false;

		bgColor = 0xffcccccc;
		createLevel();
		nextLevel = LvlTwoRoomSeven;
		currLevel = LvlTwoRoomSix;

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
		map = new FlxOgmo3Loader(AssetPaths.map1__ogmo, AssetPaths.lvl2room6__json);
		if (LevelStats.hard_mode)
		{
			map = new FlxOgmo3Loader(AssetPaths.map1__ogmo, AssetPaths.lvl2room6hard__json);
		}
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		interactables = map.loadTilemap(AssetPaths.tiles__png, "Interactables");
		add(walls);
		add(interactables);
		// loadTutorial();
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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
