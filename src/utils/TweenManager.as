package utils {
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	/**
	 * @author damrem
	 * Un tween instancié en tant que variable locale d'une méthode peut être supprimé par le gc avant même d'être terminé.
	 * Cette classe permet de stocker une référence à de tels tweens durant leur vie, puis de les supprimer au moment voulu.
	 */
	public class TweenManager 
	{
		public var DBG:Boolean;
		
		/**
		 * @private
		 * La structure permettant de stocker les animations en cours.
		 */
		private var tweens:Vector.<Tween>;
		
		function TweenManager():void
		{
			this.tweens = new <Tween>[];
		}
		
		/**
		 * Stocke une animation en cours, et met en place l'écoute de sa fin pour le détruire.
		 * @param tween:Tween L'animation à stocker.
		 */
		public function registerShortLivedTween(tween:Tween):void
		{
			if(this.DBG)	trace(this+"registerShortLivedTween("+tween);
			this.tweens.push(tween);
			tween.addEventListener(TweenEvent.MOTION_START, this.onMotionStart, false, 0, true);
			tween.addEventListener(TweenEvent.MOTION_FINISH, this.onMotionFinish_killTween, false, 0, true);
		}
		
		/**
		 * Appelée en début de lecture d'une animation.
		 * @private
		 */
		private function onMotionStart(event:TweenEvent):void
		{
			if(this.DBG)	trace(this+"onMotionStart("+event);
		}
		
		/**
		 * Appelée en fin d'animation, cette méthode arrête l'animation, coupe ses écoutes et la désenregistre.
		 * @private
		 */
		private function onMotionFinish_killTween(event:TweenEvent):void
		{
			if(this.DBG)	trace(this+"onMotionFinish("+event);
			var finishedTween:Tween = event.currentTarget as Tween;
			for(var i:uint=0; i<this.tweens.length; i++)
			{
				var currentTween:Tween = this.tweens[i];
				if(finishedTween == currentTween)
				{
					finishedTween.stop();
					finishedTween.removeEventListener(TweenEvent.MOTION_FINISH, this.onMotionFinish_killTween, false);
					this.tweens.splice(i, 1);
				}
			}
			if(this.DBG)	trace(this+"tweens.length = "+this.tweens.length);
		}
	}
}
