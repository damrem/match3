package com.supagrip.navigation {
	import flash.display.BitmapData;
	import starling.display.Button;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	import org.osflash.signals.Signal;

	/**
	 * @author damrem
	 */
	public class TouchButton extends Button 
	{
		public static var verbose:Boolean;
		private var _triggered : Signal;
		
		[Embed(source = '../../../assets/textures/button.gif')]
		private static var Button:Class;
		
		public function TouchButton(triggered:Signal, text : String = "") 
		{
			var upState:Texture = Texture.fromBitmap(new Button());
			super(upState, text);
			this._triggered = triggered;
			this.addEventListener(TouchEvent.TOUCH, this.onTouch);
		}
		
		private function onTouch(event : TouchEvent) : void 
		{
			if(verbose)	trace(this + "onTouchButtonPlay(" + arguments);
			
			var touch:Touch = event.getTouch(this);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				if(verbose)	trace("gameRequested");
				this.triggered.dispatch();
			}
		}

		public function get triggered() : Signal {
			return _triggered;
		}
	}
}
