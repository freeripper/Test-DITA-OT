<?php
/**
 * Cell renderer
 * 
 * @author serban
 *
 */
interface ICellRenderer{
	/**
	 * Render cell for field with the specied value
	 * 
	 * @param String $fieldName
	 * @param Stringe $fieldValue
	 */
	function render($fieldName,$fieldValue);	
	
}
?>