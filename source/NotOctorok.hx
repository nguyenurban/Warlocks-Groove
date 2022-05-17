import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.tile.FlxTilemap;

class NotOctorok extends Enemy
{
	private static var DETECT_RAD:Float = 800;

	private var chasing:Bool;

	public function new(x:Float, y:Float, target:Player, tilemap:FlxTilemap)
	{
		super(x, y, target);
		// Set stats here
		health = 40;
		_speed = 40;
		_dps = 20;
		_size = 32;
		_tilemap = tilemap;
		loadGraphic("assets/images/NotOctorok_Sprite_Sheet.png", true, 16, 16);
		setSize(_size, _size);
		scale.set(_size / 16, _size / 16);
		updateHitbox();
		chasing = false;
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("l", [4, 5, 6, 7], 6, false);
		animation.add("r", [8, 9, 10, 11], 6, false);
		animation.add("u", [12, 13, 14, 15], 6, false);
		animation.add("d", [0, 1, 2, 3], 6, false);
	}

	override function takeAction()
	{
		var dist = FlxMath.distanceToPoint(this, _target.getMidpoint());
		if (chasing)
		{
			if (dist > DETECT_RAD / 2 || !_tilemap.ray(getMidpoint(), _target.getMidpoint()))
			{
				FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
			}
			else if (dist <= DETECT_RAD / 2 && _tilemap.ray(getMidpoint(), _target.getMidpoint()))
			{
				FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
				velocity.x = -velocity.x;
				velocity.y = -velocity.y;
			}
			else
			{
				velocity.x = velocity.y = 0;
			}
		}
		else
		{
			if (dist < DETECT_RAD)
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

	override function shouldFire()
	{
		if (chasing && _counter > 3)
		{
			_counter = 0;
			return true;
		}
		return false;
	}
}
