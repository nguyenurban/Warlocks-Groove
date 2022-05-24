import LevelState.AttackType;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Alligator extends Enemy
{
	private var ACTION_TIME = 5;
	private var FIRE_TIME = 0.5;
	private var chasing:Bool;
	private var rapidFire:Bool;
	private var rapidFireTimer:FlxTimer;

	public function new(x:Float, y:Float, target:Player, tilemap:FlxTilemap)
	{
		super(x, y, target);
		// Set stats here
		health = 600;
		BASE_SPEED = 100;
		_dps = 20;
		_size = 200;
		setSize(_size, _size * 96 / 128);
		scale.set(_size / 128, _size / 96);
		chasing = false;
		_tilemap = tilemap;
		rapidFire = false;
		rapidFireTimer = new FlxTimer();
		rapidFireTimer.start(0, stopRapidFire);
		loadGraphic("assets/images/Alligator_Sprite_Sheet.png", true, 128, 96);
		updateHitbox();
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("l", [9, 10, 11], 6, false);
		animation.add("r", [3, 4, 5], 6, false);
		animation.add("u", [0, 1, 2], 6, false);
		animation.add("d", [6, 7, 8], 6, false);
	}

	override function takeAction()
	{
		FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);

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
		velocity.set(0, 0);
	}

	override function shouldFire()
	{
		if (!rapidFire && _counter > ACTION_TIME)
		{
			_counter = 0;
			return true;
		}
		else if (rapidFire && _counter > FIRE_TIME)
		{
			_counter = 0;
			return true;
		}
		return false;
	}

	public function isRapidFiring()
	{
		return rapidFire;
	}

	public function startRapidFire()
	{
		rapidFire = true;
		rapidFireTimer.reset(FIRE_TIME * 7);
	}

	private function stopRapidFire(t:FlxTimer)
	{
		rapidFire = false;
	}
}
