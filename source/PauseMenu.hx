import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class PauseMenu extends FlxSubState
{
	private var _title:FlxText;
	private var _backBtn:FlxButton;
	private var _menuBtn:FlxButton;
	private var _desktopBtn:FlxButton;

	override function create()
	{
		super.create();

		_title = new FlxText(0, 120, 0, "Pause Menu", 32);
		_title.alignment = CENTER;
		_title.screenCenter(X);
		add(_title);
		_title.scrollFactor.set(0, 0);

		_menuBtn = new FlxButton(0, 0, "Exit to Main Menu", () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.levelEnd("pause exit");
				LevelStats.bgm.stop();
				FlxG.switchState(new MenuState());
			});
		});
		_menuBtn.scale.set(3, 3);
		_menuBtn.updateHitbox();
		_menuBtn.label.fieldWidth = _menuBtn.width;
		_menuBtn.label.alignment = "center";
		_menuBtn.label.offset.y -= 20;
		_menuBtn.screenCenter(X);
		_menuBtn.y = 350;
		add(_menuBtn);

		_backBtn = new FlxButton(0, 0, "Continue", () ->
		{
			LevelStats.bgm.play();
			close();
		});
		_backBtn.scale.set(3, 3);
		_backBtn.updateHitbox();
		_backBtn.label.fieldWidth = _backBtn.width;
		_backBtn.label.alignment = "center";
		_backBtn.label.offset.y -= 20;
		_backBtn.screenCenter(X);
		_backBtn.y = _menuBtn.y - 100;
		add(_backBtn);

		// _desktopBtn = new FlxButton(0, 0, "Exit to Desktop", () ->
		// {
		// 	trace("Clicked");
		// });
		// _desktopBtn.scale.set(2, 2);
		// _desktopBtn.updateHitbox();
		// _desktopBtn.label.fieldWidth = _desktopBtn.width;
		// _desktopBtn.label.alignment = "center";
		// _desktopBtn.label.offset.y -= 10;
		// _desktopBtn.screenCenter(X);
		// _desktopBtn.y = _menuBtn.y + 40;
		// add(_desktopBtn);
	}
}
