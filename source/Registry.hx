package;

enum GameRule
{
	SANDWICH;
	PALINDROME;
}

class Registry
{
	public static var NUM_COLORS:Int = 6;

	public static var GAME_WIDTH:Int = 6;
	public static var GAME_HEIGHT:Int = 10;

	public static var WINDOW_WIDTH:Int = 400;
	public static var WINDOW_HEIGHT:Int = 800;

	public static var GAME_RULE:GameRule = SANDWICH;
	public static var REGENERATE_TILES:Bool = true;

	public static var TIME_LIMIT:Float = 120;

	// public static var SUBMIT_SCORE_URL:String = "http://localhost:5000/submit_score";
	public static var SUBMIT_SCORE_URL:String = "http://slime.jschnei.com:7048/submit_score";

	public static var score:Int = 0;
	public static var name:String = "Anonymous";

	public static var accessible:Bool = false;

	public static var fontSource:String = AssetPaths.Raleway__ttf;
}
