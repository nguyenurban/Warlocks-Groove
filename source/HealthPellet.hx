import flixel.FlxSprite;
import flixel.math.FlxPoint;

class HealthPellet extends Item
{
	public var despawn_timer:Float;

	public function new(x:Float, y:Float, velocity:FlxPoint)
	{
		super(x, y);
		RESTORE = 2;
		this.velocity = velocity;
		drag = FlxPoint.weak(15, 15);
		elasticity = 1;
		loadGraphic("assets/images/HealthPellet.png", true, 8, 8);
		animation.add("default", [18, 19, 20, 21, 22, 23], 5, false);
		updateHitbox();
		// animation.add("u", [1], 1, false);
		despawn_timer = 0;
	}

	override function update(elapsed:Float)
	{
		// if (_unlocked)
		// {
		// 	animation.play("u");
		// }
		// else
		// {
		// 	animation.play("l");
		// }
		animation.play("default");
		despawn_timer += elapsed;
		if (despawn_timer >= 10)
		{
			kill();
		}
		super.update(elapsed);
	}
}
