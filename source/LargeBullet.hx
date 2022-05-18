import LevelState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

private var target_point:FlxPoint;

class LargeBullet extends EnemyBullet
{
	public function new(x:Float, y:Float, target:FlxObject, targetPoint:FlxPoint, src:String, ?speed:Float)
	{
		super(x, y, target, targetPoint, src, speed);

		loadGraphic("assets/images/large_bullet.png", false, 18, 18);
		setGraphicSize(64, 64);
		updateHitbox();
		_damage = 25;
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
