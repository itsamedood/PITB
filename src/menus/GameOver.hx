package menus;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import menus.MainMenu;

class GameOver extends FlxState
{
	public var score(default, null):Int;

	public function new(_score:Int)
	{
		super();
		this.score = _score;
	}

	override public function create():Void
	{
		#if debug FlxG.debugger.drawDebug = false; #end
		Util.black.alpha = 0;
		FlxG.camera.fade(FlxColor.BLACK, 3, true);

		add(new FlxText(0, 0, 0, 'SCORE: ${this.score}', 75, true).screenCenter());
		return super.create();
	}

	override public function update(_elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed([ESCAPE]) || FlxG.mouse.justPressed)
			FlxG.switchState(new MainMenu());

		return super.update(_elapsed);
	}
}
