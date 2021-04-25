package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.ds.Vector;

class Grid extends FlxSpriteGroup
{
	public static var CELL_WIDTH:Int = 32;
	public static var CELL_HEIGHT:Int = 32;

	// The number of rows and columns, respectively
	public var gridHeight:Int;
	public var gridWidth:Int;

	public var gridScale:Float;
	public var cellWidth:Float;
	public var cellHeight:Float;
	public var gridPixHeight:Int;
	public var gridPixWidth:Int;

	public var gameId:Int;

	public var gridBase:GridBase;
	public var gridTiles:Vector<GridTile>;

	public function new(width:Int, height:Int, ?X:Float = 0, ?Y:Float = 0, ?scale:Float = 1)
	{
		gridWidth = width;
		gridHeight = height;

		gridScale = scale;
		cellWidth = CELL_WIDTH * scale;
		cellHeight = CELL_HEIGHT * scale;
		gridPixWidth = Std.int(cellWidth * width);
		gridPixHeight = Std.int(cellHeight * height);

		gridTiles = new Vector<GridTile>(width * height);

		var xcoord = X + width * CELL_WIDTH * (1 - scale) / 2;
		super(xcoord, Y);

		gridBase = new GridBase(width, height, scale);
		add(gridBase);
	}

	public static function fromGame(game:Game, offsetX:Int, offsetY:Int, gridId:Int, ?gridScale:Float = 1.0):Grid
	{
		var grid = new Grid(game.width, game.height, offsetX, offsetY, gridScale);
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
					grid.add(gridTile);
				}
			}
		}

		return grid;
	}

	public function getSquare(dx:Float, dy:Float):Int
	{
		var x:Int = Math.floor((dx - this.x) / cellWidth);
		var y:Int = Math.floor((dy - this.y) / cellHeight);

		if (x < 0 || x >= gridWidth || y < 0 || y >= gridHeight)
			return -1;
		return y * gridWidth + x;
	}

	public function getCorner(square:Int):FlxPoint
	{
		var corner:FlxPoint = new FlxPoint();
		corner.x = x + (square % gridWidth) * cellWidth;
		corner.y = y + Std.int(square / gridWidth) * cellHeight;

		return corner;
	}

	public function changeColor(square:Int, colorId:Int)
	{
		var gridTile = gridTiles[square];
		gridTiles[square].changeColorTo(colorId);
	}

    public function refresh(square:Int)
    {
        if(Std.isOfType(gridTiles[square],GridTile))
        {
            gridTiles[square].refresh();
        }
    }

	public function deleteTile(square:Int)
	{
		remove(gridTiles[square]);
		gridTiles[square] = null;
	}

	public function createTile(square:Int, colorId:Int)
	{
		var x = square % gridWidth;
		var y = Std.int(square / gridWidth);
		var gridTile = new GridTile(this, x, y, colorId);
		gridTiles[square] = gridTile;
		insert(1, gridTile);
	}

	public function moveTile(fromSquare:Int, toSquare:Int)
	{
		var newLocation = getCorner(toSquare);
		var movingTile = gridTiles[fromSquare];
		newLocation.x -= (1 - gridScale) * movingTile.width / 2;
		newLocation.y -= (1 - gridScale) * movingTile.height / 2;
		gridTiles[toSquare] = movingTile;
		gridTiles[fromSquare] = null;
		FlxTween.tween(movingTile, {x: newLocation.x, y: newLocation.y}, 0.2, {
			ease: FlxEase.cubeIn
		});
	}

	public function setTileHighlight(square:Int, highlighted:Bool)
	{
		if (gridTiles[square] != null)
			gridTiles[square].setHighlighted(highlighted);
	}

	public function tweenToGrid(other:Grid)
	{
		FlxTween.tween(gridBase, {
			x: other.x,
			y: other.y,
			"scale.x": other.gridScale,
			"scale.y": other.gridScale
		}, 0.2);

		for (y in 0...gridHeight)
		{
			for (x in 0...gridWidth)
			{
				var square = y * gridWidth + x;
				var gridTile = gridTiles[square];
				if (gridTile != null)
				{
					// tween it to the appropriate location in the other grid
					var target = other.getCorner(square);
					target.x -= (1 - gridScale) * Grid.CELL_WIDTH / 2;
					target.y -= (1 - gridScale) * Grid.CELL_HEIGHT / 2;
					FlxTween.tween(gridTile, {
						x: target.x,
						y: target.y,
						"scale.x": other.gridScale,
						"scale.y": other.gridScale
					}, 0.2);
				}
			}
		}
	}
}

class GridBase extends FlxSprite
{
	public function new(width:Int, height:Int, gridScale:Float)
	{
		super(0, 0);
		makeGraphic(width * Grid.CELL_WIDTH + 1, height * Grid.CELL_HEIGHT + 1, FlxColor.TRANSPARENT, true);

		for (x in 0...width + 1)
		{
			FlxSpriteUtil.drawLine(this, x * Grid.CELL_WIDTH, 0, x * Grid.CELL_WIDTH, height * Grid.CELL_HEIGHT, {color: 0x3fffffff, thickness: 3});
		}
		for (y in 0...height + 1)
		{
			FlxSpriteUtil.drawLine(this, 0, y * Grid.CELL_HEIGHT, width * Grid.CELL_WIDTH, y * Grid.CELL_HEIGHT, {color: 0x3fffffff, thickness: 3});
		}
		origin.set(0, 0);
		scale.set(gridScale, gridScale);
	}
}
