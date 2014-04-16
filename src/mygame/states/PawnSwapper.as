package mygame.states 
{
	import mygame.Board;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author damrem
	 */
	public class PawnSwapper extends AbstractState
	{
		public const SWAPPED:Signal = new Signal();
		public const UNSWAPPED:Signal = new Signal();
		
		public function PawnSwapper(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			
		}
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			
		}
	}

}