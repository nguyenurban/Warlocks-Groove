package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.shapes.*;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSignal.FlxTypedSignal;
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

	// to be loaded in by a stage's own file
	// private var bpm:Float;
	// private var qtr_note:Float;
	// private var shortest_note:LevelState.NoteType;
	// // shortest notes per quarter note
	// private var snpq:Int;
	// private var shortest_note_len:Float;
	// each stage will have layout of ticks specified over one measure
	// e.g. stage 1: [r, r, r, r]
	// stage 2: [r, p, r, p, r, p, r, p]
	// etc...
	// private var tick_format:Array<LevelState.AttackType>;
	// also most likely to be stored somewhere else
	private var PERFECT_WINDOW:Float = 2 / 60;
	private var GREAT_WINDOW:Float = 6 / 60;
	// currently valued such that double-clicking on 1st stage won't cause a misfire
	// perhaps this value can change by stage
	private var OK_WINDOW:Float = 20 / 60;

	// PURELY FOR TESTING
	private var ENCHANT_CHANCE:Float = 0.25;

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
		if (judge_timer <= 0)
		{
			judge_sprite.visible = false;
		}
		judge_sprite.x = _player.x - 100;
		judge_sprite.y = _player.y + 50;
		judge_sprite.setGraphicSize(0, 10);
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

		if (!_player.exists)
		{
			LevelStats.stopMusic();
			FlxG.camera.fade(FlxColor.BLACK, 1.5, false, () ->
			{
				removeTicks();
				FlxG.switchState(new EndGame(currLevel));
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
				if (proj.getType() == LevelState.AttackType.PURPLE)
				{
					handleProjectileRaycasts(cast(proj, IceLaser));
				}
			}
		}
		FlxG.overlap(_monsters, _player, handleMonsterPlayerOverlap);
		FlxG.collide(_player, _projectiles, handlePlayerProjectileCollisions);
		FlxG.overlap(_monsters, _projectiles, handleMonsterProjectileCollisions);
		FlxG.collide(_monsters, walls);
		FlxG.collide(_monsters, interactables);
		FlxG.collide(_projectiles, walls, handleProjectileWallsCollisions);
		FlxG.collide(_projectiles, _doors, handleProjectileWallsCollisions);
		FlxG.collide(_player, _doors, levelComplete);
		FlxG.collide(_monsters, _doors);
		FlxG.collide(_projectiles, _doors);
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
				playBeat();
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

	private function handleMonsterProjectileCollisions(monsters:FlxObject, projectiles:Projectile)
	{
		if (projectiles.getType() != ENEMY)
		{
			monsters.health -= projectiles.getDamage();
			if (monsters.health <= 0)
			{
				_monsters.remove(cast(monsters, Enemy));
				monsters.kill();
				kill_sound.play();
			}
			else
			{
				var m = cast(monsters, Enemy);
				FlxSpriteUtil.flicker(m, m.DMG_FLICKER);
				hit_sound.play();
			}
			projectiles.kill();
			trace("projectile kill initiated");
		}
	}

	private function handleProjectileWallsCollisions(projectiles:Projectile, walls:FlxTilemap)
	{
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
			else
			{
				src += "unknown";
			}
			_projectiles.add(new EnemyBullet(e.getMidpoint().x, e.getMidpoint().y, _player, null, src));
			// _projectiles.add(new Projectile(e.getMidpoint().x, e.getMidpoint().y, _player, ENEMY, PERFECT, false, src));
		}
		if (e.getDodgeType() != null)
		{
			e.dodge(get_closest_projectile(e.x, e.y, _projectiles, e.getDodgeType()));
		}
	}

	private function handleMonsterPlayerOverlap(e:Enemy, p:Player)
	{
		if (p.isInvuln())
		{
			p.health -= e.getDamage();
			p.damageInvuln();
			Logger.tookDamage(this, e, e.getDamage());
			if (p.health <= 0)
			{
				Logger.playerDeath(this, e);
				p.kill();
			}
		}
	}

	private function handlePlayerProjectileCollisions(p:Player, proj:Projectile)
	{
		if (proj.getType() == ENEMY && p.isInvuln())
		{
			p.health -= proj.getDamage();
			p.damageInvuln();
			Logger.tookDamage(this, proj.src, proj.getDamage());
			if (p.health <= 0)
			{
				Logger.playerDeath(this, proj);
				p.kill();
			}
			proj.kill();
		}
	}

	private function startMusic() {}

	private function shoot()
	{
		// TODO: change up accounting for energy
		if (_player.alive && (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight || FlxG.keys.justPressed.SPACE))
		{
			var closest_tick = get_closest_tick();
			if (closest_tick == null)
			{
				// judge_text.text = "Misfire...";
				judge_sprite.loadGraphic("assets/images/judge_sprites/misfire.png");
				_player.useEnergy(10); // miscost use; TODO: doesn't deduct if out of energy?
				/*----------------------
					MISFIRE LOGIC GOES HERE
					---------------------- */
				Logger.playerShot("Misfire", "Misfire", "x");
			}
			else
			{
				var timing;
				var diff = Math.abs(closest_tick.getTick() * LevelStats.shortest_note_len - LevelStats.timer) - DELAY;
				trace(diff);
				trace(closest_tick.getTick());
				if (!(closest_tick.getEnchanted() && diff <= PERFECT_WINDOW)
					&& !_player.useEnergy(15)) // TODO: cost is only for red attack; implement logic
				{
					// judge_text.text = "Out of energy!";
					judge_sprite.loadGraphic("assets/images/judge_sprites/ooe.png");
					Logger.playerShot("OOE", "OOE", Std.string(diff));
				}
				else
				{
					var judge:String;
					if (diff <= PERFECT_WINDOW)
					{
						// judge_text.text = "Perfect!!";
						judge_sprite.loadGraphic("assets/images/judge_sprites/perfect.png");
						judge = "Perfect";
						timing = LevelState.JudgeType.PERFECT;
						closest_tick.setJudge(LevelState.JudgeType.PERFECT);
						if (closest_tick.getEnchanted())
						{
							// judge_text.text += "#";
						}
					}
					else if (diff <= GREAT_WINDOW)
					{
						// judge_text.text = "Great!";
						judge_sprite.loadGraphic("assets/images/judge_sprites/great.png");
						judge = "Great";
						timing = LevelState.JudgeType.GREAT;
						closest_tick.setJudge(LevelState.JudgeType.GREAT);
					}
					else
					{ // diff <= OK_WINDOW
						// judge_text.text = "OK";
						judge_sprite.loadGraphic("assets/images/judge_sprites/ok.png");
						judge = "OK";
						timing = LevelState.JudgeType.OK;
						closest_tick.setJudge(LevelState.JudgeType.OK);
					}

					// var mousePos = FlxG.mouse.getPosition();
					var proj:Projectile;
					if (closest_tick.getType() == LevelState.AttackType.RED)
					{
						proj = new MagMissile(_player.x, _player.y, _monsters.getFirstAlive(), timing, closest_tick.getEnchanted() && timing == PERFECT);
					}
					else // if (closest_tick.getType() == LevelState.AttackType.PURPLE)
					{
						proj = new IceLaser(_player.x, _player.y, _monsters.getFirstAlive(), timing, closest_tick.getEnchanted() && timing == PERFECT);
					}
					proj.timer.start(2.0, function(Timer:FlxTimer)
					{
						// proj.canvas.exists = false;
						proj.kill();
					}, 1);
					_projectiles.add(proj);
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

	private function get_closest_tick():Tick
	{
		var i = 0;
		// grab the tick that comes immediately before when the user fires and the tick that
		// comes immediately after (both must not have already been used), if available
		// to decide which tick to compare the player's fire to
		var earlier_beat = null;
		while (LevelStats.shortest_notes_elpsd - i >= 0
			&& LevelStats.timer - (LevelStats.shortest_notes_elpsd - i) * LevelStats.shortest_note_len <= OK_WINDOW)
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
		while ((LevelStats.shortest_notes_elpsd + i) * LevelStats.shortest_note_len - LevelStats.timer <= OK_WINDOW)
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

	private function handleProjectileRaycasts(p:IceLaser)
	{
		cast(p, IceLaser);
		if (p.canvas == null)
		{
			p.canvas = new FlxSprite();
			p.canvas.makeGraphic(4096, 4096, FlxColor.TRANSPARENT, true);
			add(p.canvas);
		}
		var line_style_2 = {color: FlxColor.BLUE, thickness: 3.0};
		var drawStyle:DrawStyle = {smoothing: true};
		p.canvas.drawLine(p.origin_point.x, p.origin_point.y, p.x + 2, p.y + 2, line_style_2, drawStyle);
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

	function levelComplete(p:Player, d:Door)
	{
		if (d.isUnlocked())
		{
			if (LevelStats._ticks != null)
			{
				removeTicks();
			}
			if (nextLevel == null)
			{
				Logger.levelEnd("completion exit");
				FlxG.switchState(new MenuState());
			}
			else
			{
				Logger.nextRoom(nextLevel);
				FlxG.switchState(Type.createInstance(nextLevel, []));
			}
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
	private var _timebar:FlxBar;
	private var timer:FlxTimer;

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
		boundingBox.scrollFactor.set(0, 0);
		add(boundingBox);

		final text = new FlxText(0, (boundingBox.y + 45), 0, "Level Complete", 25);
		text.screenCenter(X);
		text.scrollFactor.set(0, 0);
		add(text);

		final endText = new FlxText(0, (boundingBox.y + 135), 0, "Go through the door to continue.", 15);
		endText.screenCenter(X);
		endText.scrollFactor.set(0, 0);
		add(endText);

		_timebar = new FlxBar(350, 430, HORIZONTAL_INSIDE_OUT, 400, 10, null, "time", 0, 300, true);
		_timebar.screenCenter(X);
		_timebar.createFilledBar(0xff428bbf, FlxColor.WHITE, true);
		_timebar.scrollFactor.set(0, 0);
		add(_timebar);

		timer = new FlxTimer();
		timer.start(3, function(Timer:FlxTimer)
		{
			close();
		}, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE)
		{
			close();
		}
		_timebar.value = cast(timer.timeLeft * 100);
	}
}

class EndGame extends FlxState
{
	private var _title:FlxText;
	private var _tryAgainBtn:FlxButton;
	private var _menuBtn:FlxButton;
	private var currLevel:Class<LevelState>;

	override public function new(thisLevel:Class<LevelState>)
	{
		currLevel = thisLevel;
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
				Logger.startLevel(1);
				LevelStats.initialize(1);
				if (currLevel != RoomOne)
				{
					LevelStats.startMusic();
				}
				FlxG.switchState(Type.createInstance(currLevel, []));
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
