package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class HUD extends FlxSpriteGroup
{
	private var _scoreText:FlxText;

	private var _timer:FlxBar;

	private var _endGame:FlxButton;
	private var _playState:PlayState;

	public function new(timeLimit:Float, playState:PlayState, ?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
		_playState = playState;

		_scoreText = new FlxText(0, 0);
		_scoreText.setFormat(Registry.fontSource, 24, FlxColor.WHITE);
        _scoreText.borderColor = FlxColor.BLACK;
        _scoreText.text = "Score: 0";
		add(_scoreText);

		if (Registry.TIME_ON)
		{
			_timer = new FlxBar(45, 35, FlxBarFillDirection.BOTTOM_TO_TOP, 10, 290);
			_timer.createColoredEmptyBar(FlxColor.BLACK, true);
			_timer.createColoredFilledBar(FlxColor.WHITE);
			_timer.setRange(0, timeLimit);
            _timer.value = timeLimit;
			add(_timer);
		}

		_endGame = new FlxButton(0, 725, "End Game", function()
		{
			_playState.endGame();
		});
		add(_endGame);
	}

	public function setScore(score:Int)
	{
		_scoreText.text = "Score: " + score;
	}

	public function setTimeLeft(timeLeft:Float)
	{
		_timer.value = timeLeft;
	}

    public function fadeIn(duration:Float) {
        _scoreText.alpha = 0;
        FlxTween.tween(_scoreText, {alpha: 1}, duration);
        if (Registry.TIME_ON) {
            _timer.alpha = 0;
            FlxTween.tween(_timer, {alpha: 1}, duration);
        }
    }
}
