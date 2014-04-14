package gamescreen.gameview.acquisition {
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import flash.geom.Point;

	/**
	 * @author damrem
	 */
	public class TouchEntry extends AbstractUserEntry 
	{
		private var target : DisplayObject;
		private var origin:Point;
		
		private static const THRESHOLD:Number = 10.0;
		
		public function TouchEntry(target : DisplayObject) 
		{
			super();
			
			this.target = target;
			this.target.addEventListener(TouchEvent.TOUCH, this.onTouch);
		}
		
		//private var previousGlobalX:int, previousGlobalY:int;
		private function onTouch(event : TouchEvent) : void 
		{
			var touch:Touch;
			
			touch = event.getTouch(this.target, TouchPhase.BEGAN);
			if(touch)
			{
				this.onBegan(touch);
				return;
			}
			
			touch = event.getTouch(this.target, TouchPhase.STATIONARY);
			if(touch)
			{
				this.onStationary(touch);
				return;
			}
			
			touch = event.getTouch(this.target, TouchPhase.MOVED);
			if(touch)
			{
				this.onMoved(touch);
				return;
			}
			
			touch = event.getTouch(this.target, TouchPhase.ENDED);
			if(touch)
			{
				this.onEnded(touch);
				return;
			}
			
			/*
			if(touch.globalX < this.previousGlobalX)
			{
				trace(Direction.LEFT);
				this.left.dispatch();
			}
			else
			if(touch.globalX > this.previousGlobalX)
			{
				trace(Direction.RIGHT);
				this.right.dispatch();
			}
			
			this.previousGlobalX = event.touches[0].globalX;
			this.previousGlobalY = event.touches[0].globalY;*/
		}

		private function onBegan(touch:Touch) : void
		{
			trace(touch);
			this.origin = new Point(touch.globalX, touch.globalY);
		}
		
		private function onEnded(touch : Touch) : void 
		{
			trace(touch);
			trace((touch.globalX - origin.x)+", "+(touch.globalY - origin.y));
			
			var dx:Number = touch.globalX - origin.x;
			var dy:Number = touch.globalY - origin.y;
			
			if(Math.abs(dy) > Math.abs(dx))
			{
				trace("vertical");
				if(dy > THRESHOLD)
				{
					trace("vers le bas");
					this.down.dispatch();
				}
				return;
			}
			
			if(dx < - THRESHOLD)
			{
				this.left.dispatch();
			}
			else if(dx > THRESHOLD)
			{
				this.right.dispatch();
			}
			
		}

		private function onMoved(touch : Touch) : void 
		{
			//trace(touch);
		}

		private function onStationary(touch : Touch) : void 
		{
			//trace(touch);
		}
		
		
	}
}
