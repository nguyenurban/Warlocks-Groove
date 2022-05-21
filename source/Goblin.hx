import LevelState.AttackType;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class Goblin extends Enemy
{
	private static var DETECT_RAD:Float = 700;
	private static var DODGE_RAD:Float = 300;

	private var dodge_change_time:Float;
	private var dodge_dir:Float;
	private var chasing:Bool;

	public function new(x:Float, y:Float, target:Player, tilemap:FlxTilemap)
	{
		super(x, y, target);
		// Set stats here
		health = 35;
		_speed = 80;
		_dps = 20;
		_size = 32;
		_tilemap = tilemap;
		value = 100;
		setSize(_size, _size);
		scale.set(_size / 64, _size / 64);
		chasing = false;
		_counter = 0;
		dodge_change_time = Random.float(3, 5);
		dodge_dir = 90 - Random.int(0, 1) * 180;
		loadGraphic("assets/images/Goblin_Sprite_Sheet.png", true, 64, 64);
		updateHitbox();
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("l", [33, 34, 35, 36, 37, 38, 39], 6, false);
		animation.add("r", [11, 12, 13, 14, 15, 16, 17], 6, false);
		animation.add("u", [22, 23, 24, 25, 26, 27, 28], 6, false);
		animation.add("d", [0, 1, 2, 3, 4, 5, 6], 6, false);
	}

	override function takeAction()
	{
		if (_counter > dodge_change_time)
		{
			_counter = 0;
			dodge_change_time = Random.float(1, 3);
			dodge_dir = 90 - Random.int(0, 1) * 180;
		}
		if (chasing)
		{
			FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
			if (_dodgeTarget != null
				&& FlxMath.distanceToPoint(this, _dodgeTarget.getMidpoint()) < DODGE_RAD
				&& this.velocity.x * (this.getMidpoint()
					.x - _dodgeTarget.getMidpoint().x) + this.velocity.y * (this.getMidpoint().y - _dodgeTarget.getMidpoint().y) < 0)
			{
				FlxVelocity.moveTowardsPoint(this, _dodgeTarget.getMidpoint(), _speed * 2);
				velocity.rotate(FlxPoint.weak(0, 0), dodge_dir);
			}
		}
		else
		{
			if (FlxMath.distanceToPoint(this, _target.getMidpoint()) < DETECT_RAD && _tilemap.ray(getMidpoint(), _target.getMidpoint()))
			{
				chasing = true;
			}
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
			facing = DOWN;
		}
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

	override function getDodgeType():AttackType
	{
		return RED;
	}
}
