package game 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	import game.states.AbstractState;
	import game.states.Matcher;
	import game.states.Destroyer;
	import game.states.FallerAndFiller;
	import game.states.InputListener;
	import game.states.Swapper;
	import starling.core.Starling;
	/**
	 * Main controller of the game.
	 * It handles the transition between the differents states/sub-controllers,
	 * depending on the signals they dispatch.
	 * It also handles score and time.
	 * @author damrem
	 */
	public class GameController 
	{
		public static var verbose:Boolean;
		
		//	score management
		private var _score:int;
		public const SCORE_UPDATED:Signal = new Signal();

		//	time management
		public static const GAME_DURATION_MIN:Number = 0.1;
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
		private var fallerAndFiller:FallerAndFiller;
		private var inputListener:InputListener;
		private var swapper:Swapper;
		
		public function GameController() 
		{
			if (verbose)	trace(this + "GameController(" + arguments);
			
			this.timer = new Timer(1000, 5 * 60);
			
			this._board = new Board();
			
			this.fallerAndFiller = new FallerAndFiller(board);
			this.fallerAndFiller.FILLED.add(this.gotoMatcher);
			
			this.inputListener = new InputListener(board);
			this.inputListener.SWAP_REQUESTED.addOnce(this.reallyStartPlaying);
			this.inputListener.SWAP_REQUESTED.add(this.gotoSwapper);
			
			this.swapper = new Swapper(board);
			this.swapper.SWAPPED.add(this.gotoMatcher);
			this.swapper.UNSWAPPED.add(this.gotoInputListener);

			this.matcher = new Matcher(board);
			this.updateScore("GameController");
			
			//	this will be plugged only after a 1st swipe, to prevent scoring during initial board filling
			//this.matcher.MATCHES_FOUND.add(this.updateScore);
			
			this.matcher.MATCHES_FOUND.add(this.gotoDestroyer);
			this.matcher.INVALID_SWAP.add(this.gotoSwapper);
			this.matcher.NO_MATCHES_FOUND.add(this.gotoInputListener);
			
			this.destroyer = new Destroyer(board);
			this.destroyer.ALL_ARE_DESTROYED.add(this.gotoFillerAndFaller);
		}
		
		public function start():void
		{
			if (verbose)	trace(this + "start(" + arguments);
			
			this._timeLeft_sec = GAME_DURATION_MIN * 60;
			this.timer.addEventListener(TimerEvent.TIMER, this.updateTimeLeft);

			this.updateScore("start");
			this.updateTimeLeft();
			
			this.board.fillWithHoles();
			this.gotoFillerAndFaller();
		}
		
		//	At the beginning, there are matches, destructions, fallings and fillings:
		//	we wait for this first wave of actions to start timer and score.
		public function reallyStartPlaying():void
		{
			this.timer.start();
			this.matcher.MATCHES_FOUND.add(this.updateScore);
		}
		
		/**
		 * Unset the state and unplug all the signals.
		 */
		private function stop():void
		{
			if (verbose)	trace(this + "stop(" + arguments);
			
			this.timer.stop();
			this.timer.removeEventListener(TimerEvent.TIMER, this.updateTimeLeft);
			
			this.setState(null);
			
			this.destroyer.exit();
			this.fallerAndFiller.exit();
			this.inputListener.exit();
			this.matcher.exit();
			this.swapper.exit();
			
			Pawn.unselect();
			
			this.fallerAndFiller.FILLED.removeAll();
			
			this.inputListener.SWAP_REQUESTED.removeAll();
			
			this.swapper.SWAPPED.removeAll();
			this.swapper.UNSWAPPED.removeAll();

			this.matcher.MATCHES_FOUND.removeAll();
			this.matcher.INVALID_SWAP.removeAll();
			this.matcher.NO_MATCHES_FOUND.removeAll();
			
			this.destroyer.ALL_ARE_DESTROYED.removeAll();
		}
		
		private function updateScore(caller:String="other"):void 
		{
			if (verbose)	trace(this + "updateScore(" + arguments);
			
			var matchScore:int = this.board.destroyablePawns.length;
			matchScore -= 2;
			matchScore = Math.max(matchScore, 0);
			matchScore *= matchScore;
			matchScore *= 10;
			
			this._score += matchScore;
			this.SCORE_UPDATED.dispatch(this.score);
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
				this.TIME_LEFT_UPDATED.dispatch(this.timeLeft_sec);
			}
		}
		
		/**
		 * Defines the current state, by exiting the previous one, and entering the specified one.
		 * @param	state
		 */
		private function setState(state:AbstractState):void
		{
			if (verbose)	trace(this + "setState(" + arguments);
			
			if (currentState)
			{
				currentState.exit();
			}
			
			currentState = state;
			
			if (currentState)
			{
				currentState.enter("gameController.setState");
			}
		}
		
		/**
		 * Enter the input state.
		 * @param	caller
		 */
		private function gotoInputListener(caller:String="other"):void
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
		
		/**
		 * Enter the states which detects matches.
		 */
		private function gotoMatcher():void
		{
			if (verbose)	trace(this + "gotoMatcher(" + arguments);
			
			this.setState(this.matcher);
		}
		
		/**
		 * Enter the states which destroys pawns.
		 */
		private function gotoDestroyer():void 
		{
			if (verbose)	trace(this + "gotoDestroyer(" + arguments);
			
			this.setState(this.destroyer);
		}
		
		/**
		 * Enter the states which generates pawns and make them fall.
		 */
		private function gotoFillerAndFaller():void 
		{
			if (verbose)	trace(this + "gotoFillAndFall(" + arguments);
			
			this.setState(this.fallerAndFiller);
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