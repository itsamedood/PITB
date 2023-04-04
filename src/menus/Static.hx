package menus;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import menus.GameOver;

using Util;

class Static extends FlxState
{
	private var score(default, null):Int;
	private final _timer:FlxTimer = new FlxTimer();
	private var _stopped = false;
	private var _vhs = new FlxSound();

	public function new(_score:Int)
	{
		super();
		this.score = _score;
	}

	override public function create():Void
	{
		FlxG.mouse.visible = false;
		_vhs.loadEmbedded("assets/sounds/vhs.ogg", true);
		_vhs.volume = 2;

		startStatic();
		_timer.start(7, (_) -> stopStatic());

		return super.create();
	}

	override public function update(_elapsed:Float):Void
	{
		#if debug
		if (FlxG.mouse.justPressed)
			stopStatic();
		#end

		if (_stopped)
		{
			Util.black.alpha += 0.003;

			if (Util.black.alpha >= 1)
			{
				Util.staticGif.visible = false;
				Util.staticGif.stop();
				FlxG.switchState(new GameOver(this.score));
			}
		}

		return super.update(_elapsed);
	}

	private function startStatic()
	{
		Util.staticGif.visible = true;
		Util.staticGif.play();
		_vhs.play(false, 2);
	}

	private function stopStatic()
	{
		_stopped = true;
		_vhs.fadeOut(3);
	}
}
