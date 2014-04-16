package mygame 
{
	import flash.geom.Point;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * Class which makes pawns move whenever they have to.
	 * @author damrem
	 */
	public class PawnMover 
	{
		public static var verbose:Boolean;
		
		private var board:Board;
		
		public function PawnMover(board:Board) 
		{
			this.board = board;
		}
		
		public function update():void
		{
			var started:Boolean;
			for (var i:int = 0; i < this.board.fallablePawns.length; i++)
			{
				this.startMovingPawn(this.board.fallablePawns[i]);
				started = true;
			}
			//	we only reset the movable pawns if we worked on them
			if (started)
			{
				this.board.resetFallablePawns();
			}
		}
		
		private function startMovingPawn(pawn:Pawn/*xy:Point, onComplete:Function = null, onCompleteArgs:Array = null*/):void 
		{
			if (verbose)	trace(this + "startMovingPawn(" + arguments);
			
			var originXY:Point = new Point(pawn.x, pawn.y);
			var destXY:Point = this.board.indexToXY(pawn.index);
			var translation:Point = destXY.clone().subtract(originXY);
			var tween:Tween = new Tween(pawn, translation.length / 1000);
			tween.moveTo(destXY.x, destXY.y);
			
			//tween.
			/*
			if (onComplete != null)
			{
				tween.onComplete = onComplete;
				if (onCompleteArgs != null)
				{
					tween.onCompleteArgs = onCompleteArgs;
				}
			}
			*/
			Starling.juggler.add(tween);
		}
		
	}

}