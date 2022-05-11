import LevelState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxTimer;

class MagMissile extends Projectile
{
	private var blow:Bool;

	public function new(x:Float, y:Float, target:FlxObject, timing:JudgeType, enchanted:Bool)
	{
		super(x, y, target, LevelState.AttackType.RED, timing, enchanted);
		MOVEMENT_SPEED = 150;
		loadGraphic("assets/images/shooter.png", true, 16, 16);
		animation.add("blow", [256, 257, 258, 259], 5, false);
		animation.add("idle", [6, 7, 8, 9], 5);

		switch (timing)
		{
			case PERFECT:
				_speed = MOVEMENT_SPEED * 1.2;
				_damage = 7;
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
			_damage *= 1.2;
			_speed *= 1.2;
		}

		if (_target != null)
		{
			FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
			AI();
		}
		else
		{
			_heading = FlxG.mouse.getPosition();
			FlxVelocity.moveTowardsPoint(this, _heading, _speed);
		}
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
			trace("dmg = 0");
			_damage = 0;
		}
		AI();
	}

	override function kill()
	{
		alive = false;
		drag.x = drag.y = 10000;
		this.setGraphicSize(64, 64);
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
		trace("projectile killed");
	}

	private function AI()
	{
		if (alive)
		{
			if (_target != null)
			{
				FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
			}
			else
			{
				if (_heading == null)
				{
					_heading = FlxG.mouse.getPosition();
					trace(_heading);
					velocity.rotate(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, _heading, true));
				}
			}
		}
	}
}
