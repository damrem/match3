package mygame.states 
{
	import mygame.Board;
	import mygame.Pawn;
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
				if (pawn)	//	TODO this tweak is temporar for the time without refilling the board
				{
					pawn.alpha = 1.0;
					//this.isActive = true;
					pawn.addEventListener(TouchEvent.TOUCH, this.onTouch);
				}
			}
			//this.firstTime = false;
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
				if (pawn)	//	TODO this tweak is temporar for the time without refilling the board
				{
					pawn.alpha = 0.5;
					//this.isActive = false;
					pawn.removeEventListener(TouchEvent.TOUCH, this.onTouch);
				}
			}
			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			//if (verbose)	trace(this + "onTouch(" + arguments);
			//if (verbose)	trace(event.data);
			//if (this.isActive)
			{
				var touch:Touch = event.getTouch(this.board.stage);
				if (touch && touch.phase == TouchPhase.ENDED)
				{
					var pawn:Pawn = touch.target.parent as Pawn;
					
					if (this.selected && this.board.arePawnsNeighbors(pawn, this.selected) )
					{
						this.board.electPawnsForSwapping(pawn, this.selected);
						SWAP_REQUESTED.dispatch();
						this.selected = null;
					}
					else
					{
						this.selected = pawn;
					}
					
					/*
					if (pawn)
					{
						if(verbose)	trace("touched "+pawn);
						this.board.electPawnForMatching(pawn);
						this.SWAP_REQUESTED.dispatch();
					}
					*/
					
						
				}
			}
		}
		
		
		
		
	}

}