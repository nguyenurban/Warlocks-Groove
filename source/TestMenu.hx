package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class TestMenuRoom1 extends FlxState
{
	private var title:FlxText;
	private var roomName:FlxText;
	private var room1:FlxButtonPlus;
	private var room2:FlxButtonPlus;
	private var room3:FlxButtonPlus;
	private var room4:FlxButtonPlus;
	private var room5:FlxButtonPlus;
	private var room6:FlxButtonPlus;
	private var room7:FlxButtonPlus;
	private var room8:FlxButtonPlus;
	private var back:FlxButtonPlus;
	private var nextPage:FlxButtonPlus;

	override function create()
	{
		bgColor = 0x00000000;
		title = new FlxText(50, 150, 0, "Select Level to Play", 18);
		title.alignment = CENTER;
		title.screenCenter(X);
		add(title);

		roomName = new FlxText(50, 100, 0, "ROOM 1", 24);
		roomName.alignment = CENTER;
		roomName.screenCenter(X);
		add(roomName);

		room1 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(1);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomOne());
			});
		}, "Room 1", 100, 30);
		room1.x = (FlxG.width / 2) - (room1.width / 2) - 150;
		room1.y = (FlxG.height / 2) - 150;
		add(room1);

		room2 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(1);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomTwo());
			});
		}, "Room 2", 100, 30);
		room2.x = (FlxG.width / 2) - (room2.width / 2) - 150;
		room2.y = (FlxG.height / 2) - 80;
		add(room2);

		room3 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(1);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomThree());
			});
		}, "Room 3", 100, 30);
		room3.x = (FlxG.width / 2) - (room3.width / 2) - 150;
		room3.y = (FlxG.height / 2) - 10;
		add(room3);

		room4 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(1);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomFour());
			});
		}, "Room 4", 100, 30);
		room4.x = (FlxG.width / 2) - (room4.width / 2) - 150;
		room4.y = (FlxG.height / 2) + 60;
		add(room4);

		room5 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(1);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomFive());
			});
		}, "Room 5", 100, 30);
		room5.x = (FlxG.width / 2) - (room5.width / 2) + 150;
		room5.y = (FlxG.height / 2) - 150;
		add(room5);

		room6 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(1);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomSix());
			});
		}, "Room 6", 100, 30);
		room6.x = (FlxG.width / 2) - (room6.width / 2) + 150;
		room6.y = (FlxG.height / 2) - 80;
		add(room6);

		room7 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(1);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomSeven());
			});
		}, "Room 7", 100, 30);
		room7.x = (FlxG.width / 2) - (room7.width / 2) + 150;
		room7.y = (FlxG.height / 2) - 10;
		add(room7);

		room8 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(1);
				LevelStats.initialize(1, false);
				FlxG.switchState(new RoomEight());
			});
		}, "Room 8", 100, 30);
		room8.x = (FlxG.width / 2) - (room8.width / 2) + 150;
		room8.y = (FlxG.height / 2) + 60;
		add(room8);

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

		nextPage = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new TestMenuRoom2());
			});
		}, "Next page", 100, 30);
		nextPage.x = (FlxG.width / 2) - (nextPage.width / 2) + 300;
		nextPage.y = (FlxG.height / 2) + 130;
		add(nextPage);

		super.create();
	}
}

class TestMenuRoom2 extends FlxState
{
	private var title:FlxText;
	private var roomName:FlxText;
	private var room1:FlxButtonPlus;
	private var room2:FlxButtonPlus;
	private var room3:FlxButtonPlus;
	private var room4:FlxButtonPlus;
	private var room5:FlxButtonPlus;
	private var room6:FlxButtonPlus;
	private var room7:FlxButtonPlus;
	private var room8:FlxButtonPlus;
	private var back:FlxButtonPlus;
	private var nextPage:FlxButtonPlus;

	override function create()
	{
		bgColor = 0x00000000;
		title = new FlxText(50, 150, 0, "Select Level to Play", 18);
		title.alignment = CENTER;
		title.screenCenter(X);
		add(title);

		roomName = new FlxText(50, 100, 0, "ROOM 2", 24);
		roomName.alignment = CENTER;
		roomName.screenCenter(X);
		add(roomName);

		room1 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(RoomNo.L2R1);
				LevelStats.initialize(2, false);
				FlxG.switchState(new LvlTwoRoomOne());
			});
		}, "Room 1", 100, 30);
		room1.x = (FlxG.width / 2) - (room1.width / 2) - 150;
		room1.y = (FlxG.height / 2) - 150;
		add(room1);

		room2 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(RoomNo.L2R2);
				LevelStats.initialize(2, false);
				FlxG.switchState(new LvlTwoRoomTwo());
			});
		}, "Room 2", 100, 30);
		room2.x = (FlxG.width / 2) - (room2.width / 2) - 150;
		room2.y = (FlxG.height / 2) - 80;
		add(room2);

		room3 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(RoomNo.L2R3);
				LevelStats.initialize(2, false);
				FlxG.switchState(new LvlTwoRoomThree());
			});
		}, "Room 3", 100, 30);
		room3.x = (FlxG.width / 2) - (room3.width / 2) - 150;
		room3.y = (FlxG.height / 2) - 10;
		add(room3);

		room4 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(RoomNo.L2R4);
				LevelStats.initialize(2, false);
				FlxG.switchState(new LvlTwoRoomFour());
			});
		}, "Room 4", 100, 30);
		room4.x = (FlxG.width / 2) - (room4.width / 2) - 150;
		room4.y = (FlxG.height / 2) + 60;
		add(room4);

		room5 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(RoomNo.L2R5);
				LevelStats.initialize(2, false);
				FlxG.switchState(new LvlTwoRoomFive());
			});
		}, "Room 5", 100, 30);
		room5.x = (FlxG.width / 2) - (room5.width / 2) + 150;
		room5.y = (FlxG.height / 2) - 150;
		add(room5);

		room6 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(RoomNo.L2R6);
				LevelStats.initialize(2, false);
				FlxG.switchState(new LvlTwoRoomSix());
			});
		}, "Room 6", 100, 30);
		room6.x = (FlxG.width / 2) - (room6.width / 2) + 150;
		room6.y = (FlxG.height / 2) - 80;
		add(room6);

		room7 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(RoomNo.L2R7);
				LevelStats.initialize(2, false);
				FlxG.switchState(new LvlTwoRoomSeven());
			});
		}, "Room 7", 100, 30);
		room7.x = (FlxG.width / 2) - (room7.width / 2) + 150;
		room7.y = (FlxG.height / 2) - 10;
		add(room7);

		room8 = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.startLevel(RoomNo.L2R8);
				LevelStats.initialize(2, false);
				FlxG.switchState(new LvlTwoRoomEight());
			});
		}, "Room 8", 100, 30);
		room8.x = (FlxG.width / 2) - (room8.width / 2) + 150;
		room8.y = (FlxG.height / 2) + 60;
		add(room8);

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

		nextPage = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				FlxG.switchState(new TestMenuRoom1());
			});
		}, "Prev page", 100, 30);
		nextPage.x = (FlxG.width / 2) - (nextPage.width / 2) - 300;
		nextPage.y = (FlxG.height / 2) + 130;
		add(nextPage);

		super.create();
	}
}
