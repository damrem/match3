package 
{
	import mygame.Board;
	import mygame.GameController;
	import mygame.GameScreen;
	import mygame.states.FallAndFill;
	import mygame.states.InputListener;
	import mygame.states.Matcher;
	import mygame.states.Destroyer;
	import mygame.states.Swapper;
	import utils.getSimpleToString;
	
	/**
	 * @author damrem
	 */
	public class Debug 
	{		
		public static function setup():void
		{
			var classes:Vector.<Class> = new <Class>
			[
				Embeds,
				Main,
				Root,
				GameScreen,
				GameController,
				InputListener,
				Destroyer,
				//Board, 
				Swapper,
				Assets,
				FallAndFill,
				Matcher
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
