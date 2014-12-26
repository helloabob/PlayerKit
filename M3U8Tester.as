package
{
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.PluginInfoResource;
	import org.osmf.media.URLResource;
	import org.osmf.net.httpstreaming.hls.HLSPluginInfo;
	
	public class M3U8Tester extends Sprite
	{
		private var mps:MediaPlayerSprite;
		private var factory:MediaFactory;
		public function M3U8Tester(){
			factory = new MediaFactory();
			factory.loadPlugin(new PluginInfoResource(new HLSPluginInfo()));
			mps=new MediaPlayerSprite();
			mps.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			addChild(mps);
			
			var url:String = "http://lms.xun-ao.com/recorded/9/104/1226/1300/playlist.m3u8";
			mps.media = factory.createMediaElement(new URLResource(url));
		}
		private function tt():void{
			var dur:Number = mps.mediaPlayer.duration;
			if(isNaN(dur)||dur==0){
				flash.utils.setTimeout(tt,1000);
			}
			trace(mps.mediaPlayer.duration);
		}
		private function onStateChange(evt:MediaPlayerStateChangeEvent):void{
			var state:String = evt.state;
			trace(state);
			if(state=="playing"){
				flash.utils.setTimeout(tt,1000);
			}
		}
	}
}