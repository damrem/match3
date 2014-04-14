package utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * @author damrem
	 */
	public class Display 
	{
		static public function container_getChildren(container:DisplayObjectContainer):Vector.<DisplayObject>
		{
			var children:Vector.<DisplayObject> = new <DisplayObject>[];
			for(var z:uint=0; z<container.numChildren; z++)
			{
				children[z] = container.getChildAt(z);
			}
			return children;
		}
	}
}
