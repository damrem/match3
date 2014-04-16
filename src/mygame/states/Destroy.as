package mygame.states 
{
	import mygame.Board;
	import mygame.Pawn;
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * ...
	 * @author damrem
	 */
	public class Destroy extends AbstractState
	{
		public static var verbose:Boolean;
		
		static public const DESTRUCTION_DURATION_SEC:Number = 0.25;

		private var nbCompleted:int = 0;
		public const ALL_ARE_DESTROYED:Signal = new Signal();

		public function Destroy(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			for (var i:int = 0; i < this.board.destroyablePawns.length; i++)
			{
				this.startDestroyingPawn(this.board.destroyablePawns[i]);
			}
			//this.board.resetDestroyablePawns();
			/*
			var emptyIndexes:Vector.<int> = new <int>[];
			for (var i:int = 0; i < this.board.destroyablePawns.length; i++)
			{
				var pawn:Pawn = this.board.destroyablePawns[i];
				emptyIndexes.push(pawn.index);
				pawn.destroy();
				this.board.pawns[pawn.index] = null;
			}
			this.board.destroyablePawns = new <Pawn>[];
			this.DESTROYED.dispatch();
			*/
		}
		
		private function startDestroyingPawn(pawn:Pawn):void
		{
			if (verbose)	trace(this + "startDestroyingPawn(" + arguments);
			
			var tween:Tween = new Tween(pawn, DESTRUCTION_DURATION_SEC);
			tween.fadeTo(0.0);
			tween.onComplete = this.onPawnDestructionComplete;
			tween.onCompleteArgs = [pawn];
			Starling.juggler.add(tween);
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
				this.board.resetDestroyablePawns();
				this.nbCompleted = 0;
				this.ALL_ARE_DESTROYED.dispatch();
			}
		}
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			
		}
	}

}