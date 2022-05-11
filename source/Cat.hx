import flixel.FlxG;
import flixel.util.FlxTimer;

class Cat extends Enemy
{
	private var _attacktimer:Float;
	private var ATTACK_TIME_CAP_MIN = 5.0;
	private var ATTACK_TIME_CAP_MAX = 8.0;
	private var _movetimer:Float;
	private var MOVE_TIME_CAP_MIN = 1.0;
	private var MOVE_TIME_CAP_MAX = 3.0;
	private var charging:Bool;
	private var CHARGE_TIME = 2.0;
	private var FB_FIRE_RATE = 0.25;
	private var moving:Bool;
	private var fb_firing:Bool;

	public function new(x:Float, y:Float, player:Player)
	{
		super(x, y, player);
		health = 400;
		_speed = 60;
		_dps = 20;
		_target = player;
		_size = 64;
		setSize(_size, _size);
		_attacktimer = FlxG.random.float(ATTACK_TIME_CAP_MIN, ATTACK_TIME_CAP_MAX);
		charging = false;
		moving = false;
		fb_firing = false;
	}

	override function update(elapsed:Float)
	{
		_attacktimer -= elapsed;
		_movetimer -= elapsed;
		if (_movetimer <= 0 && !charging)
		{
			moving = true;
			move();
		}
		if (_attacktimer <= 0 && !moving)
		{
			_attacktimer = FlxG.random.float(ATTACK_TIME_CAP_MIN, ATTACK_TIME_CAP_MAX);
			switch FlxG.random.int(0, 2)
			{
				case 0:
					new FlxTimer().start(FB_FIRE_RATE, fiveBullets, 5);
				case 1:
					charging = true;
					new FlxTimer().start(CHARGE_TIME, chargeAtk, 1);
				case 2:
					charging = true;
					waveAtk();
			}
		}
	}

	override function takeAction() {}

	private function fiveBullets(timer:FlxTimer):Void {}

	private function chargeAtk(timer:FlxTimer):Void
	{
		charging = false;
	}

	private function waveAtk():Void {}

	private function move():Void
	{
		moving = false;
	}
}
