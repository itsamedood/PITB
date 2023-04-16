package menus;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import menus.MainMenu;

using Util;

class GameOver extends FlxState
{
	public var score(default, null):Int;

	private var _scoreText:FlxText;
	private final _menuTimer = new FlxTimer();

	public function new(_score:Int):Void
	{
		super();
		this.score = _score;
	}

	override public function create():Void
	{
		#if debug FlxG.debugger.drawDebug = false; #end
		Util.black.alpha = 0;
		FlxG.camera.fade(FlxColor.BLACK, 3, true);

		_scoreText = new FlxText(0, 0, 0, 'Score: ${this.score}', 100, true);
		_scoreText.font = Font.GHASTLY_PANIC;
		_scoreText.color = 0xFFFF0000;
		_scoreText.screenCenter();

		add(_scoreText);
		saveHighscore();

		_menuTimer.start(5, (_t) -> FlxG.switchState(new MainMenu()));

		return super.create();
	}

	override public function update(_elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed([ESCAPE]) || FlxG.mouse.justPressed)
			FlxG.switchState(new MainMenu());

		return super.update(_elapsed);
	}

	private function saveHighscore():Void
	{
		final save = new FlxSave();
		save.bind("PITB");

		final highscore:Null<Int> = save.data.highscore;

		if ((highscore == null || this.score > highscore) && this.score > 0)
			save.data.highscore = this.score;

		save.close();
	}
}
