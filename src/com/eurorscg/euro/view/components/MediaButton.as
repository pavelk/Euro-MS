package com.eurorscg.euro.view.components
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.eurorscg.euro.view.events.SiteEvents;

	public class MediaButton extends Sprite
	{
		private var tLoader:Loader = new Loader();
		private var desc   :Sprite;
		private var data   :String;
		private var kind   :String; 
		
		public function MediaButton( t:String, s:String )
		{
			data = s;
			kind = t;
			
			desc = Assets.videobtn;
			addChild( desc );
			
			tLoader.load(new URLRequest(t + "/thumbs/" + s + ".jpg" ));
			tLoader.contentLoaderInfo.addEventListener( Event.COMPLETE,loadDone );
			//tLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			mouseEnabled = true;
			mouseChildren = false;
			buttonMode = true;
			 
			addEventListener( MouseEvent.CLICK, onClickHandler );
		}
		
		private function onClickHandler(e:MouseEvent) : void
		{
			var se:SiteEvents;
			if( kind == "videos" )
			{
				se = new SiteEvents( SiteEvents.PLAY_VIDEO );
			}else{
				se = new SiteEvents( SiteEvents.PLAY_PHOTO );
			}
			
			se.value = data;
			dispatchEvent(se);
		}
		
		private function loadDone( e:Event ) : void
		{
			var b:DisplayObject = tLoader.content;
			//b.x = -b.width / 2 + 1;
			b.y = -b.height - 1;
			addChild(b);			
		}
		
		
	}
}