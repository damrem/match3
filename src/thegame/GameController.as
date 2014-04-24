package thegame 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import thegame.states.AbstractState;
	import thegame.states.Matcher;
	import thegame.states.Destroyer;
	import thegame.states.FallAndFill;
	import thegame.states.InputListener;
	import thegame.states.Swapper;
	/**
	 * ...
	 * @author damrem
	 */
	public class GameController 
	{
		public static var verbose:Boolean;
		
		private var currentState:AbstractState;
		
		private var _board:Board;
		
		private var matcher:Matcher;
		private var destroyer:Destroyer;
		private var fillAndFall:FallAndFill;
		private var inputListener:InputListener;
		private var swapper:Swapper;
		
		private var timer:Timer;
		
		public function GameController() 
		{
			if (verbose)	trace(this + "GameController(" + arguments);
			
			this._board = new Board();
			
			this.fillAndFall = new FallAndFill(board);
			this.fillAndFall.FILLED.add(this.gotoMatcher);
			
			
			this.inputListener = new InputListener(board);
			this.inputListener.SWAP_REQUESTED.add(this.gotoSwapper);
			
			this.swapper = new Swapper(board);
			this.swapper.SWAPPED.add(this.gotoMatcher);
			this.swapper.UNSWAPPED.add(this.gotoInputListener);

			this.matcher = new Matcher(board);
			this.matcher.MATCHES_FOUND.add(this.gotoDestroyer);
			this.matcher.INVALID_SWAP.add(this.gotoSwapper);
			this.matcher.NO_MATCHES_FOUND.add(this.gotoInputListener);
			
			this.destroyer = new Destroyer(board);
			this.destroyer.ALL_ARE_DESTROYED.add(this.gotoFillAndFall);
			
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
		}
		
		private function gotoInputListener():void
		{
			if (verbose)	trace(this + "gotoInputListener(" + arguments);
			
			this.setState(this.inputListener);
		}
		
		/**
		 * Depending on from what's just happened, we will swap or unswap.
		 * @param	isUnswapping
		 */
		private function gotoSwapper(isUnswapping:Boolean=false):void 
		{
			if (verbose)	trace(this + "gotoSwapper(" + arguments);
			
			this.swapper.isUnswapping = isUnswapping; 
			this.setState(this.swapper);
		}
		
		private function gotoMatcher():void
		{
			if (verbose)	trace(this + "gotoMatcher(" + arguments);
			
			this.setState(this.matcher);
		}
		
		private function gotoDestroyer():void 
		{
			if (verbose)	trace(this + "gotoDestroyer(" + arguments);
			
			this.setState(this.destroyer);
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