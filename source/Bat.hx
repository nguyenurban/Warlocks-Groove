import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class Bat extends Enemy
{
	private static var DETECT_RAD:Float = 700;

	private var chasing:Bool;

	public function new(x:Float, y:Float, target:Player, tilemap:FlxTilemap)
	{
		super(x, y, target);
		// Set stats here
		health = 20;
		_speed = 60;
		_dps = 20;
		_size = 32;
		_tilemap = tilemap;
		setSize(_size, _size);
		scale.set(_size / 32, _size / 32);
		chasing = false;
		loadGraphic("assets/images/Bat_Sprite_Sheet.png", true, 32, 32);
		updateHitbox();
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("l", [14, 15, 14, 13], 6, false);
		animation.add("r", [6, 7, 6, 5], 6, false);
		animation.add("u", [10, 11, 10, 9], 6, false);
		animation.add("d", [2, 3, 2, 1], 6, false);
	}

	override function takeAction()
	{
		if (chasing)
		{
			FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
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
}
