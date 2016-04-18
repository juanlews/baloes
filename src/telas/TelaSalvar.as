package telas
{
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
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
	import flash.ui.Mouse;
	import informacoes.ProjetoDados;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaSalvar extends Tela
	{
		
		private const link:String = 'http://192.168.10.159/';
		private var _caixaTitulo:TxBox;
		private var _caixaTags:TxBox;
		
		private var _miniatura:Bitmap;
		
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;
		
		private var _imagem:Loader;
		
		private var _fileup:File = new File();
		private var _urlLoader:URLLoader;
		private var _request:URLRequest;
		private var anim:AnimacaoFrames;
	
		private var btscala:Number;
		
		//
		private var _btEditT:BotaoIcone;
		private var _btEditF:BotaoIcone;
		
		public function TelaSalvar(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			btscala = 10;
			_caixaTitulo = new TxBox();
			_caixaTags = new TxBox();
			
			_ok = new BotaoIcone(Graficos.ImgPBOK);
			_cancelar = new BotaoIcone(Graficos.ImgCancelar);
			_btEditT = new BotaoIcone (Graficos.ImgCheckT);
			_btEditF = new BotaoIcone (Graficos.ImgCheck);
			
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
			_request = new URLRequest(link + "baloes/confirmaEnvio.php");
			_request.method = 'POST';
			var variaveis:URLVariables = new URLVariables();
			variaveis['nome'] = _caixaTitulo.text;
			variaveis['valida'] = MD5.hash('asdfg' + variaveis['nome']);
			_request.data = variaveis;
			
			_urlLoader.addEventListener(Event.COMPLETE, arquivoConfirmado);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, erroNoEnvio);
			_urlLoader.load(_request);
		
		}
		
		private function arquivoConfirmado(evento:Event):void
		{
			
			trace('no arquivo confirmado');
			
			_urlLoader.removeEventListener(Event.COMPLETE, arquivoConfirmado);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, erroNoEnvio);
			
			var variaveis:URLVariables;
			var varOK:Boolean = true;
			try
			{
				variaveis = new URLVariables(_urlLoader.data);
			}
			catch (e:Error)
			{
				varOK = false;
			}
			
			if (varOK)
			{
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
						if (variaveis['resultado'] == null)
						{
							trace('resposta do servidor mal formatada');
						}
						else
						{
							if (variaveis['resultado'] == '0')
							{
								trace('a imagem não foi gravada');
							}
							else
							{
								trace('gravação ok');
								this.mudaTela('inicial', null);
								
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
			this._imagem.load(new URLRequest(File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + Main.projeto.id + '/capa.jpg').url));
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
					
			_imagem.x = stage.stageWidth / 20;
			_imagem.y = linhacima.height + linhacima.height / 10;
			_imagem.width = stage.stageWidth / 4;
			_imagem.scaleY = _imagem.scaleX;
			
			//
			_btEditF.x = _imagem.x + stage.stageWidth / 20;
			_btEditF.y = _imagem.y + linhacima.height + linhacima.height / 10;
			//titulo
			
			
			_caixaTitulo.width = stage.stageWidth / 1.5;
			_caixaTitulo.height = stage.stageHeight / 20;
			_caixaTitulo.x = stage.stageWidth / 2 - _caixaTitulo.width / 2;
			_caixaTitulo.y = stage.stageHeight / 2 - _caixaTitulo.height / 2;
			//tags
			_caixaTags.width = stage.stageWidth / 1.5;
			_caixaTags.height = stage.stageHeight / 20;
			_caixaTags.x = _caixaTitulo.x
			_caixaTags.y = _caixaTitulo.y + _caixaTitulo.height + stage.stageWidth / 10;
			
			//botão salvar			
			this._ok.width = stage.stageWidth / btscala;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth / 20;
			this._ok.y = stage.stageHeight - this._ok.width - stage.stageHeight / 40;
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / btscala;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth - _cancelar.width - stage.stageWidth / 20;
			this._cancelar.y = stage.stageHeight - this._cancelar.height - stage.stageHeight / 40;
			
			if (!_ok.hasEventListener(MouseEvent.CLICK))
			{
				addChild(_caixaTags);
				addChild(_caixaTitulo);
				addChild(_ok);
				addChild(_cancelar);
				addChild(_btEditF);
				_ok.addEventListener(MouseEvent.CLICK, salvaProjeto);
				_cancelar.addEventListener(MouseEvent.CLICK, volta);
				
			}
		
		}
		
		private function salvaProjeto(evento:MouseEvent):void
		{
			addChild(anim);
			Main.projeto.titulo = this._caixaTitulo.text;
			Main.projeto.tags = this._caixaTags.text.split('#');
			
			trace(Main.projeto.titulo, Main.projeto.tags);
			
			if (Main.projeto.salvarDados())
			{
				var dados:Object = new Object;
				dados.id = Main.projeto.id;
				trace('projeto salvo');
				mudaTela('inicial', dados);
			}
		}
		
		private function salvaImg(evento:MouseEvent):void
		{
			trace(_caixaTitulo.text);
			
			_request = new URLRequest(link + "baloes/salvar.php");
			_request.method = 'POST';
			
			var variaveis:URLVariables = new URLVariables();
			variaveis['nome'] = _caixaTitulo.text;
			variaveis['valida'] = MD5.hash('asdfg' + variaveis['nome']);
			removeChildren();
			anim.width = stage.stageWidth / 2;
			anim.scaleY = anim.scaleX;
			anim.x = stage.stageWidth / 2 - anim.width / 2;
			anim.y = stage.stageHeight / 2 - anim.height / 2;
			
			addChild(anim);
			
			_request.data = variaveis;
			
			_fileup = File.cacheDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + Main.projeto.id);
			
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
			
			if (_fileup.hasEventListener(Event.COMPLETE) || _fileup.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				_fileup.removeEventListener(Event.COMPLETE, arquivoEnviado);
				_fileup.removeEventListener(IOErrorEvent.IO_ERROR, erroNoEnvio);
				
			}
			
			if (anim.stage != null)
			{
				removeChild(anim);
			}
			stage.removeEventListener(Event.RESIZE, desenho);
			_ok.removeEventListener(MouseEvent.CLICK, salvaImg);
			_cancelar.removeEventListener(MouseEvent.CLICK, volta);
		
		}
	
	}
}