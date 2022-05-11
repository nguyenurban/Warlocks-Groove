import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	private var _speed:Float;
	private var _size:Int;
	private var _dps:Float;
	private var _target:Player;
	private var _counter:Float;

	public function new(x:Float, y:Float, target:Player)
	{
		super(x, y);
		health = 20;
		_speed = 20;
		_size = 20;
		_dps = 20;
		_target = target;
		_counter = 0;
		drag.x = drag.y = 3000;
		setSize(_size, _size);
	}

	override function update(elapsed:Float)
	{
		_counter += elapsed;
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

	public override function toString():String
	{
		return Type.getClassName(Type.getClass(this));
	}
}
