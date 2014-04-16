package mygame 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import utils.Random;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * ...
	 * @author damrem
	 */
	public class Pawn extends Quad
	{
		public static var verbose:Boolean;
		
		private var _type:int;
		public var index:int;
		
		public static const SIZE:int = 45;
		public static const COLORS:Array = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff];
		
		public function Pawn(_index:int) 
		{
			if (verbose)	trace(this + "Pawn(" + arguments);
			
			this.index = _index;
			this._type = Random.getInteger(0, 4);
			super(SIZE, SIZE, COLORS[this.type]);
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function destroy():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function moveTo(xy:Point, onComplete:Function = null, onCompleteArgs:Array = null):void 
		{
			if (verbose)	trace(this + "moveTo(" + arguments);
			
			var tween:Tween = new Tween(this, xy.length / 1000);
			tween.moveTo(xy.x, xy.y);
			if (onComplete != null)
			{
				tween.onComplete = onComplete;
				if (onCompleteArgs != null)
				{
					tween.onCompleteArgs = onCompleteArgs;
				}
			}
			Starling.juggler.add(tween);
		}
		
		public function sleep():void 
		{
			
		}
		
		public function toString():String
		{
			return "[Pawn (index:"+this.index+", color:"+this.type+")";
		}
		
	}

}