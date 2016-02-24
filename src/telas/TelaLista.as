package telas
{
	import componentes.BotaoIcone;
	import componentes.BotaoLista;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	
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
		private var _urlLoader:URLLoader;
		private var envio:URLVariables;
	
		
		public function TelaLista(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			envio = new URLVariables();			
			_urlLoader = new URLLoader();
			_request = new URLRequest("http://192.168.25.159/baloes/listar.php");
			
			_request.method = 'POST';
			_urlLoader.addEventListener(Event.COMPLETE, recebeu);
			
			_botoes = new Botoes();
			this._lista = new Vector.<BotaoLista>();
			for (var i:int = 0; i < this._total; i++)
			{
				this._lista.push(new BotaoLista(''));
				this.addChild(this._lista[i]);
			}
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			for (var i:int = 0; i < this._total; i++)
			{
				this._lista[i].addEventListener(MouseEvent.CLICK, cliqueLista);
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
		
			// clicado.texto
		}
	
	}

}