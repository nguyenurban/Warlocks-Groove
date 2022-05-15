package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

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
		title = new FlxText(50, 200, 0, "Warlock's Groove", 18);
		title.alignment = CENTER;
		title.screenCenter(X);
		add(title);

		play = new FlxButtonPlus(0, 0, clickPlay, "Play", 100, 30);
		play.x = (FlxG.width / 2) - (play.width / 2);
		play.y = (FlxG.height / 2) - 70;
		add(play);

		test = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new TestMenu());
			});
		}, "Test", 100, 30);
		test.x = (FlxG.width / 2) - (test.width / 2);
		test.y = (FlxG.height / 2) - 20;
		add(test);

		exit = new FlxButtonPlus(0, 0, clickExit, "Exit", 100, 30);
		exit.x = (FlxG.width / 2) - (exit.width / 2);
		exit.y = (FlxG.height / 2) + 30;
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
	}
}
