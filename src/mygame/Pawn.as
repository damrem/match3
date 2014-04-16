package mygame 
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
		
		private var _type:int;
		private var _index:int;
		
		public var debugTf:TextField;
		
		public static const SIZE:int = 45;
		public static const COLORS:Array = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff];
		
		public function Pawn(_index:int) 
		{
			if (verbose)	trace(this + "Pawn(" + arguments);
			
			this.index = _index;
			this.type = Random.getInteger(0, 4);
			this.addChild(new Quad(SIZE, SIZE, COLORS[this.type]));
			
			if (verbose)
			{
				this.debugTf = new TextField(SIZE, SIZE/2, "");
				this.updateDebug();
				this.addChild(this.debugTf);
			}
			
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set index(value:int):void 
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
		
		public function destroy():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function toString():String
		{
			return "[Pawn (index:"+this.index+", color:"+this.type+")";
		}
		
	}

}