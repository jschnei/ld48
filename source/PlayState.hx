package;

import flixel.FlxState;

class PlayState extends FlxState
{
	private var _player:Player;

	override public function create()
	{
		_player = new Player(100, 100);
		add(_player);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
