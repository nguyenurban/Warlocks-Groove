import flixel.FlxSprite;

class Door extends FlxSprite
{
	private var _unlocked:Bool;

	public function new(x:Float, y:Float, unlocked:Bool)
	{
		super(x, y);
		immovable = true;
		_unlocked = unlocked;
		loadGraphic("assets/images/Door.png", true, 32, 32);
		animation.add("l", [2], 1, false);
		animation.add("u", [1], 1, false);
	}

	override function update(elapsed:Float)
	{
		if (_unlocked)
		{
			animation.play("u");
		}
		else
		{
			animation.play("l");
		}
		super.update(elapsed);
	}

	public function unlock()
	{
		_unlocked = true;
	}

	public function isUnlocked():Bool
	{
		return _unlocked;
	}
}
