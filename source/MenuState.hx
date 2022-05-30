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
	// private var exit:FlxButtonPlus;
	private var level_select:FlxButtonPlus;
	private var test:FlxButtonPlus;

	override function create()
	{
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

		level_select = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.checkTimeout();
				FlxG.switchState(new LevelSelect());
			});
		}, "", 200, 50);
		level_select.x = (FlxG.width / 2) - (level_select.width / 2);
		level_select.y = (FlxG.height / 2) - 10;
		level_select.textNormal = new FlxText(level_select.x, level_select.y + 10, 0, "Level Select", 25);
		level_select.textNormal.screenCenter(X);
		level_select.textHighlight = new FlxText(level_select.x, level_select.y + 10, 0, "Level Select", 25);
		level_select.textHighlight.screenCenter(X);
		add(level_select);

		if (Debug.ROOM_SELECT)
		{
			test = new FlxButtonPlus(0, 0, () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
				{
					Logger.checkTimeout();
					FlxG.switchState(new TestMenuRoom1());
				});
			}, "", 200, 50);
			test.x = (FlxG.width / 2) - (test.width / 2);
			test.y = (FlxG.height / 2) + 60;
			test.textNormal = new FlxText(test.x, test.y + 10, 0, "Test", 25);
			test.textNormal.screenCenter(X);
			test.textHighlight = new FlxText(test.x, test.y + 10, 0, "Test", 25);
			test.textHighlight.screenCenter(X);
			add(test);
		}

		// exit = new FlxButtonPlus(0, 0, clickExit, "", 200, 50);
		// exit.x = (FlxG.width / 2) - (exit.width / 2);
		// exit.y = (FlxG.height / 2) + 60;
		// exit.textNormal = new FlxText(exit.x, exit.y + 10, 0, "Exit", 25);
		// exit.textNormal.screenCenter(X);
		// exit.textHighlight = new FlxText(exit.x, exit.y + 10, 0, "Exit", 25);
		// exit.textHighlight.screenCenter(X);
		// add(exit);

		super.create();
	}

	private function clickPlay()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		{
			Logger.startLevel(1);
			LevelStats.initialize(1, false);
			FlxG.switchState(new RoomTwo());
		});
	}

	private function clickExit()
	{
		trace("Exiting");
		// Window.
	}
}
