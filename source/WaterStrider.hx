import LevelState.AttackType;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class WaterStrider extends Enemy
{
	private var DODGE_RAD = 400;
	private var ACTION_TIME = 4;
	private var chasing:Bool;
	private var prop_vel:FlxPoint;
	private var dodge_dir:Float;
	private var dodge_timer:FlxTimer;

	public function new(x:Float, y:Float, target:Player, tilemap:FlxTilemap)
	{
		super(x, y, target);
		// Set stats here
		health = 400;
		_speed = 120;
		_dps = 20;
		_size = 224;
		setSize(_size, _size * 128 / 144);
		scale.set(_size / 144, _size / 128);
		chasing = false;
		_tilemap = tilemap;
		prop_vel = FlxVelocity.velocityFromAngle(Random.float(0, 360), _speed);
		while (_tilemap.ray(this.getMidpoint(),
			this.getMidpoint()
				.add(_size / 2
					+ prop_vel.x * _speed
					+ acceleration.x * ACTION_TIME,
					_size / 2 * 128 / 144
					+ prop_vel.y * _speed
					+ acceleration.y * ACTION_TIME)))
		{
			prop_vel.rotate(FlxPoint.weak(0, 0), 90);
		}
		dodge_dir = 90 - Random.int(0, 1) * 180;
		dodge_timer = new FlxTimer();
		dodge_timer.start(Random.float(3, 5));
		loadGraphic("assets/images/WaterStrider_Sprite_Sheet.png", true, 144, 128);
		updateHitbox();
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("l", [9], 6, false);
		animation.add("r", [5], 6, false);
		animation.add("u", [2], 6, false);
		animation.add("d", [8], 6, false);
		animation.add("idle_l", [11, 10, 9, 10], 6, false);
		animation.add("idle_r", [3, 4, 5, 4], 6, false);
		animation.add("idle_u", [0, 1, 2, 1], 6, false);
		animation.add("idle_d", [6, 7, 8, 7], 6, false);
	}

	override function takeAction()
	{
		if (dodge_timer.finished)
		{
			dodge_dir = 90 - Random.int(0, 1) * 180;
			dodge_timer.reset(Random.float(3, 5));
		}
		if (chasing
			&& _dodgeTarget != null
			&& FlxMath.distanceToPoint(this, _dodgeTarget.getMidpoint()) < DODGE_RAD
			&& this.velocity.x * (this.getMidpoint()
				.x - _dodgeTarget.getMidpoint().x) + this.velocity.y * (this.getMidpoint().y - _dodgeTarget.getMidpoint().y) < 0)
		{
			FlxVelocity.moveTowardsPoint(this, _dodgeTarget.getMidpoint(), _speed * 1.5);
			velocity.rotate(FlxPoint.weak(0, 0), dodge_dir);
		}
		if (!chasing && _counter > ACTION_TIME)
		{
			velocity = prop_vel;
			acceleration.set(-velocity.x / ACTION_TIME, -velocity.y / ACTION_TIME);
		}
		else if (chasing && _counter > ACTION_TIME)
		{
			chasing = false;
			velocity.set(0, 0);
			acceleration.set(0, 0);
			prop_vel = FlxVelocity.velocityFromAngle(Random.float(0, 360), _speed);
			while (_tilemap.ray(this.getMidpoint(),
				this.getMidpoint()
					.add(_size / 2
						+ prop_vel.x * _speed
						+ acceleration.x * ACTION_TIME,
						_size / 2 * 128 / 144
						+ prop_vel.y * _speed
						+ acceleration.y * ACTION_TIME)))
			{
				prop_vel.rotate(FlxPoint.weak(0, 0), 90);
			}
			_counter = 0;
		}

		if (velocity.x < 0)
		{
			facing = LEFT;
			if (velocity.y < 0 && velocity.y < velocity.x)
			{
				facing = UP;
			}
			else if (velocity.y > 0 && velocity.y > -velocity.x)
			{
				facing = DOWN;
			}
		}
		else if (velocity.x > 0)
		{
			facing = RIGHT;
			if (velocity.y > 0 && velocity.y > velocity.x)
			{
				facing = DOWN;
			}
			else if (velocity.y < 0 && velocity.y < -velocity.x)
			{
				facing = UP;
			}
		}
		else
		{
			if (prop_vel.x < 0)
			{
				facing = LEFT;
				if (prop_vel.y < 0 && prop_vel.y < prop_vel.x)
				{
					facing = UP;
				}
				else if (prop_vel.y > 0 && prop_vel.y > -prop_vel.x)
				{
					facing = DOWN;
				}
			}
			else if (prop_vel.x > 0)
			{
				facing = RIGHT;
				if (prop_vel.y > 0 && prop_vel.y > prop_vel.x)
				{
					facing = DOWN;
				}
				else if (prop_vel.y < 0 && prop_vel.y < -prop_vel.x)
				{
					facing = UP;
				}
			}
		}
		if (chasing)
		{
			switch (facing)
			{
				case LEFT:
					animation.play("l");
				case RIGHT:
					animation.play("r");
				case UP:
					animation.play("u");
				case DOWN:
					animation.play("d");
				case _:
			}
		}
		else
		{
			switch (facing)
			{
				case LEFT:
					animation.play("idle_l");
				case RIGHT:
					animation.play("idle_r");
				case UP:
					animation.play("idle_u");
				case DOWN:
					animation.play("idle_d");
				case _:
			}
		}
	}

	override function shouldFire()
	{
		if (!chasing && _counter > ACTION_TIME)
		{
			chasing = true;
			_counter = 0;
			return true;
		}
		return false;
	}

	override function getDodgeType()
	{
		return RED;
	}
}
