package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _topGrid:Grid;
	private var _bottomGrid:Grid;
	private var _game:Game;

	override public function create()
	{
		_game = new Game(7, 10);

		_topGrid = Grid.fromGame(_game, 25, 25, 0);
		_bottomGrid = Grid.fromGame(_game, 25, 425, 1);

		addGrid(_topGrid);
		addGrid(_bottomGrid);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.pressed)
		{
			var hoveringTile = _topGrid.getSquare(FlxG.mouse.x, FlxG.mouse.y);
			if (hoveringTile != -1)
			{
				_game.addTileToPath(hoveringTile);
			}
		}
		if (FlxG.mouse.justReleased)
		{
			_game.submitPath();
		}

		super.update(elapsed);
	}

	public function addGrid(grid:Grid)
	{
		for (gridTile in grid.gridTiles)
		{
			add(gridTile);
		}
		add(grid);
	}
}
