package gamescreen 
{
	import starling.display.Button;

	import com.supagrip.navigation.AbstractScreen;
	import com.supagrip.navigation.TouchButton;

	import org.osflash.signals.Signal;

	/**
	 * @author damrem
	 */
	public class GameScreen extends AbstractScreen 
	{
		public static var verbose:Boolean;
		
		public const exitRequested:Signal = new Signal();
		
		private var mvc:GameMVC;
		
		public function GameScreen() 
		{
			if(verbose)	trace(this + "GameScreen(" + arguments);
			this.destroyable = true;
			
			this.mvc = new GameMVC();
			this.addChild(this.mvc.getView());
			
			this.addExitButton();
		}
		
		private function addExitButton():void
		{
			var exitButton:Button = new TouchButton(exitRequested);
			this.addChild(exitButton);
		}
		
		override public function start():void
		{
			if(verbose)	trace(this + "start(" + arguments);
			this.started.dispatch();
			this.mvc.start();
		}
		
		override public function stop():void
		{
			if(verbose)	trace(this + "start(" + arguments);
			this.stopped.dispatch();
			this.mvc.stop();
		}
		
		override public function show():void
		{
			this.shown.dispatch();
		}
		
		override public function hide():void
		{
			this.hidden.dispatch();
		}
		
		override public function destroy():void
		{
			
		}
	}
}
