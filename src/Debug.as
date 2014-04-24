package 
{
	import thegame.Board;
	import thegame.GameController;
	import thegame.GameScreen;
	import thegame.states.FallAndFill;
	import thegame.states.InputListener;
	import thegame.states.Matcher;
	import thegame.states.Destroyer;
	import thegame.states.Swapper;
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
				//GameScreen,
				//GameController,
				InputListener,
				//Destroyer,
				//Board, 
				//Swapper,
				//Assets,
				//FallAndFill,
				//Matcher
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
