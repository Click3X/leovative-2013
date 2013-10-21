package net.ored.util{

	import flash.system.Security;
	import flash.system.Capabilities;
	import flash.net.LocalConnection;
	
	/**
	 * Environment
	 *
	 * @copyright 		2013 Clickfire Media
	 * @author			Owen Corso
	 * @version			1.1
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class Environment{
			
		public static function get IS_IN_BROWSER():Boolean {
			return (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX");
		}
	
		public static function get DOMAIN():String{
			return new LocalConnection().domain;
		}
		
		public static function get IS_LOCAL():Boolean {
			return (DOMAIN == "localhost");
		}
	
		public static function get IS_AREA51():Boolean{
			return (DOMAIN == "area51.bigspaceship.com");
		}
	
		public static function get IS_BIGSPACESHIP():Boolean{
			return(DOMAIN == "www.bigspaceship.com" || DOMAIN == "bigspaceship.com");
		}
		
		public static function get IS_IN_AIR():Boolean {
			return Capabilities.playerType == "Desktop";
		}
		public static function get IS_ON_SERVER():Boolean {
			//ds: 'remote' (Security.REMOTE) — This file is from an Internet URL and operates under domain-based sandbox rules.
			return Security.sandboxType == Security.REMOTE;
		}
	}
}