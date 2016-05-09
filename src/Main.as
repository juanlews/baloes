package
{
	import colabora.display.AreaImagens;
	import colabora.display.Compartilhamento;
	import colabora.display.TelaMensagemStage;
	import colabora.oaprendizagem.servidor.Servidor;
	import colabora.oaprendizagem.servidor.Usuario;
	import componentes.AnimacaoFrames;
	import componentes.BotaoIcone;
	import flash.filesystem.File;
	import informacoes.ProjetoDados;
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.Shape;
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
	
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	
	
	
	public class Main extends Sprite 
	{
		
		
		
	    private const link:String = 'http://192.168.10.159/';	
		[Embed(source='./fontes/Pfennig.ttf', fontFamily='Pfennig', fontStyle='normal', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var PfennigRegular:Class;
		public static var projeto:ProjetoDados;
		private var _telas:Array;
		
		public function Main() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

			
			// condigurando app
			ObjetoAprendizagem.nome = 'Narrativas visuais';
			ObjetoAprendizagem.codigo = 'narvisuais';
			
			// preparando as funções de compartilhamento
			ObjetoAprendizagem.compartilhamento = new Compartilhamento(new BotaoIcone(Graficos.GRBTCompScan),
																		new BotaoIcone(Graficos.GRBTCompFechar),
																		new BotaoIcone(Graficos.GRBTCompVoltar),
																		new BotaoIcone(Graficos.GRBTCompAjuda),
																		'',
																		new BotaoIcone(Graficos.GRCompErro),
																		new BotaoIcone(Graficos.GRCompRecebido),
																		new BotaoIcone(Graficos.GRCompAguarde));
																		
														
			
			// criando área de imagem
			ObjetoAprendizagem.areaImagem = new AreaImagens(1080, 1920, 0x808080);
			
			// preparando listagem da biblioteca
			var biblio:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/biblioteca/');
			var original:File = File.applicationDirectory.resolvePath('biblioteca/');
			original.copyToAsync(biblio, true);
			
			//
			Main.projeto = new ProjetoDados();
			Main.projeto.exportarID('1460571455684');
		//	Main.projeto.titulo = 'primeiro projeto';
		//	Main.projeto.tags.push('primeiro');
		//	Main.projeto.tags.push('projeto');

			

			//Main.projeto.salvarDados();


		    //Main.projeto.salvarDados();

			// preparar as telas
			this._telas = new Array();
			this._telas['inicial'] = new TelaInicial(this.adicionaTela);
			this._telas['lista'] = new TelaLista(this.adicionaTela);
			this._telas['visualizar'] = new TelaVisualizar(this.adicionaTela);

			this._telas['fotorecuperada'] = new TelaFotoRecuperada(this.adicionaTela);
			this._telas['propriedadesbalao'] = new TelaPropriedadesBalao(this.adicionaTela);
			this._telas['editimagem'] = new TelaEditImagem(this.adicionaTela);

			this._telas['fotorecuperada'] = new TelaFotoRecuperada(this.adicionaTela);
			this._telas['propriedadesbalao'] = new TelaPropriedadesBalao(this.adicionaTela);
			this._telas['editimagem'] = new TelaEditImagem(this.adicionaTela);

			this._telas['editbalao'] = new TelaEditBalao(this.adicionaTela);
			this._telas['salvar'] = new TelaSalvar(this.adicionaTela);
			this._telas['gravacao'] = new TelaGravacao(this.adicionaTela);
			
			this.addChild(this._telas['inicial']);
			
					
		}
		
		
		private function adicionaTela(nome:String, dados:Object):void {
			this.removeChildren();			
			
			this._telas[nome].recebeDados(dados);
			
			trace('adicionando tela', nome);
			
			this.addChild(this._telas[nome]);
			
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}