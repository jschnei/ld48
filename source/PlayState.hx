package;

import flixel.FlxState;

class PlayState extends FlxState
{
	private var _grid:Grid;

	override public function create()
	{
		// _player = new Player(100, 100);
		// add(_player);

		_grid = new Grid(7, 10, 25, 25);
		add(_grid);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
