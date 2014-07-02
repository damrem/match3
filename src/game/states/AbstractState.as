package game.states 
{
	import game.Board;
	import utils.abstract;
	/**
	 * An abstract state, from which other states inherit.
	 * @author damrem
	 */
	public class AbstractState 
	{
		protected var board:Board;
		
		public function AbstractState(board:Board) 
		{
			this.board = board;
		}
		
		/**
		 * When entering the state.
		 * @param	caller	An indicator of where the method is called. For debugging purposes only.
		 */
		public function enter(caller:String="other"):void
		{
			abstract(this, "enter");
		}
		
		public function exit(caller:String="other"):void
		{
			abstract(this, "exit");
		}
	}

}