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
	public var canvas:FlxSprite;

	public function new(x:Float, y:Float, target:FlxObject, timing:JudgeType, enchanted:Bool)
	{
		super(x, y, target, LevelState.AttackType.PURPLE, timing, enchanted);
		MOVEMENT_SPEED = 400;
		makeGraphic(5, 5, FlxColor.TRANSPARENT);

		switch (timing)
		{
			case PERFECT:
				_speed = MOVEMENT_SPEED * 1.2;
				_damage = 7;
			case GREAT:
				_speed = MOVEMENT_SPEED;
				_damage = 5;
			case OK:
				_speed = MOVEMENT_SPEED * 0.8;
				_damage = 3;
			default:
		}

		if (enchanted && timing == PERFECT)
		{
			_damage *= 1.2;
			_speed *= 1.2;
		}

		_heading = FlxG.mouse.getPosition();
		velocity.set(MOVEMENT_SPEED, 0);
		velocity.rotate(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, _heading, true));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		AI();
	}

	override function kill()
	{
		if (canvas != null)
		{
			canvas.kill();
		}
		super.kill();
	}

	private function AI() {}
}

class LaserBeam extends FlxSprite
{
	public function new(x:Float, y:Float, Length:Float, Rotation:Float)
	{
		super(x, y);
		makeGraphic(5, 5, FlxColor.PURPLE);
		loadGraphic("assets/images/laser.png");
		angle = Rotation;
		scale.set(Length / pixels.width, 1);
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
