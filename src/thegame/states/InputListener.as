package thegame.states 
{
	import thegame.Board;
	import thegame.Pawn;
	import org.osflash.signals.Signal;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import starling.events.Touch;
	
	/**
	 * ...
	 * @author damrem
	 */
	public class InputListener extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const SWAP_REQUESTED:Signal = new Signal();
		private var selected:Pawn;
		
		public function InputListener(board:Board) 
		{
			if (verbose)	trace(this + "Input(" + arguments);
			
			super(board);
		}
		
		override public function enter():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			for (var i:int = 0; i < this.board.pawns.length; i++ )
			{
				var pawn:Pawn = this.board.pawns[i];
				try	//if (pawn)	//	TODO this tweak is temporar for the time without refilling the board
				{
					//pawn.alpha = 1.0;
					pawn.addEventListener(TouchEvent.TOUCH, this.onTouch);
					pawn.scaleX = pawn.scaleY = 1.0;
				}
				catch (e:Error)
				{
					trace(i);
				}
				
			}
		}
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			
			for (var i:int = 0; i < this.board.pawns.length; i++ )
			{
				var pawn:Pawn = this.board.pawns[i];
				try //if (pawn)	//	TODO this tweak is temporar for the time without refilling the board
				{
					pawn.scaleX = pawn.scaleY = 0.5;
					//this.isActive = false;
					pawn.removeEventListener(TouchEvent.TOUCH, this.onTouch);
				}
				catch (e:Error)
				{
					trace(i);
				}
			}
			
			if (verbose)	trace(this.board.pawns);
			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.board.stage);
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				var pawn:Pawn = touch.target.parent as Pawn;
				
				if (Pawn.selected && this.board.arePawnsNeighbors(pawn, Pawn.selected) )
				{
					this.board.electPawnsForSwapping(pawn, Pawn.selected);
					SWAP_REQUESTED.dispatch();
					Pawn.unselect();
				}
				else
				{
					Pawn.select(pawn);
				}
			}
		}
		
		
		
		
		
		
	}

}