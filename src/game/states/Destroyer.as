package game.states 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.Board;
	import game.Pawn;
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * ...
	 * @author damrem
	 */
	public class Destroyer extends AbstractState
	{
		public static var verbose:Boolean;
		
		static public const DESTRUCTION_DURATION_SEC:Number = 0.25;

		private var nbCompleted:int = 0;
		public const ALL_ARE_DESTROYED:Signal = new Signal();

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
		
		private var tweens:Vector.<Tween>;
		private function startDestroyingPawn(pawn:Pawn):void
		{
			if (!this.tweens)	this.tweens = new <Tween>[];
			
			if (verbose)	trace(this + "startDestroyingPawn(" + arguments);
			
			var tween:Tween = new Tween(pawn, DESTRUCTION_DURATION_SEC);
			
			if (verbose)	trace(this + "tween's target: " + tween.target);
			
			tween.fadeTo(0.0);
			tween.scaleTo(0.0);
			
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
			/*if (verbose)*/	trace(this + "onPawnDestructionComplete(" + arguments);
			
			this.nbCompleted ++;
			
			//	we register the hole
			//this.endDestroyingPawn(pawn);

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
				this.endDestroyingPawn(this.board.destroyablePawns[i]);
			}
			
			this.board.resetDestroyablePawns();
		}
		
		private function endDestroyingPawn(pawn:Pawn):void
		{
			if (verbose)	trace(this + "endDestroyingPawn(" + arguments);
			
			this.board.pawns[pawn.index] = null;
			this.board.holes.push(pawn.index);
			if (verbose)	trace(this + "holes: " + this.board.holes);
		}
		
		override public function exit():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			//if (verbose)	trace(this.board.pawns);
		}
	}

}