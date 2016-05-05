package telas 
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaBiblioteca extends TelaListaImagens
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _htmlBiblioteca:String;
		
		public function TelaBiblioteca() 
		{
			// pasta da biblioteca
			this._pasta = File.applicationDirectory.resolvePath('biblioteca/');
		}
		
		// FUNÇÕES PÚBLICAS
		
		override protected function onStage(evt:Event):void 
		{
			super.onStage(null);
			
			// carregando biblioteca
			this._webview.loadURL(File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/biblioteca/biblioteca.html').url);
		}
		
	}

}