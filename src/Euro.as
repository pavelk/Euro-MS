package {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
   	import flash.display.StageAlign;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	
	import com.eurorscg.euro.ApplicationFacade;

	[SWF(width="910", height="520", frameRate="30", backgroundColor="#ffffff")]
	
	public class Euro extends Sprite
	{
		private var facade:ApplicationFacade;
		private var flashVars:Object;
		private var StageObj:Stage;
		
		public function Euro()
		{
			new Assets();
			
			StageObj = this.stage;
			
			StageObj.scaleMode = StageScaleMode.NO_SCALE;
         	StageObj.align     = StageAlign.TOP_LEFT;
         	
         	facade = ApplicationFacade.getInstance();
			facade.startup( this, flashVars );
		}
	}
}