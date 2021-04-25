package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TitleState extends FlxState
{
	private static var TITLE = "Deeper";

	private var _background:FlxBackdrop;
	private var _titleText:FlxText;
	private var _insText:FlxText;
	private var _startText:FlxText;

	override public function create()
	{
		super.create();
		// _selectSound = FlxG.sound.load(AssetPaths.select__wav, 0.3);

		// bgColor = new FlxColor(0xFF009900);
		// _background = new FlxBackdrop(AssetPaths.grass_dark__png);
		// add(_background);

		_titleText = new FlxText(0, 150, Registry.WINDOW_WIDTH, TITLE);
		_titleText.setFormat(AssetPaths.Action_Man__ttf, 48, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_titleText);

		var insString = "The objective is to go deeper!\n
		Drag your mouse along three tiles with the first and last matching.\n
		The middle tile will drop to the next board, and the first and last tile will change color.\n
		Use UP/DOWN or W/S to move between boards.\n
		As you go deeper, there's better treasure to be found and more points to be gained!
		";
		_insText = new FlxText(0, 250, Registry.WINDOW_WIDTH, insString);
		_insText.setFormat(AssetPaths.Action_Man__ttf, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_insText);

		_startText = new FlxText(0, 550, Registry.WINDOW_WIDTH, "Start game");
		_startText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_startText);

		MusicUtils.playMusic(AssetPaths.Mine__ogg, 0);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_startText))
		{
			FlxG.switchState(new PlayState());
		}
	}
}
