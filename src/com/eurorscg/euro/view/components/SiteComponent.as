package com.eurorscg.euro.view.components
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	import com.eurorscg.euro.view.events.SiteEvents;
	
	public class SiteComponent extends Sprite
	{
		public var mainNav:MainNav;
		public var content:Content;
		
		private var bg:Sprite;
		private var photoShow:Sprite;
		
		public function SiteComponent()
		{
			bg = Assets.bg;
			addChild( bg );
			
			content = new Content();
			addChild( content );
			
			mainNav = new MainNav();
			addChild( mainNav );
			
			photoShow = new Sprite();
			var sp:Shape = new Shape();
			sp.graphics.beginFill ( 0xffffff);
			sp.graphics.drawRect( 0, 0, 910, 520 );
			sp.graphics.endFill();
			photoShow.addChild( sp );
			//sp.alpha = 0;
			addChild(photoShow);
			photoShow.visible = false;
			
			content.addEventListener( SiteEvents.FIRST_CLICK, onFirstClick );
			content.addEventListener( SiteEvents.PLAY_PHOTO, onPlayPhoto, true ); 
		}
		
		private function onPlayPhoto( e:SiteEvents ) :void
		{
			Tweener.addTween(bg, {alpha:0, time:0.5});
			Tweener.addTween(content, {alpha:0, time:0.5});
			Tweener.addTween(mainNav, {alpha:0, time:0.5});
			photoShow.visible = true;
			photoShow.alpha = 0;
			Tweener.addTween(photoShow, {alpha:1, time:0.5});
		}
		
		private function onFirstClick(e:SiteEvents) : void
		{
			mainNav.startFirst();
		}
		
	}
}