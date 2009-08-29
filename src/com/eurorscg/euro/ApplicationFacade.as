package com.eurorscg.euro
{
	import com.eurorscg.euro.controller.*;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const CMD_STARTUP       :String = "startup";
		public static const CMD_GET_MAIN_NAV  :String = "getMainNav";
		public static const CMD_CLIENT_CHANGED:String = "clientChanged";
		
        public static const INITIALIZE_SITE      :String = "initializeSite";
        public static const RESULT_MAIN_NAV      :String = "resultMainNav";
        public static const RESULT_CLIENT_CHANGED:String = "resultClientChanged";
		
        public static function getInstance() : ApplicationFacade 
        {
            return ( instance ? instance : new ApplicationFacade() ) as ApplicationFacade;  
        }
        
        public function startup( root:Object, flashVars:Object ) : void
        {
        	var arg:Object = {
        						dobj:root,
        						fv  :flashVars
        	}
        	sendNotification( CMD_STARTUP, arg );
        }
        
        override protected function initializeController() : void 
        {
            super.initializeController(); 
            registerCommand( CMD_STARTUP     , StartupCommand );
            registerCommand( CMD_GET_MAIN_NAV, MainNavCommand );
            registerCommand( CMD_CLIENT_CHANGED,  SceneUpdateCommand  );
        }
	}
}