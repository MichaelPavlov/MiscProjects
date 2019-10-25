<?php
	
	include ("connect.php");
	
	/**
	 * @param mysql_resource - $queryResult - mysql query result
	 * @param string - $rootElementName - root element name
	 * @param string - $childElementName - child element name
	 */
	function sqlToXml($queryResult, $rootElementName, $childElementName) { 
		
		$xmlData .= "<" . $rootElementName . ">";
	 
		while($record = mysql_fetch_object($queryResult)) { 
			/* Create the first child element */
			$xmlData .= "<" . $childElementName . ">";
	 
			for ($i = 0; $i < mysql_num_fields($queryResult); $i++) { 
				$fieldName = mysql_field_name($queryResult, $i); 
	 
				/* The child will take the name of the table column */
				$xmlData .= "<![CDATA[";
	 
				/* We set empty columns with NULL, or you could set 
					it to '0' or a blank. */
				if(!empty($record->$fieldName))
					$xmlData .= $record->$fieldName; 
				else
					$xmlData .= ""; 
	 
				$xmlData .= "]]>"; 
			} 
			$xmlData .= "</" . $childElementName . ">"; 
		} 
		$xmlData .= "</" . $rootElementName . ">"; 
	 
		return $xmlData; 
	}
	
	function arrayToXML($array, $rootElementName, $childElementName) {
		$xml = '';
		$xml .= "<" . $rootElementName . ">";
		
		for ($i=0; $i<count($array); $i++) {
			$xml .= "<".$childElementName."><![CDATA[".$array[$i]."]]></".$childElementName.">";
		}
		$xml .= "</" . $rootElementName . ">"; 
		
		return $xml;		
	}
	
	function parseEntries($queryResult, $delimiter) {
		$entries = array();
		
		while($record = mysql_fetch_object($queryResult)) {
			for ($i = 0; $i < mysql_num_fields($queryResult); $i++) { 
				$fieldName = mysql_field_name($queryResult, $i);
				/* We set empty columns with NULL, or you could set 
					it to '0' or a blank. */
				$stringData = $record->$fieldName;
				$tmpEntries = preg_split($delimiter, $stringData, -1, PREG_SPLIT_NO_EMPTY);
				$entries = array_merge($tmpEntries, $entries);
			}
		}
		
		return $entries;
	}
	
	/*function splitArrayEntries($array) (
		$entries = array();
		for ($i = 0; $i < count($array); $i++) { 			
			$stringData = $array[$i];
			$tmpEntries = preg_split($delimiter, $stringData, -1, PREG_SPLIT_NO_EMPTY);
			$entries = array_merge($tmpEntries, $entries);
		}
	}*/
	
	function trimString($input, $string) {
		
        $input = trim($input); 
        $startPattern = "/^($string)+/i"; 
        $endPattern = "/($string)+$/i"; 
        return trim(preg_replace($endPattern, '', preg_replace($startPattern,'',$input))); 
	}	
	
	
	
	header("Content-type: text/xml");
	
	
	$mainXML = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n";
	$mainXML .= "<data>";
	
	$query = "SELECT Inventory.Brand
			  FROM Inventory
			  GROUP BY Inventory.Brand";
	$resultID = mysql_query($query) or die("Data not found.");	
	$mainXML .= sqlToXml($resultID, "brands", "brand");
	
	
	
	
	
	$query = "SELECT Inventory.Themes
			  FROM Inventory
			  GROUP BY Inventory.Themes";
	$resultID = mysql_query($query) or die("Data not found.");		
	$parsedArray = parseEntries($resultID, '%, %');
	for ($i=0; $i<count($parsedArray); $i++) {	
		$parsedArray[$i] = trimString($parsedArray[$i], ',');
	}
	
	$parsedArray = array_unique($parsedArray, SORT_STRING);
	sort($parsedArray);	
	$mainXML .= arrayToXML($parsedArray, "themes", "theme");
	
	
	
	
	
	$query = "SELECT Inventory.Color
			  FROM Inventory
			  GROUP BY Inventory.Color";
	$resultID = mysql_query($query) or die("Data not found.");
	$parsedArray = parseEntries($resultID, '%, %');
	for ($i=0; $i<count($parsedArray); $i++) {	
		$parsedArray[$i] = trimString($parsedArray[$i], ',');
	}
	$parsedArray = array_unique($parsedArray, SORT_STRING);
	sort($parsedArray);
	$mainXML .= arrayToXML($parsedArray, "colors", "color");
	
	
	$query = "SELECT Inventory.Category
			  FROM Inventory
			  GROUP BY Inventory.Category";
	$resultID = mysql_query($query) or die("Data not found.");
	$parsedArray = parseEntries($resultID, '%, %');
	for ($i=0; $i<count($parsedArray); $i++) {	
		$parsedArray[$i] = trimString($parsedArray[$i], ',');
	}
	$parsedArray = array_unique($parsedArray, SORT_STRING);
	sort($parsedArray);
	$mainXML .= arrayToXML($parsedArray, "categories", "category");
	
	
	
	
	$mainXML .= "</data>";
	
	
	
	//print_r($parsedArray);
	

	echo  $mainXML;
?>