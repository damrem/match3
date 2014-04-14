package menuscreen 
{
	import starling.display.Button;
	import starling.textures.Texture;

	import com.supagrip.navigation.AbstractScreen;
	import com.supagrip.navigation.TouchButton;

	import org.osflash.signals.Signal;

	/**
	 * @author damrem
	 */
	public class MenuScreen extends AbstractScreen 
	{
		public static var verbose:Boolean;
		
		private var buttonPlay:Button; 
		
		public const gameRequested:Signal = new Signal();
		
		function MenuScreen()
		{
			if(verbose)	trace(this + "MenuScreen(" + arguments);
			
			this.destroyable = false;
			
			this.buttonPlay = new TouchButton(this.gameRequested, 'Play');
			this.addChild(this.buttonPlay);
			
		}
		
		override public function start():void
		{
			if(verbose)	trace(this + "start(" + arguments);
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
			 if(verbose)	trace(this + "destroy(" + arguments);
		}
	}
}
