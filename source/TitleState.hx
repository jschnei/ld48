package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class TitleState extends FlxState
{
	private static var TITLE = "Match! Drop! Match!";

	private var _background:FlxSprite;
	private var _titleText:FlxText;
	private var _insText:FlxText;
	private var _startText:FlxText;
	private var _startUntimedText:FlxText;

	private var _tileSprites:FlxSpriteGroup;

	override public function create()
	{
		super.create();

		addBackground();

		_titleText = new FlxText(0, 180, Registry.WINDOW_WIDTH, TITLE);
		_titleText.setFormat(Registry.fontSource, 40, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_titleText);

		var insString = "Match tiles to go deeper and find treasure!\n\nTo make a match, drag your mouse along three tiles with the first and last matching.\n\nMatch examples: \n\n\n\nWhen you make a match, the middle tile will drop down to the next board, and the first and last tiles will change color.\n\nUse UP/DOWN, W/S, or the scroll wheel to move between boards.\n\nAs you go deeper, you'll find better treasure and get many more points for making matches!";
		_insText = new FlxText(0, 240, Registry.WINDOW_WIDTH, insString);
		_insText.setFormat(Registry.fontSource, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_insText);

		addTileImages();

		_startText = new FlxText(0, 670, Registry.WINDOW_WIDTH, "Start game");
		_startText.setFormat(Registry.fontSource, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_startText);

		_startUntimedText = new FlxText(0, 710, Registry.WINDOW_WIDTH, "Start untimed game");
		_startUntimedText.setFormat(Registry.fontSource, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_startUntimedText);

		MusicUtils.playMusic(AssetPaths.fruitbox__wav, 0);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.overlaps(_startText))
		{
			_startText.color = FlxColor.ORANGE;
			if (FlxG.mouse.justPressed)
			{
				Registry.setMode(Registry.GameMode.ARCADE);
				transitionToGameStart();
			}
		}
		else
		{
			_startText.color = FlxColor.WHITE;
		}

		if (FlxG.mouse.overlaps(_startUntimedText))
		{
			_startUntimedText.color = FlxColor.ORANGE;
			if (FlxG.mouse.justPressed)
			{
				Registry.setMode(Registry.GameMode.UNTIMED);
				transitionToGameStart();
			}
		}
		else
		{
			_startUntimedText.color = FlxColor.WHITE;
		}
	}

	public function transitionToGameStart():Void
	{
		for (text in [_titleText, _insText, _startText, _startUntimedText])
		{
			FlxTween.tween(text, {alpha: 0, y: text.y - Registry.BACKGROUND_STARTING_HEIGHT}, 1, {
				ease: FlxEase.sineOut
			});
		}
		for (sprite in _tileSprites)
		{
			FlxTween.tween(sprite, {alpha: 0, y: sprite.y - Registry.BACKGROUND_STARTING_HEIGHT}, 1, {
				ease: FlxEase.sineOut
			});
		}
		FlxTween.tween(_background, {y: -Registry.BACKGROUND_STARTING_HEIGHT}, 1, {
			ease: FlxEase.sineOut,
			onComplete: function(tween:FlxTween)
			{
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
		_tileSprites = new FlxSpriteGroup();
		var y = 370;
		// Offsets for 'L' shapes
		var yOffset = 10;
		var xOffset = 80;

		// Center horizontal strip
		loadTileGraphics(new FlxSprite((Registry.WINDOW_WIDTH - 3 * Grid.CELL_WIDTH) / 2, y), new FlxSprite((Registry.WINDOW_WIDTH - Grid.CELL_WIDTH) / 2, y),
			new FlxSprite((Registry.WINDOW_WIDTH + Grid.CELL_WIDTH) / 2, y), AssetPaths.bluea__png, AssetPaths.purplea__png);

		// Right 'L', all same colors
		loadTileGraphics(new FlxSprite(Registry.WINDOW_WIDTH / 2 + xOffset, y + yOffset),
			new FlxSprite(Registry.WINDOW_WIDTH / 2 + xOffset + Grid.CELL_WIDTH, y + yOffset),
			new FlxSprite(Registry.WINDOW_WIDTH / 2 + xOffset + Grid.CELL_WIDTH, y + yOffset - Grid.CELL_HEIGHT), AssetPaths.reda__png, AssetPaths.reda__png);

		// Left 'L'
		loadTileGraphics(new FlxSprite(Registry.WINDOW_WIDTH / 2 - xOffset - Grid.CELL_WIDTH, y + yOffset),
			new FlxSprite(Registry.WINDOW_WIDTH / 2 - xOffset - Grid.CELL_WIDTH, y + yOffset - Grid.CELL_HEIGHT),
			new FlxSprite(Registry.WINDOW_WIDTH / 2 - xOffset - Grid.CELL_WIDTH * 2, y + yOffset - Grid.CELL_HEIGHT), AssetPaths.greena__png,
			AssetPaths.yellowa__png);
	}

	private function loadTileGraphics(sprite1:FlxSprite, sprite2:FlxSprite, sprite3:FlxSprite, colorA:String, colorB:String):Void
	{
		sprite1.loadGraphic(colorA, false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		add(sprite1);
		_tileSprites.add(sprite1);
		sprite2.loadGraphic(colorB, false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		add(sprite2);
		_tileSprites.add(sprite2);
		sprite3.loadGraphic(colorA, false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		add(sprite3);
		_tileSprites.add(sprite3);
	}
}
