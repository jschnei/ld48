package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class GridTile extends FlxSprite
{
	public var tileColors:Array<String> = [
		AssetPaths.grey__png, // no color
		AssetPaths.red__png,
		AssetPaths.orange__png,
		AssetPaths.yellow__png,
		AssetPaths.green__png,
		AssetPaths.blue__png
	];

	public var grid:Grid;
	public var gridX:Int;
	public var gridY:Int;

	public function new(grid:Grid, gridX:Int, gridY:Int, type:Int)
	{
		this.grid = grid;
		this.gridX = gridX;
		this.gridY = gridY;

		var X = grid.x + Grid.CELL_WIDTH * gridX;
		var Y = grid.y + Grid.CELL_HEIGHT * gridY;

		super(X, Y);
		loadGraphic(tileColors[type],false,Grid.CELL_WIDTH,Grid.CELL_HEIGHT);
        
	}
}
