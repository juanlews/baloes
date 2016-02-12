package telas 
{
	import componentes.Balao;
	import componentes.BotaoIcone;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaFotoRecuperada extends Tela 
	{
		
		// botoes
		private var _propBalao:BotaoIcone;
		private var _ajusteBalao:BotaoIcone;
		private var _ajusteImagem:BotaoIcone;
		private var _salvar:BotaoIcone;
		private var _cancelar:BotaoIcone;
		
		// balão
		private var _balao: Balao;
		
		// imagem
		private var _imagem:Loader;
		private var _bmpData:BitmapData;
		
		public function TelaFotoRecuperada(funcMudaTela:Function) 
		{
			super(funcMudaTela);
			
			// criar imagem fundo
			
			// criar balão
			
			// criar botões
			
		}
		
		override public function desenho(evento:Event = null):void 
		{
			super.desenho(evento);
			
			// posicionar e dimensionar botões
			// adicionar listeners dos cliques dos botões
		}
		
		override public function escondendo(evento:Event):void 
		{
			super.escondendo(evento);
			
			// remover listeners
		}
		
		override public function recebeDados(dados:Object):void 
		{
			if (dados != null) {
				this._imagem = dados.imagem as Loader;
			}
			
			// add child _image
		}
		
		private function removeBotoes():void {
			this.removeChild(this._propBalao);
			// remove child em todos os outros botoes
		}
		
		private function cliqueSalvar(evento:MouseEvent):void {
			this.removeBotoes();
			this._bmpData = new BitmapData(stage.stageWidth, stage.stageHeight);
			this._bmpData.draw(stage);
			
			var bmpArray:ByteArray = this._bmpData.encode(new Rectangle(0, 0, this._bmpData.width, this._bmpData.height), new JPEGEncoderOptions(100));
			var bmpCache:File = File.cacheDirectory.resolvePath('bmptemp.jpg');
			var fstream:FileStream = new FileStream();
			fstream.open(bmpCache, FileMode.WRITE);
			fstream.writeBytes(bmpArray);
			fstream.close();
			
			this.mudaTela('salvar', null);
		}
	}

}