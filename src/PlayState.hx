import entities.Lang;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sys.FileSystem;

using Util;

class PlayState extends FlxState
{
	public var score(get, set):Int;

	private var _blackBg:FlxSprite;
	private var _black:FlxSprite;
	private var _score = 0;
	private final _ding = new FlxSound();
	private final _langs = new FlxTypedGroup<Lang>();
	private final _findTimer = new FlxTimer();
	private final _scareTimer = new FlxTimer();

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		_ding.loadEmbedded("assets/sounds/ding.ogg");

		_blackBg = new FlxSprite(0, 0, "assets/images/bgs/black_bg.png");
		_blackBg.scale.x *= 5;
		_blackBg.scale.y *= 5;
		_blackBg.visible = false;

		_black = new FlxSprite(0, 0, "assets/images/bgs/black.png");
		_black.scale.x *= 10;
		_black.scale.y *= 10;

		addLangs();
		spawnLangs();

		Util.addMany(_blackBg, _langs, _black);
		return super.create();
	}

	override public function update(_elapsed:Float):Void
	{
		#if debug
		if (FlxG.keys.anyPressed([SHIFT]) && FlxG.keys.anyJustPressed([B]))
		{
			FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
			FlxG.mouse.visible = !FlxG.mouse.visible;
			_black.visible = !_black.visible;
		}
		#end

		_black.x = FlxG.mouse.x - (_black.width / 2) - 15;
		_black.y = FlxG.mouse.y - (_black.height / 2) - 45;

		_langs.forEach((_l) ->
		{
			if ((FlxG.mouse.overlaps(_l) && FlxG.mouse.justPressed))
			{
				if (_l.langName != "python")
				{
					_l.jumpscare(this.score);
					_scareTimer.start(0.4, (_t) ->
					{
						_t.destroy();
						_black.visible = false;
						_blackBg.visible = true;

						_langs.forEach((_ol) ->
						{
							if (_ol.langName != _l.langName)
								_ol.visible = false;
						});
					});
				}
				else
					ding();
			}
		});

		return super.update(_elapsed);
	}

	private function addLangs()
	{
		for (_file in FileSystem.readDirectory("assets/images/regular"))
		{
			if (_file != "haxeflixel.png")
				_langs.add(new Lang(_file.split('.')[0]));
		}

		_langs.forEach((_l) ->
		{
			_l.scale.x /= 8;
			_l.scale.y /= 8;
			_l.updateHitbox();
		});
	}

	private function spawnLangs()
	{
		_langs.forEach((_l) ->
		{
			final n = 100;
			_l.x = FlxG.random.float(10, FlxG.width - n);
			while (!_l.isOnScreen())
				_l.x = FlxG.random.float(10, FlxG.width - n);

			_l.y = FlxG.random.float(10, FlxG.height - n);
			while (!_l.isOnScreen())
				_l.y = FlxG.random.float(10, FlxG.height - n);
		});
	}

	private function ding()
	{
		_ding.play(true);
		FlxG.camera.flash(FlxColor.LIME, 0.5);
		score++;
		spawnLangs();
	}

	@:noCompletion
	private function get_score():Int
	{
		return _score;
	}

	@:noCompletion
	private function set_score(_s)
	{
		return _score = _s;
	}
}
