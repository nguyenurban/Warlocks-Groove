import flixel.FlxObject;
import flixel.math.FlxPoint;

class StriderShockwave extends EnemyBullet
{
	public function new(x:Float, y:Float, target:FlxObject, targetPoint:FlxPoint, src:String, ?speed:Float)
	{
		super(x, y, target, targetPoint, src, speed);
		loadGraphic("assets/images/StriderShockwave.png", true, 100, 100);
		animation.add("anim", [0, 1, 2], 6, false);
		acceleration.set(velocity.x, velocity.y);
		_damage = 20;
		scale.set(0.5, 0.5);
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		scale.set(scale.x - 0.1 * elapsed, scale.y - 0.1 * elapsed);
		updateHitbox();
		if (scale.x < 0 || scale.y < 0)
		{
			kill();
		}
	}
}
