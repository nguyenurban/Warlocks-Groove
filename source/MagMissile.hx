import LevelState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxTimer;

using flixel.math.FlxPoint;

class MagMissile extends Projectile
{
	public var blow:Bool;

	private var travel_angle:Float;
	// in degrees per second
	private var BASE_TURN_SPEED = 190;
	private var TURN_SPEED:Float;
	private var HOMING_TIME = 0.5;
	private var _homing_counter:Float;

	public function new(x:Float, y:Float, target:FlxObject, timing:JudgeType, enchanted:Bool)
	{
		super(x, y, target, LevelState.AttackType.RED, timing, enchanted);
		// base movement speed
		MOVEMENT_SPEED = 150;
		// tiny amount of inaccuracy in angles when firing shot
		var SHOT_INACC = 5.0;
		_homing_counter = 0;
		loadGraphic("assets/images/shooter.png", true, 16, 16);
		animation.add("blow", [256, 257, 258, 259], 5, false);
		animation.add("idle", [6, 7, 8, 9], 5);
		TURN_SPEED = BASE_TURN_SPEED;

		_energy = 15;

		switch (timing)
		{
			case PERFECT:
				_speed = MOVEMENT_SPEED * 1.2;
				_damage = 7;
				TURN_SPEED *= 1.2;
			case GREAT:
				_speed = MOVEMENT_SPEED;
				_damage = 5;
			case OK:
				_speed = MOVEMENT_SPEED * 0.8;
				_damage = 3;
			default:
		}

		if (enchanted && timing == PERFECT)
		{
			_damage *= 1.5;
			_speed *= 2.0;
			TURN_SPEED *= 2.0;
		}

		travel_angle = FlxAngle.angleBetweenMouse(this, true) + FlxG.random.float(-SHOT_INACC, SHOT_INACC);
		// if (_target != null)
		// {
		// 	FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
		// }
		// else
		// {
		// 	_heading = FlxG.mouse.getPosition();
		// 	FlxVelocity.moveTowardsPoint(this, _heading, _speed);
		// }
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (alive)
		{
			animation.play("idle");
		}
		else if (blow)
		{
			// trace("dmg = 0");
			_damage = 0;
		}
		AI(elapsed);
	}

	override function kill()
	{
		alive = false;
		drag.x = drag.y = 10000;
		if (this._enchanted)
		{
			this.setGraphicSize(96, 96);
		}
		else
		{
			this.setGraphicSize(64, 64);
		}
		// updateHitbox();
		this.alpha = 0.5;
		animation.play("blow");
		if (!blow)
		{
			timer.start(0.2, function(Timer:FlxTimer)
			{
				kill_projectile();
			}, 1);
			blow = true;
		}
	}

	private function kill_projectile()
	{
		super.kill();
		// trace("projectile killed");
	}

	private function AI(elapsed:Float)
	{
		_homing_counter += elapsed;
		if (_homing_counter > HOMING_TIME)
		{
			TURN_SPEED = 0;
		}
		if (alive)
		{
			if (_target != null)
			{
				var diff = this.getMidpoint().subtractPoint(_target.getMidpoint());
				diff.rotate(FlxPoint.weak(0, 0), 90);
				var travel = FlxVelocity.velocityFromAngle(travel_angle, _speed * elapsed);
				if (diff.x * travel.x + diff.y * travel.y > 0)
				{
					travel_angle += TURN_SPEED * elapsed;
				}
				else if (diff.x * travel.x + diff.y * travel.y < 0)
				{
					travel_angle -= TURN_SPEED * elapsed;
				}
				// var diff = _target.getMidpoint().subtractPoint(this.getMidpoint());
				// // transforms cartesian difference into polar difference (x = radius in degs)
				// FlxAngle.getPolarCoords(diff.x, diff.y, diff);
				// if (diff.y - travel_angle > 0)
				// {
				// 	travel_angle += TURN_SPEED * elapsed;
				// }
				// else if (diff.y - travel_angle < 0)
				// {
				// 	travel_angle -= TURN_SPEED * elapsed;
				// }
				// FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
			}
			else
			{
				// if (_heading == null)
				// {
				// 	_heading = FlxG.mouse.getPosition();
				// 	trace(_heading);
				// 	velocity.rotate(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, _heading, true));
				// }
			}
			var res = FlxVelocity.velocityFromAngle(travel_angle, _speed * elapsed);
			this.x += res.x;
			this.y += res.y;
		}
	}
}
