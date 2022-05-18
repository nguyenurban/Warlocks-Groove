package;

import TestMenu.TestMenuRoom1;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.display.Window;

class MenuState extends FlxState
{
	private var title:FlxText;
	private var play:FlxButtonPlus;
	private var exit:FlxButtonPlus;
	private var test:FlxButtonPlus;

	override function create()
	{
		Logger.createLogger();
		FlxG.mouse.unload();
		bgColor = 0x00000000;
		title = new FlxText(50, 150, 0, "Warlock's Groove", 32);
		title.alignment = CENTER;
		title.screenCenter(X);
		add(title);

		play = new FlxButtonPlus(0, 0, clickPlay, "", 200, 50);
		play.x = (FlxG.width / 2) - (play.width / 2);
		play.y = (FlxG.height / 2) - 80;
		play.textNormal = new FlxText(play.x, play.y + 10, 0, "Play", 25);
		play.textNormal.screenCenter(X);
		play.textHighlight = new FlxText(play.x, play.y + 10, 0, "Play", 25);
		play.textHighlight.screenCenter(X);
		add(play);

		test = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.checkTimeout();
				FlxG.switchState(new TestMenuRoom1());
			});
		}, "", 200, 50);
		test.x = (FlxG.width / 2) - (test.width / 2);
		test.y = (FlxG.height / 2) - 10;
		test.textNormal = new FlxText(test.x, test.y + 10, 0, "Test", 25);
		test.textNormal.screenCenter(X);
		test.textHighlight = new FlxText(test.x, test.y + 10, 0, "Test", 25);
		test.textHighlight.screenCenter(X);
		add(test);

		exit = new FlxButtonPlus(0, 0, clickExit, "", 200, 50);
		exit.x = (FlxG.width / 2) - (exit.width / 2);
		exit.y = (FlxG.height / 2) + 60;
		exit.textNormal = new FlxText(exit.x, exit.y + 10, 0, "Exit", 25);
		exit.textNormal.screenCenter(X);
		exit.textHighlight = new FlxText(exit.x, exit.y + 10, 0, "Exit", 25);
		exit.textHighlight.screenCenter(X);
		add(exit);

		super.create();
	}

	private function clickPlay()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		{
			Logger.startLevel(1);
			LevelStats.initialize(1);
			FlxG.switchState(new RoomOne());
		});
	}

	private function clickExit()
	{
		trace("Exiting");
		// Window.
	}
}
