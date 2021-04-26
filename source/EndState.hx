package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Http;

class EndState extends FlxState
{
	private static var NAME_INPUT_WIDTH = 200;

	private var _scoreText:FlxText;
	private var _nameInput:FlxInputText;
	private var _submitButton:FlxText;
	private var _submitted:Bool = false;
	private var _playAgainButton:FlxText;
	private var _background:FlxSprite;

	override public function create()
	{
		super.create();

		addBackground();

		_scoreText = new FlxText(0, 120, Registry.WINDOW_WIDTH);
		_scoreText.setFormat(Registry.fontSource, 24, FlxColor.WHITE, FlxTextAlign.CENTER);
		_scoreText.text = "You scored " + Registry.score + " points!";
		add(_scoreText);

		_nameInput = new FlxInputText((Registry.WINDOW_WIDTH - NAME_INPUT_WIDTH) / 2, 200, NAME_INPUT_WIDTH, "Anonymous", 16);
		_nameInput.alignment = FlxTextAlign.CENTER;
		add(_nameInput);

		_submitButton = new FlxText(0, 600, Registry.WINDOW_WIDTH, "Submit score");
		_submitButton.setFormat(Registry.fontSource, 30, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(_submitButton);

		_playAgainButton = new FlxText(0, 700, Registry.WINDOW_WIDTH);
		_playAgainButton.setFormat(Registry.fontSource, 30, FlxColor.WHITE, FlxTextAlign.CENTER);
		_playAgainButton.text = "Click to play again";
		add(_playAgainButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(_submitButton))
		{
			_submitButton.color = FlxColor.ORANGE;
			if (FlxG.mouse.justPressed)
			{
				if (!_submitted)
					submitScore();
				_submitted = true;
				_submitButton.text = "Submitted!";
			}
		}
		else
		{
			_submitButton.color = FlxColor.WHITE;
		}

		if (FlxG.mouse.overlaps(_playAgainButton))
		{
			_playAgainButton.color = FlxColor.ORANGE;
			if (FlxG.mouse.justPressed)
			{
				FlxG.switchState(new TitleState());
			}
		}
		else
		{
			_playAgainButton.color = FlxColor.WHITE;
		}
	}

	public function submitScore()
	{
		var req = new haxe.Http(Registry.SUBMIT_SCORE_URL);
		req.setParameter("name", _nameInput.text);
		req.setParameter("score", Std.string(Registry.score));
		req.setParameter("gamemode", Registry.encodeGameMode());
		req.setParameter("transcript", Registry.encodeTranscript());
		req.setParameter("seed", Std.string(Registry.randomSeed));
		req.onError = function(msg:String)
		{
			trace("Submit Score Error:", msg);
		}
		req.request(true);
	}

	private function addBackground():Void
	{
		_background = new FlxSprite();
		_background.loadGraphic(AssetPaths.endscreen__png, true, Registry.WINDOW_WIDTH, Registry.WINDOW_HEIGHT);
		var flicker = "flicker";
		_background.animation.add(flicker, [0, 1], 1, true);
		_background.animation.play(flicker);
		add(_background);
	}
}
