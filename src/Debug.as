package 
{
	import game.Board;
	import game.Pawn;
	import game.PawnPool;
	import game.GameController;
	import game.GameScreen;
	import game.states.FallerAndFiller;
	import game.states.InputListener;
	import game.states.Matcher;
	import game.states.Destroyer;
	import game.states.Swapper;
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
				//Embeds,
				//Main,
				//Root,
				//GameScreen,
				//GameController,
				//InputListener,
				Destroyer,
				//Board, 
				//Swapper,
				FallerAndFiller,
				//Assets,
				//Matcher,
				Pawn,
				PawnPool
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
