package com.eurorscg.euro.controller
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import com.eurorscg.euro.ApplicationFacade;
    import com.eurorscg.euro.view.ApplicationMediator;
    import com.eurorscg.euro.model.DataProxy;
	
	public class StartupCommand extends SimpleCommand implements ICommand
	{
		override public function execute( note:INotification ) : void    
        {
	    	facade.registerProxy( new DataProxy( note.getBody().fv ) );

            facade.registerMediator( new ApplicationMediator( note.getBody().dobj as DisplayObject ) );
        }

	}
}