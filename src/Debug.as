package 
{
	import utils.getSimpleToString;
	import thegame.GameScreen;
	import thegame.Board;
	import thegame.Gem;
	
	/**
	 * @author damrem
	 */
	public class Debug 
	{		
		public static function setup():void
		{
			var classes:Vector.<Class> = new <Class>
			[
				Main,
				Root,
				GameScreen,
				Board, 
				Gem,
				Assets
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
