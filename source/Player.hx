import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
	private var INVULN_WINDOW = 2.0;
	private var MAX_HEALTH = 100;
	private var MAX_ENERGY = 100;

	public var _energy:Float;

	private var BASE_ENERGY_REGEN = 50.0;

	static inline var MOVEMENT_SPEED:Float = 200;

	private var invuln_buffer:Float;

	public var timer:FlxTimer;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// makeGraphic(20, 20, FlxColor.ORANGE);
		loadGraphic("assets/images/Characters_Sprite_Sheet.png", true, 32, 32);
		setSize(24, 24);
		offset.set(4, 4);
		drag.x = drag.y = 3000;
		health = MAX_HEALTH;
		_energy = MAX_ENERGY;
		invuln_buffer = 0;
		timer = new FlxTimer();
		animation.add("run_down", [36, 37, 38, 39, 40, 41, 42, 43], 5);
		animation.add("run_side", [45, 46, 47, 48, 49, 50, 51, 52], 5);
		animation.add("run_up", [54, 55, 56, 57, 58, 59, 60, 61], 5);
		animation.add("idle", [0, 1, 2, 3], 5, false);
		animation.add("kill", [27, 28, 29, 30, 31, 32], 5, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
	}

	override function kill()
	{
		alive = false;
		animation.play("kill");
		timer.start(1.0, function(Timer:FlxTimer)
		{
			kill_player();
		}, 1);
	}

	private function kill_player()
	{
		super.kill();
	}

	override function update(elapsed:Float)
	{
		if (alive)
		{
			movement();
		}
		invuln_buffer += elapsed;
		super.update(elapsed);
	}

	public function damageInvuln():Void
	{
		if (alive)
		{
			invuln_buffer = 0;
			FlxSpriteUtil.flicker(this, INVULN_WINDOW);
		}
	}

	public function isInvuln():Bool
	{
		return invuln_buffer >= INVULN_WINDOW;
	}

	// energy regeneration at the end of every measure / bar
	public function barRegen():Void
	{
		_energy = Math.min(_energy + BASE_ENERGY_REGEN, MAX_ENERGY); // TODO: regen can be multiplied by freshness
	}

	public function useEnergy(cost:Float):Bool
	{
		if (_energy < cost)
		{
			return false;
		}
		_energy -= cost;
		return true;
	}

	public function getEnergy():Float
	{
		return _energy;
	}

	private function movement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		up = FlxG.keys.anyPressed([W]);
		down = FlxG.keys.anyPressed([S]);
		left = FlxG.keys.anyPressed([A]);
		right = FlxG.keys.anyPressed([D]);

		if (up && down)
		{
			up = down = false;
		}

		if (left && right)
		{
			left = right = false;
		}

		if (up || down || left || right)
		{
			var newAngle:Float = 0;

			if (up)
			{
				newAngle = -90;

				if (left)
				{
					newAngle -= 45;
				}
				else if (right)
				{
					newAngle += 45;
				}
			}
			else if (down)
			{
				newAngle = 90;

				if (left)
				{
					newAngle += 45;
				}
				else if (right)
				{
					newAngle -= 45;
				}
			}
			else if (left)
			{
				newAngle = 180;
			}
			else if (right)
			{
				newAngle = 0;
			}

			velocity.set(MOVEMENT_SPEED, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		}

		if (up)
		{
			animation.play("run_up");
			Logger.checkTimeout();
		}
		else if (down)
		{
			animation.play("run_down");
			Logger.checkTimeout();
		}
		else if (left)
		{
			facing = FlxObject.LEFT;
			animation.play("run_side");
			Logger.checkTimeout();
		}
		else if (right)
		{
			facing = FlxObject.RIGHT;
			animation.play("run_side");
			Logger.checkTimeout();
		}
		else
		{
			animation.play("idle");
		}
	}
}
