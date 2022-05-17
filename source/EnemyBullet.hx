import LevelState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

private var target_point:FlxPoint;

class EnemyBullet extends Projectile
{
	public function new(x:Float, y:Float, target:FlxObject, targetPoint:FlxPoint, src:String, speed:Float)
	{
		super(x, y, target, LevelState.AttackType.ENEMY, PERFECT, false, src);
		_speed = speed;
		target_point = targetPoint;
		loadGraphic("assets/images/enemy_bullet.png", false, 24, 24);
		if (target == null)
		{
			FlxVelocity.moveTowardsPoint(this, FlxPoint.weak(x, y), _speed);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
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
