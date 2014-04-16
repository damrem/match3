package 
{
	import mygame.Board;
	import mygame.GameController;
	import mygame.GameScreen;
	import mygame.states.FallAndFill;
	import mygame.states.InputListener;
	import mygame.states.MatchChecker;
	import mygame.states.PawnDestroyer;
	import mygame.states.PawnSwapper;
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
				PawnDestroyer,
				Board, 
				PawnSwapper,
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
