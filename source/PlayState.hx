package;

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
