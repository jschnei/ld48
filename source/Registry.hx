package;

enum GameRule
{
	SANDWICH;
	PALINDROME;
}

enum GameMode
{
	ARCADE;
	UNTIMED;
}

class Registry
{
	public static var NUM_COLORS:Int = 6;

	public static var GAME_WIDTH:Int = 6;
	public static var GAME_HEIGHT:Int = 10;

	public static var WINDOW_WIDTH:Int = 400;
	public static var WINDOW_HEIGHT:Int = 800;

	public static var BACKGROUND_STARTING_HEIGHT:Int = 800;
	public static var SCROLL_HEIGHT:Int = 800;

	public static var GAME_RULE:GameRule = SANDWICH;
	public static var REGENERATE_TILES:Bool = true;

	public static var TIME_ON:Bool = true;
	public static var TIME_LIMIT:Float = 120;

	// public static var SUBMIT_SCORE_URL:String = "http://localhost:5000/submit_score";
	public static var SUBMIT_SCORE_URL:String = "http://slime.jschnei.com:7048/submit_score";
	public static var TRANSCRIPT_ALPHABET:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijlkmnopqrstuvwxyz0123456789";

	public static var score:Int = 0;
	public static var name:String = "Anonymous";
	public static var randomSeed:Int = 0;
	public static var transcript:Array<Int>;
	public static var gameMode:GameMode;

	public static function encodeTranscript():String
	{
		return transcript.map(function(x:Int)
		{
			return TRANSCRIPT_ALPHABET.charAt(x);
		}).join("");
	}

	public static function encodeGameMode():String
	{
		if (gameMode == ARCADE)
			return "arcade";
		if (gameMode == UNTIMED)
			return "untimed";
		return "unknown";
	}

	public static var accessible:Bool = false;

	public static var fontSource:String = AssetPaths.Raleway__ttf;

	public static function setMode(mode:GameMode)
	{
		if (mode == ARCADE)
		{
			TIME_ON = true;
			TIME_LIMIT = 120;
			REGENERATE_TILES = true;
		}

		if (mode == UNTIMED)
		{
			TIME_ON = false;
			REGENERATE_TILES = false;
		}

		gameMode = mode;
	}
}
