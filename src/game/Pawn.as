package game 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import utils.Random;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author damrem
	 */
	public class Pawn extends Sprite
	{
		public static var verbose:Boolean;
		
		private static var _selected:Pawn;
		
		private var _type:int;
		private var _index:int;
		
		public var debugTf:TextField;
		
		public static const SIZE:int = 45;
		
		/**
		 * Useful for pivoting.
		 */
		//public static const HALF_SIZE:int = 22;
		
		public static const COLORS:Array = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff];
		
		public function Pawn(/*_index:int*/) 
		{
			if (verbose)	trace(this + "Pawn(" + arguments);
			
			//this.setIndex(_index);
			
			/*
			this.type = Random.getInteger(0, 4);
			
			this.drawGem();
			
			Pawn.select(this);
			Pawn.unselect();
			*/
		}
		
		public function reset():void
		{
			if(verbose)	trace(this + "reset(" + arguments);
			this.type = Random.getInteger(0, 4);
			
			this.alpha = 1.0;
			this.scaleX = this.scaleY = 1.0;
			
			this.drawGem();
			
			Pawn.select(this);
			Pawn.unselect();
		}
		
		private function drawGem():void
		{
			//this.pivotX = this.pivotY = Pawn.HALF_SIZE;
			var img:Image = new Image(Embeds.gemTextures[this.type]);
			//img.x = img.y = Math.round(- Pawn.SIZE / 2);
			this.addChild(img);
			
		}
		
		private function drawQuad():void
		{
			this.addChild(new Quad(SIZE, SIZE, COLORS[this.type]));
			
			if (verbose)
			{
				this.debugTf = new TextField(SIZE, SIZE/2, "");
				this.updateDebug();
				//this.addChild(this.debugTf);
			}
			
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function setIndex(value:int):void 
		{
			_index = value;
			this.updateDebug();
		}
		
		private function updateDebug():void
		{
			if (this.debugTf)	this.debugTf.text = index + ":" + _type;
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
			this.updateDebug();
		}
		
		static public function get selected():Pawn 
		{
			return _selected;
		}
		
		/**
		 * Removes the graphics from its parent, and the contained graphics as well.
		 */
		public function remove():void
		{
			this.removeChildren();
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		static public function select(pawn:Pawn):void
		{
			Pawn._selected = pawn;
			Pawn._selected.alpha = 0.75;
		}
		
		static public function unselect():void
		{
			if (Pawn.selected)
			{
				Pawn._selected.alpha = 1.0;
				Pawn._selected = null;
			}
		}
		
		public function toString():String
		{
			return "[Pawn (index:"+this.index+", color:"+this.type+")";
		}
	}

}