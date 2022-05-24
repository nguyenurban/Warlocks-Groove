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

class WaveBullet extends EnemyBullet
{
	public function new(x:Float, y:Float, target:FlxObject, targetPoint:FlxPoint, src:String, ?speed:Float)
	{
		super(x, y, target, targetPoint, src, speed);

		loadGraphic("assets/images/cat_wave.png", true, 32, 32, true);
		animation.add("n", [0, 1, 2, 3, 4, 5], 5);
		animation.play("n");
		setGraphicSize(32 * 2, 32 * 3);
		// setSize(7 * 2, 23 * 3);
		offset = FlxPoint.weak(13 * 2, 5 * 3);
		var point = (target == null ? targetPoint : target.getMidpoint());
		var diff = FlxAngle.angleBetweenPoint(this, point, true);
		angle = diff;
		updateHitbox();
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
