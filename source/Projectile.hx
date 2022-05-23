import LevelState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Projectile extends FlxSprite
{
	private var hostile:Bool;

	private var MOVEMENT_SPEED:Float = 150;

	private var _target:FlxObject;
	private var _type:LevelState.AttackType;
	private var _monsters:FlxTypedGroup<Enemy>;

	public var _enchanted:Bool;

	private var _damage:Float;
	private var _energy:Float;
	private var _speed:Float;
	private var _heading:FlxPoint;

	public var src = "n/a";

	public var origin_point:FlxPoint;
	public var _timing:LevelState.JudgeType;

	public var timer:FlxTimer;
	public var hit_enemies:Array<Dynamic>;

	public function new(x:Float, y:Float, target:FlxObject /**monsters:FlxTypedGroup<Enemy>**/, type:LevelState.AttackType, timing:LevelState.JudgeType,
			enchanted:Bool, ?source:String)
	{
		super(x, y);
		_target = target;
		_type = type;
		timer = new FlxTimer();
		_timing = timing;
		_enchanted = enchanted;
		origin_point = this.getMidpoint();
		src = source;
		if (type == ENEMY && _target != null)
		{
			makeGraphic(5, 5, FlxColor.BLACK);
			FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), _speed);
			_damage = 15;
		}
		hit_enemies = new Array();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function update_target(target:Enemy)
	{
		_target = target;
	}

	public function getType():AttackType
	{
		return _type;
	}

	public function getDamage():Float
	{
		return _damage;
	}

	public function getEnergy():Float
	{
		return _energy;
	}

	override function kill()
	{
		super.kill();
	}

	public override function toString():String
	{
		return Type.getClassName(Type.getClass(this));
	}
}
