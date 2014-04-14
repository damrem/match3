package gamescreen.gamecontroller 
{
	import gamescreen.gamemodel.GameModel;
	import gamescreen.gameview.GameView;
	import gamescreen.gameview.acquisition.AbstractUserEntry;
	import gamescreen.gameview.acquisition.TouchEntry;

	import com.supagrip.mvc.AbstractController;
	/**
	 * @author damrem
	 */
	public class GameController extends AbstractController
	{
		public static var verbose:Boolean;
		
		private var fullModel:GameModel, fullView:GameView;
		
		private var entry : AbstractUserEntry;
		
		function GameController(gameModel:GameModel, gameView:GameView) 
		{
			if(verbose)	trace(this + "GameController(" + arguments);
			super(gameModel, gameView);
			this.fullModel = gameModel;
			this.fullView = gameView;
		}
		
		override public function start():void
		{
			if(verbose)	trace(this + "start(" + arguments);
			
			super.start();
			
			this.entry = new TouchEntry(this.fullView);
			this.entry.down.add(this.fullModel.fall);
			this.entry.left.add(this.fullModel.floatLeft);
			this.entry.right.add(this.fullModel.floatRight);
		}
	}
}
