package mygame 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mygame.states.AbstractState;
	import mygame.states.Check;
	import mygame.states.Destroy;
	import mygame.states.Fall;
	import mygame.states.Input;
	import mygame.states.Swap;
	/**
	 * ...
	 * @author damrem
	 */
	public class GameController 
	{
		public static var verbose:Boolean;
		
		private var currentState:AbstractState;
		
		private var check:Check;
		private var destroy:Destroy;
		private var fall:Fall;
		private var input:Input;
		private var swap:Swap;
		
		private var timer:Timer;
		
		public function GameController(board:Board) 
		{
			if (verbose)	trace(this + "GameController(" + arguments);
			
			this.fall = new Fall(board);
			this.fall.BOARD_FILLED.add(this.gotoCheck);
			//this.fall.LANDED.add(this.gotoFall);
			
			this.check = new Check(board);
			
			this.input = new Input(board);
			this.input.INPUT.add(this.gotoDestroy);
			
			this.destroy = new Destroy(board);
			this.destroy.ALL_ARE_DESTROYED.add(this.gotoFall);
			
			this.swap = new Swap(board);
			
			this.timer = new Timer(1000 / 60);
			this.timer.addEventListener(TimerEvent.TIMER, this.update);
		}
		
		public function start():void
		{
			if (verbose)	trace(this + "start(" + arguments);
			
			this.setState(this.input);
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
		}
		
		private function gotoCheck():void
		{
			if (verbose)	trace(this + "gotoCheck(" + arguments);
			
			this.setState(this.check);
		}
		
		private function gotoDestroy():void 
		{
			if (verbose)	trace(this + "gotoDestroy(" + arguments);
			
			this.setState(this.destroy);
		}
		
		private function gotoFall():void 
		{
			if (verbose)	trace(this + "gotoFall(" + arguments);
			
			this.setState(this.fall);
		}
		
	}

}