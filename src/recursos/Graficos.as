package recursos
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class Graficos
	{
		
		// tela inicial
		[Embed(source = "imagens/btnGaleria.png")]
		public static var ImgGaleria:Class;
		[Embed(source = "imagens/btnCamera.png")]
		public static var ImgCamera:Class;
		[Embed(source = "imagens/btnCarregar.png")]
		public static var ImgCarregar:Class;
		[Embed(source = "imagens/Open.png")]
		public static var ImgOpenFile:Class;
		[Embed(source = "imagens/BTArquivos.png")]
		public static var ImgArquivos:Class;
		[Embed(source = "imagens/BTReceber.png")]
		public static var ImgReceber:Class;
		
		[Embed(source = "imagens/BTBiblioteca.png")]
		public static var ImgBiblioteca:Class;
		[Embed(source = "imagens/BTCompartilhar.png")]
		public static var ImgCompartilhar:Class;
		[Embed(source = "imagens/BTExportarImagem.png")]
		public static var ImgExportarImagem:Class;
		
		// tela foto recuperada
		//[Embed(source = "imagens/btnConfigBalao.png")]
		//public static var ImgPropBalao:Class;
		[Embed(source = "imagens/btnExpandir.png")]
		public static var ImgAjusteBalao:Class;
		[Embed(source = "imagens/btnEditImagem.png")]
		public static var ImgAjusteImagem:Class;
		[Embed(source = "imagens/btnCerto.png")]
		public static var ImgSalvar:Class;
		[Embed(source = "imagens/btnCancela.png")]
		public static var ImgCancelar:Class;
		
		// help
		[Embed(source = "imagens/textohelp1.png")]
		public static var ImgHelp01:Class;
		[Embed(source = "imagens/textohelp2.png")]
		public static var ImgHelp02:Class;
		[Embed(source = "imagens/textohelp3.1.png")]
		public static var ImgHelp03:Class;
		
		[Embed(source = "imagens/zoom_out.png")]
		public static var ImgZoomOut:Class;
		[Embed(source = "imagens/zoom_in.png")]
		public static var ImgZoomIn:Class;
		[Embed(source = "imagens/rotacionarDireita.png")]
		public static var rotacaoDireita:Class;
		[Embed(source = "imagens/rotacionarEsquerda.png")]
		public static var rotacaoEsquerda:Class;
		// add balão	
		//
		[Embed(source = "imagens/barra.png")]
		public static var ImgBarra:Class;
		// add balão
		[Embed(source = "imagens/addBalao.png")]
		public static var ImgAddBalao:Class;
		//excluir balão
		[Embed(source = "imagens/btnExcluir.png")]
		public static var ImgExcluiBalao:Class;
		//botão info 
		[Embed(source = "imagens/btnInformacao.png")]
		public static var ImgBtInfo:Class;
		
		//
		[Embed(source = "imagens/btnCancelarVermelho.png")]
		public static var excImagem:Class;
		
		// balao
		[Embed(source = "imagens/btnBalaoNuvem.png")]
		public static var ImgBalao01:Class;
		[Embed(source = "imagens/btnBalaoPensamento.png")]
		public static var ImgBalao02:Class;
		[Embed(source = "imagens/btnBalaoRect.png")]
		public static var ImgBalao03:Class;
		[Embed(source = "imagens/btnBalaoGrito.png")]
		public static var ImgBalao10:Class;
		//
		[Embed(source = "imagens/btnBalaoNuvemSemBorda.png")]
		public static var ImgBalao04:Class;
		[Embed(source = "imagens/btnBalaoPensamentoSemBorda.png")]
		public static var ImgBalao05:Class;
		[Embed(source = "imagens/btnBalaoRectSemBorda.png")]
		public static var ImgBalao06:Class;
		[Embed(source = "imagens/btnBalaoGritoSemBorda.png")]
		public static var ImgBalao11:Class;
		//
		[Embed(source = "imagens/btnBalaoNuvemPreto.png")]
		public static var ImgBalao07:Class;
		[Embed(source = "imagens/btnBalaoPensamentoPreto.png")]
		public static var ImgBalao08:Class;
		[Embed(source = "imagens/btnBalaoRectPreto.png")]
		public static var ImgBalao09:Class;
		[Embed(source = "imagens/btnBalaoGritoPreto.png")]
		public static var ImgBalao12:Class;
		
		// botoes tipo de balão
		[Embed(source = "imagens/btnBalaoNuvem.png")]
		public static var ImgBTBalao01:Class;
		[Embed(source = "imagens/btnBalaoPensamento.png")]
		public static var ImgBTBalao02:Class;
		[Embed(source = "imagens/btnBalaoRect.png")]
		public static var ImgBTBalao03:Class;
		[Embed(source = "imagens/btnBalaoGrito.png")]
		public static var ImgBTBalao11:Class;
		
		// botoes cor
		[Embed(source = "imagens/btnCor0xFF0000.png")]
		public static var ImgBTCor01:Class;
		[Embed(source = "imagens/btnCor0x3FA9F5.png")]
		public static var ImgBTCor02:Class;
		[Embed(source = "imagens/btnCor0x999999.png")]
		public static var ImgBTCor03:Class;
		[Embed(source = "imagens/btnCor0xCCCCCC.png")]
		public static var ImgBTCor04:Class;
		[Embed(source = "imagens/btnCor0xFFFFFF.png")]
		public static var ImgBTCor05:Class;
		
		// fundo preview propriedades
		[Embed(source = "imagens/Help.png")]
		public static var ImgHelp:Class;
		
		//Botão nova pagina
		[Embed(source = "imagens/novaPagina.png")]
		public static var ImgNovaPagina:Class;
		
		//Setas
		[Embed(source = "imagens/SetaEsq.png")]
		public static var ImgSetaEsq:Class;
		
		[Embed(source = "imagens/SetaDir.png")]
		public static var ImgSetaDir:Class;
		
		[Embed(source = "imagens/SetaEsq.png")]
		public static var ImgSetae:Class;
		
		[Embed(source = "imagens/SetaDir.png")]
		public static var ImgSetad:Class;
		
		[Embed(source = "imagens/BTExpandir.png")]
		public static var ImgAmpliar:Class;
		
		[Embed(source = "imagens/BTRecolher.png")]
		public static var ImgRecolher:Class;
		
		// botoes propriedades do balão
		[Embed(source = "imagens/btnFlipVertical.png")]
		public static var ImgPBFlipV:Class;
		[Embed(source = "imagens/btnFlip.png")]
		public static var ImgPBFlipH:Class;
		[Embed(source = "imagens/btnCerto.png")]
		public static var ImgPBOK:Class;
		[Embed(source = "imagens/btnCheckSmooth.png")]
		public static var ImgCheck:Class;
		[Embed(source = "imagens/btnCheckSmoothTrue.png")]
		public static var ImgCheckT:Class;
		[Embed(source = "imagens/lixeira.png")]
		public static var ImgLixeira:Class;
		
		// animação salva
		[Embed(source = "imagens/quadro1.png")]
		public static var ImgAnimacao1:Class;
		[Embed(source = "imagens/quadro2.png")]
		public static var ImgAnimacao2:Class;
		[Embed(source = "imagens/quadro3.png")]
		public static var ImgAnimacao3:Class;
		[Embed(source = "imagens/quadro4.png")]
		public static var ImgAnimacao4:Class;
		[Embed(source = "imagens/quadro5.png")]
		public static var ImgAnimacao5:Class;
		[Embed(source = "imagens/quadro6.png")]
		public static var ImgAnimacao6:Class;
		[Embed(source = "imagens/quadro7.png")]
		public static var ImgAnimacao7:Class;
		[Embed(source = "imagens/quadro8.png")]
		public static var ImgAnimacao8:Class;
		
		// telas de compartilhamento
		[Embed(source = "imagens/BTCompAjuda.png")]
		public static var GRBTCompAjuda:Class;
		[Embed(source = "imagens/BTCompFechar.png")]
		public static var GRBTCompFechar:Class;
		[Embed(source = "imagens/BTCompScan.png")]
		public static var GRBTCompScan:Class;
		[Embed(source = "imagens/BTCompVoltar.png")]
		public static var GRBTCompVoltar:Class;
		[Embed(source = "imagens/telaAguarde.png")]
		public static var GRCompAguarde:Class;
		[Embed(source = "imagens/telaArquivoRecebido.png")]
		public static var GRCompRecebido:Class;
		[Embed(source = "imagens/telaErro.png")]
		public static var GRCompErro:Class;
		
		//Splash
		[Embed(source = "imagens/Splash/Colabora-950x446.jpg")]
		public static var Colabora:Class;
		[Embed(source = "imagens/Splash/Plug.jpg")]
		public static var Plug:Class;
		[Embed(source = "imagens/Splash/AIC.jpg")]
		public static var AIC:Class;
		
		[Embed(source = "imagens/Splash/Splash.png")]
		public static var Splash:Class;
		
		
		
		
		public function Graficos()
		{
		
		}
	
		
			public function getGR(nome:String):Bitmap
		{
			var bmp:Bitmap;
			switch (nome) {
	/*			case 'AreaVazia': bmp = new GRAreaVazia() as Bitmap; break;
				case 'AreaCheia1': bmp = new GRAreaCheia1() as Bitmap; break;
				case 'AreaCheiaInicio': bmp = new GRAreaCheiaInicio() as Bitmap; break;
				case 'AreaCheiaMeio': bmp = new GRAreaCheiaMeio() as Bitmap; break;
				case 'AreaCheiaFim': bmp = new GRAreaCheiaFim() as Bitmap; break;
				case 'FundoTrilhas': bmp = new GRFundoTrilhas() as Bitmap; break;
				case 'BTAvancar': bmp = new GRBTAvancar() as Bitmap; break;
				case 'BTAvancar10': bmp = new GRBTAvancar10() as Bitmap; break;
				case 'BTVoltar': bmp = new GRBTVoltar() as Bitmap; break;
				case 'BTVoltar10': bmp = new GRBTVoltar10() as Bitmap; break;
				case 'BTInicio': bmp = new GRBTInicio() as Bitmap; break;
				case 'BTPlay': bmp = new GRBTPlay() as Bitmap; break;
				case 'BTPause': bmp = new GRBTPause() as Bitmap; break;
				case 'BTStop': bmp = new GRBTStop() as Bitmap; break;
				case 'BTCompAjuda': bmp = new GRBTCompAjuda() as Bitmap; break;
				case 'BTCompFechar': bmp = new GRBTCompFechar() as Bitmap; break;
				case 'BTCompScan': bmp = new GRBTCompScan() as Bitmap; break;
				case 'BTCompVoltar': bmp = new GRBTCompVoltar() as Bitmap; break;
				case 'MensagemErroDownload': bmp = new GRMensagemErroDownload() as Bitmap; break;
				case 'MensagemSucessoDownload': bmp = new GRMensagemSucessoDownload() as Bitmap; break;
				case 'MensagemAguardeDownload': bmp = new GRMensagemAguardeDownload() as Bitmap; break;
				case 'BTAbrir': bmp = new GRBTAbrir() as Bitmap; break;
				case 'BTAjuda': bmp = new GRBTAjuda() as Bitmap; break;
				case 'BTArquivos': bmp = new GRBTArquivos() as Bitmap; break;
				case 'BTCompartilhar': bmp = new GRBTCompartilhar() as Bitmap; break;
				case 'BTInfo': bmp = new GRBTInfo() as Bitmap; break;
				case 'BTMixer': bmp = new GRBTMixer() as Bitmap; break;
				case 'BTNovo': bmp = new GRBTNovo() as Bitmap; break;
				case 'BTSalvar': bmp = new GRBTSalvar() as Bitmap; break;
				case 'BTReceber': bmp = new GRBTReceber() as Bitmap; break;
				case 'BTOk': bmp = new GRBTOk() as Bitmap; break;
				case 'BTCancel': bmp = new GRBTCancel() as Bitmap; break;
				case 'BTLixeira': bmp = new GRBTLixeira() as Bitmap; break;
				case 'FundoJanela': bmp = new GRFundoJanela() as Bitmap; break;
				case 'BTBiblioteca': bmp = new GRBTBiblioteca() as Bitmap; break;
				case 'BTMeusAudios': bmp = new GRBTMeusAudios() as Bitmap; break;
				case 'BTBibliotecaIm': bmp = new GRBTBibliotecaIm() as Bitmap; break;
				case 'BTMinhasImagens': bmp = new GRBTMinhasImagens() as Bitmap; break;
				case 'BTTexto': bmp = new GRBTTexto() as Bitmap; break;
				case 'BTAbrirMp3': bmp = new GRBTAbrirMp3() as Bitmap; break;
				case 'BTGravarMp3': bmp = new GRBTGravarMp3() as Bitmap; break;
				case 'AreaTextoNome': bmp = new GRAreaTextoNome() as Bitmap; break;
				case 'AreaTextoId': bmp = new GRAreaTextoId() as Bitmap; break;
				case 'AreaTextoSobre': bmp = new GRAreaTextoSobre() as Bitmap; break;
				case 'AreaTextoTexto': bmp = new GRAreaTextoTexto() as Bitmap; break;
				case 'AreaTextoLink': bmp = new GRAreaTextoLink() as Bitmap; break;
				case 'AreaVolume': bmp = new GRAreaVolume() as Bitmap; break;
				case 'BTVolume': bmp = new GRBTVolume() as Bitmap; break;
				case 'BTMicrofoneGrande': bmp = new GRBTMicrofoneGrande() as Bitmap; break;
				case 'MensagemGravandoAudio': bmp = new GRMensagemGravandoAudio() as Bitmap; break;
				case 'MensagemProcessandoAudio': bmp = new GRMensagemProcessandoAudio() as Bitmap; break;
				case 'SobreID': bmp = new GRSobreID() as Bitmap; break;
				case 'BTMais': bmp = new GRBTMais() as Bitmap; break;
				case 'BTFontePfennig': bmp = new GRBTFontePfennig() as Bitmap; break;
				case 'BTFonteAveria': bmp = new GRBTFonteAveria() as Bitmap; break;
				case 'BTFonteGamaliel': bmp = new GRBTFonteGamaliel() as Bitmap; break;
				case 'BTFonteCodeRoman': bmp = new GRBTFonteCodeRoman() as Bitmap; break;
				case 'BTPropMais': bmp = new GRBTPropMais() as Bitmap; break;
				case 'BTPropMenos': bmp = new GRBTPropMenos() as Bitmap; break;
				case 'PropTamanho': bmp = new GRPropTamanho() as Bitmap; break;
				case 'PropRotacao': bmp = new GRPropRotacao() as Bitmap; break;
				case 'PropVermelho': bmp = new GRPropVermelho() as Bitmap; break;
				case 'PropVerde': bmp = new GRPropVerde() as Bitmap; break;
				case 'PropAzul': bmp = new GRPropAzul() as Bitmap; break;
				case 'PropOrdem': bmp = new GRPropOrdem() as Bitmap; break;
				case 'BTLink': bmp = new GRBTLink() as Bitmap; break;
				case 'BTMaisPagina': bmp = new GRBTMaisPagina() as Bitmap; break;
				case 'BTMenosPagina': bmp = new GRBTMenosPagina() as Bitmap; break;
				case 'BTPaginaAnterior': bmp = new GRBTPaginaAnterior() as Bitmap; break;
				case 'BTPaginaProxima': bmp = new GRBTPaginaProxima() as Bitmap; break;
				case 'BTResetImagem': bmp = new GRBTResetImagem() as Bitmap; break;
				case 'BTEditaTexto': bmp = new GRBTEditaTexto() as Bitmap; break;
				case 'BTApresentar': bmp = new GRBTApresentar() as Bitmap; break;
				case 'BTExportarImagem': bmp = new GRBTExportarImagem() as Bitmap; break;
				case 'BTTelaCheia': bmp = new GRBTTelaCheia() as Bitmap; break;
				case 'BTManagana': bmp = new GRBTManagana() as Bitmap; break;
				case 'BTEsquerda': bmp = new GRBTEsquerda() as Bitmap; break;
				case 'BTDireita': bmp = new GRBTDireita() as Bitmap; break;
				case 'BTFechar': bmp = new GRBTFechar() as Bitmap; break;
				
				case 'HELP01': bmp = new HELP01() as Bitmap; break;
				case 'HELP02': bmp = new HELP02() as Bitmap; break;
				case 'HELP03': bmp = new HELP03() as Bitmap; break;
				case 'HELP04': bmp = new HELP04() as Bitmap; break;
				case 'BTHelp2': bmp = new GRBTHelp2() as Bitmap; break;
				case 'BTHelp3': bmp = new GRBTHelp3() as Bitmap; break;
				*/
				case 'Splash': bmp = new Colabora() as Bitmap; break;
				case 'Splash2': bmp = new AIC() as Bitmap; break;
				case 'Splash3': bmp = new Plug() as Bitmap; break;
				
			}
			
			if (bmp != null) bmp.smoothing = true;
			return (bmp);
		}
		
		/**
		 * Recupera um sprite com o gráfico indicado.
		 * @param	nome	o nome do gráfico a ser usado
		 * @return	objeto Sprite com o gráfico ou null caso o nome não seja encontrado
		 */
		public function getSPGR(nome:String):Sprite
		{
			var retorno:Sprite;
			var bmp:Bitmap = this.getGR(nome);
			if (bmp != null) {
				retorno = new Sprite();
				retorno.addChild(bmp);
				retorno.useHandCursor = true;
				retorno.buttonMode = true;
			}
			return (retorno);
		}
	}

}