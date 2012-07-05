<?php
/**
 * Export data in xml format
 *
 * @author serban
 *
 */
class InLineExporter implements IExporter{
	/**
	 * exported content
	 *
	 * @var String
	 */
	private $toReturn;
	/**
	 * Total exported rows
	 *
	 * @var int
	 */
	private $rows;

	private $ignoredFields;

	private $columnSizes;
	/**
	 * Cell renderer
	 * 
	 * @var ICellRenderer
	 */
	private $cellRenderer;
	/**
	 * Constructor
	 * @param String $table table name
	 * @param array $ignoredFields - fields to be ignored in view
	 * @param array $columnSizes - custom column size for each selected field 
	 */
	function __construct($table="",$ignoredFields=null,$columnSizes=null){
		$this->toReturn="<div class=\"table\">";
		$this->rows=0;
		$this->ignoredFields=$ignoredFields;
		$this->columnSizes=$columnSizes;
	}
	/**
	 * Set cell renderer
	 * 
	 * @param ICellRenderer $cellRenderer
	 */
	function setCellRenderer($cellRenderer){
		$this->cellRenderer=$cellRenderer;
	}
	/**
	 * Export one row
	 * @param Array $AssociativeRowArray - array containing fieldName=>fieldValue
	 */
	function exportRow($AssociativeRowArray){
		$width=20;
		if ($this->rows==0){
			$this->toReturn.="<div class=\"tbHRow\">";
			$column=0;
			foreach ($AssociativeRowArray as $field => $value){
				if (!in_array($field, $this->ignoredFields)){
					if ($this->columnSizes!=null){
						if ($this->columnSizes[$column]){
							$width=$this->columnSizes[$column];
						}else{
							$width=11;
						}
					}
					$this->toReturn.="<div class=\"tbCell\" style=\"width:$width%;\">".Utils::translate("label.tc.".$field)."</div>";
					$column++;
				}
			}
			if ($this->columnSizes!=null){
				$width=$this->columnSizes[count($this->columnSizes)-1];
			}
			//$this->toReturn.="<div class=\"tbCell\" style=\"width:$width%;\"><div>".Utils::translate("selected")."</div></div>";
			$this->toReturn.="</div>";
		}
		$this->rows++;
		$this->toReturn.="<div class=\"tbRow\">";
		$column=0;
		foreach ($AssociativeRowArray as $field => $value){
			$this->rows++;
			if ($field=="commentId"){
				$id=$value;
				$this->cellRenderer->setAName($id);
			}
			if (!in_array($field, $this->ignoredFields)){
				if ($this->columnSizes!=null){
					if ($this->columnSizes[$column]){
						$width=$this->columnSizes[$column];
					}else{
						$width=11;
					}
				}
				$renderedValue=$value;
				if ($this->cellRenderer){
					$renderedValue=$this->cellRenderer->render($field, $value);
				}
				$this->toReturn.="<div class=\"tbCell\" style=\"width:$width%;\">".$renderedValue."</div>";
				$column++;
			}
		}		
		$this->toReturn.="<div class=\"tbCell\"><input type=\"checkbox\" class=\"cb-element\" onclick=\"addToDelete($id);\"/></div>";
		$this->toReturn.="</div>";
	}

	function getContent(){
		$this->toReturn.="</div>";
		$this->toReturn.="</div>";
		return  $this->toReturn;
	}

}
?>