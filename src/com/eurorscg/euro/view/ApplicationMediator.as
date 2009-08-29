package com.eurorscg.euro.view
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import com.eurorscg.euro.ApplicationFacade;
	
	import com.eurorscg.euro.view.components.SiteComponent;
	//import com.eurorscg.guidepost.view.events.SiteEvents;
	
	public class ApplicationMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = "StageMediator";
				
		public function ApplicationMediator( viewComponent:Object )
		{
			super( NAME, viewComponent );
		}
		
		override public function listNotificationInterests() : Array 
        {
            return [ 
            			ApplicationFacade.INITIALIZE_SITE
                   ];
        }
        
        override public function handleNotification( note:INotification ) : void 
        {
            switch ( note.getName() ) 
            {
                case ApplicationFacade.INITIALIZE_SITE:
                	registerChildMediators();     	
                  	break;	  	
            }
        }
        
		private function registerChildMediators() : void
		{
			var site:SiteComponent = new SiteComponent();

        	facade.registerMediator( new SceneMediator( site.content ) );
        	facade.registerMediator( new NavMediator( site.mainNav ) );
        	//facade.registerMediator( new SubNavMediator( site.subNav ) );
        	
        	root.addChild( site );
        	sendNotification( ApplicationFacade.CMD_GET_MAIN_NAV );
		}
                       
        protected function get root() : Sprite
        {
            return viewComponent as Sprite;
        }

	}
}