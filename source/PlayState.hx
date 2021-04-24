package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	private var activeGrid:Grid;
	private var nextGrid:Grid;
	private var _game:Game;

	private var _scoreText:FlxText;

	override public function create()
	{
		_game = new Game(7, 10);
		switchActiveId(0);

		_scoreText = new FlxText(260, 50);
		_scoreText.size = 18;
		add(_scoreText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.pressed)
		{
			var hoveringTile = activeGrid.getSquare(FlxG.mouse.x, FlxG.mouse.y);
			if (hoveringTile != -1)
			{
				_game.hoverOnTile(hoveringTile);
			}
		}
		if (FlxG.mouse.justReleased)
		{
			_game.submitPath();
		}
		_scoreText.text = "Score: " + _game.score;

		if (FlxG.keys.justPressed.DOWN)
		{
			incrementActiveId();
		}

		if (FlxG.keys.justPressed.UP)
		{
			decrementActiveId();
		}

		super.update(elapsed);
	}

	public function incrementActiveId()
	{
		var curId = _game.activeGrid;
		if (curId + 2 < _game.grids.length)
		{
			switchActiveId(curId + 1);
		}
	}

	public function decrementActiveId()
	{
		var curId = _game.activeGrid;
		if (curId - 1 >= 0)
		{
			switchActiveId(curId - 1);
		}
	}

	public function switchActiveId(gridId:Int)
	{
		if (activeGrid != null)
		{
			_game.detachGrids();
			remove(activeGrid);
			remove(nextGrid);
		}

		_game.activeGrid = gridId;
		activeGrid = Grid.fromGame(_game, 25, 25, gridId);
		nextGrid = Grid.fromGame(_game, 25, 425, gridId + 1, 0.75);

		add(activeGrid);
		add(nextGrid);
	}
}
