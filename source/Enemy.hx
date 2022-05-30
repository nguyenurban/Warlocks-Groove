import LevelState.AttackType;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	public var BASE_SPEED = 20.0;

	private var _speed:Float;
	private var _size:Int;

	public var _dps:Float;

	private var _target:Player;
	private var _counter:Float;
	private var _tilemap:FlxTilemap;
	private var _dodgeTarget:Projectile;

	/**
	 * Whether or not the enemy is currently slowed by an ice laser.
	 * < 0 = not slowed, > 0 = # of seconds of slow left
	 */
	public var ice_slowed:Float;

	public var DMG_FLICKER = 0.75;

	/**
	 * If health pellets are used, the number of pellets to drop on kill when the player has a combo less than 25.
	 */
	public var pellet_drop = 2;

	/**
	 * If health pellets are used, the number of pellets to drop when the player has a combo between 25 and 99.
	 */
	public var pd_25_combo = 3;

	/**
	 * If health pellets are used, the number of pleets to drop when the player has a combo of 100 or better.
	 */
	public var pd_100_combo = 5;

	/**
	 * How many points this enemy awards upon kill (default 50).
	 */
	public var value = 50;

	public function new(x:Float, y:Float, target:Player)
	{
		super(x, y);
		health = 20;
		_speed = BASE_SPEED;
		_size = 20;
		_dps = 20;
		_target = target;
		_counter = 0;
		drag.x = drag.y = 3000;
		setSize(_size, _size);
		ice_slowed = 0;
	}

	override function update(elapsed:Float)
	{
		_counter += elapsed;
		ice_slowed -= elapsed;
		_speed = (ice_slowed > 0 ? BASE_SPEED * 0.6 : BASE_SPEED);
		takeAction();
		super.update(elapsed);
	}

	private function takeAction()
	{
		FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
	}

	public function shouldFire():Bool
	{
		return false;
	}

	public function getDamage():Float
	{
		return _dps;
	}

	public function getSize():Float
	{
		return _size;
	}

	public function setSpeed(spd:Float)
	{
		_speed = spd;
	}

	public function getSpeed()
	{
		return _speed;
	}

	public function dodge(p:Projectile)
	{
		_dodgeTarget = p;
	}

	public function getDodgeType():AttackType
	{
		return null;
	}

	public override function toString():String
	{
		return Type.getClassName(Type.getClass(this));
	}
}
