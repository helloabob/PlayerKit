package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	
	public class PlayerKitTester extends Sprite
	{
		private var vid_ld:Loader = null;
		private var tviecore:*;
		public function PlayerKitTester()
		{
			vid_ld=new Loader();
			vid_ld.load(new URLRequest("./PlayerKit.swf"));
			vid_ld.contentLoaderInfo.addEventListener(Event.COMPLETE,vidComplete);
		}
		private function vidComplete(e:Event) {//loading video completed
			vid_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE,vidComplete);
			tviecore=vid_ld.contentLoaderInfo.content as Sprite;
			addChild(tviecore);
			trace("play");
			var obj:Object = {};
//			obj.url="http://64k.kankanews.com/hls-smgvod/2014/12/15/SHDongFangHD25000002014121510608473091.m3u8";
//			obj.url="http://segment.livehls.kksmg.com/hls/dfws/index.m3u8";
//			obj.url="http://pl.youku.com/playlist/m3u8?ts=1418819698&keyframe=0&vid=XODI1NjEzMzg4&type=flv&ep=dCaVEkGMX8gJ7Svfiz8bbyngcXJcXJZ1gmaE%2F4gXSsZuH%2BzQnj3Qwg%3D%3D&sid=64188196988031285255c&token=7315&ctype=12&ev=1&oip=2059647531";
			obj.url="http://lms.csytv.com//recorded/19/122/0605/1110/livestream.m3u8";
			obj.duration=900;
			obj.islive="false";
			obj.starttime="11:10:25";
			obj.endtime="11:25:25";
			tviecore.sendUICommand("UI_COMMAND_REGISTER_PLAYER_STATE", onCallback);
			tviecore.sendUICommand("UI_COMMAND_PLAY",obj);
			
			
//			tviecore.sendUICommand("UI_COMMAND_RESUME");
		}
		private function onCallback(state:String):void{
			trace("state:"+state);
		}
	}
}