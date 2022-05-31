import flixel.FlxSprite;
import flixel.math.FlxPoint;

class HealthPellet extends Item
{
	public function new(x:Float, y:Float, velocity:FlxPoint)
	{
		super(x, y);
		RESTORE = 5;
		this.velocity = velocity;
		drag = FlxPoint.weak(5, 5);
		// loadGraphic("assets/images/Door.png", true, 32, 32);
		// animation.add("l", [2], 1, false);
		// animation.add("u", [1], 1, false);
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
		super.update(elapsed);
	}
}
