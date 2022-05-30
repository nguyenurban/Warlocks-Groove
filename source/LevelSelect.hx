package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class LevelSelect extends FlxState
{
	private var title:FlxText;
	private var level1:FlxButtonPlus;
	private var level2:FlxButtonPlus;
	private var level3:FlxButtonPlus;
	// private var level4:FlxButtonPlus;
	// private var level5:FlxButtonPlus;
	// private var level6:FlxButtonPlus;
	private var back:FlxButtonPlus;
	private var nextPage:FlxButtonPlus;

	override function create()
	{
		bgColor = 0x00000000;
		title = new FlxText(50, 150, 0, "Select Level to Play", 18);
		title.alignment = CENTER;
		title.screenCenter(X);
		add(title);

		level1 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(101);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomTwo());
			});
		}, "Level 1", 100, 30);
		level1.x = (FlxG.width / 2) - (level1.width / 2) - 150;
		level1.y = (FlxG.height / 2) - 150;
		add(level1);
		if (LevelStats.save_data.data.high_scores[1] != -1)
		{
			var level1_hi_score = new FlxText(level1.x, level1.y + 40, 0, "Best score: " + LevelStats.save_data.data.high_scores[1]);
			add(level1_hi_score);
		}

		if (LevelStats.save_data.data.levels_seen[2])
		{
			level2 = new FlxButtonPlus(0, 0, () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
				{
					Logger.startLevel(201, "level select");
					LevelStats.initialize(2, false);
					FlxG.switchState(new LvlTwoRoomOne());
				});
			}, "Level 2", 100, 30);
			level2.x = (FlxG.width / 2) - (level2.width / 2) - 150;
			level2.y = (FlxG.height / 2) - 80;
			add(level2);

			if (LevelStats.save_data.data.high_scores[2] != -1)
			{
				var level2_hi_score = new FlxText(level2.x, level2.y + 40, 0, "Best score: " + LevelStats.save_data.data.high_scores[2]);
				add(level2_hi_score);
			}
		}

		if (LevelStats.save_data.data.levels_seen[3])
		{
			level3 = new FlxButtonPlus(0, 0, () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
				{
					Logger.startLevel(301, "level select");
					LevelStats.initialize(3, false);
					FlxG.switchState(new LvlThreeRoomOne());
				});
			}, "Level 3", 100, 30);
			level3.x = (FlxG.width / 2) - (level2.width / 2) - 150;
			level3.y = (FlxG.height / 2) - 10;
			add(level2);

			if (LevelStats.save_data.data.high_scores[3] != -1)
			{
				var level3_hi_score = new FlxText(level3.x, level3.y + 40, 0, "Best score: " + LevelStats.save_data.data.high_scores[3]);
				add(level3_hi_score);
			}
		}
		// level3 = new FlxButtonPlus(0, 0, () ->
		// {
		// 	FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		// 	{
		// 		Logger.startLevel(1);
		// 		LevelStats.initialize(1, false);
		// 		FlxG.switchState(new RoomThree());
		// 	});
		// }, "Room 3", 100, 30);
		// level3.x = (FlxG.width / 2) - (level3.width / 2) - 150;
		// level3.y = (FlxG.height / 2) - 10;
		// add(level3);

		// level4 = new FlxButtonPlus(0, 0, () ->
		// {
		// 	FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		// 	{
		// 		Logger.startLevel(1);
		// 		LevelStats.initialize(1, false);
		// 		FlxG.switchState(new RoomFour());
		// 	});
		// }, "Room 4", 100, 30);
		// level4.x = (FlxG.width / 2) - (level4.width / 2) - 150;
		// level4.y = (FlxG.height / 2) + 60;
		// add(level4);

		// level5 = new FlxButtonPlus(0, 0, () ->
		// {
		// 	FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		// 	{
		// 		Logger.startLevel(1);
		// 		LevelStats.initialize(1, false);
		// 		FlxG.switchState(new RoomFive());
		// 	});
		// }, "Room 5", 100, 30);
		// level5.x = (FlxG.width / 2) - (level5.width / 2) + 150;
		// level5.y = (FlxG.height / 2) - 150;
		// add(level5);

		// level6 = new FlxButtonPlus(0, 0, () ->
		// {
		// 	FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		// 	{
		// 		Logger.startLevel(1);
		// 		LevelStats.initialize(1, false);
		// 		FlxG.switchState(new RoomSix());
		// 	});
		// }, "Room 6", 100, 30);
		// level6.x = (FlxG.width / 2) - (level6.width / 2) + 150;
		// level6.y = (FlxG.height / 2) - 80;
		// add(level6);

		back = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new MenuState());
			});
		}, "Back to Main Menu", 150, 30);
		back.x = (FlxG.width / 2) - (back.width / 2);
		back.y = (FlxG.height / 2) + 130;
		add(back);

		super.create();
	}
}
