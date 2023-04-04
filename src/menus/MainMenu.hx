package menus;

import PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using Util;

class MainMenu extends FlxState
{
	private var _titleText:FlxText;
	private var _playButton:ClickableText;
	private var _exitButton:ClickableText;
	private var _pythonLogo:FlxSprite;

	override public function create():Void
	{
		FlxG.mouse.useSystemCursor = true;

		_titleText = new FlxText(0, 0, 0, "Python Is The Best", 90, true);
		_titleText.font = Font.HEY_COMIC;
		_titleText.screenCenter().y -= FlxG.height / 3;

		_playButton = new ClickableText(0, 0, 0, "PLAY", 50, true, FlxColor.WHITE, FlxColor.YELLOW, (_) -> FlxG.switchState(new PlayState()));
		_playButton.font = Font.HEY_COMIC;
		_playButton.screenCenter().x -= 100;
		_playButton.y += 250;

		_exitButton = new ClickableText(0, 0, 0, "EXIT", 50, true, FlxColor.WHITE, FlxColor.YELLOW, (_) -> Sys.exit(0));
		_exitButton.font = Font.HEY_COMIC;
		_exitButton.screenCenter().x += 100;
		_exitButton.y += 250;

		_pythonLogo = new FlxSprite(0, 0, "assets/images/regular/python.png");
		_pythonLogo.setGraphicSize(200, 200);
		_pythonLogo.updateHitbox();
		_pythonLogo.screenCenter();

		Util.addMany(_titleText, _playButton, _exitButton, _pythonLogo);
		return super.create();
	}

	override public function update(_elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed([ESCAPE]))
			Sys.exit(0);

		if (FlxG.mouse.overlaps(_pythonLogo) && FlxG.mouse.justPressed)
			FlxG.sound.play("assets/sounds/honk.ogg", 1, false);

		return super.update(_elapsed);
	}
}
