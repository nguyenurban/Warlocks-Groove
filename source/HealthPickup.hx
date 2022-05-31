import flixel.FlxSprite;

class HealthPickup extends Item
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		RESTORE = 50;
		immovable = true;
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
