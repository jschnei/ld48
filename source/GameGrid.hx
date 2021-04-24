import flixel.math.FlxRandom;
import haxe.ds.Vector;

class GameGrid
{
	// 0 = empty square
	// positive numbers are colors
	public var tiles:Vector<Int>;

	public var width:Int;
	public var height:Int;

	public function new(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;

		tiles = new Vector<Int>(width * height);
		for (i in 0...(width * height))
		{
			tiles[i] = 0;
		}
	}

	public function randomizeTiles()
	{
		for (i in 0...(width * height))
		{
			tiles[i] = Game.randomTile();
		}
	}

	public function getSquare(x:Int, y:Int):Int
	{
		return y * width + x;
	}

	public function getTile(x:Int, y:Int):Int
	{
		return tiles[getSquare(x, y)];
	}

	public function isAdjacent(square1:Int, square2:Int)
	{
		var x1 = square1 % width;
		var y1 = square1 / width;

		var x2 = square2 % width;
		var y2 = square2 / width;

		var dx = x1 - x2;
		if (dx < 0)
			dx *= -1;
		var dy = y1 - y2;
		if (dy < 0)
			dy *= -1;

		return (dx + dy == 1);
	}
}
