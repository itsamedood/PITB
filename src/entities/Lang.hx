package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import menus.Static;

class Lang extends FlxSprite
{
	public var langName(get, set):String;

	private var _langName:String;
	private var _ogX:Float;
	private var _ogY:Float;
	private var _scream:FlxSound;
	private final _preScreamTimer = new FlxTimer();
	private final _screamTimer = new FlxTimer();

	public function new(_lang:String):Void
	{
		super(0, 0, 'assets/images/regular/$_lang.png');
		_langName = _lang;

		_scream = new FlxSound();
		_scream.loadEmbedded("assets/sounds/scream.ogg");
	}

	override public function update(_elapsed:Float):Void
	{
		return super.update(_elapsed);
	}

	public function jumpscare(_score:Int):Void
	{
		_scream.play(false, 3);
		_preScreamTimer.start(0.4, (_) ->
		{
			_preScreamTimer.destroy();

			loadGraphic('assets/images/scary/${this.langName}_scary.png');
			this.scale.x *= 8;
			this.scale.y *= 8;
			updateHitbox();
			screenCenter();

			_ogX = this.x;
			_ogY = this.y;

			FlxG.camera.shake(0.03, 2);
			_screamTimer.start(2, (_) -> FlxG.camera.fade(FlxColor.WHITE, 0.5, false, () -> FlxG.switchState(new Static(_score))));
		});
	}

	public function reload():Void
	{
		loadGraphic('assets/images/regular/${this.langName}.png');
	}

	@:noCompletion
	public function get_langName():String
	{
		return _langName;
	}

	@:noCompletion
	public function set_langName(_ln):String
	{
		return _langName = _ln;
	}
}
