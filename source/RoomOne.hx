import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

class RoomOne extends LevelState
{
	override public function create()
	{
		super.create();
		FlxG.fixedTimestep = false;
		// createLogger();
		bgColor = 0xffcccccc;
		createLevel();
		nextLevel = RoomTwo;
		map.loadEntities(placeEntities, "player");
		map.loadEntities(placeEntities, "monsters");
		map.loadEntities(placeEntities, "mechanics");
		_projectiles = new FlxTypedGroup<Projectile>();
		add(_projectiles);
	}

	function createLevel()
	{
		map = new FlxOgmo3Loader(AssetPaths.map1__ogmo, AssetPaths.room1__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		interactables = map.loadTilemap(AssetPaths.tiles__png, "Interactables");
		add(walls);
		add(interactables);
		loadTutorial();
	}

	function loadTutorial()
	{
		var WASD = new FlxSprite(70, 200);
		WASD.loadGraphic("assets/images/WASD.png", false, 80, 64, true);
		add(WASD);
		var instr = new FlxText(50, 260, 0, "TO MOVE AROUND", 10);
		instr.setFormat("assets/font.ttf", 20, FlxColor.RED, LEFT);
		instr.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(instr);
	}

	override public function update(elapsed:Float)
	{
		_healthbar.value = _player.health;
		_energybar.value = _player.getEnergy();
		if (_healthbar.value == 100)
		{
			h_bar_timer += elapsed;
			if (h_bar_timer > 3)
			{
				_healthbar.visible = false;
			}
		}
		else
		{
			h_bar_timer = 0;
			_healthbar.visible = true;
		}
		if (_energybar.value == 100)
		{
			e_bar_timer += elapsed;
			if (e_bar_timer > 3)
			{
				_energybar.visible = false;
			}
		}
		else
		{
			e_bar_timer = 0;
			_energybar.visible = true;
		}

		// TODO: this could potentially be split into different methods that update the hud only when
		// necessary, not every frame call
		shoot();
		for (proj in _projectiles)
		{
			if (proj.getType() != ENEMY)
			{
				var closest_mons = get_closest_monster(proj.x, proj.y, _monsters);
				proj.update_target(closest_mons);
				if (proj.getType() == LevelState.AttackType.PURPLE)
				{
					handleProjectileRaycasts(cast(proj, IceLaser));
				}
			}
		}

		_monsters.forEach(handleMonsterFire);
		// _projectiles.forEach(handleProjectileRaycasts);

		FlxG.overlap(_monsters, _player, handleMonsterPlayerOverlap);
		FlxG.collide(_player, _projectiles, handlePlayerProjectileCollisions);
		FlxG.overlap(_monsters, _projectiles, handleMonsterProjectileCollisions);
		FlxG.collide(_monsters, walls);
		FlxG.collide(_projectiles, walls, handleProjectileWallsCollisions);
		super.update(elapsed);
		FlxG.collide(_player, walls);
	}

	// disabled mechanics for first room
	override private function shoot() {}

	override function addTicks() {}

	override function callUpdateHUD() {}

	override function playBeat() {}

	// override function updateTicks() {}
}
