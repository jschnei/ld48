package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Http;

class EndState extends FlxState
{
	private var _scoreText:FlxText;

	private var _playAgainButton:FlxText;

	override public function create()
	{
		super.create();

		_scoreText = new FlxText(0, 0);
		_scoreText.setFormat(AssetPaths.Action_Man__ttf, 24, FlxColor.WHITE, FlxTextAlign.CENTER);
		_scoreText.text = "You scored " + Registry.score + " points!";
		add(_scoreText);

		_playAgainButton = new FlxText(0, 250);
		_playAgainButton.setFormat(AssetPaths.Action_Man__ttf, 30, FlxColor.WHITE, FlxTextAlign.CENTER);
		_playAgainButton.text = "Click to play again";
		add(_playAgainButton);

		submitScore();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_playAgainButton))
		{
			FlxG.switchState(new TitleState());
		}
	}

	public function submitScore()
	{
		var req = new haxe.Http(Registry.SUBMIT_SCORE_URL);
		req.setParameter("name", Registry.name);
		req.setParameter("score", Std.string(Registry.score));
		req.onError = function(msg:String)
		{
			trace("Submit Score Error:", msg);
		}
		req.request(true);
	}
}
