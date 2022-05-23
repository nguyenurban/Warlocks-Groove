import LevelState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class IceLaser extends Projectile
{
	/**
	 * How long the enemies are slowed for.
	 */
	public var slowed:Float;

	public function new(x:Float, y:Float, target:FlxObject, timing:JudgeType, enchanted:Bool, rotation:Float)
	{
		super(x, y, target, LevelState.AttackType.PURPLE, timing, enchanted);
		MOVEMENT_SPEED = 2000;
		makeGraphic(16, 16, FlxColor.TRANSPARENT);
		origin.set(0, pixels.height / 2);

		_energy = 15;

		switch (timing)
		{
			case PERFECT:
				_damage = 3;
				slowed = 3;
			case GREAT:
				_damage = 2;
				slowed = 2;
			case OK:
				_damage = 1;
				slowed = 0.25;
			default:
		}

		if (enchanted && timing == PERFECT)
		{
			_damage *= 1.2;
		}

		_heading = FlxG.mouse.getPosition();
		velocity.set(MOVEMENT_SPEED, 0);
		velocity.rotate(FlxPoint.weak(0, 0), rotation);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		AI();
	}

	override function kill()
	{
		super.kill();
	}

	private function AI() {}
}

class LaserBeam extends FlxSprite
{
	public function new(x:Float, y:Float, Length:Float, Rotation:Float)
	{
		super(x, y);
		// makeGraphic(5, 5, FlxColor.PURPLE);
		loadGraphic("assets/images/laser.png");
		angle = Rotation;
		scale.set((Length / pixels.width), 4);
		origin.set(0, pixels.height / 2);

		FlxTween.tween(this, {alpha: 0}, 0.4, {
			onComplete: function(t:FlxTween)
			{
				kill();
			},
			ease: FlxEase.quadOut
		});
	}
}
