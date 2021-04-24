package;

import flixel.FlxState;

class PlayState extends FlxState
{
	private var _grid:Grid;
	private var _game:Game;

	override public function create()
	{
		// _player = new Player(100, 100);
		// add(_player);
		_game = new Game(7, 10);

		_grid = Grid.fromGame(_game, 25, 25);
		for (gridTile in _grid.gridTiles)
		{
			add(gridTile);
		}
		add(_grid);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
