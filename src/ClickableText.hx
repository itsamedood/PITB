import flixel.FlxG;
import flixel.text.FlxText;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
	Extension of `FlxText` that turns a piece of text into a button.
**/
class ClickableText extends FlxText
{
	/**
		Normal text color.
	**/
	public var primaryColor(default, set):FlxColor = FlxColor.WHITE;

	/**
		Color of the text when the mouse cursor is hovering over it.
	**/
	public var secondaryColor(default, set):FlxColor = FlxColor.YELLOW;

	/**
		Function to call when the text is clicked on.
	**/
	public var onClicked(default, set):Null<ClickableText->Void>;

	public function new(_x:Float = 0, _y:Float = 0, _fieldWidth:Float = 0, ?_text:Null<String>, _size:Int = 8, _embeddedFont:Bool = true,
			_primaryColor:FlxColor = FlxColor.WHITE, _secondaryColor:FlxColor = FlxColor.YELLOW, ?_onClicked:Null<ClickableText->Void> = null)
	{
		super(_x, _y, _fieldWidth, _text, _size, _embeddedFont);
		this.primaryColor = _primaryColor;
		this.secondaryColor = _secondaryColor;
		this.onClicked = _onClicked;
	}

	override public function update(_elapsed:Float):Void
	{
		FlxG.mouse.overlaps(this) ? {
			this.color = this.secondaryColor;

			if (FlxG.mouse.justPressed)
				if (this.onClicked != null)
					this.onClicked(this);
		} : this.color = this.primaryColor;
		super.update(_elapsed);
	}

	@:noCompletion
	private function set_primaryColor(_primaryColor:FlxColor):FlxColor
	{
		return this.primaryColor = _primaryColor;
	}

	@:noCompletion
	private function set_secondaryColor(_secondaryColor:FlxColor):FlxColor
	{
		return this.secondaryColor = _secondaryColor;
	}

	@:noCompletion
	private function set_onClicked(_onClicked:Null<ClickableText->Void>):Null<ClickableText->Void>
	{
		return this.onClicked = _onClicked;
	}
}
