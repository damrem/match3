package 
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.ProgressEvent;
   import flash.utils.getDefinitionByName;
   import loadingscreen.ProgressBar;

  public class Preloader extends MovieClip 
  {
		public static var verbose:Boolean;
		
		private var progressBar:ProgressBar;
		
		public function Preloader()
		{
			//add preloader graphics
			this.progressBar = new ProgressBar(175, 20);
			this.progressBar.x = (Main.STAGE_WIDTH - this.progressBar.width) / 2;
			this.progressBar.y = (Main.STAGE_HEIGHT - this.progressBar.height) / 2;
			this.addChild(progressBar);

			//check loading progress
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		 private function onProgress(e:ProgressEvent):void 
		 {
			var ratio:Number = Math.round(e.bytesLoaded / e.bytesTotal);
			this.progressBar.setRatio(ratio);
			if (ratio == 1)
			{
				this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				onLoaded();
		}	
	}
	private function onLoaded():void
	{
		nextFrame(); //go to next frame
		var App:Class = getDefinitionByName('Main') as Class; //class of your app
		addChild(new App() as DisplayObject);
	}
	 
	
  }
}
