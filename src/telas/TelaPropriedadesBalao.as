package telas 
{
	import componentes.Balao;
	import componentes.BotaoIcone;
	import componentes.BotaoRadio;
	import flash.events.Event;
	import flash.text.TextField;
	import recursos.Graficos;
	
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaPropriedadesBalao extends Tela 
	{
		
		private var _texto:TextField;
		
		// tipos de balão
		private var _tipo1:BotaoRadio;
		private var _tipo2:BotaoRadio;
		private var _tipo3:BotaoRadio;
		
		private var _cor1:BotaoRadio;
		private var _cor2:BotaoRadio;
		private var _cor3:BotaoRadio;
		private var _cor4:BotaoRadio;
		private var _cor5:BotaoRadio;
		
		private var _flipH:BotaoIcone;
		private var _flipV:BotaoIcone;
		private var _ok:BotaoIcone;
		
		private var _preview:Balao;
		
		
		public function TelaPropriedadesBalao(funcMudaTela:Function) 
		{
			super(funcMudaTela);
			
			// desenhar fundo usando a propriedades graphics
			
			// adicionar caixa de texto para input
			
			// adicionando grupo de radio do tipo de balão
			this._tipo1 = new BotaoRadio(Graficos.ImgBTBalao01, '1', true);
			this._tipo2 = new BotaoRadio(Graficos.ImgBTBalao02, '2');
			this._tipo3 = new BotaoRadio(Graficos.ImgBTBalao03, '3');
			
			
			
			var grupoTipoBalao:Vector.<BotaoRadio> = new Vector.<BotaoRadio>();
			grupoTipoBalao.push(this._tipo1);
			grupoTipoBalao.push(this._tipo2);
			grupoTipoBalao.push(this._tipo3);
			
			this._tipo1.grupo = this._tipo2.grupo = this._tipo3.grupo = grupoTipoBalao;
			
			// adicionando grupo de radio de cores
			
			this._cor1 = new BotaoRadio(Graficos.ImgBTCor01, '1', true);
			this._cor2 = new BotaoRadio(Graficos.ImgBTCor02, '2');
			this._cor3 = new BotaoRadio(Graficos.ImgBTCor03, '3');
			this._cor4 = new BotaoRadio(Graficos.ImgBTCor04, '4');
			this._cor5 = new BotaoRadio(Graficos.ImgBTCor05, '5');
			
			
			
			var grupoCores:Vector.<BotaoRadio> = new Vector.<BotaoRadio>();
			grupoCores.push(this._cor1);
			grupoCores.push(this._cor2);
			grupoCores.push(this._cor3);
			grupoCores.push(this._cor4);
			grupoCores.push(this._cor5);
			
			this._cor1.grupo = this._cor2.grupo = this._cor3.grupo = this._cor4.grupo = this._cor5.grupo = grupoCores;
			
			
			
		}
		
		private function cliqueCor(evento:Event):void {
			var clicado:BotaoRadio = evento.target as BotaoRadio;
			switch (clicado.valor) {
				case '1':
					break;
				case '2':
					break;
				case '3':
					break;
				case '4':
					break;
				case '5':
					break;
			}
		}
		
		private function cliqueBTipo(evento:Event):void {
			var clicado:BotaoRadio = evento.target as BotaoRadio;
			switch (clicado.valor) {
				case '1':
					break;
				case '2':
					break;
				case '3':
					break;
			}
		}
		
		override public function desenho(evento:Event = null):void 
		{
			super.desenho(evento);
			// posicionar todo mundo
			
			this._tipo1.addEventListener('marcado', cliqueBTipo);
			this._tipo2.addEventListener('marcado', cliqueBTipo);
			this._tipo3.addEventListener('marcado', cliqueBTipo);
			
			this._cor1.addEventListener('marcado', cliqueCor);
			this._cor2.addEventListener('marcado', cliqueCor);
			this._cor3.addEventListener('marcado', cliqueCor);
			this._cor4.addEventListener('marcado', cliqueCor);
			this._cor5.addEventListener('marcado', cliqueCor);
		}
		
		override public function escondendo(evento:Event):void 
		{
			super.escondendo(evento);
			// remover listeners
			
			this._tipo1.removeEventListener('marcado', cliqueBTipo);
			this._tipo2.removeEventListener('marcado', cliqueBTipo);
			this._tipo3.removeEventListener('marcado', cliqueBTipo);
			
			this._cor1.removeEventListener('marcado', cliqueCor);
			this._cor2.removeEventListener('marcado', cliqueCor);
			this._cor3.removeEventListener('marcado', cliqueCor);
			this._cor4.removeEventListener('marcado', cliqueCor);
			this._cor5.removeEventListener('marcado', cliqueCor);
		}
		
	}

}