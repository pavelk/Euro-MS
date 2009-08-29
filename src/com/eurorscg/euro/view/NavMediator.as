package com.eurorscg.euro.view
{
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import com.eurorscg.euro.ApplicationFacade;
	
	import com.eurorscg.euro.view.components.MainNav;
	import com.eurorscg.euro.view.events.SiteEvents;

	public class NavMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = "NavMediator";
		
		public function NavMediator( viewComponent:Object )
		{
			super( NAME, viewComponent );
			nav.addEventListener( SiteEvents.GET_SECTION, onNavButtonPressed, true );
		}
		
		override public function listNotificationInterests() : Array 
        {
            return [ 
            			ApplicationFacade.RESULT_MAIN_NAV,
            			ApplicationFacade.RESULT_CLIENT_CHANGED
                   ];
        }
        
        override public function handleNotification( note:INotification ) : void 
        {
            switch ( note.getName() ) 
            {
                case ApplicationFacade.RESULT_MAIN_NAV:
    				nav.init( note.getBody() as Object );
                  	break;
                case ApplicationFacade.RESULT_CLIENT_CHANGED:
    				nav.update( note.getBody().id );
                  	break; 		  	
            }
        }
       	
       	private function onNavButtonPressed( e:SiteEvents ) : void
       	{
       		sendNotification( ApplicationFacade.CMD_CLIENT_CHANGED, e.value );
       	}  		
		
		protected function get nav() : MainNav
        {
			return viewComponent as MainNav;
        }
	}
}