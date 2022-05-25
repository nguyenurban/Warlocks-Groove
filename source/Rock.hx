import flixel.FlxSprite;
import flixel.math.FlxVector;

class Rock extends FlxSprite
{
	static var nextAge = 0;

	public var age:Float;
	public var damage:Float;
	public var speed:Float;
	public var deadlyToMonster:Bool;
	public var deadlyToPlayer:Bool;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		age = nextAge;
		nextAge++;
		setSize(16, 16);
		scale.set(0.5, 0.5);
		loadGraphic("assets/images/Rock.png", true, 32, 32);
		updateHitbox();
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("r", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 6, false);
		damage = 10;
		elasticity = 0.5;
		speed = 400;
		drag.x = drag.y = 50;
		deadlyToPlayer = false;
		deadlyToMonster = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (velocity.x != 0 || velocity.y != 0)
		{
			animation.play("r");
		}
		if (FlxVector.weak(velocity.x, velocity.y).length < 200)
		{
			deadlyToPlayer = false;
			deadlyToMonster = false;
		}
	}
}
