<?php 

	include ("connect.php");
	
	/**
	 * @param mysql_resource - $queryResult - mysql query result
	 * @param string - $rootElementName - root element name
	 * @param string - $childElementName - child element name
	 */
	function sqlToXml($queryResult, $rootElementName, $childElementName)
	{ 
		$xmlData = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n"; 
		$xmlData .= "<" . $rootElementName . ">";
	 
		while($record = mysql_fetch_object($queryResult))
		{ 
			/* Create the first child element */
			$xmlData .= "<" . $childElementName . ">";
	 
			for ($i = 0; $i < mysql_num_fields($queryResult); $i++)
			{ 
				$fieldName = mysql_field_name($queryResult, $i); 
	 
				/* The child will take the name of the table column */
				$xmlData .= "<" . $fieldName . "><![CDATA[";
	 
				/* We set empty columns with NULL, or you could set 
					it to '0' or a blank. */
				if(!empty($record->$fieldName))
					$xmlData .= $record->$fieldName; 
				else
					$xmlData .= "null"; 
	 
				$xmlData .= "]]></" . $fieldName . ">"; 
			} 
			$xmlData .= "</" . $childElementName . ">"; 
		} 
		$xmlData .= "</" . $rootElementName . ">"; 
	 
		return $xmlData; 
	}

	header("Content-type: text/xml");

	/*
	POST VARS 
	Allow the user to view the clothing by brand, category, theme and color.
	$_GET["b"] - brand
	$_GET["ca"] - category
	$_GET["t"] - theme
	$_GET["co"] - color
	*/

	if (isset($_GET["b"])) {
		$selectedBrand = mysql_real_escape_string($_GET["b"]);
		$brandParam = "Inventory.Brand = '".$selectedBrand."'";
	} else {
		$brandParam = '1=1';
	}

	if (isset($_GET["ca"])) {
		$selectedCategory = mysql_real_escape_string($_GET["ca"]);
		$categoryParam = " AND Inventory.Category LIKE '%".$selectedCategory."%'";
	} else {
		$categoryParam = " AND 1=1";
	}

	if (isset($_GET["t"])) {
		$selectedTheme = mysql_real_escape_string($_GET["t"]);
		$themeParam = " AND Inventory.Themes LIKE '%".$selectedTheme."%'";
	} else {
		$themeParam = " AND 1=1";
	}

	if (isset($_GET["co"])) {
		$selectedColor = mysql_real_escape_string($_GET["co"]);
		$colorParam = " AND Inventory.Color = '".$selectedColor."'";
	} else {
		$colorParam = " AND 1=1";
	}

	$query = "SELECT Inventory.ID, Inventory.Photo, Inventory.Description, Inventory.Brand, Inventory.Price, Inventory.URL 
			  FROM Inventory
			  WHERE ".$brandParam.$categoryParam.$themeParam.$colorParam;

	$resultID = mysql_query($query) or die("Data not found.");

	echo sqlToXml($resultID, "assets", "asset"); 

?>