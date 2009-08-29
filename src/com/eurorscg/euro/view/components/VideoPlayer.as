package com.eurorscg.euro.view.components
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import com.eurorscg.utils.media.FLVPlayer;
	import com.eurorscg.utils.media.MediaData;
	
	import com.eurorscg.euro.view.events.SiteEvents;

	public class VideoPlayer extends Sprite
	{
		private var mediaPlayer : FLVPlayer;
		private var video       : Video;
		private var stopBtn     : MovieClip;
		private var pauseBtn    : MovieClip;
		private var muteBtn     : MovieClip;
		
		public function VideoPlayer( )
		{
			mediaPlayer       = new FLVPlayer();
			video             = new Video(383, 220);
			mediaPlayer.video = video;

			addChild(video);
			video.x = 235;
			video.y = 200;
			
			var cp:Sprite = Assets.playerControls;
			addChild(cp);
			cp.x = video.x;
			cp.y = video.y + video.height;
			
			stopBtn = MovieClip(cp.getChildByName("vstop"));
			stopBtn.buttonMode = true;
			stopBtn.stop();
			
			pauseBtn = MovieClip(cp.getChildByName("pause"));
			pauseBtn.buttonMode = true;
			pauseBtn.stop();
			pauseBtn.status = false;
			
			muteBtn = MovieClip(cp.getChildByName("mute"));
			muteBtn.buttonMode = true;
			muteBtn.stop();
			muteBtn.status = false;
			
			stopBtn.addEventListener( MouseEvent.CLICK, onStopClick );
			
			pauseBtn.addEventListener( MouseEvent.CLICK, onPauseClick );
			
			muteBtn.addEventListener( MouseEvent.CLICK, onMuteClick );
			
		}
		
		public function playVideo( src:String ) : void
		{
			var mediaData:MediaData = new MediaData("videos/" + src + ".flv", "title", 0, "", 383, 220);
			mediaPlayer.playMedia(mediaData);
			addEventListener(Event.ENTER_FRAME, onEnterFrame );
		}
		
		public function clearVideoPlayer() : void
		{
			mediaPlayer.reset();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame );
		}
		
		private function onEnterFrame(e:Event) : void
		{
			trace(mediaPlayer.position);
		}
		
		private function onStopClick(e:MouseEvent) : void
		{
			mediaPlayer.seek(0);
			mediaPlayer.stop();
			pauseBtn.gotoAndStop(2);
			pauseBtn.status = true;
			muteBtn.gotoAndStop(1);
			muteBtn.status = true;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame );
		}
		
		private function onPauseClick(e:MouseEvent) : void
		{
			if(!e.target.status)
			{
				mediaPlayer.pause();
				e.target.gotoAndStop(2);
				e.target.status = true;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame );
			}else{
				mediaPlayer.play();
				e.target.gotoAndStop(1);
				e.target.status = false;
				addEventListener(Event.ENTER_FRAME, onEnterFrame );
			}
		}
		
		private function onMuteClick(e:MouseEvent) : void
		{
			if(!e.target.status)
			{
				mediaPlayer.mute(true);
				e.target.gotoAndStop(2);
				e.target.status = true;
			}else{
				mediaPlayer.mute(false);
				e.target.gotoAndStop(1);
				e.target.status = false;
			}
		
		}

		
	}
}



/*



package com.eurorscg.nd.view.assets
{
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.events.MouseEvent;

	import com.eurorscg.patterns.iterator.*;
		
	import com.eurorscg.utils.media.FLVPlayer;
	import com.eurorscg.utils.media.MediaData;
	import com.eurorscg.nd.view.events.GalleryEvents;
	
	public class VideoPlayer extends Sprite
	{
		private var mediaPlayer : FLVPlayer;
		private var video       : Video;
		private var videoMask   : Sprite;
		private var arrowLeft   : Sprite;
		private var arrowRight  : Sprite;
		private var videosList  : SimpleList;
		private var iterator    : IIterator;
		private var close       : Sprite;
		private var mute        : MuteSound;
		private var playBtn     : Sprite;
		private var pauseBtn    : Sprite;
		//private var mediaDesc   : MediaDescription;
				
		/**
		 * 
		 * @param v - list of videos
		 * @param c - current video
		 * @param x - x position
		 * @param y - y position
		 * 
		 */
		/* 		
		final public function VideoPlayer(v:XMLList, c:int, x:Number, y:Number)
		{
			this.x = x;
			this.y = y;

			addChild( new Asset(Assets.bgElement, false) );
			
			videosList = new SimpleList(v);
			iterator   = videosList.createIterator();
			iterator.setCursor(c);
			
			mediaPlayer       = new FLVPlayer();
			video             = new Video(383, 220);
			mediaPlayer.video = video;

			addChild(video);
			video.x = 11;
			video.y = 36;
			
			videoMask = new Asset(Assets.videoMask, false, "", 11, 36);
			addChild(videoMask);
			
			//video.cacheAsBitmap = true;
			//videoMask.cacheAsBitmap = true;
			
			//video.mask = videoMask;
			//mediaDesc = new MediaDescription(411, 0);
			//addChild(mediaDesc);
			
			playVideo();
			
			arrowLeft = new Asset(Assets.arrow, true, "left", -5, height -4, 1, 180);
			arrowRight = new Asset(Assets.arrow, true, "right", 411, height - 30);
			arrowLeft.buttonMode = true;
			arrowRight.buttonMode = true;
			
			addChild(arrowLeft);
			addChild(arrowRight);
			
			close = new Asset(Assets.closeButton, true, "", 380, 5);
			close.buttonMode = true;
			close.addEventListener(MouseEvent.MOUSE_DOWN, removePlayer);
			addChild(close);
			
			mute = new MuteSound(90, 5);
			mute.addEventListener(MouseEvent.MOUSE_DOWN, muteSound);
			addChild(mute);
			
			playBtn = new Asset(Assets.arrow, true, "", 50, 5);
			playBtn.addEventListener(MouseEvent.MOUSE_DOWN, onPlayDown);
			addChild(playBtn);
			playBtn.buttonMode = true;
			
			pauseBtn = new Asset(Assets.videoPause, true, "", 10, 5);
			pauseBtn.addEventListener(MouseEvent.MOUSE_DOWN, onPauseDown);
			addChild(pauseBtn);
			pauseBtn.buttonMode = true;
						
			arrowLeft.addEventListener(MouseEvent.MOUSE_DOWN, onArrowDown);
			arrowRight.addEventListener(MouseEvent.MOUSE_DOWN, onArrowDown);			
			
		}
		
		public function clearVideo() : void
		{
			mediaPlayer.killPlayer();
		
		}
		
		private function playVideo() : void
		{
			var mediaData:MediaData = new MediaData("videos/" + iterator.current().@src + ".flv", "title", 0, "", 383, 220);
			mediaPlayer.playMedia(mediaData);
			//mediaDesc.setDescription(iterator.current().head, iterator.current().text);
		}
				
		private function clearVideoPlayer() : void
		{
			mediaPlayer.killPlayer();
        	mediaPlayer = null;
        	removeChild(video);
        	video = null;
		}
		
		private function onPlayDown(e:MouseEvent) : void
		{
			mediaPlayer.play(false);
		}
		
		private function onPauseDown(e:MouseEvent) : void
		{
			mediaPlayer.pause();
		}
		
		private function onArrowDown(e:MouseEvent) : void
		{
			switch(e.currentTarget.type)
        	{
        		case "left":
        			if(!iterator.hasPrevious())
					{
						iterator.last();
					}
					iterator.previous();
        			break;
        		case "right":
        			if(!iterator.hasNext())
        			{
        				iterator.reset();
        			}
        			iterator.next();
        			break;
        	}
        	playVideo();			
		}
		
		private function muteSound(e:MouseEvent) : void
		{
			e.target.setMute();
			if(e.target.mute)
				mediaPlayer.mute();
			else
				mediaPlayer.mute(false);
		}
		
		private function removePlayer(e:MouseEvent) : void
		{
			clearVideoPlayer();
			dispatchEvent(new GalleryEvents(GalleryEvents.REMOVE_VIDEO_PLAYER));
		}

	}
}
*/