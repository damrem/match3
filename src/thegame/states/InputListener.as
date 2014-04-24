package thegame.states 
{
	import flash.geom.Point;
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
			
			this.activateTouchZone();
		}
		
		
		public function activateTouchZone(mustActivate:Boolean = true):void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			if (mustActivate)
			{
				this.board.touchZone.addEventListener(TouchEvent.TOUCH, this.onZoneTouched);
			}
			else
			{
				this.board.touchZone.removeEventListener(TouchEvent.TOUCH, this.onZoneTouched);
			}
		}
		
		override public function exit():void
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
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				var touchXY:Point = touch.getLocation(this.board.touchZone);
				var index:int = this.board.getIndexFromXY(touchXY);	
				var pawn:Pawn = this.board.pawns[index];
				
				//	When we touch a pawn and nothing is selected, the pawn is selected.
				if (!Pawn.selected)
				{
					Pawn.select(pawn);
				}
				else
				{
					//	When we touch a pawn neighbor to the selected one, we try to swap them.
					if (this.board.arePawnsNeighbors(pawn, Pawn.selected))
					{
						this.board.electPawnsForSwapping(pawn, Pawn.selected);
						SWAP_REQUESTED.dispatch();
						Pawn.unselect();
					}
					//	When we touch a pawn not neighbor to the selected one, 
					//	we unselect the previous one and we select the touched one.
					else if (pawn != Pawn.selected)
					{
						Pawn.unselect();
						Pawn.select(pawn);
					}
					//	When we touch the selected pawn, we unselect it.
					else
					{
						Pawn.unselect();
					}
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		public function activateTouchPawns():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			for (var i:int = 0; i < this.board.pawns.length; i++ )
			{
				var pawn:Pawn = this.board.pawns[i];
				try
				{
					pawn.addEventListener(TouchEvent.TOUCH, this.onTouchPawn);
					
				}
				catch (e:Error)
				{
					trace(i);
				}
				
			}
		}
		
		
		
		
		public function unactivateTouchPawns():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			
			for (var i:int = 0; i < this.board.pawns.length; i++ )
			{
				var pawn:Pawn = this.board.pawns[i];
				try
				{
					pawn.removeEventListener(TouchEvent.TOUCH, this.onTouchPawn);
				}
				catch (e:Error)
				{
					trace(i);
				}
			}
			
			if (verbose)	trace(this.board.pawns);
			
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
		private function onTouchPawn(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.board.stage);
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				var pawn:Pawn = touch.target.parent as Pawn;
				
				//	When we touch a pawn and nothing is selected, the pawn is selected.
				if (!Pawn.selected)
				{
					Pawn.select(pawn);
				}
				else
				{
					//	When we touch a pawn neighbor to the selected one, we try to swap them.
					if (this.board.arePawnsNeighbors(pawn, Pawn.selected))
					{
						this.board.electPawnsForSwapping(pawn, Pawn.selected);
						SWAP_REQUESTED.dispatch();
						Pawn.unselect();
					}
					//	When we touch a pawn not neighbor to the selected one, 
					//	we unselect the previous one and we select the touched one.
					else if (pawn != Pawn.selected)
					{
						Pawn.unselect();
						Pawn.select(pawn);
					}
					//	When we touch the selected pawn, we unselect it.
					else
					{
						Pawn.unselect();
					}
				}
			}
		}
		
		
		
		
		
		
	}

}