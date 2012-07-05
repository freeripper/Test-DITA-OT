<?php
/**
 * Exporter Interface
 * 
 * @author serban
 *
 */
interface IExporter{
	/**
	 * Export one row 
	 * @param Array $AssociativeRowArray - array containing fieldName=>fieldValue
	 */
	function exportRow($AssociativeRowArray);
	/**
	 * Return the exported contents
	 * @return String content exported
	 */
	function getContent();
	 
}
?>