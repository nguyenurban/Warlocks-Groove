import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class Slime extends Enemy
{
	private static var DETECT_RAD:Float = 700;

	private var chasing:Bool;

	public function new(x:Float, y:Float, target:Player, tilemap:FlxTilemap)
	{
		super(x, y, target);
		// Set stats here
		health = 40;
		_dps = 20;
		_size = 50;
		BASE_SPEED = 30;
		_tilemap = tilemap;
		setSize(_size, _size);
		scale.set(_size / 25, _size / 25);
		chasing = false;
		loadGraphic("assets/images/Slime_Sprite_Sheet.png", true, 25, 25);
		updateHitbox();
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("s", [0, 1, 5, 6, 7, 8, 9, 10, 11], 6, false);
		animation.add("u", [30, 31, 35, 36, 37, 38, 39, 40, 41], 6, false);
		animation.add("d", [15, 16, 20, 21, 22, 23, 24, 25, 26], 6, false);
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
				animation.play("s");
			case RIGHT:
				animation.play("s");
			case UP:
				animation.play("u");
			case DOWN:
				animation.play("d");
			case _:
		}
	}
}
