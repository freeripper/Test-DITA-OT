<?php
class Template {
	/**
	 * Tempplate file content
	 * @var string
	 */
	private $template;
	/**
	 * Constructor
	 * @param string $filepath template file path
	 */
	function __construct($filepath) {
		$this->template = file_get_contents($filepath);
	}

	/**
	 * Replace provided value in template
	 * 
	 * @param array $content array containing pairs of value to be replaced => value to preplace with
	 * @return content of the template after replacement 
	 */ 
	function replace($content) {
		foreach ($content as $key => $val){
			$this->template = str_replace("#$key#", $val, $this->template);
		}
		return $this->template;
	}	

}

?>