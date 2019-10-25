package MyLife.Components 
{
    import MyLife.*;
    import MyLife.Interfaces.*;
    import fl.controls.listClasses.*;
    import fl.events.*;
    import flash.utils.*;
    
    public class AlternatingColorRenderer extends fl.controls.listClasses.CellRenderer implements fl.controls.listClasses.ICellRenderer
    {
        public function AlternatingColorRenderer()
        {
            super();
            return;
        }

        protected override function drawBackground():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = getDefinitionByName("CellRenderer_upSkinPremium") as Class;
            loc2 = getDefinitionByName("CellRenderer_downSkinPremium") as Class;
            loc3 = MyLifeInstance.getInstance()._interface.interfaceHUD.eventWindow;
            if (loc3.isPremiumIndex(_listData.index))
            {
                setStyle("upSkin", loc1);
                setStyle("overSkin", loc2);
                setStyle("downSkin", loc2);
            }
            else 
            {
                if (_listData.index % 2)
                {
                    setStyle("upSkin", CellRenderer_upSkinB);
                }
                else 
                {
                    setStyle("upSkin", CellRenderer_upSkinA);
                }
            }
            super.drawBackground();
            return;
        }

        public static function getStyleDefinition():Object
        {
            return CellRenderer.getStyleDefinition();
        }
    }
}
