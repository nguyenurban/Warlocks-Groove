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

class RoomEight extends LevelState
{
	override public function create()
	{
		super.create();
		room_no = RoomNo.L1R8;
		FlxG.fixedTimestep = false;

		bgColor = 0xffcccccc;
		createLevel();
		nextLevel = LvlTwoRoomOne;
		currLevel = RoomEight;

		// beat_sound = FlxG.sound.load("assets/sounds/beat.wav");
		// beat_sound.volume = 0.3;

		// setShortestNote();

		// var line_style_2 = {color: FlxColor.BLACK, thickness: 3.0};
		// timeline_arw = new FlxShapeArrow(-5, -50, new FlxPoint(10, 50), new FlxPoint(10, 0), 15, line_style_2);
		// add(timeline_arw);
		// var draw_style = {smoothing: true};

		// level_bounds = FlxCollision.createCameraWall(FlxG.camera, true, 1);
		createHUDandTicks();
		var boss = null;
		for (m in _monsters)
		{
			if (m.alive)
			{
				boss = m;
			}
		}
		_hud.spawnBossBar(boss);
		_actionSignal.add(handleCall);
		// timer = 0;
		// beat = 0;
		// shortest_notes_elpsd = 0;
		// prev_sne = 0;
		// FlxG.sound.playMusic("assets/music/test.mp3", 0.6, true);
	}

	function createLevel()
	{
		map = new FlxOgmo3Loader(AssetPaths.map1__ogmo, AssetPaths.room8__json);
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

	public function handleCall(input:Array<Float>)
	{
		switch (input[0])
		{
			case 0:
				// TODO: replace this with proper own projectile
				_projectiles.add(new EnemyBullet(input[1], input[2], _player, _player.getMidpoint(), "FB from Cat", 120.0));
			case 1:
				_projectiles.add(new LargeBullet(input[1], input[2], _player, _player.getMidpoint(), "Large from Cat", 200.0));
			case 2:
				_projectiles.add(new WaveBullet(input[1], input[2], _player, _player.getMidpoint(), "Wave from Cat", 155.0));
			default:
		}
	}

	private override function handleMonsterProjectileCollisions(monsters:FlxObject, projectiles:Projectile)
	{
		if (projectiles.getType() != ENEMY)
		{
			if (Std.isOfType(monsters, Cat))
			{
				var cat = cast(monsters, Cat);
				if (cat.shielded)
				{
					if (projectiles._enchanted)
					{
						cat.curr_shield_hp--;
						if (cat.curr_shield_hp == 0)
						{
							cat.shieldBreaking();
							// other shield-breaking code goes here
						}
					}
					else
					{
						// shield deflecting projectile logic goes here
					}
				}
				else
				{
					monsters.health -= projectiles.getDamage();
					if (monsters.health <= 0)
					{
						_monsters.remove(cast(monsters, Enemy));
						monsters.kill();
					}
					projectiles.kill();
					trace("projectile kill initiated");
				}
			}
			monsters.health -= projectiles.getDamage();
			if (monsters.health <= 0)
			{
				_monsters.remove(cast(monsters, Enemy));
				monsters.kill();
			}
			projectiles.kill();
			trace("projectile kill initiated");
		}
	}
}
