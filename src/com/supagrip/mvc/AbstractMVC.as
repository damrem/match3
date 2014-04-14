package com.supagrip.mvc 
{
	/**
	 * @author damrem
	 */
	public class AbstractMVC 
	{
		protected var model:AbstractModel;
		protected var view:AbstractView;
		protected var controller:AbstractController;
		
		function AbstractMVC(){}
		
		public function start():void
		{
			this.controller.start();
		}
		
		public function stop():void
		{
			this.controller.stop();
		}
		
		public function getView():AbstractView
		{
			return this.view;
		}
	}
}
