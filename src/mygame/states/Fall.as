package mygame.states 
{
	import mygame.Board;
	import mygame.Pawn;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author damrem
	 */
	public class Fall extends AbstractState
	{
		public static var verbose:Boolean;
		/**
		 * Dispatched when the board is filled so that we can set another state (Check).
		 */
		public const BOARD_FILLED:Signal = new Signal();
		public const LANDED:Signal = new Signal();
		
		public function Fall(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			//	for each hole in the board, we take the pawn just above (if there's one), and we start moving it to this hole.
			if (verbose)	trace("holes: "+this.board.holes);
			for (var i:int = 0; i < this.board.holes.length; i++)
			{
				var holeIndex:int = this.board.holes[i];
				var abovePawn:Pawn = this.board.getAbovePawnByIndex(holeIndex);
				if (abovePawn)
				{
					this.board.startMovingPawn(abovePawn, holeIndex);
				}
			}
			
			//for each pawn, ascending
			/*
			for (var i:int = this.board.pawns.length - Board.WIDTH - 1; i >=0; i--)
			{
				var pawn:Pawn = this.board.pawns[i];
				if (pawn && !this.board.getBottomPawn(pawn))
				{
					var bottomIndex:int = this.board.getBottomIndex(pawn);
					
					if (verbose)	trace("bottomIndex: " + bottomIndex);
					
					this.board.movePawnTo(pawn, bottomIndex, onFallMoveComplete, [pawn, bottomIndex]);
				}
			}
			*/
		}
		
		private function onFallMoveComplete(pawn:Pawn, destinationIndex:int):void
		{
			this.board.startMovingPawn(pawn, destinationIndex);
			//this.LANDED.dispatch();
		}
		
		override public function update():void
		{
			
			
			if (this.board.isFull)
			{
				if (verbose)	trace(this + "update(" + arguments +"->the board is full");
				
				this.BOARD_FILLED.dispatch();
			}
		}
		
		override public function exit():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			
		}
	}

}