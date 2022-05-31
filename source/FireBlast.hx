import LevelState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using flixel.math.FlxPoint;

class FireBlast extends Projectile
{
	public var blow:Bool;

	// in degrees per second
	private var heading:FlxPoint;

	private var player_knockback:Float;
	private var enemy_knockback:Float;

	public function new(x:Float, y:Float, target:FlxObject, timing:JudgeType, enchanted:Bool, rotation:Float)
	{
		super(x - 16, y - 16, target, LevelState.AttackType.GREEN, timing, enchanted);
		// base movement speed
		MOVEMENT_SPEED = 150;
		loadGraphic("assets/images/fire_blast.png", true, 48, 48);
		animation.add("idle", [0, 1, 2], 5, true, true, false);

		_energy = 10;

		switch (timing)
		{
			case PERFECT:
				_speed = MOVEMENT_SPEED * 1.2;
				_damage = 7;
				player_knockback = 10;
				enemy_knockback = 20;
			case GREAT:
				_speed = MOVEMENT_SPEED;
				_damage = 5;
				player_knockback = 15;
				enemy_knockback = 15;
			case OK:
				_speed = MOVEMENT_SPEED * 0.8;
				_damage = 3;
				player_knockback = 25;
				enemy_knockback = 10;
			default:
		}

		if (enchanted && timing == PERFECT)
		{
			_damage *= 1.5;
			_speed *= 2.0;
		}

		// For 30 degree cone and 60 degree enchant
		// if (!enchanted)
		// {
		// 	this.setGraphicSize(48, 24);
		// }

		// For 60 degree cone and 120 degree enchant
		if (enchanted)
		{
			this.setGraphicSize(48, 96);
			// this.updateHitbox();
			this.width = 96;
			this.height = 96;
			offset.set(-0.5 * (this.width - this.frameWidth), -0.5 * (this.height - this.frameHeight));
			centerOrigin();
		}
		heading = FlxG.mouse.getPosition();
		velocity.set(MOVEMENT_SPEED, 0);
		velocity.rotate(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, heading, true));
		angle = rotation;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		animation.play("idle");
		// AI(elapsed);
	}

	override function kill()
	{
		alive = false;
		drag.x = drag.y = 10000;
		// if (this._enchanted)
		// {
		// 	this.setGraphicSize(96, 96);
		// }
		// else
		// {
		// 	this.setGraphicSize(64, 64);
		// }
		// updateHitbox();
		this.alpha = 0.5;
		// animation.play("blow");
		if (!blow)
		{
			timer.start(0.2, function(Timer:FlxTimer)
			{
				kill_projectile();
			}, 1);
			blow = true;
		}
	}

	private function kill_projectile()
	{
		super.kill();
		trace("projectile killed");
	}

	public function knockback(target:FlxObject)
	{
		if (Std.isOfType(target, Player))
		{
			var x2:Float = target.x - player_knockback * Math.cos(this.angle * Math.PI / 180);
			var y2:Float = target.y - player_knockback * Math.sin(this.angle * Math.PI / 180);
			FlxTween.linearMotion(target, target.x, target.y, x2, y2, 0.2, true, {ease: FlxEase.quadOut});
			// target.velocity.add(500, 0);
			// target.velocity.rotate(FlxPoint.weak(0, 0), this.angle - 180);
		}
		else
		{
			var x2:Float = target.x + enemy_knockback * Math.cos(this.angle * Math.PI / 180);
			var y2:Float = target.y + enemy_knockback * Math.sin(this.angle * Math.PI / 180);
			FlxTween.linearMotion(target, target.x, target.y, x2, y2, 0.2, true, {ease: FlxEase.quadOut});
			// target.velocity.add(500, 0);
			// target.velocity.rotate(FlxPoint.weak(0, 0), this.angle);
		}
	}
}
