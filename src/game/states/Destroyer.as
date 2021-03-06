package game.states 
{
	import game.Board;
	import game.Pawn;
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * Controller which handles pawn-destruction animation.
	 * @author damrem
	 */
	public class Destroyer extends AbstractState
	{
		public static var verbose:Boolean;
		
		static public const DESTRUCTION_DURATION_SEC:Number = 0.2;

		private var nbCompleted:int = 0;
		public const ALL_ARE_DESTROYED:Signal = new Signal();
		
		private var tweens:Vector.<Tween>;

		public function Destroyer(board:Board) 
		{
			if (verbose)	trace(this + "Destroyer(" + arguments);
			
			super(board);
		}
		
		override public function enter(caller:String="other"):void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			if (verbose)	trace("destroyables: "+this.board.destroyablePawns);
			
			for (var i:int = 0; i < this.board.destroyablePawns.length; i++)
			{
				if (this.board.destroyablePawns[i])	//	this test prevents from destroying a pawn who would be in 2 matches (horizontal & vertical)
				{
					this.startDestroyingPawn(this.board.destroyablePawns[i]);
				}
			}
		}
		
		private function startDestroyingPawn(pawn:Pawn):void
		{
			if (!this.tweens)	this.tweens = new <Tween>[];
			
			if (verbose)	trace(this + "startDestroyingPawn(" + arguments);
			
			var tween:Tween = new Tween(pawn, DESTRUCTION_DURATION_SEC);
			
			if (verbose)	trace(this + "tween's target: " + tween.target);
			
			tween.fadeTo(0.0);
			tween.scaleTo(0.0);
			tween.moveTo(pawn.x + Pawn.SIZE / 2, pawn.y + Pawn.SIZE / 2);
			
			this.tweens.push(tween);
			
			if (verbose)	trace("tween is already complete? " + tween.isComplete);
			
			tween.onComplete = this.onPawnDestructionComplete;
			tween.onCompleteArgs = [pawn];
			
			Starling.juggler.add(tween);
			
			if (verbose)	trace("completed: " + this.nbCompleted+"/"+this.board.destroyablePawns.length);
		}
		
		/**
		 * Check that all destruction tweens are complete.
		 * @param	pawn
		 */
		private function onPawnDestructionComplete(pawn:Pawn):void 
		{
			if (verbose)	trace(this + "onPawnDestructionComplete(" + arguments);
			
			this.nbCompleted ++;
			
			if (verbose)	trace("completed: " + this.nbCompleted+"/"+this.board.destroyablePawns.length);

			if (this.nbCompleted == this.board.destroyablePawns.length)
			{
				if (verbose)	trace(this + "all destructions complete");
				
				Starling.juggler.purge();
				
				this.endDestroyingAllDestroyablePawns();
				
				this.nbCompleted = 0;
				this.ALL_ARE_DESTROYED.dispatch();
			}
		}
		
		private function endDestroyingAllDestroyablePawns():void
		{
			if (verbose)	trace(this + "endDestroyingAllDestroyablePawns(" + arguments);
			
			for (var i:int = 0; i < this.board.destroyablePawns.length; i++) 
			{
				this.board.removePawn(this.board.destroyablePawns[i]);
			}
			
			this.board.resetDestroyablePawns();
		}
		
		
		
		override public function exit(caller:String="other"):void
		{
			if (verbose)	trace(this + "exit(" + arguments);
		}
	}

}