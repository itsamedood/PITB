package;

import flixel.FlxGame;
import gif.AnimatedGif;
import menus.MainMenu.LoadState;
import openfl.Assets;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChildAt(new FlxGame(0, 0, LoadState, 120, 120, false, true), 0);

		Util.staticGif = new AnimatedGif(Assets.getBytes("assets/gifs/static.gif"));
		Util.staticGif.visible = false;
		Util.staticGif.scaleX *= 2;
		Util.staticGif.scaleY *= 2;
		addChildAt(Util.staticGif, 1);

		Util.black.alpha = 0;
		Util.black.scaleX *= 2;
		Util.black.scaleY *= 2;
		addChildAt(Util.black, 2);

		#if debug
		Util.FPS.scaleX *= 1.5;
		Util.FPS.scaleY *= 1.5;
		addChildAt(Util.FPS, 3);
		#end
	}
}
