package
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class SoundImageView extends SoundRate
	{
		private var image_loader:Loader = null;
		public function SoundImageView()
		{
			super();
		}
		public override function showBar(imageUrl:String=""):void{
			if(image_loader!=null){
				image_loader.content.width = conWidth;
				image_loader.content.height = conHeight;
			}
			
			
			image_loader = new Loader();
			image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComp);
			image_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			image_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			image_loader.load(new URLRequest(imageUrl),new LoaderContext(true));
		}
		
		protected function ioErrorHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			log("ioErrorHandler");
			image_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComp);
			image_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			image_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		protected function securityErrorHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			log("securityErrorHandler");
			image_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComp);
			image_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			image_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		private function onComp(evt:Event):void{
			this.addChild(image_loader);
			image_loader.content.width = conWidth;
			image_loader.content.height = conHeight;
			image_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComp);
			image_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			image_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
	}
}