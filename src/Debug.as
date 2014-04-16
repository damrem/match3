package 
{
	import mygame.Board;
	import mygame.GameController;
	import mygame.GameScreen;
	import mygame.Pawn;
	import mygame.states.FallAndFill;
	import mygame.states.InputListener;
	import mygame.states.PawnDestroyer;
	import utils.getSimpleToString;
	import mygame.states.MatchChecker;
	
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
				PawnDestroyer,
				Board, 
				Pawn,
				Assets,
				FallAndFill,
				MatchChecker
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
