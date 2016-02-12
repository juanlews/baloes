package telas 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import componentes.BotaoIcone;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaSalvar extends Tela 
	{
		
		private var _miniatura:Bitmap;
		private var _texto:TextField;
		
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;
		
		private var _imagem:Loader;
		
		
		
		public function TelaSalvar(funcMudaTela:Function) 
		{
			super(funcMudaTela);
			
		}
		
		override public function recebeDados(dados:Object):void 
		{
			this._imagem = new Loader();
			this._imagem.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
            this._imagem.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			this._imagem.load(new URLRequest(File.cacheDirectory.resolvePath('bmptemp.jpg').url));
		}
		
	}

}