package utils.debug {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * @author damrem
	 */
	public class DebugField extends TextField
	{
		static public var titleFix:String = '--------';
		
		public function DebugField(bgColor:uint=0xffff00, title:Object='[UNTITLED DEBUG FIELD]'):void
		{
			super();
			this.background = true;
			this.backgroundColor = bgColor;
			this.border = true;
			this.alpha = 0.75;
			
			this.autoSize = TextFieldAutoSize.LEFT;
			
			this.t(titleFix + title + titleFix);
		}
		
		public function t(...values:Array):void
		{
			this.appendText(values.toString()+"\n");
		}
	}
}
