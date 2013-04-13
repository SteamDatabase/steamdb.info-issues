<?php
	/*
	 * Requires PHP Markdown: https://github.com/michelf/php-markdown
	 */
	
	require __DIR__ . '/Markdown.php';
	
	use \Michelf\Markdown;
	
	class SteamDBFlavoredMarkdown extends \Michelf\Markdown
	{
		public function __construct( )
		{
			$this->span_gamut += Array(
				'doAutoSteamLinks' => 5
			);
			
			parent :: __construct( );
			
			$this->empty_element_suffix = '>';
			$this->no_markup = true;
			$this->no_entities = true;
		}
		
		protected function doAutoSteamLinks( $Text )
		{
			// Match /app/440 and optionally followed by ending slash
			$Text = preg_replace_callback(
						'{' .
							'(?<![\w\x1A])' .
							'/app/' .
							'(\d{1,6})' .
							'/?' .
							'(?![\w\x1A])' .
						'}s',
				Array( &$this, '__doAutoAppLinks_callback' ), $Text );
			
			// Match /sub/61 and optionally followed by ending slash
			$Text = preg_replace_callback( 
						'{' .
							'(?<![\w\x1A])' .
							'/sub/' .
							'(\d{1,6})' .
							'/?' .
							'(?![\w\x1A])' .
						'}s',
				Array( &$this, '__doAutoPackageLinks_callback' ), $Text );
			
			return $Text;
		}
		
		protected function __doAutoAppLinks_callback( $Matches )
		{
			$AppID = (int)$Matches[ 1 ];
			
			return $this->hashPart( '<a href="/app/' . $AppID . '/">App ' . $AppID . '</a>' );
		}
		
		protected function __doAutoPackageLinks_callback( $Matches )
		{
			$SubID = (int)$Matches[ 1 ];
			
			return $this->hashPart( '<a href="/sub/' . $SubID . '/">Package ' . $SubID . '</a>' );
		}
	}
