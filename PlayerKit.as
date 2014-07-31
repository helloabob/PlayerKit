package
{
	import com.smgbb.SmgbbCommand;
	import com.tvie.PlayerProperties;
	import com.tvie.uisdk.PlayerPanelEx;
	import com.tvie.uisdk.UIEvent;
	import com.tvie.utilities.TVieEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.PluginInfoResource;
	import org.osmf.media.URLResource;
	import org.osmf.net.httpstreaming.hls.HLSPluginInfo;
	
	public class PlayerKit extends Sprite
	{
		private var config:Config;
		private var factory:MediaFactory;
		private var mps:MediaPlayerSprite;
		private var toolbar:SmgbbPlayPanel;
		private var callback:Function;
		private var islive:Boolean;
		public function PlayerKit()
		{
			Security.allowDomain("*");
			this.addEventListener(Event.ADDED_TO_STAGE,onStageAdded);
		}
		private function setStageAlign() : void
		{
//			stage.align = StageAlign.TOP_LEFT;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, stageResized);
//			stage.addEventListener(Event.FULLSCREEN, onFullScreenHandler);
			return;
		}// end function
		private function onStageAdded(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,onStageAdded);
			init();
		}
		private function init():void{
			config = Config.instance;
			config.Rect.x = 0;
			config.Rect.y = 0;
			config.Rect.width = stage.stageWidth;
			config.Rect.height = stage.stageHeight;
			log("width:"+config.Rect.width+"   height:"+config.Rect.height);
			factory = new MediaFactory();
			factory.loadPlugin(new PluginInfoResource(new HLSPluginInfo()));
			mps=new MediaPlayerSprite();
			mps.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			toolbar = new SmgbbPlayPanel();
			this.setStageAlign();
			this.changeElementSize();
			this.addChild(mps);
			this.addChild(toolbar);
			
			var timer:Timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER,onFrame);
			timer.start();
			
//			flash.utils.setTimeout(tt,1000);
		}
		private function onStateChange(evt:MediaPlayerStateChangeEvent):void{
			if(callback){
				callback(evt.state);
			}
		}
		override public function set width(param:Number) : void
		{
			config.Rect.width = param;
			changeElementSize();
		}
		override public function set height(param:Number) : void
		{
			config.Rect.height = param;
			changeElementSize();
		}
		
		private function onFrame(evt:TimerEvent):void{
			if(islive==false){
				if(mps.mediaPlayer.playing){
					toolbar.updateTime(mps.mediaPlayer.currentTime);
				}
			}
		}
		
		private function tt():void{
			this.sendUICommand(SmgbbCommand.UI_COMMAND_PLAY,{url:"http://lms.smgtech.net/recorded/1/0729/1620/playlist.m3u8",duration:"900",islive:"true"});
		}
		private function stageResized(evt:Event):void{
			log("stageResized");
			config.Rect.x = 0;
			config.Rect.y = 0;
			config.Rect.width = stage.stageWidth;
			config.Rect.height = stage.stageHeight;
			this.changeElementSize();
		}
		private function changeElementSize():void{
//			log("changeElementSize:"+config.Rect.width);
			mps.width = config.Rect.width;
			mps.height = config.Rect.height-16;
			toolbar.y = config.Rect.height-16;
			toolbar.width = config.Rect.width;
		}
		private function log(str:String):void{
			trace(str);
			flash.external.ExternalInterface.call("console.log",str);
		}
		public function sendUICommand(dispatchEvent:String, param:* = null) : Number
		{
			var _loc_4:Function = null;
			var _loc_5:Number = NaN;
			var _loc_6:Number = NaN;
			var _loc_7:Number = NaN;
			var _loc_8:Number = NaN;
			var _loc_3:Number = -1;
			switch(dispatchEvent)
			{
				case SmgbbCommand.UI_COMMAND_RESUME:
				{
					mps.mediaPlayer.play();
					break;
				}
				case SmgbbCommand.UI_COMMAND_PAUSE:
				{
					mps.mediaPlayer.pause();
					break;
				}
				case SmgbbCommand.UI_COMMAND_SET_SOUND:
				{
					_loc_5 = Number(param);
					mps.mediaPlayer.volume = _loc_5;
					break;
				}
				case SmgbbCommand.UI_COMMAND_GET_SOUND:
				{
					_loc_3 = mps.mediaPlayer.volume;
					break;
				}
				case SmgbbCommand.UI_COMMAND_PLAY:
				{
					log("try to play:"+param.url);
					var url:String = param.url;
					mps.media = factory.createMediaElement(new URLResource(url));
					if(param.islive=="true"){
						islive=true;
						toolbar.setDuration(-1);
					}
					else{
						islive=false;
						toolbar.setDuration(param.duration);
					}
					break;
				}
				case SmgbbCommand.UI_COMMAND_GET_PLAYINGTIME:
				{
					break;
				}
				case SmgbbCommand.UI_COMMAND_REGISTER_PLAYER_STATE:
				{
					callback = param;
					break;
				}
				case SmgbbCommand.UI_COMMAND_UNREGISTER_PLAYER_STATE:
				{
					callback=null;
					break;
				}
				default:
				{
					break;
				}
			}
			return _loc_3;
		}// end function
	}
}