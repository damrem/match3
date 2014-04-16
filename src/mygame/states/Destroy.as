package mygame.states 
{
	import mygame.Board;
	import mygame.Pawn;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author damrem
	 */
	public class Destroy extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const DESTROYED:Signal = new Signal();

		public function Destroy(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			var emptyIndexes:Vector.<int> = new <int>[];
			for (var i:int = 0; i < this.board.destroyablePawns.length; i++)
			{
				var pawn:Pawn = this.board.destroyablePawns[i];
				emptyIndexes.push(pawn.index);
				pawn.destroy();
				this.board.pawns[pawn.index] = null;
			}
			this.board.destroyablePawns = new <Pawn>[];
			this.DESTROYED.dispatch();
		}
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			
		}
	}

}