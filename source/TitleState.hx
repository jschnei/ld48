package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TitleState extends FlxState
{
	private static var TITLE = "Mine!";

	private var _background:FlxSprite;
	private var _titleText:FlxText;
	private var _insText:FlxText;
	private var _startText:FlxText;

	override public function create()
	{
		super.create();

		addBackground();

		_titleText = new FlxText(0, 220, Registry.WINDOW_WIDTH, TITLE);
		_titleText.setFormat(Registry.fontSource, 48, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_titleText);

		var insString = "The objective is to mine for treasure!\n
		Drag your mouse along three tiles with the first and last matching.\n
		The middle tile will drop to the next board, and the first and last tile will change color.\n
		Use UP/DOWN or W/S to move between boards.\n
		As you go deeper, there's better treasure to be found and more points to be gained!
		";
		_insText = new FlxText(0, 300, Registry.WINDOW_WIDTH, insString);
		_insText.setFormat(Registry.fontSource, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_insText);

		_startText = new FlxText(0, 680, Registry.WINDOW_WIDTH, "Start game");
		_startText.setFormat(Registry.fontSource, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_startText);

		MusicUtils.playMusic(AssetPaths.fruitbox__ogg, 0);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.overlaps(_startText)) {
			_startText.color = FlxColor.ORANGE;
		} else {
			_startText.color = FlxColor.WHITE;
		}
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_startText))
		{
			// Registry.setMode(Registry.GameMode.UNTIMED);
			FlxG.switchState(new PlayState());
		}
	}

	private function addBackground():Void
	{
		_background = new FlxSprite();
		_background.loadGraphic(AssetPaths.main__png, true, Registry.WINDOW_WIDTH, Registry.WINDOW_HEIGHT);
		var flicker = "flicker";
		_background.animation.add(flicker, [0, 1], 1, true);
		_background.animation.play(flicker);
		add(_background);
	}
}
