package com.eurorscg.utils.media
{
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent; 
    import flash.events.SecurityErrorEvent;
    import flash.events.AsyncErrorEvent;  
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.media.Video;

	public class FLVPlayer extends EventDispatcher
	{

		protected var _currentMedia  :MediaData;
        protected var _stream        :NetStream;
        protected var _paused        :Boolean = false;
        protected var _playing       :Boolean = false;
        protected var _timer         :Timer  
        protected var _soundTransform:SoundTransform;
        protected var _lastVolume    :Number = 1;
        protected var _mute          :Boolean = false;       
        protected var _connection    :NetConnection;       
        protected var _mediaFinished :Boolean = false;      
        protected var _streamStatus  :Array;
        protected var _lastPos       :Number;
        protected var _video         :Video;
        
		public function set video(video:Video):void { _video = video; }
		public function get video() : Video { return _video; }       
		public function get playing() : Boolean { return _playing; }   
		public function get paused() : Boolean { return _paused; }       
		public function get currentMedia() : MediaData { return _currentMedia; }   
		public function get volume() : Number { return _lastVolume * 100; }
		
		public function get position() : Number
        {
			if(_stream != null)
				return _stream.time;
			else
				return 0;
		}

        public function get duration() : Number
		{
			if(_currentMedia != null)
			{
				return _currentMedia.duration;
			}else
				return -1;
		}
        

		public function FLVPlayer()
		{
			_soundTransform = new SoundTransform();
            _timer = new Timer(250);
            _timer.addEventListener(TimerEvent.TIMER, doMediaTime);
            _streamStatus = [];
		}
		
		public function killPlayer() : void
		{
			_timer.removeEventListener(TimerEvent.TIMER, doMediaTime);
			
			_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
            _stream.removeEventListener(NetStatusEvent.NET_STATUS, doStreamStatus);
            _stream.removeEventListener(IOErrorEvent.IO_ERROR, doIOError);
            _stream.close();
            _stream = null;
            
            _connection.removeEventListener(NetStatusEvent.NET_STATUS, doConnectionStatus);
            _connection.removeEventListener(IOErrorEvent.IO_ERROR, doIOError);
            _connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, doSecurityError);
            _connection.close();
            _connection = null;
		}
		
        public function reset() : void //na zacatek
        {
            stop();
            newStream();
        }

		protected function newStream() : void
        {
            if(_stream != null)
            {
                _stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
                //_stream.removeEventListener(NetStatusEvent.NET_STATUS, doNetStatus);
                _stream.removeEventListener(NetStatusEvent.NET_STATUS, doStreamStatus);
                _stream.removeEventListener(IOErrorEvent.IO_ERROR, doIOError);
                _stream.close();
                _stream = null;//krtz
            }

            if(_connection != null)
            {
	            //_connection.removeEventListener(NetStatusEvent.NET_STATUS, doNetStatus);
	            _connection.removeEventListener(NetStatusEvent.NET_STATUS, doConnectionStatus);
                _connection.removeEventListener(IOErrorEvent.IO_ERROR, doIOError);
                _connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, doSecurityError);
                _connection.close();
                _connection = null;//krtz
            }
			
			//nova connection
            _connection = new NetConnection();
            _connection.connect(null);
            _connection.addEventListener(NetStatusEvent.NET_STATUS, doConnectionStatus);
            _connection.addEventListener(IOErrorEvent.IO_ERROR, doIOError);
            _connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, doSecurityError);

            // novy net stream
            _stream = new NetStream(_connection);
            _stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
            _stream.addEventListener(NetStatusEvent.NET_STATUS, doStreamStatus);
            _stream.addEventListener(IOErrorEvent.IO_ERROR, doIOError);
            _stream.client = this;

            _video.attachNetStream(_stream);
            
            //krtz
            _video.width = currentMedia.width;
            _video.height = currentMedia.height;
            _video.smoothing = true;
            _video.deblocking = 4;
            //

            _stream.bufferTime = 1;//do propertie

            _stream.receiveAudio(true);
            _stream.receiveVideo(true);
        }
        
        
        public function playMedia(media:MediaData) : void
        {
            _mediaFinished = false;

            if(media == null)
            	return;

            _currentMedia = media;

            _streamStatus = [];
            
            play(true);
        }
        
        
		public function play(forced:Boolean = false) : void
        {
            if(_paused && !forced)
            {
                _stream.resume();
                _paused = false;
                _timer.start();
                return;
            }

            reset();

            _stream.play(_currentMedia.uri);

            setVolume(this._lastVolume*100);

            _playing = true;
            _paused = false;

            _timer.start();
        }
        

        public function stop() : void
        {
            if(!_playing)
            	return;
            	
            _stream.pause();
            _playing = false;
            _timer.stop();
        }

		public function pause() : void
        {
            _stream.pause();
            _paused = true;
            _timer.stop();
        }

        public function seek(seconds:Number) : void
        {   
            _lastPos = _stream.time;
            _stream.seek(seconds);
            _stream.resume();
            if (seconds <_currentMedia.duration-2 && _playing)
            {
                _lastPos = _stream.time;
                _stream.seek(seconds);
                _stream.resume();
		        //_paused = false;
            }
        }
        

		public function mute(muted:Boolean = true) : void
        {
            _mute = muted;
            if(_mute)
            {
                _soundTransform.volume = 0;
                _stream.soundTransform = _soundTransform;
            }else{
                _soundTransform.volume = _lastVolume;
                _stream.soundTransform = _soundTransform;
            }
        }

        

		public function setVolume(volume:Number) : void
        {   
            _lastVolume = _soundTransform.volume = volume/100;
            if(!_mute)
            	_stream.soundTransform = _soundTransform;                  
        }
        

		public function onMetaData(infoObject:Object) : void
        {
            if (infoObject.duration != null)
            {
                dispatchEvent(new MediaTimeEvent(MediaTimeEvent.DURATION, infoObject.duration));
                //dispatchEvent(new MediaEvent(MediaEvent.DURATION_RECEIVED, {duration:infoObject.duration}));
                //_currentMedia.duration = infoObject.duration;
            }

            var lclHeight:Number = infoObject.height;
            var lclWidth:Number = infoObject.width;
            //trace("WIDTH" + lclWidth);

            if(isNaN(lclHeight) || isNaN(lclWidth))
            {
                lclWidth = 425;
                lclHeight= 320;
            }
			
            //dispatchEvent(new MediaEvent(MediaEvent.SIZE_RECEIVED, {width:lclWidth, height:lclHeight}));
            //dispatchEvent(new MediaSizeEvent(MediaSizeEvent.SIZE, lclWidth, lclHeight));
            dispatchEvent(new MediaSizeEvent(MediaSizeEvent.SIZE, currentMedia.width, currentMedia.height));
            
			/*
			if(!willTrigger(MediaSizeEvent.SIZE))
			{
            	var yDif:Number = (_video.height - lclHeight)/2;
				_video.y += yDif;
				_video.height = lclHeight;
			}
			*/
        }

        public function doMediaTime(evt:TimerEvent) : void
        {
            var pct:Number = Math.round(_stream.bytesLoaded / _stream.bytesTotal * 100);
            dispatchEvent(new MediaTimeEvent(MediaTimeEvent.TIME, _stream.time, pct));
            //dispatchEvent(new MediaEvent(MediaEvent.TIME, {seconds:_stream.time, loaded:pct}));
        }

        protected function doSecurityError(evt:SecurityErrorEvent) : void
        {
            trace("AbstractStream.securityError");
            //dispatchEvent(new MediaEvent(MediaEvent.ERROR, {errorEvt:evt}));
            dispatchEvent(new MediaEvent(MediaEvent.ERROR, evt.text));
        }      

        protected function doIOError(evt:IOErrorEvent) : void
        {
            trace("AbstractScreem.ioError");
            //dispatchEvent(new MediaEvent(MediaEvent.ERROR, { errorEvt:evt } ));
            dispatchEvent(new MediaEvent(MediaEvent.ERROR, evt.text));
        }

        protected function doAsyncError(evt:AsyncErrorEvent) : void
        {
            trace("AsyncError");
            //dispatchEvent(new MediaEvent(MediaEvent.ERROR, {errorEvt:evt}));
            dispatchEvent(new MediaEvent(MediaEvent.ERROR, evt.text));
        }      

        protected function doStreamStatus(evt:NetStatusEvent) : void
        {
			trace("stream: " + evt.info.code);
            
            if (evt.info.code == "NetStream.Seek.InvalidTime")
            {
                _stream.seek(_lastPos);
                _stream.resume();
            }else{
                pushStatus(evt.info.code);     
                analyzeStatus();
            }
        }
        
        protected function doConnectionStatus(evt:NetStatusEvent) : void
        {
			trace("connection: " + evt.info.code);
        }

        
        protected function pushStatus(status:String) : void
        {
			_streamStatus.push(status);

            while (_streamStatus.length> 3)
  	          _streamStatus.shift();

		}

	
	    protected function analyzeStatus() : void
       	{

       		var stopIdx:Number  = _streamStatus.lastIndexOf("NetStream.Play.Stop");
 			var flushIdx:Number = _streamStatus.lastIndexOf("NetStream.Buffer.Flush");
			var emptyIdx:Number = _streamStatus.lastIndexOf("NetStream.Buffer.Empty");

            var mediaFinished:Boolean = false;

            if (stopIdx> -1 && flushIdx> -1 && emptyIdx> -1)
            {
				if(flushIdx <stopIdx && stopIdx <emptyIdx)
                {
 					mediaFinished = true;
                }
            }else if(flushIdx> -1 && emptyIdx> -1){
            	if (flushIdx <emptyIdx)
                	mediaFinished = true;
            }else if(stopIdx> -1 && flushIdx> -1){
            	mediaFinished = true;
			}

		    if (mediaFinished)
	        {      
 	        	trace("finished playing");
				dispatchEvent(new MediaEvent(MediaEvent.FINISHED_PLAYING))
 	            //dispatchEvent(new MediaEvent(MediaEvent.FINISHED_PLAYING, {}))               
                while (_streamStatus.length > 0)
			   		_streamStatus.pop();
            }else if (_streamStatus[_streamStatus.length-1] == "NetStream.Play.Start")
				dispatchEvent(new MediaEvent(MediaEvent.STARTED_PLAYING));
      	}

	}
}