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
	public class Input extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const INPUT:Signal = new Signal();
		
		public function Input(board:Board) 
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
				pawn.addEventListener(TouchEvent.TOUCH, this.onTouch);
			}
		}
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			//if (verbose)	trace(this + "onTouch(" + arguments);
			//if (verbose)	trace(event.data);
			
			var touch:Touch = event.getTouch(this.board.stage);
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				if (verbose)
				{
					//trace(event.data);
					var pawn:Pawn = touch.target as Pawn;
					if (pawn)
					{
						if(verbose)	trace("touched "+pawn);
						this.board.startDestroyingPawn(pawn);
						this.INPUT.dispatch();
					}
					
				}
			}
		}
		
		
	}

}