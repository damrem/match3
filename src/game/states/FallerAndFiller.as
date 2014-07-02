package game.states 
{
	import flash.geom.Point;
	import game.Board;
	import game.Pawn;
	import game.PawnPool;
	import org.osflash.signals.Signal;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	/**
	 * Controller that handles the fall of gems when there are holes.
	 * It also generates/recycles gems at the top of the board.
	 * @author damrem
	 */
	public class FallerAndFiller extends AbstractState
	{
		public static var verbose:Boolean;
		
		/**
		 * Dispatched when the board is filled so that we can set another state (Check).
		 */
		public const FILLED:Signal = new Signal();
		
		public static const FALL_SPEED_PX_PER_SEC:Number = Pawn.SIZE * 12;
		
		private var nbCompleted:int;
		
		public function FallerAndFiller(board:Board) 
		{
			if (verbose)	trace(this + "FallerAndFiller(" + arguments);
			
			super(board);
		}
		
		override public function enter(caller:String="other"):void
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
			if (verbose)	trace(this + "refill(" + arguments);
			
			//	during one refill, we will register how many pawns we create per column
			//	in order to create them at the proper y coordinate (and not all at the same y)
			
			var nbHolesPerCol:Vector.<int> = new <int>[];
			for (var j:int = 0; j < Board.WIDTH; j++)
			{
				nbHolesPerCol.push(0);
			}
			
			var i:int;
			var hole:int;
			var col:int;
			
			for (i = 0; i< this.board.holes.length; i++)
			{
				hole = this.board.holes[i];
				col = this.board.getColFromIndex(hole);
				nbHolesPerCol[col] ++;
			}
			if (verbose)	trace("nbHolesPerCol: " + nbHolesPerCol);
			
			//	for each hole, we generate a pawn above the column
			for (i = 0; i< this.board.holes.length; i++)
			{
				hole = this.board.holes[i];
				var pawn:Pawn = PawnPool.loadPawn(hole);
				//new Pawn();
				pawn.setIndex(hole);
				
				col = this.board.getColFromIndex(hole);
				var nbHolesInCol:int = nbHolesPerCol[col];
				
				pawn.x = this.board.getXYFromIndex(hole).x;
				if (verbose)	trace("generated pawn: " + pawn);
		
				pawn.y = - Pawn.SIZE * nbHolesInCol + this.board.getRowFromIndex(pawn.index) * Pawn.SIZE;
				if (verbose)	trace("y generated pawn: " + pawn.y);
				
				this.board.pawnContainer.addChild(pawn);
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
			var destXY:Point = this.board.getXYFromIndex(pawn.index);
			var translation:Point = destXY.clone().subtract(originXY);
			
			if (verbose)
			{
				
				trace("originXY: "+originXY);
				trace("destXY: " + destXY);
				trace("translation: " + translation);
				trace("--------");
			}
			
			var tween:Tween = new Tween(pawn, translation.length / FALL_SPEED_PX_PER_SEC, Transitions.EASE_IN);
			tween.moveTo(destXY.x, destXY.y);
			tween.onComplete = this.onFallingComplete;
			tween.onCompleteArgs = [pawn];
			
			Starling.juggler.add(tween);
		}
		
		private function onFallingComplete(pawn:Pawn):void 
		{
			if (verbose)	trace(this + "onFallingComplete(" + arguments);
			
			this.nbCompleted ++;
			
			if (verbose)	trace("completed: " + this.nbCompleted+"/"+this.board.fallablePawns.length);

			if (this.nbCompleted == this.board.fallablePawns.length)
			{
				//	there are no more pawns to fall
				this.board.resetFallablePawns();
				this.nbCompleted = 0;
				
				//	all pawns must be checked
				this.board.electAllPawnsForMatching();
				
				//	it is VERY IMPORTANT to purge the juggler BEFORE dispatching the signal
				//	so that it is avalaible for animating the destructions
				Starling.juggler.purge();
				
				this.FILLED.dispatch();
			}
		}
		
		override public function exit(caller:String="other"):void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			if (verbose)	trace(this.board.pawns);
		}
	}

}