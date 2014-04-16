package mygame 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mygame.states.AbstractState;
	import mygame.states.MatchChecker;
	import mygame.states.PawnDestroyer;
	import mygame.states.FallAndFill;
	import mygame.states.InputListener;
	import mygame.states.PawnSwapper;
	/**
	 * ...
	 * @author damrem
	 */
	public class GameController 
	{
		public static var verbose:Boolean;
		
		private var currentState:AbstractState;
		
		private var _board:Board;
		
		private var matchChecker:MatchChecker;
		private var pawnDestroyer:PawnDestroyer;
		private var fillAndFall:FallAndFill;
		private var inputListener:InputListener;
		private var pawnSwapper:PawnSwapper;
		
		private var timer:Timer;
		
		public function GameController() 
		{
			if (verbose)	trace(this + "GameController(" + arguments);
			
			this._board = new Board();
			
			this.fillAndFall = new FallAndFill(board);
			this.fillAndFall.BOARD_FILLED.add(this.gotoMatchChecker);
			this.fillAndFall.ALL_HAVE_LANDED.add(this.gotoInputListener);
			//this.fall.LANDED.add(this.gotoFall);
			
			
			this.inputListener = new InputListener(board);
			this.inputListener.SWAP_REQUESTED.add(this.gotoMatchChecker);
			
			this.pawnSwapper = new PawnSwapper(board);
			this.pawnSwapper.SWAPPED.add(this.gotoMatchChecker);
			this.pawnSwapper.UNSWAPPED.add(this.gotoInputListener);

			this.matchChecker = new MatchChecker(board);
			this.matchChecker.MATCHES.add(this.gotoPawnDestroyer);
			this.matchChecker.NO_MATCHES.add(this.gotoInputListener);
			
			this.pawnDestroyer = new PawnDestroyer(board);
			this.pawnDestroyer.ALL_ARE_DESTROYED.add(this.gotoFillAndFall);
			
			this.timer = new Timer(1000 / 60);
			this.timer.addEventListener(TimerEvent.TIMER, this.update);
		}
		
		public function start():void
		{
			if (verbose)	trace(this + "start(" + arguments);
			
			this.gotoInputListener();
			this.timer.start();
		}
		
		private function setState(state:AbstractState):void
		{
			if (verbose)	trace(this + "setState(" + arguments);
			
			if (currentState)
			{
				currentState.exit();
			}
			currentState = state;
			currentState.enter();
		}
		
		private function update(event:TimerEvent):void
		{
			this.currentState.update();
			//this.pawnMover.update();
		}
		
		private function gotoInputListener():void
		{
			if (verbose)	trace(this + "gotoInputListener(" + arguments);
			
			this.setState(this.inputListener);
		}
		
		private function gotoPawnSwapper():void 
		{
			if (verbose)	trace(this + "gotoPawnSwapper(" + arguments);
			
			this.setState(this.pawnSwapper);
		}
		
		private function gotoMatchChecker():void
		{
			if (verbose)	trace(this + "gotoMatchChecker(" + arguments);
			
			this.setState(this.matchChecker);
		}
		
		private function gotoPawnDestroyer():void 
		{
			if (verbose)	trace(this + "gotoPawnDestroyer(" + arguments);
			
			this.setState(this.pawnDestroyer);
		}
		
		private function gotoFillAndFall():void 
		{
			if (verbose)	trace(this + "gotoFillAndFall(" + arguments);
			
			this.setState(this.fillAndFall);
		}
		
		public function get board():Board 
		{
			return _board;
		}
		
	}

}