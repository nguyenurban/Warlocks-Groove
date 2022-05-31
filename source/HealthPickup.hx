import flixel.FlxSprite;

class HealthPickup extends Item
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		RESTORE = 40;
		immovable = true;
		loadGraphic("assets/images/HealthPickup.png", true, 32, 32);
		animation.add("default", [0, 1, 2, 3], 1);
		updateHitbox();
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
		animation.play("default");
		super.update(elapsed);
	}
}
