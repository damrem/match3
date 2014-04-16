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
			
			this.board = new Board();
			this.addChild(this.board);
			
			this.controller = new GameController(this.board);
			this.controller.start();
		}
		
	}

}