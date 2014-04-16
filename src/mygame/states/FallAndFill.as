package mygame.states 
{
	import flash.geom.Point;
	import mygame.Board;
	import mygame.Pawn;
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * Controller that handles the fall of gems when there are holes.
	 * It also generates/recycles gems at the top of the board.
	 * @author damrem
	 */
	public class FallAndFill extends AbstractState
	{
		public static var verbose:Boolean;
		/**
		 * Dispatched when the board is filled so that we can set another state (Check).
		 */
		public const BOARD_FILLED:Signal = new Signal();
		public const ALL_HAVE_LANDED:Signal = new Signal();
		
		private var nbCompleted:int;
		
		public function FallAndFill(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			this.collapse();
			this.refill();
			this.board.resetHoles();
			
			//	for each pawn which has to fall, we start the animation
			for (var j:int = 0; j < this.board.fallablePawns.length; j++)
			{
				this.startFallingPawn(this.board.fallablePawns[j]);
			}
		}
		
		//private var collapsingPawns:Vector.<Pawn>;
		private function collapse():void
		{
			if (verbose)	trace(this + "collapse(" + arguments);
			
			var nbCollapsed:int;
			
			//	for each hole in the board
			//	we check if there is a pawn who could fill it
			if (verbose)	trace("holes:" + this.board.holes);
			
			//for (var i:int = this.board.holes.length - 1; i >=0; i--)
			for (var i:int = 0; i < this.board.holes.length; i++)
			{
				var hole:int = this.board.holes[i];
				
				var abovePawn:Pawn = this.board.getPawnAboveHole(hole);
				
				if (abovePawn)
				{
					nbCollapsed ++;
					this.board.holes[i] = abovePawn.index;
					this.board.electPawnForFalling(abovePawn, hole);
				}
			}
			
			//	if any pawn has collapsed, since the holes have changed, we try to collapse again
			if (nbCollapsed > 0)
			{
				this.collapse();
			}
		}
		
		private function refill():void
		{
			//	for each hole, we generate a pawn above the column
			for (var i:int = 0; i < this.board.holes.length; i++)
			{
				var hole:int = this.board.holes[i];
				var pawn:Pawn = new Pawn(hole);
				//this.board.pawns[i] = pawn;
				pawn.x = this.board.indexToXY(hole).x;
				pawn.y = - Pawn.SIZE;
				this.board.addChild(pawn);
				this.board.electPawnForFalling(pawn, hole);
			}
		}
		
		
		
		private function trash():void
		{
			//	for each hole in the board:
			//	- we generate a new pawn above the board
			//	- 
			//	we take the pawn above (if there's one) who is not movable yet
			//	and we start moving it to this hole.
			if (verbose)	trace("holes: "+this.board.holes);
			for (var i:int = 0; i < this.board.holes.length; i++)
			{
				var holeIndex:int = this.board.holes[i];
				
				//	
				
				var abovePawn:Pawn = this.board.getPawnAboveHole(holeIndex);
				if (verbose)	trace("abovePawn: " + abovePawn);
				if (abovePawn)
				{
					this.board.electPawnForFalling(abovePawn, holeIndex);
				}
			}
			this.board.resetHoles();
			
			//	for each pawn which has to fall, we start the animation
			for (var j:int = 0; j < this.board.fallablePawns.length; j++)
			{
				this.startFallingPawn(this.board.fallablePawns[j]);
			}
		}
		
		
		private function startFallingPawn(pawn:Pawn/*xy:Point, onComplete:Function = null, onCompleteArgs:Array = null*/):void 
		{
			if (verbose)	trace(this + "startMovingPawn(" + arguments);
			
			var originXY:Point = new Point(pawn.x, pawn.y);
			var destXY:Point = this.board.indexToXY(pawn.index);
			var translation:Point = destXY.clone().subtract(originXY);
			
			var tween:Tween = new Tween(pawn, translation.length / 1000);
			tween.moveTo(destXY.x, destXY.y);
			tween.onComplete = this.onFallingComplete;
			tween.onCompleteArgs = [pawn];
			
			Starling.juggler.add(tween);
			//this.onFallingComplete(pawn);
		}
		
		private function onFallingComplete(pawn:Pawn):void 
		{
			if (verbose)	trace(this + "onPawnDestructionComplete(" + arguments);
			
			this.nbCompleted ++;
			
			if (verbose)	trace("completed: " + this.nbCompleted+"/"+this.board.fallablePawns.length);

			if (this.nbCompleted == this.board.fallablePawns.length)
			{
				this.board.resetFallablePawns();
				this.nbCompleted = 0;
				this.ALL_HAVE_LANDED.dispatch();
				Starling.juggler.purge();
			}
		}
		
		/*
		private function onFallMoveComplete(pawn:Pawn, destinationIndex:int):void
		{
			if (verbose)	trace(this + "onFallMoveComplete(" + arguments);
			
			this.board.electPawnForMovement(pawn, destinationIndex);
			//this.LANDED.dispatch();
		}
		*/
		
		override public function update():void
		{
			/*
			if (this.board.isFull)
			{
				if (verbose)	trace(this + "update(" + arguments +"->the board is full");
				
				this.BOARD_FILLED.dispatch();
			}
			*/
		}
		
		override public function exit():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			
		}
	}

}