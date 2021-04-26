package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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

		_titleText = new FlxText(0, 200, Registry.WINDOW_WIDTH, TITLE);
		_titleText.setFormat(Registry.fontSource, 48, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_titleText);

		var insString = "The objective is to mine for treasure!
		Drag your mouse along three tiles with the first and last matching.\n\n
		The middle tile will drop to the next board, and the first and last tile will change color.
		Use UP/DOWN or W/S to move between boards.
		As you go deeper, there's better treasure to be found and more points to be gained!";
		_insText = new FlxText(0, 280, Registry.WINDOW_WIDTH, insString);
		_insText.setFormat(Registry.fontSource, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_insText);

		addTileImages();

		_startText = new FlxText(0, 670, Registry.WINDOW_WIDTH, "Start game");
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
			transitionToGameStart();
		}
	}

	public function transitionToGameStart():Void {
		for (text in [_titleText, _insText, _startText]) {
			FlxTween.tween(text, {alpha: 0, y: text.y - Registry.BACKGROUND_STARTING_HEIGHT}, 1, {
				ease: FlxEase.sineOut
			});
		}
		FlxTween.tween(_background, {y: -Registry.BACKGROUND_STARTING_HEIGHT}, 1, {
			ease: FlxEase.sineOut,
			onComplete: function(tween: FlxTween) {
				FlxG.switchState(new PlayState());
			}
		});
	}

	private function addBackground():Void
	{
		_background = new FlxSprite();
		_background.loadGraphic(AssetPaths.bigbackground__png, true, Registry.WINDOW_WIDTH, Registry.WINDOW_HEIGHT * 6);
		var flicker = "flicker";
		_background.animation.add(flicker, [0, 1], 1, true);
		_background.animation.play(flicker);
		add(_background);
	}

	private function addTileImages():Void
	{
		var y = 370;

		loadTileGraphics(
			new FlxSprite((Registry.WINDOW_WIDTH - Grid.CELL_WIDTH) / 2, y),
			new FlxSprite(x + Grid.CELL_WIDTH, y),
			new FlxSprite(x + 2 * Grid.CELL_WIDTH, y),
			AssetPaths.bluea__png,
			AssetPaths.purplea__png);

		colorA = AssetPaths.reda__png;
		colorB = AssetPaths.yellowa__png;

	}

	private function loadTileGraphics(
		sprite1:FlxSprite,
		sprite2:FlxSprite,
		sprite3:FlxSprite,
		colorA:FlxGraphicAsset,
		colorB:FlxGraphicAsset):Void
	{
		sprite1.loadGraphic(colorA, false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		add(sprite1);
		sprite2.loadGraphic(colorB, false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		add(sprite2);
		sprite3.loadGraphic(colorA, false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		add(sprite3);
	}
}
