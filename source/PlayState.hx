package;

import flixel.FlxG;
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

		_grid = Grid.fromGame(_game, 25, 25, 0);
		for (gridTile in _grid.gridTiles)
		{
			add(gridTile);
		}
		add(_grid);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.pressed) {
			var hoveringTile = _grid.getSquare(FlxG.mouse.x, FlxG.mouse.y);
			if (hoveringTile != -1) {
				_game.addTileToPath(hoveringTile);
			}
		}
		if (FlxG.mouse.justReleased) {
			_game.submitPath();
		}

		super.update(elapsed);
	}
}
