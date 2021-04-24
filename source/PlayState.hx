package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	private var _topGrid:Grid;
	private var _bottomGrid:Grid;
	private var _game:Game;

	private var _scoreText:FlxText;

	override public function create()
	{
		_game = new Game(7, 10);

		_topGrid = Grid.fromGame(_game, 25, 25, 0);
		_topGrid.parentState = this;
		_bottomGrid = Grid.fromGame(_game, 25, 425, 1);
		_bottomGrid.parentState = this;
		_scoreText = new FlxText(260, 50);
		_scoreText.size = 18;

		add(_topGrid);
		add(_bottomGrid);
		add(_scoreText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.pressed)
		{
			var hoveringTile = _topGrid.getSquare(FlxG.mouse.x, FlxG.mouse.y);
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
		super.update(elapsed);
	}

	public function addGrid(grid:Grid)
	{
		for (gridTile in grid.gridTiles)
		{
			if (gridTile != null)
				add(gridTile);
		}
		add(grid);
	}
}
