package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class HUD extends FlxSpriteGroup
{
	private var _scoreText:FlxText;

	private var _timer:FlxBar;

	public function new(timeLimit:Float, ?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);

		_scoreText = new FlxText(0, 0);
		_scoreText.setFormat(Registry.fontSource, 24, FlxColor.WHITE);
		add(_scoreText);

		if (Registry.TIME_ON)
		{
			_timer = new FlxBar(40, 35, FlxBarFillDirection.BOTTOM_TO_TOP, 10, 300);
			_timer.createColoredEmptyBar(FlxColor.BLACK, true);
			_timer.createColoredFilledBar(FlxColor.WHITE);
			_timer.setRange(0, timeLimit);
			add(_timer);
		}
	}

	public function setScore(score:Int)
	{
		_scoreText.text = "Score: " + score;
	}

	public function setTimeLeft(timeLeft:Float)
	{
		_timer.value = timeLeft;
	}
}
