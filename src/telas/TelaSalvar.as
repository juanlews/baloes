package telas
{
	import com.adobe.crypto.MD5;
	import componentes.AnimacaoFrames;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import componentes.BotaoIcone;
	import componentes.TxBox;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaSalvar extends Tela
	{
		private var _caixa:TxBox;
		
		private var _miniatura:Bitmap;
		
		
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;
		
		private var _imagem:Loader;
		
		private var _fileup:File;
		private var _urlLoader:URLLoader;
		private var _request:URLRequest;
		private	var anim:AnimacaoFrames;
		public function TelaSalvar(funcMudaTela:Function)
		{
			super(funcMudaTela);
			_caixa = new TxBox();
			_ok = new BotaoIcone(Graficos.ImgPBOK);
			_cancelar = new BotaoIcone(Graficos.ImgCancelar);
			
			var classes:Vector.<Class> = new Vector.<Class>();
			classes.push(Graficos.ImgAnimacao1);
			classes.push(Graficos.ImgAnimacao2);
			classes.push(Graficos.ImgAnimacao3);
			classes.push(Graficos.ImgAnimacao4);
			classes.push(Graficos.ImgAnimacao5);
			classes.push(Graficos.ImgAnimacao6);
			classes.push(Graficos.ImgAnimacao7);
			classes.push(Graficos.ImgAnimacao8);
		    anim = new AnimacaoFrames(classes, 40);
			
		
		}
		
		private function arquivoEnviado(evento:Event):void
		{
			
			trace('no arquivo enviado');
			
			_urlLoader = new URLLoader();
			_request = new URLRequest("http://192.168.25.159/baloes/confirmaEnvio.php");
			_request.method = 'POST';
			var variaveis:URLVariables = new URLVariables();
			variaveis['nome'] = _caixa.text;			
			variaveis['valida'] = MD5.hash('asdfg' + variaveis['nome']);
			_request.data = variaveis;
			
			_urlLoader.addEventListener(Event.COMPLETE, arquivoConfirmado);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, erroNoEnvio);
			_urlLoader.load(_request);
		
		}
		
		private function arquivoConfirmado(evento:Event):void {
			
			trace ('no arquivo confirmado');
			
			_urlLoader.removeEventListener(Event.COMPLETE, arquivoConfirmado);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, erroNoEnvio);
			
			var variaveis:URLVariables;
			var varOK:Boolean = true;
			try {
				variaveis = new URLVariables(_urlLoader.data);
			} catch (e:Error) {
				varOK = false;
			}
			
			if (varOK) {
				if (variaveis['erro'] == null)
				{
					trace('resposta do servidor mal formatada');
				}
				else
				{
					if (variaveis['erro'] == '-1')
					{
						trace('erro de validação no servidor');
					}
					else
					{
						if (variaveis['resultado'] == null) {
							trace('resposta do servidor mal formatada');
						}
						else
						{
							if (variaveis['resultado'] == '0') {
								trace ('a imagem não foi gravada');
							} else {
								trace ('gravação ok');
							}
						}
					}
					
				}
			}
		}
		
		private function imagemCarregada(evento:Event):void
		{
			trace('carregou');
			addChild(_imagem);
			desenho();
		
		}
		
		private function imagemErro(evento:IOError):void
		{
			
			trace('Erro');
		}
		
		override public function recebeDados(dados:Object):void
		{
			
			this._imagem = new Loader();
			this._imagem.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			this._imagem.load(new URLRequest(File.cacheDirectory.resolvePath('bmptemp.jpg').url));
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			_imagem.x = 0;
			_imagem.y = 0;
			_imagem.width = stage.stageWidth / 4;
			_imagem.scaleY = _imagem.scaleX;
			_caixa.width = stage.stageWidth / 1.5;
			_caixa.height = stage.stageHeight / 10;
			_caixa.x = stage.stageWidth / 2 - _caixa.width / 2;
			_caixa.y = stage.stageHeight / 2 - _caixa.height / 2;
			
			//botão salvar			
			this._ok.width = stage.stageWidth / 6;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth / 8;
			this._ok.y = stage.stageHeight - this._ok.width;
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / 6;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth / 1.4;
			this._cancelar.y = stage.stageHeight - this._cancelar.height;
			
			addChild(_caixa);
			addChild(_ok);
			addChild(_cancelar);
			
			if (!_ok.hasEventListener(MouseEvent.CLICK))
			{
				
				_ok.addEventListener(MouseEvent.CLICK, salvaImg);
				_cancelar.addEventListener(MouseEvent.CLICK, volta);
				
			}
		
		}
		
		private function salvaImg(evento:MouseEvent):void
		{
			trace(_caixa.text);
			_request = new URLRequest("http://192.168.25.159/baloes/salvar.php");
			_request.method = 'POST';
			
			var variaveis:URLVariables = new URLVariables();
			variaveis['nome'] = _caixa.text;			
			variaveis['valida'] = MD5.hash('asdfg' + variaveis['nome']);
			removeChildren();
			anim.width = stage.stageWidth / 2;
			anim.scaleY = anim.scaleX;
			anim.x = stage.stageWidth / 2 - anim.width / 2;
			anim.y = stage.stageHeight / 2 - anim.height / 2;
			
			addChild(anim);
			
			_request.data = variaveis;			
			_fileup = File.cacheDirectory.resolvePath('bmptemp.jpg');
			
			_fileup.addEventListener(Event.COMPLETE, arquivoEnviado);
			_fileup.addEventListener(IOErrorEvent.IO_ERROR, erroNoEnvio);
			_fileup.upload(_request);
			
			
		
		}
		
		private function erroNoEnvio(evento:IOErrorEvent):void
		{
			trace('erro no envio');
		}
		
		private function volta(evento:MouseEvent):void
		{
			mudaTela('fotorecuperada', null);
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			stage.removeEventListener(Event.RESIZE, desenho);
		
		}
	
	}
}