package 
{
	import mygame.Board;
	import mygame.GameController;
	import mygame.GameScreen;
	import mygame.Pawn;
	import mygame.states.FallAndFill;
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
				Embeds,
				Main,
				Root,
				GameScreen,
				GameController,
				Input,
				Destroy,
				Board, 
				Pawn,
				Assets,
				FallAndFill
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
