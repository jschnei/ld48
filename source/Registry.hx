package;

enum GameRule
{
	SANDWICH;
	PALINDROME;
}

class Registry
{
	public static var NUM_COLORS:Int = 6;

	public static var GAME_WIDTH:Int = 7;
	public static var GAME_HEIGHT:Int = 10;

	public static var GAME_RULE:GameRule = SANDWICH;
	public static var REGENERATE_TILES:Bool = true;

	public static var TIME_LIMIT:Float = 120;
	
	public static var score:Int = 0;
}
