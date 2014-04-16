package mygame.states 
{
	import mygame.Board;
	import mygame.Pawn;
	import org.osflash.signals.Signal;
	import flash.geom.Point;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * ...
	 * @author damrem
	 */
	public class PawnSwapper extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const SWAPPED:Signal = new Signal();
		public const UNSWAPPED:Signal = new Signal();
		
		public function PawnSwapper(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			var pawn1:Pawn = this.board.swappablePawns[0];
			var pawn2:Pawn = this.board.swappablePawns[1];
			
			//	we swap the indexes of the 2 pawns on the board
			var index1:int = pawn1.index;
			pawn1.index = pawn2.index;
			pawn2.index = index1;
			
			//	we start the animations
			this.startSwappingPawn(this.board.swappablePawns[0], true);
			this.startSwappingPawn(this.board.swappablePawns[1], false);
			
			//	no more swapping
			this.board.resetSwappablePawns();
		}
		
		private function startSwappingPawn(pawn:Pawn, side:Boolean):void 
		{
			if (verbose)	trace(this + "startMovingPawn(" + arguments);
				
			var originXY:Point = new Point(pawn.x, pawn.y);
			var destXY:Point = this.board.indexToXY(pawn.index);
			var translation:Point = destXY.clone().subtract(originXY);
			
			var tween:Tween = new Tween(pawn, translation.length * 0.0075);
			tween.moveTo(destXY.x, destXY.y);
			
			//	the tween callback only applies once
			if (side)
			{
				tween.onComplete = this.onSwappingComplete;
			}
			
			Starling.juggler.add(tween);
		}
		
		private function onSwappingComplete():void 
		{
			this.SWAPPED.dispatch();
		}
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			
		}
	}

}