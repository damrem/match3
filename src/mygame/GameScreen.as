package mygame 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author damrem
	 */
	public class GameScreen extends Sprite
	{
		public static var verbose:Boolean;
		
		private var board:Board;
		private var controller:GameController;
		
		public function GameScreen() 
		{
			if (verbose)	trace(this + "GameScreen(" + arguments);
			
			//	loading textures needs to be done AFTER starling setup
			Embeds.init();
			
			this.controller = new GameController();
			this.addChild(this.controller.board);
			this.controller.start();
		}
		
	}

}