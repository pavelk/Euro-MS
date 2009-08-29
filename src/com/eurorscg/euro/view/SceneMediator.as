package com.eurorscg.euro.view
{
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import com.eurorscg.euro.ApplicationFacade;
	
	import com.eurorscg.euro.view.components.Content;
	import com.eurorscg.euro.view.events.SiteEvents;

	public class SceneMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = "SceneMediator";
		
		public function SceneMediator( viewComponent:Object )
		{
			super( NAME, viewComponent );
		}
		
		override public function listNotificationInterests() : Array 
        {
            return [ 
            			ApplicationFacade.RESULT_CLIENT_CHANGED
                   ];
        }
        
        override public function handleNotification( note:INotification ) : void 
        {
            switch ( note.getName() ) 
            {
                case ApplicationFacade.RESULT_CLIENT_CHANGED:
 					cont.updateContent( note.getBody().label                as String, 
 										note.getBody().content.texts        as XMLList, 
 										note.getBody().content.media.videos as XMLList, 
 										note.getBody().content.media.photos as XMLList );
                  	break; 		  	
            }
        }		

		protected function get cont() : Content
        {
			return viewComponent as Content;
        }

	}
}