package com.eurorscg.euro.model
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import com.eurorscg.euro.ApplicationFacade;
	
	import com.eurorscg.euro.model.vo.*;
	
	public class DataProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DataProxy";
		
		//private var language:String;
		
		public function DataProxy( fv:Object )
		{
			//default value for standalone swf testing
			var dataUrl:String = "data/data.xml";

			/*
			if( fv.xml_location != undefined || fv.language != undefined )
			{
				dataUrl  = fv.xml_location;
			}
			*/
			super( NAME, new Object() );
                        
            var loader:URLLoader = new URLLoader();
            loader.addEventListener( Event.COMPLETE, onDataLoaded );
            
            try{
               loader.load( new URLRequest( dataUrl ) );
            }catch ( error:Error ){
                trace("Nedari se nahrat data");
            } 
		}
		
		public function getMainNav() : void
		{		
			sendNotification( ApplicationFacade.RESULT_MAIN_NAV, data.mainNav  );
		}
		
		public function getSection( i:Object ) : void
		{
			sendNotification( ApplicationFacade.RESULT_CLIENT_CHANGED, data[i]  );
		}
		
		private function onDataLoaded( e:Event ) : void
		{
			var xml:XML = new XML( e.target.data );
			
			var nav:Object = new Object();
			for each(var x:XML in xml.client)
			{
				nav[ x.@id ] = x.@name;
				
				var vo:ClientVO = new ClientVO( x.@id, x.@name, x.data );
				data[ x.@id ] = vo;
			}
			data.mainNav = nav;
						
			sendNotification( ApplicationFacade.INITIALIZE_SITE );
		}

	}
}