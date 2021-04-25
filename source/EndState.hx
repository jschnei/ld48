package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;

class EndState extends FlxState {
    private var _scoreText:FlxText;

    private var _playAgainButton:FlxText;

    override public function create()
    {
        super.create();

        _scoreText = new FlxText(0, 0);
        _scoreText.setFormat(AssetPaths.Action_Man__ttf, 48, FlxColor.WHITE, FlxTextAlign.CENTER);
        _scoreText.text = "You scored " + Registry.score + " points!";
        add(_scoreText);

        _playAgainButton = new FlxText(0, 250);
        _playAgainButton.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
        _playAgainButton.text = "Click to play again";
        add(_playAgainButton);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_playAgainButton))
        {
            FlxG.switchState(new TitleState());
        }
    }
}