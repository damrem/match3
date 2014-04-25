package game.states 
{
	import game.Board;
	import utils.abstract;
	/**
	 * ...
	 * @author damrem
	 */
	public class AbstractState 
	{
		protected var board:Board;
		
		public function AbstractState(board:Board) 
		{
			this.board = board;
		}
		
		public function enter(caller:String="other"):void
		{
			abstract(this, "enter");
		}
		
		public function exit():void
		{
			abstract(this, "exit");
		}
	}

}