package thegame 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
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
		
		//	score management
		private var _score:int;
		public const SCORE_UPDATED:Signal = new Signal();

		//	time management
		public static const GAME_DURATION_MIN:Number = 1.0;
		private var timer:Timer;
		private var _timeLeft_sec:int;
		public const TIME_LEFT_UPDATED:Signal = new Signal();
		public const TIME_S_UP:Signal = new Signal();
		
		//	the board containing the pawns
		private var _board:Board;
		
		//	the current sub-controller
		private var currentState:AbstractState;
		
		//	the sub-controllers
		private var matcher:Matcher;
		private var destroyer:Destroyer;
		private var fillAndFall:FallAndFill;
		private var inputListener:InputListener;
		private var swapper:Swapper;
		
		public function GameController() 
		{
			if (verbose)	trace(this + "GameController(" + arguments);
			
			this.timer = new Timer(1000, 5 * 60);
			
			this._board = new Board();
			
			this.fillAndFall = new FallAndFill(board);
			this.fillAndFall.FILLED.add(this.gotoMatcher);
			
			this.inputListener = new InputListener(board);
			this.inputListener.SWAP_REQUESTED.add(this.gotoSwapper);
			
			this.swapper = new Swapper(board);
			this.swapper.SWAPPED.add(this.gotoMatcher);
			this.swapper.UNSWAPPED.add(this.gotoInputListener);

			this.matcher = new Matcher(board);
			this.updateScore();
			this.matcher.MATCHES_FOUND.add(this.updateScore);
			this.matcher.MATCHES_FOUND.add(this.gotoDestroyer);
			this.matcher.INVALID_SWAP.add(this.gotoSwapper);
			this.matcher.NO_MATCHES_FOUND.add(this.gotoInputListener);
			
			this.destroyer = new Destroyer(board);
			this.destroyer.ALL_ARE_DESTROYED.add(this.gotoFillAndFall);
		}
		
		public function start():void
		{
			if (verbose)	trace(this + "start(" + arguments);
			
			this._timeLeft_sec = GAME_DURATION_MIN * 60;
			this.timer.addEventListener(TimerEvent.TIMER, this.updateTimeLeft);
			this.updateTimeLeft();
			this.timer.start();
			
			//this.gotoInputListener();
			this.board.fillWithHoles();
			this.gotoFillAndFall();
		}
		
		private function stop():void
		{
			if (verbose)	trace(this + "stop(" + arguments);
			
			this.timer.stop();
			this.timer.removeEventListener(TimerEvent.TIMER, this.updateTimeLeft);
			
			this.setState(null);
		}
		
		private function updateScore():void 
		{
			if (verbose)	trace(this + "updateScore(" + arguments);
			if (verbose)	trace();
			
			var matchScore:int = this.board.destroyablePawns.length;
			matchScore -= 2;
			matchScore *= matchScore;
			matchScore *= 10;
			
			this._score += matchScore;
			this.SCORE_UPDATED.dispatch();
		}
		
		private function updateTimeLeft(e:TimerEvent=null):void 
		{
			if (verbose)	trace(this + "updateTimer(" + arguments);
			
			this._timeLeft_sec --;
			
			
			if(this._timeLeft_sec < 0)
			{
				this.TIME_S_UP.dispatch();
				this.stop();
			}
			else
			{
				this.TIME_LEFT_UPDATED.dispatch();
			}
		}
		
		private function setState(state:AbstractState):void
		{
			if (currentState)
			{
				currentState.exit();
			}
			currentState = state;
			if (currentState)
			{
				currentState.enter();
			}
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
		
		public function get score():int 
		{
			return _score;
		}
		
		public function get timeLeft_sec():int 
		{
			return _timeLeft_sec;
		}
		
	}

}