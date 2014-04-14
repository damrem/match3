package 
{
	import com.supagrip.smart.IRoot;
	import gamescreen.GameScreen;

	import menuscreen.MenuScreen;

	import com.supagrip.navigation.AbstractNavigator;
	/**
	 * @author damrem
	 */
	public class Navigator extends AbstractNavigator implements IRoot
	{
		public static var verbose:Boolean;
		
		function Navigator():void
		{
			if(verbose)	trace(this + "Navigator(" + arguments);
			super();
		}
		
		public function start() : void 
		{
			if(verbose)	trace(this + "start(" + arguments);
			this.gotoMenu();
		}
		
		public function gotoMenu():void
		{
			if(verbose)	trace(this + "gotoMenu(" + arguments);
			var menu:MenuScreen = new MenuScreen();
			menu.gameRequested.add(this.gotoGame);
			this.gotoScreen(menu);
		}
		
		public function gotoGame():void
		{
			if(verbose)	trace(this + "gotoGame(" + arguments);
			var game:GameScreen = new GameScreen();
			game.exitRequested.add(this.gotoMenu);
			this.gotoScreen(game);
		}
	}
}
