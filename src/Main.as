package
{
	import componentes.AnimacaoFrames;
	import componentes.BotaoIcone;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import telas.TelaEditBalao;
	import telas.TelaEditImagem;
	import telas.TelaFotoRecuperada;
	import telas.TelaGravacao;
	import telas.TelaInicial;
	import telas.TelaLista;
	import telas.TelaPropriedadesBalao;
	import telas.TelaSalvar;
	import telas.TelaVisualizar;
	
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class Main extends Sprite 
	{
		
		[Embed(source='./fontes/Pfennig.ttf', fontFamily='Pfennig', fontStyle='normal', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var PfennigRegular:Class;
		
		private var _telas:Array;
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			this.stage.color = 0XE8E8E8;
			// preparar as telas
			this._telas = new Array();
			this._telas['inicial'] = new TelaInicial(this.adicionaTela);
			//this._telas['lista'] = new TelaLista(this.adicionaTela);
			//this._telas['visualizar'] = new TelaVisualizar(this.adicionaTela);

			this._telas['fotorecuperada'] = new TelaFotoRecuperada(this.adicionaTela);
			this._telas['propriedadesbalao'] = new TelaPropriedadesBalao(this.adicionaTela);
			this._telas['editimagem'] = new TelaEditImagem(this.adicionaTela);

			this._telas['fotorecuperada'] = new TelaFotoRecuperada(this.adicionaTela);
			this._telas['propriedadesbalao'] = new TelaPropriedadesBalao(this.adicionaTela);
			this._telas['editimagem'] = new TelaEditImagem(this.adicionaTela);

			//this._telas['editbalao'] = new TelaEditBalao(this.adicionaTela);
			this._telas['salvar'] = new TelaSalvar(this.adicionaTela);
			//this._telas['gravacao'] = new TelaGravacao(this.adicionaTela);
			
			this.addChild(this._telas['inicial']);
			

			//this.addChild(this._telas['inicial']);
			

			/*
			var classes:Vector.<Class> = new Vector.<Class>();
			classes.push(Graficos.ImgAnimacao1);
			classes.push(Graficos.ImgAnimacao2);
			classes.push(Graficos.ImgAnimacao3);
			classes.push(Graficos.ImgAnimacao4);
			classes.push(Graficos.ImgAnimacao5);
			classes.push(Graficos.ImgAnimacao6);
			classes.push(Graficos.ImgAnimacao7);
			classes.push(Graficos.ImgAnimacao8);
			var anim:AnimacaoFrames = new AnimacaoFrames(classes, 70);
			this.addChild(anim);
			*/
		}
		
		private function adicionaTela(nome:String, dados:Object):void {
			this.removeChildren();
			
			this._telas[nome].recebeDados(dados);
			this.addChild(this._telas[nome]);
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}