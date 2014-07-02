package gui
{
	import starling.display.Sprite;
	import starling.display.Shape;

	public class ProgressBar extends Sprite 
	{
		public static var verbose : Boolean;
		
		private var bar : Shape;
		private var bg : Shape;

		public function ProgressBar(w : uint, h : uint, padding:uint) 
		{
			if (verbose) trace(this + "ProgressBar(" + arguments);

			this.draw(w, h, padding);
		}

		private function draw(w : uint, h : uint, padding:uint) : void 
		{
			if (verbose) trace(this + "draw(" + arguments);

			var cornerRadius : Number = padding * 2;

			// create grey box for background

			this.bg = new Shape();
			this.bg.graphics.beginFill(0x808080, 0.6);
			this.bg.graphics.drawRect(0, 0, w, h);
			this.bg.graphics.endFill();

			addChild(this.bg);

			// create progress bar

			this.bar = new Shape();
			this.bar.graphics.beginFill(0xeeeeee);
			this.bar.graphics.drawRect(0, 0, w - 2 * padding, h - 2 * padding); 
			
			this.bar.x = padding;
			this.bar.y = padding;
			this.bar.scaleX = 0;
			this.addChild(this.bar);
		}

		public function setRatio(ratio : Number) : void 
		{
			if (verbose) trace(this + "setRatio(" + arguments);

			this.bar.scaleX = Math.max(0.0, Math.min(1.0, ratio));
		}
	}
}