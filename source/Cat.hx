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
		health = 300;
		_speed = 50;
		_dps = 20;
		_target = player;
		_size = 64;
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
		shieldBreak = new FlxSignal();
		shieldBreak.add(shieldBreaking);
		_movetimer = FlxG.random.float(MOVE_TIME_CAP_MIN, MOVE_TIME_CAP_MAX);
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
					new FlxTimer().start(FB_FIRE_RATE,
						(timer:FlxTimer) -> _signal.dispatch([0, this.x + FlxG.random.int(-FB_SHOT_VARIANCE, FB_SHOT_VARIANCE), this.y]), 5);
				case 1:
					charging = true;
					new FlxTimer().start(CHARGE_TIME, chargeAtk, 1);
				case 2:
					charging = true;
					waveAtk();
			}
		}
		if (curr_shield_cd <= 0 && !shielded)
		{
			shielded = true;
		}
	}

	private function fiveBullets(timer:FlxTimer):Void {}

	private function chargeAtk(timer:FlxTimer):Void
	{
		charging = false;
	}

	private function waveAtk():Void {}

	public function shieldBreaking():Void
	{
		shielded = false;
		curr_shield_cd = 8.0;
	}
}
