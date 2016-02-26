package telas
{
	import componentes.BotaoIcone;
	import componentes.BotaoLista;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import com.adobe.crypto.MD5;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaLista extends Tela
	{
		
		private var _lista:Vector.<BotaoLista>;
		private var _total:int = 5;
		
		private var _voltar:BotaoIcone;
		private var _proximo:BotaoIcone;
		private var _anterior:BotaoIcone;
		
		//Conexão com server
		private var _request:URLRequest;
		private var _urlLoader:URLLoader;
		private var envio:URLVariables;
		
		public function TelaLista(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			_voltar = new BotaoIcone(Graficos.ImgCancelar);
			_proximo = new BotaoIcone(Graficos.ImgSetad);
			_anterior = new BotaoIcone(Graficos.ImgSetae);
			
			addChild(_voltar);
			addChild(_proximo);
			addChild(_anterior);
			
			envio = new URLVariables();
			_urlLoader = new URLLoader();
			_request = new URLRequest("http://192.168.25.159/baloes/listar.php");
			
			_request.method = 'POST';
			_urlLoader.addEventListener(Event.COMPLETE, recebeu);
			
			this._lista = new Vector.<BotaoLista>();
			for (var i:int = 0; i < this._total; i++)
			{
				this._lista.push(new BotaoLista('', Graficos.ImgBarra));
				this.addChild(this._lista[i]);
			}
			
			envio['valida'] = MD5.hash('asdfg');
			_request.data = envio;
			_urlLoader.load(_request);
		
		}
		
		private function recebeu(evento:Event):void
		{
			
			_urlLoader.removeEventListener(Event.COMPLETE, recebeu);
			
			var variaveis:URLVariables = new URLVariables(_urlLoader.data);
			
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
				else if (variaveis['erro'] == '1')
				{
					trace('pasta não encontrada no servidor');
				}
				else
				{
					var arquivos:Array = String(variaveis['lista']).split(';');
					//	trace('arquivos encontrados:');
					
					//trace("fora da funçao" + arquivos);
					
					trace('carregando: ' + 'http://192.168.25.159/baloes/gravados', arquivos);
					trace(arquivos[2] as String);
					for (var i:int = 0; i < arquivos.length; i++)
					{
						_lista[i].texto = arquivos[i] as String;
						
					}
				}
				
			}
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			trace("na desenho: ", _lista[1].texto);
			
			//desenha botoes
			
			_voltar.width = stage.stageWidth / 5;
			_voltar.scaleY = _voltar.scaleX;
			_voltar.x = stage.stageWidth / 2 - _voltar.width / 2;
			_voltar.y = stage.stageHeight - _voltar.height;
			
			_anterior.width = stage.stageWidth / 5;
			_anterior.scaleY = _anterior.scaleX;
			_anterior.y = stage.stageHeight - _voltar.height;
			
			_proximo.width = stage.stageWidth / 5;
			_proximo.scaleX = -_proximo.scaleX;
			_proximo.scaleY = _proximo.scaleX;
			_proximo.x = stage.stageWidth;
			_proximo.y = stage.stageHeight - _proximo.height;
			
			for (var i:int = 0; i < this._total; i++)
			{
				if (this._lista[i] != null)
				{
					if (!this._lista[i].hasEventListener(MouseEvent.CLICK))
					{
						this._lista[i].addEventListener(MouseEvent.CLICK, cliqueLista);
					}
					this._lista[i].width = stage.stageWidth;
					this._lista[i].scaleY = this._lista[i].scaleX;
					this._lista[i].y = _lista[i].height * i;
					
				}
			}
			
			if (!this._anterior.hasEventListener(MouseEvent.CLICK))
			{
				
				_voltar.addEventListener(MouseEvent.CLICK, cliquevoltar);
				_proximo.addEventListener(MouseEvent.CLICK, cliqueproximo);
				_anterior.addEventListener(MouseEvent.CLICK, cliqueanterior);
				
			}
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			for (var i:int = 0; i < this._total; i++)
			{
				this._lista[i].removeEventListener(MouseEvent.CLICK, cliqueLista);
			}
		
		}
		
		private function cliqueLista(evento:MouseEvent):void
		{
			var clicado:BotaoLista = evento.target as BotaoLista;
			var dados:Object = new Object;
			trace(clicado.texto);
			dados.link = clicado.texto;			
			this.mudaTela('visualizar', dados);
		
			// clicado.texto
		}
		
		private function cliquevoltar(evento:MouseEvent):void
		{
			this.mudaTela('inicial', null);
		}
		
		private function cliqueproximo(evento:MouseEvent):void
		{
		trace ('proximo');
		}
		
		private function cliqueanterior(evento:MouseEvent):void
		{
		trace('anterior')
		}
		
	
	}
}