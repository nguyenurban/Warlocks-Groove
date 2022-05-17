import LevelState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import js.html.AbortController;

using flixel.util.FlxSpriteUtil;

class Tick extends FlxSprite
{
	private var _type:LevelState.AttackType;
	private var _judge:LevelState.JudgeType;
	private var _tick_no:Int;
	private var _enchanted:Bool;
	private var _sprite_file:String;

	public function new(type:LevelState.AttackType, tick_num:Int, enchanted:Bool, place:Int, height:Int)
	{
		super(place, 0);
		this._type = type;
		this._tick_no = tick_num;
		this._judge = NONE;
		this._enchanted = enchanted;
		switch (type)
		{
			case RED:
				_sprite_file = "assets/images/ticks/red";
			case PURPLE:
				_sprite_file = "assets/images/ticks/purple";
			case GREEN:
				_sprite_file = "assets/images/ticks/green";
			default:
		}
		loadGraphic(_sprite_file + (_enchanted ? "_e.png" : ".png"), false, 6, height, true);
		// drawGlow();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function getType():LevelState.AttackType
	{
		return _type;
	}

	public function getTick():Int
	{
		return _tick_no;
	}

	public function getJudge():LevelState.JudgeType
	{
		return _judge;
	}

	public function getEnchanted():Bool
	{
		return _enchanted;
	}

	public function setTick(input:Int):Void
	{
		_tick_no = input;
	}

	public function setJudge(input:LevelState.JudgeType)
	{
		_judge = input;
		switch (input)
		{
			case PERFECT:
				loadGraphic(_sprite_file + "_p" + (_enchanted ? "_e.png" : ".png"), false, 10, Std.int(height));
			case GREAT:
				loadGraphic(_sprite_file + "_g.png", false, 10, Std.int(height));
			case OK:
				loadGraphic(_sprite_file + "_o.png", false, 10, Std.int(height));
			case NONE:
				loadGraphic(_sprite_file + (_enchanted ? "_e.png" : ".png"), false, 10, Std.int(height));
			default:
		}
	}

	public function drawGlow():Void
	{
		var draw_style = {smoothing: true};
		var line_style = {
			color: (_enchanted && (_judge == PERFECT || _judge == NONE) ? FlxColor.LIME : FlxColor.BLACK),
			thickness: 3.5
		}
		FlxSpriteUtil.drawRect(this, 0, 0, 10, height, FlxColor.TRANSPARENT, line_style, draw_style);
		this.dirty = true;
	}

	public function setEnchanted(enchant:Bool):Void
	{
		_enchanted = enchant;
		// drawGlow();
	}
}
