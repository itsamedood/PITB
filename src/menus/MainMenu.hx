package menus;

import PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;

using Util;

class LoadState extends FlxState
{
	private var _loadText:FlxText;
	private final _loadTimer = new FlxTimer();

	override public function create():Void
	{
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = false;

		_loadText = new FlxText(0, 0, 0, "Loading assets...", 100, true);
		_loadText.font = Font.HEY_COMIC;
		// _loadText.color = 0xFFFF0000;
		_loadText.screenCenter();

		add(_loadText);

		_loadTimer.start(1.5, (_t) ->
		{
			Util.eerieBgNoise.loadEmbedded("assets/music/eerie-bg-noise.ogg", true);
			FlxG.switchState(new MainMenu());
		});

		return super.create();
	}

	override public function update(elapsed:Float):Void
	{
		return super.update(elapsed);
	}
}

class MainMenu extends FlxState
{
	private var _titleText:FlxText;
	private var _highscoreText:FlxText;
	private var _playButton:ClickableText;
	private var _exitButton:ClickableText;
	private var _pythonLogo:FlxSprite;

	override public function create():Void
	{
		FlxG.mouse.visible = true;

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
		_pythonLogo.angularVelocity = 20;

		Util.addMany(_titleText, _playButton, _exitButton, _pythonLogo);
		displayHighscore();

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

	private function displayHighscore():Void
	{
		final save = new FlxSave();
		save.bind("PITB");

		final highscore:Null<Int> = save.data.highscore;

		if (highscore != null)
		{
			_highscoreText = new FlxText(0, 0, 0, 'Highscore: $highscore', 50, true);
			_highscoreText.font = Font.GHASTLY_PANIC;
			_highscoreText.alpha = 0.5;
			_highscoreText.screenCenter().y += (FlxG.height / 3) + (_playButton.height);

			add(_highscoreText);
		}

		save.close();
	}
}
