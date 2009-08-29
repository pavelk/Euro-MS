package com.eurorscg.euro.controller
{
    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import com.eurorscg.euro.model.DataProxy;
    //import app.model.StateProxy;  
	 /**
     * BaseCommand for this app
     * 
     * By inheriting from this command class, commands
     * will get easy access to our proxies
     * 
     * @author Pavel Krusek
     */
     
	public class BaseCommand extends SimpleCommand implements ICommand
	{
		//protected var state:StateProxy;
        protected var source:DataProxy;
		
		public function BaseCommand()
		{
			source = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
            //state = facade.retrieveProxy( StateProxy.NAME ) as StateProxy;
		}

	}
}