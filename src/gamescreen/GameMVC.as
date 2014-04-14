package gamescreen 
{
	import gamescreen.gamecontroller.GameController;
	import gamescreen.gamemodel.GameModel;
	import gamescreen.gameview.GameView;

	import com.supagrip.mvc.AbstractMVC;
	/**
	 * @author damrem
	 */
	public class GameMVC extends AbstractMVC 
	{
		public static var verbose:Boolean;
		
		function GameMVC()
		{
			if(verbose)	trace(this + "GameMVC(" + arguments);
			
			this.model = new GameModel();
			this.view = new GameView(this.fullModel);
			this.controller = new GameController(this.fullModel, this.fullView);
		}
		
		private function get fullModel():GameModel
		{
			return this.model as GameModel;
		}
		
		private function get fullView():GameView
		{
			return this.view as GameView;
		}
	}
}
