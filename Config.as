package
{
	public class Config
	{
		private static var _config:Config;
		public var Rect:Object={};
		public function Config()
		{
		}
		public static function get instance():Config{
			if(_config==null)_config = new Config();
			return _config;
		}
	}
}