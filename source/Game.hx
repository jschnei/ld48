import Random;
import haxe.ds.Vector;

class Game
{
	// 0 = empty square
	// positive numbers are colors
	public var gridTiles:Array<Int>;

	public var width:Int;
	public var height:Int;
	public var numColors:Int = 5;

	public function new(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;

		this.gridTiles = new Array<Int>(width * height);

		for (i in 0..(width * height))
		{
			this.gridTiles[i] = 0;
		}
	}

	public function randomTile():Int
	{
		return Random.int(1, numColors);
	}

	public function getSquare(x:Int, y:Int):Int
	{
		return y * width + x;
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

	public function doMove(squares:Array<Int>):Bool
	{
		var L = squares.length;

		if (L != 3)
			return false;

		if (!isAdjacent(squares[0], squares[1]))
			return false;
		if (!isAdjacent(squares[1], squares[2]))
			return false;

		if (squares[0] == squares[2])
			return false;

		if (gridTiles[squares[0]] == 0 || gridTiles[squares[1]] == 0 || gridTiles[squares[2]] == 0)
		{
			return false;
		}

		// passed checks
		gridTiles[squares[1]] = 0;
		gridTiles[squares[0]] = randomTile();
		gridTiles[squares[2]] = randomTile();

		return true;
	}
}
