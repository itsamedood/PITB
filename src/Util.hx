import flixel.FlxBasic;
import flixel.FlxG;
import flixel.system.FlxSound;
import gif.AnimatedGif;
import openfl.display.FPS;
import openfl.display.Sprite;

final class Util
{
	public static final FPS = new FPS(10, 0, 0xFFFFFF);

	public static var staticGif:AnimatedGif;
	public static var black:Black = new Black();
	public static final eerieBgNoise = new FlxSound();

	public static function addMany(_objects:...FlxBasic):Void
	{
		for (object in _objects)
			FlxG.state.add(object);
	}
}

private class Black extends Sprite
{
	public function new():Void
	{
		super();
		this.graphics.beginFill(0x000000);
		this.graphics.drawRect(0, 0, 1000, 1000);
	}
}

@:enum
abstract Font(String) from String to String
{
	private final PATH = "assets/fonts";
	public static final CURSE_OF_THE_ZOMBIE = '$PATH/curse-of-the-zombie.ttf';
	public static final GHASTLY_PANIC = '$PATH/ghastly-panic.ttf';
	public static final HEY_COMIC = '$PATH/hey_comic.ttf';
	public static final TROLLKATT = '$PATH/trollkatt.otf';
}
