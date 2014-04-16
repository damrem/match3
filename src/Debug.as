package 
{
	import mygame.Board;
	import mygame.GameController;
	import mygame.GameScreen;
	import mygame.Pawn;
	import mygame.states.Fall;
	import mygame.states.Input;
	import mygame.states.Destroy;
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
				Main,
				Root,
				GameScreen,
				GameController,
				Input,
				Destroy,
				Board, 
				Pawn,
				Assets,
				Fall
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
