package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		#if js untyped
		{
			document.oncontextmenu = document.body.oncontextmenu = function()
			{
				return false;
			}
		}
		#end
		super();
		// addChild(new FlxGame(810, 540, PlayState));   // Use for a zoomed in camera
		FlxG.fixedTimestep = false;
		addChild(new FlxGame(1080, 720, MenuState));
	}
}
