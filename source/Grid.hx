package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.ds.Vector;

class Grid extends FlxSprite
{
	public static var CELL_WIDTH:Int = 32;
	public static var CELL_HEIGHT:Int = 32;

	public var gridHeight:Int;
	public var gridWidth:Int;

	public var gameId:Int;

	public var gridTiles:Vector<GridTile>;

	// TODO: turn Grid into an FlxSpriteGroup so we don't need to do this?
	public var parentState:FlxState;

	public function new(width:Int, height:Int, ?X:Float = 0, ?Y:Float = 0)
	{
		gridWidth = width;
		gridHeight = height;

		gridTiles = new Vector<GridTile>(width * height);

		super(X, Y);
		makeGraphic(gridWidth * CELL_WIDTH + 1, gridHeight * CELL_HEIGHT + 1, FlxColor.TRANSPARENT, true);

		for (x in 0...gridWidth + 1)
		{
			FlxSpriteUtil.drawLine(this, x * CELL_WIDTH, 0, x * CELL_WIDTH, gridHeight * CELL_HEIGHT, {color: 0x3fffffff, thickness: 3});
		}
		for (y in 0...gridHeight + 1)
		{
			FlxSpriteUtil.drawLine(this, 0, y * CELL_HEIGHT, gridWidth * CELL_WIDTH, y * CELL_HEIGHT, {color: 0x3fffffff, thickness: 3});
		}
	}

	public static function fromGame(game:Game, offsetX:Int, offsetY:Int, gridId:Int):Grid
	{
		var grid = new Grid(game.width, game.height, offsetX, offsetY);
		grid.gameId = gridId;
		game.grids[gridId].attachedGrid = grid;

		for (y in 0...game.height)
		{
			for (x in 0...game.width)
			{
				var tile = game.getTile(x, y, gridId);
				if (tile > 0)
				{
					var gridTile = new GridTile(grid, x, y, tile);
					grid.gridTiles[y * game.width + x] = gridTile;
				}
			}
		}

		return grid;
	}

	public function getSquare(dx:Float, dy:Float):Int
	{
		var x:Int = Math.floor((dx - this.x) / CELL_WIDTH);
		var y:Int = Math.floor((dy - this.y) / CELL_HEIGHT);

		if (x < 0 || x >= gridWidth || y < 0 || y >= gridHeight)
			return -1;
		return y * gridWidth + x;
	}

	public function getCorner(square:Int):FlxPoint
	{
		var corner:FlxPoint = new FlxPoint();
		corner.x = x + (square % gridWidth) * CELL_WIDTH;
		corner.y = y + Std.int(square / gridWidth) * CELL_HEIGHT;

		return corner;
	}

	public function changeColor(square:Int, colorId:Int)
	{
		var gridTile = gridTiles[square];
		gridTiles[square].changeColorTo(colorId);
	}

	public function deleteTile(square:Int)
	{
		parentState.remove(gridTiles[square]);
		gridTiles[square] = null;
	}

	public function createTile(square:Int, colorId:Int)
	{
		var x = square % gridWidth;
		var y = Std.int(square / gridWidth);
		var gridTile = new GridTile(this, x, y, colorId);
		gridTiles[square] = gridTile;
		parentState.add(gridTile);
	}
}
