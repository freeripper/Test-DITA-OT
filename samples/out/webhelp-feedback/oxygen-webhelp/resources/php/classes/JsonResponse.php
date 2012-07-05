<?php
/**
 * Constructs the json response for ajax requests   
 * 
 * @author serban
 *
 */
class JsonResponse {
	
	private $value;
	function __construct(){
		$this->value= array();
	}
	/**
	 *  set variable 
	 * @param String $variable
	 * @param String $value
	 */
	public function set($variable, $value){
		$this->value[$variable]=$value;
	}
	
	function __get($variableName){
		$toReturn="";
		if (isset($this->value[$variableName])){
			$toReturn=$this->value[$variableName];
		}
		return $toReturn;
	}
	public function __toString(){
		return $this->getJson();
	}
	
	/**
	 * JSON  representation of the object 
	 */
	private function getJson(){
		$toReturn="{";
		
		// in order to use json_encode php 5 >= 5.2
		//string json_encode ( mixed $value [, int $options = 0 ] )
		
		foreach ($this->value as $key=> $value){
			$toReturn.="\"".$key."\":\"".$value."\",";
		}
		$toReturn=substr($toReturn,0, -1);
		$toReturn.="}";
		return $toReturn;
	}
}
?>