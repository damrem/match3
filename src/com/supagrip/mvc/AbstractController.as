package com.supagrip.mvc 
{
	/**
	 * @author damrem
	 */
	public class AbstractController 
	{
		protected var view:AbstractView;
		protected var model:AbstractModel;
		
		public function AbstractController(model:AbstractModel, view:AbstractView) 
		{
			this.model = model;
			this.view = view;
		}
		
		public function start():void
		{
			this.view.start();
			this.model.start();
		}
		
		public function stop():void
		{
			this.view.stop();
			this.model.stop();
		}
	}
}
