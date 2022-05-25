package;

import IceLaser.LaserBeam;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxMouseSpring;
import flixel.addons.display.shapes.*;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

using flixel.math.FlxPoint;
using flixel.util.FlxSpriteUtil;

enum AttackType
{
	RED;
	PURPLE;
	GREEN;
	ENEMY;
}

enum NoteType
{
	QUARTER;
	EIGHTH;
	SIXTEENTH;
}

enum JudgeType
{
	NONE;
	PERFECT;
	GREAT;
	OK;
	MISFIRE;
}

class LevelState extends FlxState
{
	// MAP LOADER
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var interactables:FlxTilemap;

	// BASIC MECHANICS
	private var _player:Player;
	private var _healthbar:FlxBar;
	private var _energybar:FlxBar;
	private var h_bar_timer:Float;
	private var e_bar_timer:Float;
	private var _healthico:FlxSprite;
	private var _energyico:FlxSprite;
	private var _monsters:FlxTypedGroup<Enemy>;
	private var _projectiles:FlxTypedGroup<Projectile>;
	private var _doors:FlxTypedGroup<Door>;
	private var _rocks:FlxTypedGroup<Rock>;

	// NEXT LEVEL STATES
	var nextLevel:Class<LevelState>;
	var currLevel:Class<LevelState>;
	var lvlPopup:Bool;

	// where to put this?
	private var _music:FlxSound;

	// public var timer:Float;
	// public var beat:Float;
	// public var prev_beat:Int;
	// public var shortest_notes_elpsd:Int;
	// // value of shortest_notes_elpsd during last frame
	// public var prev_sne:Int;
	/*-----------------------------------------------------------------------------------------------
		- Ticks are stored in an array, all initialized to have no timing yet
		- As gameplay progresses, shortest_notes_elpsd serves as counter to which tick is the current one
		- Over time, ticks furthest away from the current tick in the array gets rewritten to have no
		timing and with a new tick #, so that the current tickin the array loops around
		----------------------------------------------------------------------------------------------- */
	// private var _ticks:Array<Tick>;
	// private var ticks_len:Int;
	private var timer_text:FlxText;
	private var timer_beats_text:FlxText;
	private var judge_text:FlxText; // to be replaced w/ own sprite
	private var health_text:FlxText;
	private var energy_text:FlxText;

	private var judge_sprite:FlxSprite;
	private var judge_timer:Float;
	private var combo_text:FlxText;
	// supposed boundaries of timeline display
	// private var TIMELINE_LEFT = 100;
	// private var TIMELINE_RIGHT = 1060;
	// private var TIMELINE_TOP = 0;
	// private var TIMELINE_BOTTOM = 50;
	// private var TICK_X_OFFSET = Std.int(FlxG.width / 2);
	private var timeline_box:FlxShapeBox;
	private var timeline_arw:FlxShapeArrow;
	// private var SCROLL_MUL = 350;
	private var beat_sound:FlxSound;
	private var fire_sound:FlxSound;
	private var hit_sound:FlxSound;
	private var kill_sound:FlxSound;
	private var fire_e_sound:FlxSound;
	private var DELAY = 0.066;

	// PURELY FOR TESTING
	private var ENCHANT_CHANCE:Float = 0.25;

	/**
	 * Level that this room belongs to. Default is 1; to be set by room files that extend this.
	 */
	public var level_no = 1;

	/**
	 * Room number, mainly for logging purposes. Default is 101 (first level, first room); to be set by room files that extend this.
	 */
	public var room_no = 101;

	/**
	 * Whether or not the player will spawn in this room after dying past this point (default is no).
	 */
	public var checkpoint = false;

	/**
	 * Whether or not this is the last room in the level (i.e. call the level complete window upon exiting if so).
	 */
	public var end_of_level = false;

	/* ------------------------------------------------------------------------------------------------------------------------
		In the final build, each level will have its
		own set format for which ticks will be enchanted
		that might look something like this:
		private var _enchanted_ticks:Array<Int>;
		private var intro_ticks_total:Int; // total number of ticks played over the intro of a song
		private var body_ticks_total:Int;  // same as above, but over the loopable section of the song
		_enchanted_ticks = [0, 2, 4, 5, 7, 13, ...];
		- in create():
		...
		for (i in 0...ticks_len)
		{
		  	_ticks[i] = new Tick(tick_format[i % tick_format.length], i, _enchanted_ticks.contains(i));
		}
		...
		- in update():
		...
		recycled_tick.setJudge(NONE);
		recycled_tick.setTick(shortest_notes_elpsd + Std.int(_ticks.length / 2));
		recycled_tick.setEnchanted(_enchanted_ticks.contains((shortest_notes_elapsed < intro_ticks_total + body_ticks_total ?
			shortest_notes_elapsed :
			(shortest_notes_elapsed - intro_ticks_total) % body_ticks_total + intro_ticks_total)));
		...
			 -------------------------------------------------------------------------------------------------------------------------- */
	// HUD
	private var _hud:HUD;

	// enemies can use this to tell the level state to spawn projectiles
	public var _actionSignal:FlxTypedSignal<Array<Float>->Void>;

	override function create()
	{
		super.create();
		FlxG.worldBounds.set(-65536, -65536, 65536 * 2, 65536 * 2);
		_player = new Player(50, 50);
		add(_player);
		FlxG.camera.follow(_player, 1);
		FlxG.camera.setPosition(0, 0);
		FlxG.camera.deadzone = new FlxRect(FlxG.camera.x + FlxG.width / 2 - _player.width / 2, FlxG.camera.y + 7 * FlxG.height / 12 - _player.height / 2,
			_player.width, _player.height);
		FlxG.camera.setSize(FlxG.width, FlxG.height);
		FlxG.autoPause = false;

		FlxG.mouse.load("assets/images/crosshair.png", 2, -13, -13);

		_monsters = new FlxTypedGroup<Enemy>();
		add(_monsters);

		_doors = new FlxTypedGroup<Door>();
		add(_doors);
		_rocks = new FlxTypedGroup<Rock>();
		add(_rocks);
		// vars to be loaded in by a file (or are unique to each level)
		// bpm = 130;
		// qtr_note = 60 / bpm;
		// shortest_note = QUARTER;
		// snpq = 1;
		// tick_format = [
		// 	LevelState.AttackType.RED,
		// 	LevelState.AttackType.RED,
		// 	LevelState.AttackType.RED,
		// 	LevelState.AttackType.RED,
		// ];
		// addTicks();
		createPlayerBars();
		// createTexts();

		_actionSignal = new FlxTypedSignal<Array<Float>->Void>();

		judge_sprite = new FlxSprite();
		add(judge_sprite);
		judge_sprite.visible = false;
		judge_timer = 0;
		combo_text = new FlxText(0, 0, 0, "Combo: 0");
		combo_text.font = "assets/PRESSSTART2P.TTF";
		combo_text.addFormat(new FlxTextFormat(FlxColor.WHITE, false, true, FlxColor.BLACK));
		combo_text.setBorderStyle(SHADOW, FlxColor.BLACK, 2);
		combo_text.visible = false;
		add(combo_text);
		beat_sound = FlxG.sound.load("assets/sounds/beat.wav");
		beat_sound.volume = 0.3;
		hit_sound = FlxG.sound.load("assets/sounds/hit.mp3");
		hit_sound.volume = 0.2;
		kill_sound = FlxG.sound.load("assets/sounds/kill.mp3");
		kill_sound.volume = 0.7;
		fire_sound = FlxG.sound.load("assets/sounds/fire.mp3");
		fire_sound.volume = 0.4;
		fire_e_sound = FlxG.sound.load("assets/sounds/fire_e.mp3");
		fire_e_sound.volume = 0.2;
		lvlPopup = false;
		startMusicSub();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		handleKeyboard();
		judge_timer -= elapsed;
		judge_sprite.visible = judge_timer >= 0;
		judge_sprite.x = _player.x - 100;
		judge_sprite.y = _player.y + 50;
		judge_sprite.setGraphicSize(0, 10);
		combo_text.text = "Combo: " + LevelStats.combo;
		combo_text.visible = LevelStats.combo >= 5;
		combo_text.x = _player.x - 100;
		combo_text.y = _player.y + 70;
		_healthbar.value = _player.health;
		_energybar.value = _player.getEnergy();
		_healthico.x = _player.x - 130;
		_healthico.y = _player.y + 16;
		_energyico.x = _player.x - 130;
		_energyico.y = _player.y + 30;
		if (_healthbar.value == 100)
		{
			h_bar_timer += elapsed;
			if (h_bar_timer > 3)
			{
				_healthbar.visible = false;
				_healthico.visible = false;
			}
		}
		else
		{
			h_bar_timer = 0;
			_healthbar.visible = true;
			_healthico.visible = true;
		}
		if (_energybar.value == 100)
		{
			e_bar_timer += elapsed;
			if (e_bar_timer > 3)
			{
				_energybar.visible = false;
				_energyico.visible = false;
			}
		}
		else
		{
			e_bar_timer = 0;
			_energybar.visible = true;
			_energyico.visible = true;
		}

		// updateDebugTexts();

		// updateTicks();
		// for (i in LevelStats._ticks)
		// {
		// 	i.x = (i.getTick() * LevelStats.shortest_note_len - LevelStats.timer) * LevelStats.scroll_mul + LevelStats.TICK_X_OFFSET;
		// }
		_monsters.forEach(handleMonsterActions);
		// _projectiles.forEach(handleProjectileRaycasts);
		if (_monsters.countLiving() <= 0)
		{
			for (d in _doors)
			{
				d.unlock();
			}
			// disabling for now
			// if (!lvlPopup && currLevel == RoomEight)
			// {
			// 	final lvlCompPop = new LvlCompletePopup();
			// 	openSubState(lvlCompPop);
			// 	lvlPopup = true;
			// }
		}

		while (_rocks.countLiving() > 50)
		{
			var min_r = _rocks.getFirstAlive();
			for (r in _rocks)
			{
				if (r.age < min_r.age)
				{
					min_r = r;
				}
			}
			min_r.kill();
			_rocks.remove(min_r);
		}

		if (!_player.exists)
		{
			LevelStats.stopMusic();
			FlxG.camera.fade(FlxColor.BLACK, 1.5, false, () ->
			{
				removeTicks();
				FlxG.switchState(new EndGame(currLevel, room_no));
			});
		}

		// TODO: this could potentially be split into different methods that update the hud only when
		// necessary, not every frame call
		callUpdateHUD();
		shoot();
		for (proj in _projectiles)
		{
			if (proj.getType() != ENEMY)
			{
				var closest_mons = get_closest_monster(proj.x, proj.y, _monsters);
				proj.update_target(closest_mons);
				// if (proj.getType() == LevelState.AttackType.PURPLE)
				// {
				// 	handleProjectileRaycasts(cast(proj, IceLaser));
				// }
			}
		}
		FlxG.overlap(_monsters, _player, handleMonsterPlayerOverlap);
		FlxG.overlap(_player, _projectiles, handlePlayerProjectileCollisions);
		FlxG.overlap(_monsters, _projectiles, handleMonsterProjectileCollisions);
		FlxG.collide(_monsters, walls);
		FlxG.collide(_monsters, interactables);
		FlxG.collide(_projectiles, walls, handleProjectileWallsCollisions);
		FlxG.collide(_projectiles, _doors, handleProjectileWallsCollisions);
		FlxG.collide(_player, _doors, levelComplete);
		FlxG.collide(_monsters, _doors);
		FlxG.collide(_projectiles, _doors);
		FlxG.overlap(_rocks, _projectiles, handleRockProjectileOverlap);
		FlxG.collide(_rocks, walls);
		FlxG.collide(_rocks, _player, handlePlayerRockCollision);
		FlxG.collide(_rocks, _monsters, handleMonsterRockCollision);
		FlxG.collide(_rocks, _doors);
		FlxG.collide(_rocks, _rocks);
		super.update(elapsed);
		FlxG.collide(_player, walls);
		LevelStats.update(elapsed);
		// timer += elapsed;
		// beat += elapsed / qtr_note;
		// number of notes of smallest denomination that have elapsed so far
		// shortest_notes_elpsd = Math.floor(timer / shortest_note_len);
		if (LevelStats.shortest_notes_elpsd > LevelStats.prev_sne)
		{
			if (LevelStats.shortest_notes_elpsd % LevelStats.snpq == 0)
			{
				if (Debug.PLAY_BEAT)
				{
					playBeat();
				}
				_hud.flashBeatLight();
			}
			if (LevelStats.shortest_notes_elpsd % LevelStats.tick_format.length == 0)
			{
				_player.barRegen();
			}
		}

		LevelStats.prev_sne = LevelStats.shortest_notes_elpsd; // this must always be last thing in update()
	}

	private function handleKeyboard()
	{
		Logger.checkTimeout();
		if (FlxG.keys.anyPressed([ESCAPE]))
		{
			LevelStats.bgm.pause();
			if (LevelStats.started)
			{
				openSubState(new PauseMenu(FlxColor.BLACK, removeTicks));
			}
			else
			{
				openSubState(new PauseMenu(FlxColor.BLACK));
			}
		}
	}

	private function createPlayerBars()
	{
		_healthbar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, _player, "health", 0, 100, true);
		_healthbar.createFilledBar(FlxColor.RED, FlxColor.GREEN, true);
		_healthbar.trackParent(-120, 20);
		h_bar_timer = 0;
		add(_healthbar);
		_energybar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, _player, "_energy", 0, 100, true);
		_energybar.createFilledBar(FlxColor.RED, FlxColor.BLUE, true);
		_energybar.trackParent(-120, 30);
		e_bar_timer = 0;
		add(_energybar);
		_healthico = new FlxSprite(_player.x - 130, _player.y + 16);
		_healthico.loadGraphic("assets/images/health.png");
		_healthico.scale.set(0.75, 0.75);
		add(_healthico);
		_energyico = new FlxSprite(_player.x - 130, _player.y + 30);
		_energyico.loadGraphic("assets/images/energy.png");
		_energyico.scale.set(0.75, 0.75);
		add(_energyico);
	}

	private function createHUDandTicks()
	{
		map.loadEntities(placeEntities, "player");
		map.loadEntities(placeEntities, "monsters");
		map.loadEntities(placeEntities, "mechanics");
		_projectiles = new FlxTypedGroup<Projectile>();
		add(_projectiles);

		if (currLevel != RoomOne)
		{
			_hud = new HUD(_player, LevelStats.tick_format, LevelStats.shortest_note_len);
			_hud.updateHUD(100, 100);
			add(_hud);
			addTicks();
		}

		if (LevelStats.adapted)
		{
			for (m in _monsters)
			{
				m._dps *= 0.8;
				m.BASE_SPEED *= 0.9;
				m.health *= 0.8;
			}
		}
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				_player.setPosition(entity.x, entity.y);
			case "bat":
				_monsters.add(new Bat(entity.x, entity.y, _player, walls));
			case "not_octorok":
				_monsters.add(new NotOctorok(entity.x, entity.y, _player, walls));
			case "door":
				_doors.add(new Door(entity.x, entity.y, true));
			case "locked_door":
				_doors.add(new Door(entity.x, entity.y, false));
			case "cat_boss":
				_monsters.add(new Cat(entity.x, entity.y, _player, _actionSignal));
			case "goblin":
				_monsters.add(new Goblin(entity.x, entity.y, _player, walls));
			case "water_strider":
				_monsters.add(new WaterStrider(entity.x, entity.y, _player, walls));
			case "slime":
				_monsters.add(new Slime(entity.x, entity.y, _player, walls));
			case "rock":
				_rocks.add(new Rock(entity.x, entity.y));
			case "alligator":
				_monsters.add(new Alligator(entity.x, entity.y, _player, walls));
			default:
		}
	}

	private function get_closest_monster(x:Float, y:Float, monsters:FlxTypedGroup<Enemy>):Enemy
	{
		var closest = new FlxPoint(0, 0);
		var dist:Float;
		var min_dist = Math.POSITIVE_INFINITY;
		var monster = null;
		for (mons in monsters)
		{
			if (mons.alive)
			{
				dist = Math.sqrt((mons.x - x) * (mons.x - x) + (mons.y - y) * (mons.y - y));
				if (dist < min_dist && walls.ray(FlxPoint.weak(x, y), mons.getMidpoint()))
				{
					min_dist = dist;
					closest = new FlxPoint(mons.x, mons.y);
					monster = mons;
				}
			}
		}
		return monster;
	}

	private function get_closest_projectile(x:Float, y:Float, projectiles:FlxTypedGroup<Projectile>, type:AttackType):Projectile
	{
		var closest = new FlxPoint(0, 0);
		var dist:Float;
		var min_dist = Math.POSITIVE_INFINITY;
		var projectile = null;
		for (p in projectiles)
		{
			if (p.getType() == type && p.alive)
			{
				dist = Math.sqrt((p.x - x) * (p.x - x) + (p.y - y) * (p.y - y));
				if (dist < min_dist)
				{
					min_dist = dist;
					closest = new FlxPoint(p.x, p.y);
					projectile = p;
				}
			}
		}
		return projectile;
	}

	private function handleRockProjectileOverlap(r:Rock, p:Projectile)
	{
		var mag = FlxVector.weak(p.velocity.x, p.velocity.y).length;
		r.velocity.set(r.speed * p.velocity.x / mag, r.speed * p.velocity.y / mag);
		r.deadlyToPlayer = true;
		r.deadlyToMonster = true;
		if (p.getType() == PURPLE)
		{
			var temp = _player.getMidpoint();
			var laserGraphic:FlxSprite = new LaserBeam(temp.x, temp.y, temp.distanceTo(p.getMidpoint()), cast(p, IceLaser).deg);
			add(laserGraphic);
		}
		p.kill();
	}

	private function handlePlayerRockCollision(r:Rock, p:Player)
	{
		if (p.isVuln() && r.deadlyToPlayer)
		{
			LevelStats.combo = 0;
			p.health -= r.damage;
			p.damageInvuln();
			Logger.tookDamage(r, r.damage);
			if (p.health <= 0)
			{
				Logger.playerDeath(r);
				p.kill();
			}
			r.kill();
		}
	}

	private function handleMonsterRockCollision(r:Rock, e:Enemy)
	{
		if (r.deadlyToMonster)
		{
			e.health -= r.damage;
			if (e.health <= 0)
			{
				switch (Type.typeof(e))
				{
					case TClass(Slime):
						for (i in 0...2)
						{
							for (j in 0...2)
							{
								_monsters.add(new SmallSlime(e.x + i * cast(e, Enemy).getSize() / 2, e.y + j * cast(e, Enemy).getSize() / 2, _player, walls));
							}
						}
					default:
				}
				_monsters.remove(cast(e, Enemy));
				e.kill();
				kill_sound.play();
				LevelStats.score += cast(e, Enemy).value;
			}
			else
			{
				var m = cast(e, Enemy);
				FlxSpriteUtil.flicker(m, m.DMG_FLICKER);
				hit_sound.play();
			}
			r.kill();
		}
	}

	private function handleMonsterProjectileCollisions(monsters:FlxObject, projectiles:Projectile)
	{
		if (projectiles.getType() != ENEMY && !projectiles.hit_enemies.contains(monsters))
		{
			projectiles.hit_enemies.push(monsters);
			monsters.health -= projectiles.getDamage();
			if (monsters.health <= 0)
			{
				switch (Type.typeof(monsters))
				{
					case TClass(Slime):
						for (i in 0...2)
						{
							for (j in 0...2)
							{
								_monsters.add(new SmallSlime(monsters.x + i * cast(monsters, Enemy).getSize() / 2,
									monsters.y + j * cast(monsters, Enemy).getSize() / 2, _player, walls));
							}
						}
					default:
				}
				_monsters.remove(cast(monsters, Enemy));
				monsters.kill();
				kill_sound.play();
				LevelStats.score += cast(monsters, Enemy).value;
			}
			else
			{
				var m = cast(monsters, Enemy);
				FlxSpriteUtil.flicker(m, m.DMG_FLICKER);
				hit_sound.play();
			}
			if (projectiles.getType() == PURPLE)
			{
				// var mons_speed:Float = cast(monsters, Enemy).getSpeed();
				cast(monsters, Enemy).ice_slowed = Math.max(cast(projectiles, IceLaser).slowed, cast(monsters, Enemy).ice_slowed);
				// cast(monsters, Enemy).setSpeed(mons_speed * cast(projectiles, IceLaser).slowed);
				// var slowTimer:FlxTimer = new FlxTimer();
				// slowTimer.start(0.25, function(Timer:FlxTimer)
				// {
				// 	cast(monsters, Enemy).setSpeed(mons_speed);
				// }, 1);
				var temp = _player.getMidpoint();
				var laserGraphic:FlxSprite = new LaserBeam(temp.x, temp.y, temp.distanceTo(projectiles.getMidpoint()), cast(projectiles, IceLaser).deg);
				add(laserGraphic);
			}
			if (!(projectiles.getType() == PURPLE && projectiles._enchanted))
			{
				projectiles.kill();
			}
			if (projectiles.hit_enemies.length == 1)
			{
				LevelStats.hitOnce(projectiles._timing);
			}
		}
	}

	private function handleProjectileWallsCollisions(projectiles:Projectile, walls:FlxTilemap)
	{
		if (projectiles.getType() == PURPLE)
		{
			var temp = _player.getMidpoint();
			var laserGraphic:FlxSprite = new LaserBeam(temp.x, temp.y, temp.distanceTo(projectiles.getMidpoint()), cast(projectiles, IceLaser).deg);
			add(laserGraphic);
		}
		projectiles.kill();
	}

	private function handleMonsterActions(e:Enemy)
	{
		if (e.shouldFire())
		{
			var src = "From ";
			if (Std.isOfType(e, NotOctorok))
			{
				src += "NotOctorok";
			}
			else if (Std.isOfType(e, WaterStrider))
			{
				src += "WaterStrider";
			}
			else if (Std.isOfType(e, Alligator))
			{
				src += "Alligator";
			}
			else
			{
				src += "unknown";
			}
			switch (src)
			{
				case "From WaterStrider":
					for (angle in 0...24)
					{
						var dir = FlxVelocity.velocityFromAngle(angle * 15, 50);
						var tar = e.getMidpoint().add(dir.x, dir.y);
						_projectiles.add(new StriderShockwave(e.getMidpoint().x, e.getMidpoint().y, null, tar, src, 100));
					}
				case "From Alligator":
					if (cast(e, Alligator).isRapidFiring())
					{
						var rock = new Rock(e.getMidpoint().x, e.getMidpoint().y);
						_rocks.add(rock);
						rock.deadlyToPlayer = true;
						FlxVelocity.moveTowardsPoint(rock, _player.getMidpoint(), rock.speed);
					}
					else if (Random.int(0, 1) == 0)
					{
						for (angle in -3...4)
						{
							var rock = new Rock(e.getMidpoint().x, e.getMidpoint().y);
							_rocks.add(rock);
							rock.deadlyToPlayer = true;
							FlxVelocity.moveTowardsPoint(rock, _player.getMidpoint(), rock.speed);
							rock.velocity.rotate(FlxPoint.weak(0, 0), angle * 10);
						}
					}
					else
					{
						cast(e, Alligator).startRapidFire();
					}
				default:
					_projectiles.add(new EnemyBullet(e.getMidpoint().x, e.getMidpoint().y, _player, null, src));
			}
			// _projectiles.add(new Projectile(e.getMidpoint().x, e.getMidpoint().y, _player, ENEMY, PERFECT, false, src));
		}
		if (e.getDodgeType() != null)
		{
			e.dodge(get_closest_projectile(e.x, e.y, _projectiles, e.getDodgeType()));
		}
	}

	private function handleMonsterPlayerOverlap(e:Enemy, p:Player)
	{
		if (p.isVuln())
		{
			LevelStats.combo = 0;
			p.health -= e.getDamage();
			p.damageInvuln();
			Logger.tookDamage(e, e.getDamage());
			if (p.health <= 0)
			{
				Logger.playerDeath(e);
				p.kill();
			}
		}
	}

	private function handlePlayerProjectileCollisions(p:Player, proj:Projectile)
	{
		if (proj.getType() == ENEMY && (!proj.precise || FlxCollision.pixelPerfectCheck(proj, p, 200)))
		{
			if (p.isVuln())
			{
				LevelStats.combo = 0;
				p.health -= proj.getDamage();
				p.damageInvuln();
				Logger.tookDamage(proj.src, proj.getDamage());
				if (p.health <= 0)
				{
					Logger.playerDeath(proj);
					p.kill();
				}
			}
			proj.kill();
		}
	}

	private function startMusic() {}

	/**
	 * Function updating values pertaining to level values (i.e. can't be called on this create(); has to be called after setting up)
	 */
	private function levelUpdate()
	{
		Logger.startLevel(room_no);
		LevelStats.curr_level = Std.int(room_no / 100);
		LevelStats.curr_room = room_no % 100;

		if (RoomNo.CHKPTS[Std.int(room_no / 100)].contains(room_no))
		{
			LevelStats.chkpt = Type.getClass(this);
			LevelStats.chkpt_no = room_no;
			LevelStats.chkpt_score = LevelStats.score;
		}
		LevelStats.save_data.data.levels_seen[Std.int(room_no / 100)] = true;
		LevelStats.save_data.flush();
	}

	private function shoot()
	{
		Logger.checkTimeout();
		// TODO: change up accounting for energy
		if (_player.alive && (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight || FlxG.keys.justPressed.SPACE))
		{
			LevelStats.shots_fired++;
			var closest_tick = get_closest_tick();
			if (closest_tick == null)
			{
				// judge_text.text = "Misfire...";
				judge_sprite.loadGraphic("assets/images/judge_sprites/misfire.png");
				_player.useEnergy(10); // miscost use; TODO: doesn't deduct if out of energy?
				/*----------------------
					MISFIRE LOGIC GOES HERE
					---------------------- */
				LevelStats.ex_score = Std.int(Math.max(0, LevelStats.ex_score - 1));
				Logger.playerShot("Misfire", "Misfire", "x");
				LevelStats.combo = 0;
			}
			else
			{
				var diff = Math.abs(closest_tick.getTick() * LevelStats.shortest_note_len - LevelStats.timer) - DELAY;
				trace(diff);
				trace(closest_tick.getTick());
				var timing = getTiming(diff);

				var proj:Projectile;
				if (closest_tick.getType() == LevelState.AttackType.RED)
				{
					proj = new MagMissile(_player.x, _player.y, _monsters.getFirstAlive(), timing, closest_tick.getEnchanted() && timing == PERFECT);
					proj.timer.start(2.0, function(Timer:FlxTimer)
					{
						proj.kill();
					}, 1);
					_projectiles.add(proj);
				}
				else // if (closest_tick.getType() == LevelState.AttackType.PURPLE)
				{
					proj = shootLaser(_monsters.getFirstAlive(), timing, closest_tick.getEnchanted() && timing == PERFECT, _player.getMidpoint());
				}

				var energy_used = proj.getEnergy();

				if (!(closest_tick.getEnchanted() && diff <= LevelStats.PERFECT_WINDOW)
					&& !_player.useEnergy(energy_used)) // TODO: cost is only for red attack; implement logic
				{
					// judge_text.text = "Out of energy!";
					judge_sprite.loadGraphic("assets/images/judge_sprites/ooe.png");
					Logger.playerShot("OOE", "OOE", Std.string(diff));
				}
				else
				{
					var judge:String;
					if (diff <= LevelStats.PERFECT_WINDOW)
					{
						// judge_text.text = "Perfect!!";
						judge_sprite.loadGraphic("assets/images/judge_sprites/perfect.png");
						judge = "Perfect";
						// timing = LevelState.JudgeType.PERFECT;
						closest_tick.setJudge(LevelState.JudgeType.PERFECT);
						if (closest_tick.getEnchanted())
						{
							// judge_text.text += "#";
						}
					}
					else if (diff <= LevelStats.GREAT_WINDOW)
					{
						// judge_text.text = "Great!";
						judge_sprite.loadGraphic("assets/images/judge_sprites/great.png");
						judge = "Great";
						// timing = LevelState.JudgeType.GREAT;
						closest_tick.setJudge(LevelState.JudgeType.GREAT);
					}
					else
					{ // diff <= LevelStats.OK_WINDOW
						// judge_text.text = "OK";
						judge_sprite.loadGraphic("assets/images/judge_sprites/ok.png");
						judge = "OK";
						// timing = LevelState.JudgeType.OK;
						closest_tick.setJudge(LevelState.JudgeType.OK);
					}

					fire_sound.play();
					if (closest_tick.getEnchanted() && judge == "Perfect")
					{
						fire_e_sound.play();
					}
					Logger.playerShot(Std.string(closest_tick.getType()), judge, Std.string(diff));
				}
			}
			judge_sprite.visible = true;
			judge_timer = 2.0;
		}
	}

	private function getTiming(diff:Float)
	{
		if (diff <= LevelStats.PERFECT_WINDOW)
		{
			return LevelState.JudgeType.PERFECT;
		}
		else if (diff <= LevelStats.GREAT_WINDOW)
		{
			return LevelState.JudgeType.GREAT;
		}
		else
		{
			return LevelState.JudgeType.OK;
		}
	}

	private function get_closest_tick():Tick
	{
		var i = 0;
		// grab the tick that comes immediately before when the user fires and the tick that
		// comes immediately after (both must not have already been used), if available
		// to decide which tick to compare the player's fire to
		var earlier_beat = null;
		while (LevelStats.shortest_notes_elpsd - i >= 0
			&& LevelStats.timer - (LevelStats.shortest_notes_elpsd - i) * LevelStats.shortest_note_len <= LevelStats.OK_WINDOW)
		{
			var curr = LevelStats._ticks[(LevelStats.shortest_notes_elpsd - i) % LevelStats._ticks.length];
			if (curr.getJudge() == NONE)
			{
				earlier_beat = curr;
				break;
			}
			i++;
		}
		i = 1;
		var later_beat = null;
		while ((LevelStats.shortest_notes_elpsd + i) * LevelStats.shortest_note_len - LevelStats.timer <= LevelStats.OK_WINDOW)
		{
			var curr = LevelStats._ticks[(LevelStats.shortest_notes_elpsd + i) % LevelStats._ticks.length];
			if (curr.getJudge() == NONE)
			{
				later_beat = curr;
				break;
			}
			i++;
		}
		if (earlier_beat == null && later_beat == null)
		{
			return null;
		}
		if (later_beat == null)
		{
			return earlier_beat;
		}
		if (earlier_beat == null)
		{
			return later_beat;
		}
		return LevelStats.timer
			- earlier_beat.getTick() * LevelStats.shortest_note_len <= later_beat.getTick() * LevelStats.shortest_note_len - LevelStats.timer ? earlier_beat : later_beat;
	}

	private function shootLaser(target:FlxObject, timing:JudgeType, enchanted:Bool, source:FlxPoint)
	{
		// var ground:Float = FlxG.height - 100;
		// var source:FlxPoint = _player.getMidpoint();
		var mouse:FlxPoint = FlxG.mouse.getPosition();
		var deg:Float = source.angleBetween(mouse) - 90;
		// var groundPoint = FlxPoint.get(source.x + (ground - source.y) / Math.tan(deg * FlxAngle.TO_RAD), ground); // Work on this
		// source.distanceTo(groundPoint);

		var laserTimer:FlxTimer = new FlxTimer();
		var eighthNote = 60 / (2 * LevelStats.bpm);

		var laser:IceLaser = makeLaser(source, target, timing, enchanted, deg);

		laserTimer.start(eighthNote / 3, function(Timer:FlxTimer)
		{
			// makeLaser(source, target, timing, enchanted, deg);
			makeLaser(_player.getMidpoint(), target, timing, enchanted, source.angleBetween(FlxG.mouse.getPosition()) - 90);
		}, 2);

		return laser;
	}

	private function makeLaser(source:FlxPoint, target:FlxObject, timing:JudgeType, enchanted:Bool, deg:Float)
	{
		var length:Float = 1000;
		var laser:IceLaser = new IceLaser(source.x, source.y, target, timing, enchanted, deg);
		_projectiles.add(laser);
		// var laserGraphic:FlxSprite = new LaserBeam(source.x, source.y, length, deg);
		// add(laserGraphic);
		return laser;
	}

	// private function debugTickDisplay()
	// {
	// 	var output = "";
	// 	for (i in _ticks)
	// 	{
	// 		output += " " + i.getTick();
	// 		switch (i.getJudge())
	// 		{
	// 			case NONE:
	// 				output += "N";
	// 			case PERFECT:
	// 				output += "P";
	// 			case GREAT:
	// 				output += "G";
	// 			case OK:
	// 				output += "O";
	// 			default:
	// 		}
	// 		if (i.getEnchanted())
	// 		{
	// 			output += "#";
	// 		}
	// 	}
	// 	trace(output);
	// }
	// private function setShortestNote()
	// {
	// 	switch (shortest_note)
	// 	{
	// 		case QUARTER:
	// 			ticks_len = 16;
	// 			shortest_note_len = qtr_note;
	// 		case EIGHTH:
	// 			ticks_len = 32;
	// 			shortest_note_len = qtr_note / 2;
	// 		case SIXTEENTH:
	// 			ticks_len = 64;
	// 			shortest_note_len = qtr_note / 4;
	// 	}
	// }
	// private function createTicks()
	// {
	// 	_ticks = new Array();
	// 	for (i in 0...(LevelStats.tick_format.length * 4))
	// 	{
	// 		var tick = new Tick(LevelStats.tick_format[i % LevelStats.tick_format.length], i, Math.random() <= ENCHANT_CHANCE,
	// 			Std.int((i * LevelStats.shortest_note_len - LevelStats.timer) * LevelStats.scroll_mul) + LevelStats.TICK_X_OFFSET,
	// 			LevelStats.TIMELINE_BOTTOM - LevelStats.TIMELINE_TOP);
	// 		_ticks[i] = tick;
	// 		// tick.makeGraphic(20, TIMELINE_BOTTOM - TIMELINE_TOP, temp_color, true);
	// 		// tick.x = (i * shortest_note_len - timer) * SCROLL_MUL;
	// 		// tick.y = -150;
	// 		add(tick);
	// 		tick.scrollFactor.set(0, 0);
	// 	}
	// }

	private function createTexts()
	{
		timer_text = new FlxText(-300, 0, 500);
		timer_text.text = "Time elapsed: " + LevelStats.timer;
		timer_text.setFormat("assets/font.ttf", 20, FlxColor.WHITE, LEFT);
		timer_text.setBorderStyle(OUTLINE, FlxColor.RED, 1);
		timer_beats_text = new FlxText(-300, 100, 500);
		timer_beats_text.text = "Beats elapsed: " + LevelStats.timer;
		timer_beats_text.setFormat("assets/font.ttf", 20, FlxColor.WHITE, LEFT);
		timer_beats_text.setBorderStyle(OUTLINE, FlxColor.RED, 1);
		judge_text = new FlxText(-300, 200, 500);
		judge_text.setFormat("assets/font.ttf", 20, FlxColor.YELLOW, LEFT);
		health_text = new FlxText(-300, 300, 500);
		health_text.text = "Health: " + _player.health;
		health_text.setFormat("assets/font.ttf", 20, FlxColor.WHITE, LEFT);
		health_text.setBorderStyle(OUTLINE, FlxColor.GREEN, 1);
		energy_text = new FlxText(-300, 400, 500);
		energy_text.text = "Energy: " + _player.getEnergy();
		energy_text.setFormat("assets/font.ttf", 20, FlxColor.WHITE, LEFT);
		energy_text.setBorderStyle(OUTLINE, FlxColor.BLUE, 1);
		add(timer_text);
		add(timer_beats_text);
		add(judge_text);
		add(health_text);
		add(energy_text);
	}

	private function updateDebugTexts()
	{
		timer_text.text = "Time elapsed: " + LevelStats.timer;
		timer_beats_text.text = "Beats elapsed: " + LevelStats.timer / LevelStats.qtr_note;
		health_text.text = (_player.health > 0 ? "Health: " + _player.health : "Health: dead");
		energy_text.text = "Energy: " + _player.getEnergy();
	}

	/**
	 * Call this whenever the current ROOM (not level) is completed with the player
	 * touching the door.
	 * @param p 
	 * @param d 
	 */
	function levelComplete(p:Player, d:Door)
	{
		if (d.isUnlocked())
		{
			if (LevelStats._ticks != null)
			{
				removeTicks();
			}
			if (end_of_level)
			{
				lvlPopup = true;
				openSubState(new LvlCompletePopup(finishComplete));
			}
			else
			{
				finishComplete();
			}
		}
	}

	function finishComplete()
	{
		if (nextLevel == null)
		{
			Logger.levelEnd("game completion exit");
			LevelStats.stopMusic();
			FlxG.switchState(new MenuState());
		}
		else
		{
			Logger.levelEnd("to next level");
			// Logger.nextRoom(nextLevel);
			if (end_of_level)
			{
				LevelStats.stopMusic();
				LevelStats.initialize(Std.int(room_no / 100) + 1, false);
			}
			FlxG.switchState(Type.createInstance(nextLevel, []));
		}
	}

	// function updateTicks()
	// {
	// 	for (i in _ticks)
	// 	{
	// 		i.x = (i.getTick() * shortest_note_len - timer) * SCROLL_MUL + TICK_X_OFFSET;
	// 	}
	// 	if (shortest_notes_elpsd >= Std.int(_ticks.length / 2))
	// 	{
	// 		if (shortest_notes_elpsd > prev_sne)
	// 		{
	// 			var recycled_tick = _ticks[(shortest_notes_elpsd - Std.int(_ticks.length / 2)) % _ticks.length];
	// 			// TESTING ONLY; TO BE CHANGED LATER WHEN ENCHANTED MARKUP IS CREATED
	// 			// (also, enchanted has to be set before judge in order for enchant glow to show up properly)
	// 			recycled_tick.setEnchanted(Math.random() <= ENCHANT_CHANCE);
	// 			recycled_tick.setJudge(NONE);
	// 			recycled_tick.setTick(shortest_notes_elpsd + Std.int(_ticks.length / 2));
	// 			debugTickDisplay();
	// 		}
	// 	}
	// }
	public override function toString():String
	{
		return Type.getClassName(Type.getClass(this));
	}

	/**
	 * Must be called at the creation of every room.
	 */
	public function addTicks()
	{
		for (i in LevelStats._ticks)
		{
			add(i);
		}
	}

	/**
	 * Must be called when exiting the room for any reason (e.g. game over, exiting via pause, level complete)
	 */
	public function removeTicks()
	{
		for (i in LevelStats._ticks)
		{
			remove(i);
		}
	}

	public function callUpdateHUD()
	{
		_hud.updateHUD(_player.health, _player.getEnergy());
	}

	public function playBeat()
	{
		beat_sound.play();
	}

	/**
	 * Necessary for rooms w/o music to override with empty func.
	 */
	private function startMusicSub()
	{
		if (!LevelStats.started)
		{
			LevelStats.startMusic();
		}
	}
}

class LvlCompletePopup extends FlxSubState
{
	// private var _timebar:FlxBar;
	// private var timer:FlxTimer;
	private var signal:FlxSignal;

	public function new(call:() -> Void)
	{
		signal = new FlxSignal();
		signal.add(call);
		super(0x61000000);
	}

	override public function create()
	{
		super.create();
		final boundingBox = new FlxSprite();
		boundingBox.makeGraphic(600, 400, 0xff428bbf);
		boundingBox.screenCenter(XY);
		boundingBox.scrollFactor.set(0, 0);
		add(boundingBox);

		final text = new FlxText(0, (boundingBox.y + 45), 0, "Level Complete!", 35);
		text.screenCenter(X);
		text.scrollFactor.set(0, 0);
		add(text);

		var res = LevelStats.calculateFinalScore();
		final level_score = new FlxText(boundingBox.x + 10, boundingBox.y + 90, 0, "Level Score ", 25);
		level_score.scrollFactor.set(0, 0);
		add(level_score);
		final level_score_val = new FlxText(boundingBox.x + 10, boundingBox.y + 90, 580, Std.string(res[0]), 25);
		level_score_val.alignment = RIGHT;
		level_score_val.scrollFactor.set(0, 0);
		add(level_score_val);

		final time_bonus = new FlxText(boundingBox.x + 10, level_score.y + 30, 0, "Time bonus ", 25);
		time_bonus.scrollFactor.set(0, 0);
		add(time_bonus);

		final time_bonus_val = new FlxText(boundingBox.x + 10, level_score_val.y + 30, 580, Std.string(res[1]), 25);
		time_bonus_val.alignment = RIGHT;
		time_bonus_val.scrollFactor.set(0, 0);
		add(time_bonus_val);

		final acc_bonus = new FlxText(boundingBox.x + 10, time_bonus.y + 30, 0, "Accuracy bonus ", 25);
		acc_bonus.scrollFactor.set(0, 0);
		add(acc_bonus);

		final acc_bonus_val = new FlxText(boundingBox.x + 10, time_bonus_val.y + 30, 580, Std.string(res[2]), 25);
		acc_bonus_val.alignment = RIGHT;
		acc_bonus_val.scrollFactor.set(0, 0);
		add(acc_bonus_val);

		final combo_bonus = new FlxText(boundingBox.x + 10, acc_bonus.y + 30, 0, "Combo bonus ", 25);
		combo_bonus.scrollFactor.set(0, 0);
		add(combo_bonus);

		final combo_bonus_val = new FlxText(boundingBox.x + 10, acc_bonus_val.y + 30, 580, Std.string(res[3]), 25);
		combo_bonus_val.alignment = RIGHT;
		combo_bonus_val.scrollFactor.set(0, 0);
		add(combo_bonus_val);

		final final_score = new FlxText(boundingBox.x + 10, combo_bonus.y + 50, 0, "Total score ", 35);
		final_score.scrollFactor.set(0, 0);
		add(final_score);

		var score_value = res[0] + res[1] + res[2] + res[3];
		final final_score_val = new FlxText(boundingBox.x + 10, combo_bonus_val.y + 50, 580, Std.string(score_value), 35);
		final_score_val.alignment = RIGHT;
		final_score_val.scrollFactor.set(0, 0);
		add(final_score_val);

		LevelStats.save_data.data.high_scores[LevelStats.curr_level] = score_value;
		LevelStats.save_data.data.hidden_high_scores[LevelStats.curr_level] = Std.int(score_value * Math.pow(0.9, LevelStats.num_deaths));
		LevelStats.save_data.flush();
		Logger.scoreGet(score_value, LevelStats.num_deaths);
		var text = LevelStats.TIPS[LevelStats.curr_level];
		if (text != "")
		{
			final tipText = new FlxText(0, final_score.y + 50, 0, "TIP: " + LevelStats.TIPS[LevelStats.curr_level], 10);
			tipText.screenCenter(X);
			tipText.scrollFactor.set(0, 0);
			add(tipText);
		}
		final endText = new FlxText(0, final_score.y + 65, 0, "Press SPACE to continue.", 15);
		endText.screenCenter(X);
		endText.scrollFactor.set(0, 0);
		add(endText);

		// _timebar = new FlxBar(350, 430, HORIZONTAL_INSIDE_OUT, 400, 10, null, "time", 0, 300, true);
		// _timebar.screenCenter(X);
		// _timebar.createFilledBar(0xff428bbf, FlxColor.WHITE, true);
		// _timebar.scrollFactor.set(0, 0);
		// add(_timebar);

		// timer = new FlxTimer();
		// timer.start(3, function(Timer:FlxTimer)
		// {
		// 	close();
		// }, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE)
		{
			close();
			signal.dispatch();
		}
		// _timebar.value = cast(timer.timeLeft * 100);
	}
}

class EndGame extends FlxState
{
	private var _title:FlxText;
	private var _tryAgainBtn:FlxButton;
	private var _menuBtn:FlxButton;
	private var currLevel:Class<LevelState>;
	private var room_no:Int;

	/**
	 * Yeah
	 * @param thisLevel 
	 * @param r_no Have to include the room number cause apparently `Class<LevelState> has no field room_no` :/ 
	 */
	override public function new(thisLevel:Class<LevelState>, r_no:Int)
	{
		currLevel = thisLevel;
		room_no = r_no;
		super();
	}

	override function create()
	{
		super.create();
		bgColor = 0x00000000;
		_title = new FlxText(0, 120, 0, "GAME OVER", 48);
		_title.alignment = CENTER;
		_title.screenCenter(X);
		add(_title);
		_title.scrollFactor.set(0, 0);

		_menuBtn = new FlxButton(0, 0, "Exit to Main Menu", () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.checkTimeout();
				Logger.levelEnd("game over exit");
				FlxG.switchState(new MenuState());
			});
		});
		_menuBtn.scale.set(3, 3);
		_menuBtn.updateHitbox();
		_menuBtn.label.fieldWidth = _menuBtn.width;
		_menuBtn.label.alignment = "center";
		_menuBtn.label.offset.y -= 20;
		_menuBtn.screenCenter(Y);
		_menuBtn.x = (FlxG.width / 2) - (_menuBtn.width / 2) + 200;
		add(_menuBtn);

		_tryAgainBtn = new FlxButton(0, 0, "Try Again", () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 1.00, false, () ->
			{
				Logger.checkTimeout();
				// // by default, respawn at beginning of current level
				// var respawn = (Std.int(room_no / 100) * 100) + 1;
				// for (r in respawn...room_no)
				// {
				// 	if (RoomNo.CHKPTS[Std.int(room_no / 100)].contains(r))
				// 	{
				// 		respawn = Std.int(Math.max(respawn, r));
				// 	}
				// }
				var respawn = (Debug.RESPAWN_AT_SAME_ROOM ? currLevel : LevelStats.chkpt);
				var respawn_no = (Debug.RESPAWN_AT_SAME_ROOM ? room_no : LevelStats.chkpt_no);
				Logger.startLevel(respawn_no, "retry");
				LevelStats.initialize(Std.int(respawn_no / 100), true);
				// LevelStats.initialize(Std.int(chkpt_no / 100), true);
				if (respawn != RoomOne)
				{
					LevelStats.startMusic();
				}
				FlxG.switchState(Type.createInstance(respawn, []));
			});
		});
		_tryAgainBtn.scale.set(3, 3);
		_tryAgainBtn.updateHitbox();
		_tryAgainBtn.label.fieldWidth = _tryAgainBtn.width;
		_tryAgainBtn.label.alignment = "center";
		_tryAgainBtn.label.offset.y -= 20;
		_tryAgainBtn.screenCenter(Y);
		_tryAgainBtn.x = (FlxG.width / 2) - (_tryAgainBtn.width / 2) - 200;
		add(_tryAgainBtn);
	}
}
