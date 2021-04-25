package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TitleState extends FlxState
{
	private static var TITLE = "Deeper";
	private static var WIDTH = 400;

	private var _background:FlxBackdrop;
	private var _titleText:FlxText;
	private var _helpText:FlxText;
	private var _startText:FlxText;

	override public function create()
	{
		super.create();
		// _selectSound = FlxG.sound.load(AssetPaths.select__wav, 0.3);

		// bgColor = new FlxColor(0xFF009900);
		// _background = new FlxBackdrop(AssetPaths.grass_dark__png);
		// add(_background);

		_titleText = new FlxText(0, 150, WIDTH, TITLE);
		_titleText.setFormat(AssetPaths.Action_Man__ttf, 48, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_titleText);

		_helpText = new FlxText(0, 200, WIDTH, "How to play");
		_helpText.setFormat(AssetPaths.Action_Man__ttf, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_helpText);

		_startText = new FlxText(0, 250, WIDTH, "Start game");
		_startText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_startText);

		// MusicUtils.playMusic(AssetPaths.title__ogg, 7351.20181406);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_helpText))
		{
			//
		}
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_startText))
		{
			FlxG.switchState(new PlayState());
		}
	}
}
