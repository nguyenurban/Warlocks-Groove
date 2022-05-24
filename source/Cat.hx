import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

class Cat extends Enemy
{
	private var _attacktimer:Float;
	private var ATTACK_TIME_CAP_MIN = 1.0;
	private var ATTACK_TIME_CAP_MAX = 3.0;
	private var _movetimer:Float;
	private var MOVE_TIME_CAP_MIN = 0.4;
	private var MOVE_TIME_CAP_MAX = 1.0;
	private var MOVE_VARIANCE_MIN = 100;
	private var MOVE_VARIANCE_MAX = 500;
	// in ms
	private var MIN_MOVING_TIME = 1.5;
	private var MAX_MOVING_TIME = 3.0;
	private var charging:Bool;
	private var CHARGE_TIME = 2.0;
	private var FB_FIRE_RATE = 0.25;
	private var FB_SHOT_VARIANCE = 10;
	private var moving:Bool;
	private var curr_dest:FlxPoint;
	private var fb_firing:Bool;
	private var _signal:FlxTypedSignal<Array<Float>->Void>;
	private var SHIELD_COOLDOWN = 8.0;
	private var curr_shield_cd:Float;

	public var shielded:Bool;

	private var SHIELD_HITS = 3;

	public var curr_shield_hp:Int;

	public var shield:FlxSprite;
	public var shieldBreak:FlxSignal;

	public function new(x:Float, y:Float, player:Player, signal:FlxTypedSignal<Array<Float>->Void>)
	{
		super(x, y, player);
		BASE_SPEED = 50;
		health = 300;
		_dps = 20;
		_target = player;
		_size = 128;
		_signal = signal;
		setSize(_size, _size);
		_attacktimer = FlxG.random.float(ATTACK_TIME_CAP_MIN, ATTACK_TIME_CAP_MAX);
		charging = false;
		moving = false;
		fb_firing = false;
		shielded = true;
		curr_shield_cd = 0.0;
		shield = new FlxSprite();
		shield.loadGraphic("assets/images/cat_shield.png");
		// stamp(shield, 0, 0);
		shieldBreak = new FlxSignal();
		shieldBreak.add(shieldBreaking);
		_movetimer = FlxG.random.float(MOVE_TIME_CAP_MIN, MOVE_TIME_CAP_MAX);
		loadGraphic("assets/images/Cat_Sprite_Sheet.png", true, 32, 32);
		scale.set(_size / 32, _size / 32);

		updateHitbox();
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		animation.add("l", [3, 4, 5, 4], 6, false);
		animation.add("r", [6, 7, 8, 7], 6, false);
		animation.add("u", [9, 10, 11, 10], 6, false);
		animation.add("d", [0, 1, 2, 1], 6, false);
	}

	override function update(elapsed:Float)
	{
		_attacktimer -= elapsed;
		_movetimer -= elapsed;
		curr_shield_cd -= elapsed;
		super.update(elapsed);
	}

	override function takeAction()
	{
		shield.x = this.x;
		shield.y = this.y;
		if (_movetimer <= 0 && !charging)
		{
			if (moving)
			{
				moving = false;
				velocity = FlxPoint.weak(0, 0);
				_movetimer = FlxG.random.float(MOVE_TIME_CAP_MIN, MOVE_TIME_CAP_MAX);
			}
			else
			{
				moving = true;
				_movetimer = FlxG.random.float(MIN_MOVING_TIME, MAX_MOVING_TIME);
				var curr_move = FlxG.random.float(MOVE_VARIANCE_MIN, MOVE_VARIANCE_MAX);
				curr_dest = FlxPoint.weak(this.x + (FlxG.random.bool() ? 1 : -1) * curr_move, this.y + (FlxG.random.bool() ? 1 : -1) * curr_move);
			}
		}
		if (moving)
		{
			FlxVelocity.moveTowardsPoint(this, curr_dest, _speed);
		}
		if (_attacktimer <= 0 && !moving)
		{
			_attacktimer = FlxG.random.float(ATTACK_TIME_CAP_MIN, ATTACK_TIME_CAP_MAX);
			switch FlxG.random.int(0, 2)
			{
				case 0:
					new FlxTimer().start(FB_FIRE_RATE, (timer:FlxTimer) -> _signal.dispatch([
						0,
						this.getMidpoint().x + FlxG.random.int(-FB_SHOT_VARIANCE, FB_SHOT_VARIANCE),
						this.getMidpoint().y
					]), 5);
				case 1:
					charging = true;
					_signal.dispatch([3, this.getGraphicMidpoint().x, this.getGraphicMidpoint().y, CHARGE_TIME]);
					new FlxTimer().start(CHARGE_TIME, chargeAtk);
					_attacktimer = CHARGE_TIME + FlxG.random.float(ATTACK_TIME_CAP_MIN, ATTACK_TIME_CAP_MAX);
				case 2:
					charging = true;
					_signal.dispatch([3, this.getGraphicMidpoint().x, this.getGraphicMidpoint().y, CHARGE_TIME / 2]);
					new FlxTimer().start(CHARGE_TIME / 2, waveAtk);
					_attacktimer = CHARGE_TIME / 2 + FlxG.random.float(ATTACK_TIME_CAP_MIN, ATTACK_TIME_CAP_MAX);
				default:
			}
		}
		if (curr_shield_cd <= 0 && !shielded)
		{
			shielded = true;
		}
		if (velocity.x < 0)
		{
			facing = LEFT;
			if (velocity.y < 0 && velocity.y < velocity.x)
			{
				facing = UP;
			}
			else if (velocity.y > 0 && velocity.y > -velocity.x)
			{
				facing = DOWN;
			}
		}
		else if (velocity.x > 0)
		{
			facing = RIGHT;
			if (velocity.y > 0 && velocity.y > velocity.x)
			{
				facing = DOWN;
			}
			else if (velocity.y < 0 && velocity.y < -velocity.x)
			{
				facing = UP;
			}
		}
		else
		{
			facing = DOWN;
		}
		switch (facing)
		{
			case LEFT:
				animation.play("l");
			case RIGHT:
				animation.play("r");
			case UP:
				animation.play("u");
			case DOWN:
				animation.play("d");
			case _:
		}
	}

	private function fiveBullets(timer:FlxTimer):Void {}

	private function chargeAtk(timer:FlxTimer):Void
	{
		_signal.dispatch([1, this.getMidpoint().x, this.getMidpoint().y]);
		charging = false;
	}

	private function waveAtk(timer:FlxTimer):Void
	{
		_signal.dispatch([2, this.getMidpoint().x, this.getMidpoint().y]);
		charging = false;
	}

	public function shieldBreaking():Void
	{
		shielded = false;
		curr_shield_cd = 8.0;
	}
}
