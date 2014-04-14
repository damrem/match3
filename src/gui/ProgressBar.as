package gui
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Shape;

	public class ProgressBar extends Sprite 
	{
		public static var verbose : Boolean;
		
		private var bar : Shape;
		private var bg : Shape;

		public function ProgressBar(w : uint, h : uint) 
		{
			if (verbose) trace(this + "ProgressBar(" + arguments);

			this.draw(w, h);
		}

		private function draw(w : int, h : int) : void 
		{
			if (verbose) trace(this + "draw(" + arguments);

			var padding : Number = h * 0.2;
			var cornerRadius : Number = padding * 2;

			// create black rounded box for background

			this.bg = new Shape();
			this.bg.graphics.beginFill(0x0, 0.6);
			this.bg.graphics.drawRoundRect(0, 0, w, h, cornerRadius, cornerRadius);
			this.bg.graphics.endFill();

			addChild(this.bg);

			// create progress bar quad

			this.bar = new Shape();
			this.bar.graphics.beginFill(0xeeeeee);
			this.bar.graphics.drawRect(0, 0, w - 2 * padding, h - 2 * padding); 
			
			/*
			this.bar.setVertexColor(2, 0xaaaaaa);
			this.bar.setVertexColor(3, 0xaaaaaa);
			*/
			
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