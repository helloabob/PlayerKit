package
{
	import flash.external.ExternalInterface;

	public class CutUtils
	{
		public function CutUtils()
		{
		}
		
		/**
		 * 记录打点时间
		 * @param islive 是否直播
		 * @param cid 频道id
		 * @param ts 时间戳
		 */
		public static function notifyCutInfo(islive:Boolean, cid:String, ts:String):Boolean {
			if(startTime>0&&endTime>0){
				var obj:Object = {};
				obj.start=islive?startTime:startTime.toFixed(2);
				obj.end=islive?endTime:endTime.toFixed(2);
				obj.channelid=cid;
				if(!(ts==null||ts=="null"||ts=="")){
					obj.timestamp=ts;
				}
				var str:String = JSON.stringify(obj);
				log(str);
				if(flash.external.ExternalInterface.available)flash.external.ExternalInterface.call("onSetCutInfo",str);
				startTime=0;
				endTime=0;
				return true;
			}
			return false;
		}
		
		private static function log(str:String):void{
			trace(str);
			if(flash.external.ExternalInterface.available)flash.external.ExternalInterface.call("console.log",str);
		}
		
		/**
		 * 打点开关
		 */
		public static var cutOpen:Boolean = false;
		
		/**
		 * 开始时间
		 */
		public static var startTime:Number = 0;
		
		/**
		 * 结束时间
		 */
		public static var endTime:Number = 0;
		
		/**
		 * 打点开始节点类型
		 */
		public static var TypeStart:int = 1;
		
		/**
		 * 打点结束节点类型
		 */
		public static var TypeEnd:int = 2;
		
		/**
		 * 打点js回调类型
		 */
		public static var TypeNotify:int = 3;
	}
}