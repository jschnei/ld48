package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class HUD extends FlxSpriteGroup {
    private var _scoreText:FlxText;
    
	private var _timer:FlxBar;

    public function new(timeLimit:Float, ?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        _scoreText = new FlxText(0, 0);
		_scoreText.size = 18;
		add(_scoreText);

        _timer = new FlxBar(30, 30, FlxBarFillDirection.BOTTOM_TO_TOP, 10, 300);
        _timer.createColoredEmptyBar(FlxColor.BLACK, true);
        _timer.createColoredFilledBar(FlxColor.WHITE);
        _timer.setRange(0, timeLimit);
        add(_timer);

        // _overallTimeBar = new FlxSprite(15, 30);
        // _overallTimeBar.makeGraphic(10, 200, FlxColor.WHITE);
        // add(_overallTimeBar);

        // _remainingTimeBar = new FlxSprite(16, 31);
        // _remainingTimeBar.makeGraphic(8, 3, FlxColor.BLACK);
        // add(_remainingTimeBar);
    }

    public function setScore(score:Int) {
		_scoreText.text = "Score: " + score;
    }

    public function setTimeLeft(timeLeft:Float) {
        _timer.value = timeLeft;
    }
}