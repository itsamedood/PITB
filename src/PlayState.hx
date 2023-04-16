import entities.Lang;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxRainbowEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sys.FileSystem;

using Util;

class PlayState extends FlxState
{
	public var score(get, set):Int;

	private final _CLICK_TIME:Float = 1;

	// Sprites & Text.
	private var _blackBg:FlxSprite;
	private var _black:FlxSprite;
	private var _flixelFxBg:FlxEffectSprite;
	private var _guideText:FlxText;
	private var _timeLeftText:FlxText;

	// Numbers.
	private var _score = 0;
	private var _time = 20;
	private var _clickTime:Float = 0;

	// Booleans.
	private var _textToGo = false;
	private var _canClick = true;
	private var _chanceSucceeded = false;
	private var _lost = false;

	// Timers.
	private final _textTimer = new FlxTimer();
	private final _findTimer = new FlxTimer();
	private final _scareTimer = new FlxTimer();

	// Other.
	private final _ding = new FlxSound();
	private final _langs = new FlxTypedGroup<Lang>();

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

		_flixelFxBg = new FlxEffectSprite(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height), [new FlxRainbowEffect(0.3, 1, 3)]);
		_flixelFxBg.alpha = 0.3;
		_flixelFxBg.visible = false;

		_guideText = new FlxText(0, 0, 0, "Find and click the best programming language.", 40, true);
		_guideText.font = Font.HEY_COMIC;
		_guideText.alpha = 0.5;
		_guideText.screenCenter();

		_findTimer.start(_time, (_t) -> killPlayer(_langs.getRandom()));

		_timeLeftText = new FlxText(0, 0, 0, '${_findTimer.timeLeft}', 75, true);
		_timeLeftText.font = Font.GHASTLY_PANIC;
		_timeLeftText.alpha = 0.3;
		_timeLeftText.screenCenter().x += (FlxG.width / 3) + 75;
		_timeLeftText.y -= (FlxG.height / 3) + 75;

		Util.eerieBgNoise.play(false);

		_textTimer.start(3, (_t) ->
		{
			_t.destroy();
			_textToGo = true;
		});

		addLangs();
		spawnLangs();

		Util.addMany(_blackBg, _langs, _flixelFxBg, _black, _guideText, _timeLeftText);
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

		if (_clickTime > 0)
			_clickTime -= 0.1;

		if (_textToGo && _guideText.alpha > 0)
			_guideText.alpha -= 0.05;

		_black.x = FlxG.mouse.x - (_black.width / 2) - 15;
		_black.y = FlxG.mouse.y - (_black.height / 2) - 45;

		_langs.forEach((_l) ->
		{
			if ((FlxG.mouse.overlaps(_l) && (FlxG.mouse.justPressed && (_canClick && !_lost && _clickTime <= 0))))
			{
				_l.langName != "python" ? killPlayer(_l) : ding();
				_clickTime = _CLICK_TIME;
			}
		});

		_timeLeftText.text = '${Math.round(_findTimer.timeLeft)}';
		return super.update(_elapsed);
	}

	private function addLangs():Void
	{
		for (_file in FileSystem.readDirectory("assets/images/regular"))
			if (_file != "haxeflixel.png")
				_langs.add(new Lang(_file.split('.')[0]));

		_langs.forEach((_l) ->
		{
			_l.scale.x /= 8;
			_l.scale.y /= 8;
		});
	}

	private function runChance():Void
	{
		final r = #if debug FlxG.random.int(1, 2) % 2 == 0 #else FlxG.random.int(0, 100) % 2 == 0 #end;

		if (r)
		{
			trace('Chance succeeded! (${this.score})');

			_langs.forEach((_l) ->
			{
				if (_l.langName == "haxe")
				{
					_l.langName = "haxeflixel";
					_l.reload();

					_chanceSucceeded = true;
				}
			});
		}
	}

	private function spawnLangs():Void
	{
		if (_chanceSucceeded)
		{
			_langs.forEach((_l) ->
			{
				if (_l.langName == "haxeflixel")
				{
					_l.langName = "haxe";
					_l.reload();
				}
			});

			_chanceSucceeded = false;
		}

		if (this.score > 0 && this.score % 5 == 0)
			runChance();

		_langs.forEach((_l) ->
		{
			final n = 100;
			_l.x = FlxG.random.float(10, FlxG.width - n);
			while (!_l.isOnScreen())
				_l.x = FlxG.random.float(10, FlxG.width - n);

			_l.y = FlxG.random.float(10, FlxG.height - n);
			while (!_l.isOnScreen())
				_l.y = FlxG.random.float(10, FlxG.height - n);

			_l.updateHitbox();
		});
	}

	private function killPlayer(_l:Lang):Void
	{
		_lost = true;
		_l.jumpscare(this.score);
		_findTimer.cancel();

		_scareTimer.start(0.4, (_t) ->
		{
			if (_l.langName == "haxeflixel")
				_flixelFxBg.visible = true;
			_black.visible = false;
			_blackBg.visible = true;
			Util.eerieBgNoise.fadeOut(2);

			_langs.forEach((_ol) ->
			{
				if (_ol.langName != _l.langName)
					_ol.visible = false;
			});
		});
	}

	private function ding():Void
	{
		if (this.score > 0 && this.score % 10 == 0)
			_time -= 2;

		_ding.play(true);
		_findTimer.reset(_time);
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
	private function set_score(_s):Int
	{
		return _score = _s;
	}
}
