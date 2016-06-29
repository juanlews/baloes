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
		
		[Embed(source = "imagens/Salvando.png")]
		public static var salvando:Class;
		
		// AJUDA
		[Embed(source = "help/ajuda00.png", compression="true", quality="70")]
		public static var ajuda00:Class;
		[Embed(source = "help/ajuda01.png", compression="true", quality="70")]
		public static var ajuda01:Class;
		[Embed(source = "help/ajuda02.png", compression="true", quality="70")]
		public static var ajuda02:Class;
		[Embed(source = "help/ajuda03.png", compression="true", quality="70")]
		public static var ajuda03:Class;
		[Embed(source = "help/ajuda04.png", compression="true", quality="70")]
		public static var ajuda04:Class;
		[Embed(source = "help/ajuda05.png", compression="true", quality="70")]
		public static var ajuda05:Class;
		[Embed(source = "help/ajuda06.png", compression="true", quality="70")]
		public static var ajuda06:Class;
		[Embed(source = "help/ajuda07.png", compression="true", quality="70")]
		public static var ajuda07:Class;
		[Embed(source = "help/ajuda08.png", compression="true", quality="70")]
		public static var ajuda08:Class;
		[Embed(source = "help/ajuda09.png", compression="true", quality="70")]
		public static var ajuda09:Class;
		[Embed(source = "help/ajuda10.png", compression="true", quality="70")]
		public static var ajuda10:Class;
		[Embed(source = "help/ajuda11.png", compression="true", quality="70")]
		public static var ajuda11:Class;
		[Embed(source = "help/ajuda12.png", compression="true", quality="70")]
		public static var ajuda12:Class;
		[Embed(source = "help/ajuda13.png", compression="true", quality="70")]
		public static var ajuda13:Class;
		[Embed(source = "help/ajuda14.png", compression="true", quality="70")]
		public static var ajuda14:Class;
		[Embed(source = "help/ajuda15.png", compression="true", quality="70")]
		public static var ajuda15:Class;
		[Embed(source = "help/ajuda16.png", compression="true", quality="80")]
		public static var ajuda16:Class;
		
		[Embed(source = "imagens/BTHelp1.png")]
		public static var BTHelp1:Class;
		[Embed(source = "imagens/BTHelp2.png")]
		public static var BTHelp2:Class;
		[Embed(source = "imagens/BTHelp3.png")]
		public static var BTHelp3:Class;
		
		public function Graficos()
		{
		
		}
		
		public static function imgAjuda(num:int):Bitmap
		{
			var bmp:Bitmap;
			switch (num) {
				case 0: bmp = new ajuda00() as Bitmap; break;
				case 1: bmp = new ajuda01() as Bitmap; break;
				case 2: bmp = new ajuda02() as Bitmap; break;
				case 3: bmp = new ajuda03() as Bitmap; break;
				case 4: bmp = new ajuda04() as Bitmap; break;
				case 5: bmp = new ajuda05() as Bitmap; break;
				case 6: bmp = new ajuda06() as Bitmap; break;
				case 7: bmp = new ajuda07() as Bitmap; break;
				case 8: bmp = new ajuda08() as Bitmap; break;
				case 9: bmp = new ajuda09() as Bitmap; break;
				case 10: bmp = new ajuda10() as Bitmap; break;
				case 11: bmp = new ajuda11() as Bitmap; break;
				case 12: bmp = new ajuda12() as Bitmap; break;
				case 13: bmp = new ajuda13() as Bitmap; break;
				case 14: bmp = new ajuda14() as Bitmap; break;
				case 15: bmp = new ajuda15() as Bitmap; break;
				case 16: bmp = new ajuda16() as Bitmap; break;
			}
			bmp.smoothing = true;
			return (bmp);
		}
		
	}

}