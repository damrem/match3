package com.supagrip.navigation 
{
	import starling.display.Sprite;
	/**
	 * @author damrem
	 */
	public class AbstractNavigator extends Sprite
	{
		public static var verbose:Boolean;
		
		protected var currentScreen : AbstractScreen;
		
		function AbstractNavigator(){}
		
		protected function gotoScreen(screen:AbstractScreen):void
		{
			if(verbose)	trace(this + "gotoScreen(" + arguments);
			this.hidePreviousScreen();
			this.currentScreen = screen;
			this.addNextScreen();
			
		}
		
		private function hidePreviousScreen():void
		{
			if(this.currentScreen)
			{
				this.currentScreen.hidden.add(this.removePreviousScreen);
				this.currentScreen.hide();
			}
		}
		
		private function removePreviousScreen():void
		{
			if(this.currentScreen.destroyable)	this.currentScreen.destroy();
			this.removeChild(this.currentScreen);
		}
		
		private function addNextScreen():void
		{
			this.addChild(this.currentScreen);
			
			this.currentScreen.shown.add(this.currentScreen.start);
			this.currentScreen.show();
		}
	}
}
