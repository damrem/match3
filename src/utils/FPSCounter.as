package utils 
{
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	/**
	 * Inspired by the starling internal class starling.core.StatsDisplay
	 * @author damrem
	 */
	public class FPSCounter extends Sprite
	{
		public static var verbose:Boolean;

		private var totalTime:Number=0;
		private var frameCount:int;
		private const UPDATE_INTERVAL:Number = 0.5;
		private var _fps:Number=0;
		
		public function FPSCounter() 
		{
			if (verbose)	trace(this + "FPSCounter(" + arguments);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.onStage);
			
		}
		
		private function onStage(event:Event):void
		{
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:EnterFrameEvent):void
        {
			if (verbose)	trace(this + "onEnterFrame(" + arguments);
			
            this.totalTime += event.passedTime;

            this.frameCount++;
            
            if (this.totalTime > this.UPDATE_INTERVAL)
            {
                this.update();
                this.frameCount = this.totalTime = 0;
            }
        }
		
		/** Updates the displayed values. */
        public function update():void
        {
			if (verbose)	trace(this + "update(" + arguments);
			
            this._fps = this.totalTime > 0 ? this.frameCount / this.totalTime : 0;
        }
		
		public function get fps():Number 
		{
			return _fps;
		}
		
	}

}