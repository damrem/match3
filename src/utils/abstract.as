package utils
{
	/**
	 * @author damrem
	 */
	public function abstract(incompleteObject:Object, methodName:String):void
	{
		throw new Error("The class of "+ incompleteObject+" must override the '"+methodName+"' method of its super-class.");
	}
}
