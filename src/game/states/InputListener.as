package game.states 
{
	import flash.geom.Point;
	import game.Board;
	import game.Pawn;
	import org.osflash.signals.Signal;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import starling.events.Touch;
	
	/**
	 * This class setup the input event listener (and remove them as well).
	 * @author damrem
	 */
	public class InputListener extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const SWAP_REQUESTED:Signal = new Signal();
		private var selected:Pawn;
		
		public function InputListener(board:Board) 
		{
			if (verbose)	trace(this + "InputListener(" + arguments);
			
			super(board);
		}
		
		override public function enter(caller:String="other"):void
		{
			if (verbose)	trace(this + "enter(" + caller);
			
			this.activateTouchZone();
		}
		
		
		public function activateTouchZone(mustActivate:Boolean = true):void
		{
			if (verbose)	trace(this + "activateTouchZone(" + arguments);
			
			if (mustActivate)
			{
				this.board.touchZone.addEventListener(TouchEvent.TOUCH, this.onZoneTouched);
			}
			else
			{
				this.board.touchZone.removeEventListener(TouchEvent.TOUCH, this.onZoneTouched);
			}
		}
		
		override public function exit(caller:String="other"):void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			
			this.activateTouchZone(false);
		}
		
		/**
		 * When we touch a pawn and nothing is selected, the pawn is selected.
		 * 
		 * When we touch a pawn neighbor to the selected one, we try to swap them.
		 * 
		 * When we touch a pawn not neighbor to the selected one, 
		 * we unselect the previous one and we select the touched one.
		 * 
		 * When we touch the selected pawn, we unselect it.
		 * 
		 * @param	event
		 */
		private function onZoneTouched(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.board.stage);
			
			
			if (touch && (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.ENDED))
			{
				var touchXY:Point = touch.getLocation(this.board.touchZone);
			
				if (verbose)	trace(touchXY);
				var index:int = this.board.getIndexFromXY(touchXY);	
				var pawn:Pawn = this.board.pawns[index];
				
				//	NO PAWN SELECTED
				//	When we touch/tap a pawn and nothing is selected, the pawn is selected.
				if (!Pawn.selected)
				{
					if (verbose)	trace("none selected -> touched selected");
					Pawn.select(pawn);
					return;
				}
				
				//	NEIGHBOR PAWNS
				//	When we touch/tap a pawn neighbor to the selected one, we try to swap them.
				if (this.board.arePawnsNeighbors(pawn, Pawn.selected))
				{
					if (verbose)	trace("neighbors -> swap");
					
					this.board.electPawnsForSwapping(pawn, Pawn.selected);
					SWAP_REQUESTED.dispatch();
					Pawn.unselect();
					return;
				}
				
				//	DISTANT PAWNS
				if (pawn != Pawn.selected)
				{
					//	When we touch a pawn not neighbor to the selected one, 
					//	we unselect the previous one and we select the touched one.
					if (touch.phase == TouchPhase.BEGAN)
					{
						if (verbose)	trace("distant + -> replace selection");
						Pawn.unselect();
						Pawn.select(pawn);
						return;
					}
					//	When we release on a pawn not neighbor to the selected one, we only unselect.
					if (touch.phase == TouchPhase.ENDED)
					{
						Pawn.unselect();
						return;
					}
				}
				
				//	SAME PAWN
				else if (pawn == Pawn.selected)
				{
					//	When we touch the selected pawn, we unselect it.
					if (touch.phase == TouchPhase.BEGAN)
					{
						Pawn.unselect();
						Pawn.select(pawn);
						return;
					}
					//	When we release on the selected pawn, we do nothing.
					else if (touch.phase == TouchPhase.ENDED)
					{
						if (verbose)
						{
							trace(touch.getMovement(this.board.touchZone));
							trace(touch.getPreviousLocation(this.board.touchZone));
						}
						//Pawn.unselect();
					}
				}
	
			
			}
		}
		
	}

}