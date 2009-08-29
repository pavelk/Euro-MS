package com.eurorscg.euro.view.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.eurorscg.euro.view.events.SiteEvents;
	
	import caurina.transitions.Tweener;

	public class Content extends Sprite
	{
		private var header:TextField;
		//private var subNav:SubNav;
		private var subNav:Sprite;
		private var videoNav:Sprite;
		private var photoNav:Sprite;
		private var texts:Array = new Array();
		private var navButtons:Array = new Array();
		private var vidButtons:Array = new Array();
		private var phtButtons:Array = new Array();
		private var bgcopy:Sprite;
		private var paper:Sprite;
		private var firstClick:Boolean = false;
		private var copy:TextField;
		private var video:VideoPlayer;
		private var videoPlay:Boolean = false;
		
		public function Content()
		{
			
			bgcopy = Assets.bgcopy;
			addChild( bgcopy );
			bgcopy.x = 92;
			bgcopy.y = 176;
			bgcopy.visible = false;
			
			var c:Sprite = Assets.copy;
			addChild( c );
			c.x = 209;
			c.y = 195;
			copy = TextField( c.getChildByName("txt") );
			copy.autoSize = TextFieldAutoSize.LEFT;
			
			video = new VideoPlayer();
			addChild ( video );
			video.visible = false;		
			
			paper = Assets.paper;
			paper.x = -30;
			paper.y = 10;
			addChild( paper );
			paper.addEventListener( Event.ENTER_FRAME, onPaperEnterFrame );
			
			var h:Sprite = Assets.header;
			addChild( h );
			
			header = TextField( h.getChildByName("txt") );
			header.autoSize = TextFieldAutoSize.LEFT;
			
			addChild( header );
			header.x = 209;
			header.y = 113;
			
			subNav = new Sprite();
			subNav.x = 203;
			subNav.y = 155;
			addChild( subNav );
			
			videoNav = new Sprite();
			videoNav.x = 705;
			videoNav.y = 80;
			addChild( videoNav );
			
			photoNav = new Sprite();
			photoNav.x = 705;
			photoNav.y = 80;
			addChild( photoNav );
		}
		
		public function updateContent( h:String, d:XMLList, v:XMLList, p:XMLList ) : void
		{
			if(!firstClick)
			{
				firstClick = true;
				bgcopy.visible = true;
				bgcopy.alpha = 0;
				Tweener.addTween(bgcopy, {alpha:1, time:.5, transition:"linear"});
			}
			
			clearOld();
			
			header.alpha = 0;
			header.htmlText = h;
			Tweener.addTween(header, {alpha:1, time:.5, transition:"linear"});
			
			var j:uint = 0;
			var w:Number = 0;
			for each( var i:XML in d.page )
			{
				texts.push( i.text );
				var snb:SubNavButton = new SubNavButton( j, i.@name );
				snb.x = w;
				navButtons.push( snb );
				subNav.addChild( snb );
				snb.addEventListener(SiteEvents.GET_SUBSECTION, onSubUpdateHandler);
				snb.alpha = 0;
				Tweener.addTween(snb, {alpha:1, time:.3, delay: 0.1*j, transition:"linear"});
				w += snb.width + 20;
				j ++;	
			}
			navButtons[0].dispatchEvent( new MouseEvent( MouseEvent.CLICK ) );
			
			//videos
			if ( v.length() > 0 )
			{
				buildVideos( v );
			}
			
			//photos
			if ( p.length() > 0 )
			{
				buildPhotos( p );
			}
			
		}
		
		private function buildPhotos( p:XMLList ) : void
		{
			var pushX:Number = 0;
			var pushY:Number = 0;
			
			var j:uint = 0;
			for each( var i:XML in p.photo )
			{
				var pb:MediaButton = new MediaButton( "prints", i.@src );
				phtButtons.push( pb );
				photoNav.addChild( pb );
				pb.x = pushX;
				pb.y = pushY;
				pushX += pb.width + 12;
				if ( pushX >= (pb.width + 12)*2 )
				{
					pushX = 0;
					//pushY += vb.height + 12;
					pushY += 86;
				}
				pb.addEventListener( SiteEvents.PLAY_PHOTO, onPlayPhoto );
				pb.alpha = 0;
				Tweener.addTween(pb, {alpha:1, time:.3, delay: 0.1*j, transition:"linear"});
				j ++;
			}			
		}
		
		private function buildVideos( v:XMLList ) : void
		{
			var pushX:Number = 0;
			var pushY:Number = 0;
			
			var j:uint = 0;
			for each( var i:XML in v.video )
			{
				var vb:MediaButton = new MediaButton( "videos", i.@src );
				vidButtons.push( vb );
				videoNav.addChild( vb );
				vb.x = pushX;
				vb.y = pushY;
				pushX += vb.width + 12;
				if ( pushX >= (vb.width + 12)*2 )
				{
					pushX = 0;
					//pushY += vb.height + 12;
					pushY += 86;
				}
				vb.addEventListener( SiteEvents.PLAY_VIDEO, onPlayVideo );
				vb.alpha = 0;
				Tweener.addTween(vb, {alpha:1, time:.3, delay: 0.1*j, transition:"linear"});
				j ++;
			}
		}
		
		private function onPlayPhoto( e:SiteEvents ) : void
		{
			if(videoPlay)
			{

			}
			//video.playVideo( e.value as String );
		}
		
		private function onPlayVideo( e:SiteEvents ) : void
		{
			if(!videoPlay)
			{
				videoPlay = true;
				resetSubMenu();
				video.visible = true;
			}
			video.playVideo( e.value as String );
		}

		private function onSubUpdateHandler(e:SiteEvents) : void
		{
			if (videoPlay)
			{
				resetVideo();
			}
			copy.htmlText = texts[e.value];
			copy.alpha = 0;
			Tweener.addTween(copy, {alpha:1, time:.5, delay: 0, transition:"linear"});
			
			for each (var b:SubNavButton in navButtons)
			{
				if( Number(b.id) == e.value )
				{
					b.enableButton(false);
				}else{
					b.enableButton(true);
				}
			}
		}
		
		private function resetVideo() : void
		{
			videoPlay = false;
			video.clearVideoPlayer();
			video.visible = false;
		}
		
		private function resetSubMenu() : void
		{
			copy.htmlText = "";
			
			for each (var b:SubNavButton in navButtons)
			{
				b.enableButton(true);
			}
			
		}
		
		private function onPaperEnterFrame(e:Event) : void
		{
			if ( e.target.currentLabel == "end" )
			{
				paper.removeEventListener( Event.ENTER_FRAME, onPaperEnterFrame );
				e.target.stop();
				dispatchEvent(new SiteEvents( SiteEvents.FIRST_CLICK ));
			}
		}
		
		private function clearOld() : void
		{
			texts = [];
			copy.htmlText = "";
			while ( navButtons.length > 0) 
			{ 
				var s:Sprite = navButtons.shift();
				subNav.removeChild(s);
				s = null; 
			}
			while ( vidButtons.length > 0) 
			{ 
				var v:Sprite = vidButtons.shift();
				videoNav.removeChild(v);
				v = null; 
			}
			while ( phtButtons.length > 0) 
			{ 
				var p:Sprite = phtButtons.shift();
				photoNav.removeChild(p);
				p = null; 
			}
						
		}
		
		
	}
}