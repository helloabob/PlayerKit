﻿package{	import com.cp.HLSMediaPlayer;		import flash.display.Sprite;	import flash.events.Event;	import flash.events.TimerEvent;	import flash.external.ExternalInterface;	import flash.system.Security;	import flash.utils.ByteArray;	import flash.utils.Timer;		import org.osmf.media.MediaFactory;	import org.osmf.media.MediaPlayerState;
		public class PlayerKit extends Sprite	{		private var config:Config;		private var factory:MediaFactory;		private var player:HLSMediaPlayer;		private var toolbar:SmgbbPlayPanel;		private var callback:Function=null;		private var islive:Boolean;		private var bufferPanel:BufferPanel;				private var cid:String="";		private var ts:String="";				private var toolPanel:CutToolPanel;		private var cut1:Number = 0;		private var cut2:Number = 0;				private var duration:Number = 0;				private var rateView:SoundRate=new SoundRate();		private var videoType:String="0";				/*打点功能 0开启  1关闭*/		private var cutVideoMode:String = "1";				public function PlayerKit()		{			Security.allowDomain("*");			this.addEventListener(Event.ADDED_TO_STAGE,onStageAdded);		}		private function setStageAlign() : void		{//			stage.align = StageAlign.TOP_LEFT;//			stage.scaleMode = StageScaleMode.NO_SCALE;			stage.addEventListener(Event.RESIZE, stageResized);//			stage.addEventListener(Event.FULLSCREEN, onFullScreenHandler);			return;		}// end function		private function onStageAdded(evt:Event):void{			this.removeEventListener(Event.ADDED_TO_STAGE,onStageAdded);			init();		}		private function getDateTime():String {			var dt:Date = new Date();			var hrs:String = dt.hours<10?("0"+dt.hours):dt.hours.toString();			var mins:String = dt.minutes<10?("0"+dt.minutes):dt.minutes.toString();			var secs:String = dt.seconds<10?("0"+dt.seconds):dt.seconds.toString();			return hrs+":"+mins+":"+secs;		}		public function onSetCut(type:int):void{			trace("onSetCut:"+type);			var now:Number = 0;			if(islive){				now = new Date().time;			}else{				now = player.currentTime;			}			if(type==1){				cut1 = now;				toolbar.setCutPoint(now,type);				toolPanel.setCutTime(true,now,islive);			}else if(type==2){				cut2 = now;				toolbar.setCutPoint(now,type);				toolPanel.setCutTime(false,now,islive);			}else{				if(cut1>0&&cut2>0){					var obj:Object = {};					obj.start=islive?cut1:cut1.toFixed(2);					obj.end=islive?cut2:cut2.toFixed(2);					obj.channelid=cid;					if(!(ts==null||ts=="null"||ts=="")){						obj.timestamp=ts;					}					var str:String = JSON.stringify(obj);					log(str);					if(flash.external.ExternalInterface.available)flash.external.ExternalInterface.call("onSetCutInfo",str);					cut1=0;					cut2=0;					toolbar.setCutPoint(0,type);					toolPanel.setCutTime(true,0);					toolPanel.setCutTime(false,0);				}			}		}		private function seekTime(rate:Number):void{			log("seek:"+rate+" dur:"+duration+" time:"+int(rate*duration));			player.seek(int(rate*duration));		}		override public function set width(param:Number) : void		{			config.Rect.width = param;			changeElementSize();		}		override public function set height(param:Number) : void		{			config.Rect.height = param;			changeElementSize();		}				private function onFrame(evt:TimerEvent):void{			if(islive==false){				if(player.playing){					toolbar.updateTime(player.currentTime);				}			}			if(videoType=="1"&&rateView!=null){				rateView.visible=true;				rateView.showBar();			}else{				rateView.visible=false;			}		}				private function tt():void{			this.sendUICommand(SmgbbCommand.UI_COMMAND_PLAY,{url:"http://lms.smgtech.net/recorded/1/0729/1620/playlist.m3u8",duration:"900",islive:"true"});		}		private function stageResized(evt:Event):void{			log("stageResized");			config.Rect.x = 0;			config.Rect.y = 0;			config.Rect.width = stage.stageWidth;			config.Rect.height = stage.stageHeight;			this.changeElementSize();		}		private function changeElementSize():void{			log("changeElementSize:"+config.Rect.width);			graphics.clear();			graphics.beginFill(0x000000,1);			graphics.drawRect(config.Rect.x,config.Rect.y,config.Rect.width,config.Rect.height);			graphics.endFill();			player.width = config.Rect.width;			player.height = config.Rect.height-16;			rateView.conWidth = config.Rect.width;			rateView.conHeight = config.Rect.height-16;			toolbar.y = config.Rect.height-16;			toolbar.width = config.Rect.width;			bufferPanel.x = config.Rect.width/2 - bufferPanel.width/2 + 10;			bufferPanel.y = config.Rect.height/2 - bufferPanel.height/2 + 10;						if(cutVideoMode=="0"){			toolPanel.x = config.Rect.width - toolPanel.width;			toolPanel.y = config.Rect.height/2 - toolPanel.height/2;			}		}		private function log(str:String):void{			trace(str);			if(flash.external.ExternalInterface.available)flash.external.ExternalInterface.call("console.log",str);		}		public function sendUICommand(dispatchEvent:String, param:* = null) : Number		{			var _loc_4:Function = null;			var _loc_5:Number = NaN;			var _loc_6:Number = NaN;			var _loc_7:Number = NaN;			var _loc_8:Number = NaN;			var _loc_3:Number = -1;			switch(dispatchEvent)			{				case SmgbbCommand.UI_COMMAND_RESUME:				{					player.play();					break;				}				case SmgbbCommand.UI_COMMAND_PAUSE:				{					player.pause();					break;				}				case SmgbbCommand.UI_COMMAND_SET_SOUND:				{					_loc_5 = Number(param);					player.volume = _loc_5;					break;				}				case SmgbbCommand.UI_COMMAND_GET_SOUND:				{					_loc_3 = player.volume;					break;				}				case SmgbbCommand.UI_COMMAND_PLAY:				{					log("try to play:"+param.url);					var url:String = param.url;					cid=param.cid;					ts=param.ts;					videoType=param.videotype;					player.mediaResourceURL = url;					if(param.islive=="true"){						islive=true;						duration = -1;						toolbar.setDuration(-1);					}					else{						islive=false;						duration = param.duration;						toolbar.setDuration(param.duration);					}					if(cutVideoMode=="0"){					cut1=0;					cut2=0;					toolPanel.setCutTime(true,0);					toolPanel.setCutTime(false,0);					}					break;				}				case SmgbbCommand.UI_COMMAND_GET_PLAYINGTIME:				{					break;				}				case SmgbbCommand.UI_COMMAND_REGISTER_PLAYER_STATE:				{					callback = param;					break;				}				case SmgbbCommand.UI_COMMAND_UNREGISTER_PLAYER_STATE:				{					callback=null;					break;				}				default:				{					break;				}			}			return _loc_3;		}// end function		private function init():void{			Security.allowDomain("*");			config = Config.instance;			config.Rect.x = 0;			config.Rect.y = 0;			config.Rect.width = stage.stageWidth;			config.Rect.height = stage.stageHeight;			log("width:"+config.Rect.width+"   height:"+config.Rect.height);			player = new HLSMediaPlayer(onStateChange);			toolbar = new SmgbbPlayPanel();			toolbar.seekFunc=seekTime;			bufferPanel = new BufferPanel();			bufferPanel.visible = false;						/**/			if(cutVideoMode=="0"){			toolPanel = new CutToolPanel();			toolPanel.x = config.Rect.width - toolPanel.width;			toolPanel.y = config.Rect.height/2 - toolPanel.height/2;			}									this.setStageAlign();			this.changeElementSize();			this.addChild(player);			this.addChild(rateView);			this.addChild(toolbar);			this.addChild(bufferPanel);						if(cutVideoMode=="0"){			this.addChild(toolPanel);			}												var timer:Timer = new Timer(500);			timer.addEventListener(TimerEvent.TIMER,onFrame);			timer.start();						//			flash.utils.setTimeout(tt,1000);						/*test case*///			log("start...");//			var obj:Object = {};//			obj.url = "http://hls.kksmg.com/iphone/downloads/ch1/index.m3u8";//			obj.duration=3580;//			obj.islive="true";//			obj.cid="123123";//			obj.ts="111333";//			sendUICommand(SmgbbCommand.UI_COMMAND_PLAY,obj);//			player.volume = 1;//			log("end...");			/*end*/		}		private function onStateChange(evt:*):void{			if(evt.state == MediaPlayerState.PLAYING){				bufferPanel.visible = false;			}else{				bufferPanel.visible = true;			}			if(callback!=null){				callback.apply(null,[evt.state]);			}		}	}}