package mygame 
{
	/**
	 * Class which makes pawns move whenever they have to.
	 * @author damrem
	 */
	public class PawnMover 
	{
		private var board:Board;
		
		public function PawnMover(board:Board) 
		{
			this.board = board;
		}
		
		public function update():void
		{
			for (var i:int = 0; i < this.board.movablePawns.length; i++)
			{
				
			}
		}
		
	}

}