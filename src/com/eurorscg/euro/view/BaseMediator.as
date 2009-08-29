package com.eurorscg.euro.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
    import org.puremvc.as3.interfaces.IMediator;
	
	import com.eurorscg.euro.ApplicationFacade;
	
	public class BaseMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BaseMediator";
		
		private var _name        :String = "";
		
		public function BaseMediator( name:String, viewComponent:Object = null )
		{
			super(NAME, viewComponent);
			_name = name;
		}
						
		override public function getMediatorName() : String
        {    
            return _name;
        }

	}
}