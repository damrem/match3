package game.states 
{
	import flash.geom.Point;
	import game.Board;
	import game.Pawn;
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * Controller that handles pawn-swapping.
	 * @author damrem
	 */
	public class Swapper extends AbstractState
	{
		private var nbSwaps:int;
		public static var verbose:Boolean;
		
		public const SWAPPED:Signal = new Signal();
		public const UNSWAPPED:Signal = new Signal();
		
		public static const SWAP_SPEED_PX_PER_SEC:Number = Pawn.SIZE * 4;
		
		private var _isUnswapping:Boolean;
		
		public function Swapper(board:Board) 
		{
			if (verbose)	trace(this + "Swapper(" + arguments);
			
			super(board);
		}
		
		override public function enter(caller:String="other"):void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			var pawn1:Pawn = this.board.swappablePawns[0];
			var pawn2:Pawn = this.board.swappablePawns[1];
			
			//	we swap the indexes of the 2 pawns on the board
			var index1:int = pawn1.index;
			
			if (verbose)	trace(pawn2);
			this.board.setPawnIndex(pawn1, pawn2.index, false);
			this.board.setPawnIndex(pawn2, index1, false);
			
			//	we elect swapped pawns for matching
			//	only if it is an actual swap (and not an unswap)
			if (!this._isUnswapping)
			{
				this.board.electPawnForMatching(pawn1);
				this.board.electPawnForMatching(pawn2);
			}
			
			//	we start the animations
			this.startSwappingPawn(pawn1, true);
			this.startSwappingPawn(pawn2, false);
			
			//	no more swapping
			this.board.resetSwappablePawns();
		}
		
		private function startSwappingPawn(pawn:Pawn, side:Boolean):void 
		{
			if (verbose)	trace(this + "startSwappingPawn(" + arguments);
				
			var originXY:Point = new Point(pawn.x, pawn.y);
			var destXY:Point = this.board.getXYFromIndex(pawn.index);
			var translation:Point = destXY.clone().subtract(originXY);
			
			var tween:Tween = new Tween(pawn, translation.length / SWAP_SPEED_PX_PER_SEC);
			tween.moveTo(destXY.x, destXY.y);
			
			//	the tween callback only applies once
			tween.onComplete = this.onSwappingComplete;
			
			Starling.juggler.add(tween);
		}
		
		private function onSwappingComplete():void 
		{
			if (verbose)	trace(this + "onSwappingComplete(" + arguments);
			
			this.nbSwaps++;
			if (this.nbSwaps == 2)
			{
				Starling.juggler.purge();
				this.nbSwaps = 0;
				if (this._isUnswapping)
				{
					this.UNSWAPPED.dispatch();
				}
				else
				{
					this.SWAPPED.dispatch();
				}
			}
		}
		
		override public function exit(caller:String="other"):void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			if (verbose)	trace(this.board.pawns);
		}
		
		public function set isUnswapping(value:Boolean):void 
		{
			_isUnswapping = value;
		}
	}

}