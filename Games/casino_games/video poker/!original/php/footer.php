<?PHP

?>
<table border="0" cellpadding="0" cellspacing="0" style="background:transparent; position: absolute; bottom:0px" width="100%" height="45">
	<tr>
		<td colspan="6"><hr color="#FFCC00" size="1">
		</td>
	</tr>
	<tr>
		<td height="3" width="20%">
<? if (!empty ($type)){ ?>
		<font color="#FFFFCC">
		<input type="radio" style="background:transparent;" name="screen_mode" onclick="window.moveTo(0,0); self.resizeTo(screen.availWidth,screen.availHeight); window_mode.checked=false;"> 
		Full Screen</font>
<? } ?>&nbsp;		
		</td>
		<td height="6" rowspan="2" width="15%">	
		<p align="center"></td>
		<td height="6" rowspan="2" width="15%"><p align="right"><b><font face="Verdana" color="#FFCC00">Your Balance $</font></b>
		</td>
		<td height="6" rowspan="2" width="15%">	
		<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" id="main" align="left" width="56" height="24">
		<param name="movie" value="balance.swf?u=<? echo $_SESSION['userid']; ?>" />
		<param name="quality" value="Best" />
		<param name="menu" value="false" />
		<param name="scale" value="ExactFit">
		<param name="wmode" value="transparent">
		<param name="salign" value="L">
		<embed src="balance.swf?u=<? echo $_SESSION['userid']; ?>" quality="Best" menu="false" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" width="56" height="24" scale="ExactFit" wmode="transparent" salign="L" />
		</object></td>
		<td height="6" rowspan="2" width="15%">	
				</td>
		<td align="right" height="7" width="20%">
<? if (!empty ($type)){ ?>
				<a href="<?=$siteurl?>/games/start.php" style="text-decoration: none">lobby</a>
<? } ?>
		</td>
	</tr>
	<tr>
		<td height="3">
<? if (!empty ($type)){ ?>
		<font color="#FFFFCC">
		<input type="radio" style="background:transparent;" name="window_mode" onclick="self.resizeTo(750,550); window.moveTo(self.screen.width/4,self.screen.height/4); screen_mode.checked=false;" checked> 
		Window Mode</font>
<? } ?>&nbsp;
		</td>
		<td align="right" height="7">
		<a href="javascript:void(window.close())" style="text-decoration: none">
		<font color="#C0C0C0">close</font></a></td>
	</tr>
</table>