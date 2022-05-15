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

		_title = new FlxText(0, 150, 0, "Pause Menu", 28);
		_title.alignment = CENTER;
		_title.screenCenter(X);
		add(_title);
		_title.scrollFactor.set(0, 0);

		_menuBtn = new FlxButton(0, 0, "Exit to Main Menu", () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
			{
				Logger.levelEnd("pause exit");
				FlxG.switchState(new MenuState());
			});
		});
		_menuBtn.screenCenter(XY);
		// _menuBtn.y = FlxG.height - 200;
		add(_menuBtn);
		_menuBtn.scrollFactor.set(0, 0);

		_backBtn = new FlxButton(0, 0, "Continue", () -> close());
		_backBtn.screenCenter(X);
		_backBtn.y = _menuBtn.y - _backBtn.height - 20;
		add(_backBtn);
		_backBtn.scrollFactor.set(0, 0);

		// _desktopBtn = new FlxButton(0, 0, "Exit to Desktop", () -> Sys.exit(0));
		// _backBtn.screenCenter(X);
		// _backBtn.y = _menuBtn.y + _desktopBtn.height + 2;
		// add(_backBtn);
	}
}
