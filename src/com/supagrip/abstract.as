package com.supagrip
{
	/**
	 * @author damrem
	 */
	public function abstract(incompleteObject:Object, methodName:String):void
	{
		throw new Error("La classe des objets "+incompleteObject+" doivent implémenter la méthode '"+methodName+"'.");
	}
}
