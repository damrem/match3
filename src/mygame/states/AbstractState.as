package mygame.states 
{
	import mygame.Board;
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
		
		public function enter():void
		{
			abstract(this, "enter");
		}
		
		public function update():void
		{
			abstract(this, "update");
		}
		
		public function exit():void
		{
			abstract(this, "exit");
		}
	}

}