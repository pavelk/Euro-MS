package com.eurorscg.euro.controller
{
	import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import com.eurorscg.euro.model.DataProxy;
    		
	public class SceneUpdateCommand extends BaseCommand implements ICommand
	{
		override public function execute( notification:INotification ) : void
        {
            source.getSection( notification.getBody() );
        }
		
	}
}