package MyLife.Assets 
{
    import flash.display.*;
    import flash.utils.*;
    
    public class SimpleItem extends flash.display.MovieClip
    {
        public function SimpleItem()
        {
            super();
            return;
        }

        public function getItemData():Object
        {
            var AssetClass:Class;
            var className:String;
            var i:int;
            var itemData:Object;
            var loc1:*;
            var loc2:*;
            var pattern:RegExp;
            var qualifiedClassName:String;
            var supportedViews:Array;
            var viewClassName:String;
            var viewName:String;
            var viewTypes:Array;

            viewName = null;
            viewClassName = null;
            AssetClass = null;
            itemData = {};
            qualifiedClassName = getQualifiedClassName(this);
            pattern = new RegExp("::");
            className = qualifiedClassName.replace(pattern, ".");
            viewTypes = ["Back", "Front", "Preview"];
            supportedViews = [];
            i = viewTypes.length;
            for (;;) 
            {
                i = ((i) - 1);
                if (!i)
                {
                    break;
                }
                viewName = viewTypes[i];
                viewClassName = className + "." + viewName;
                try
                {
                    AssetClass = getDefinitionByName(viewClassName) as Class;
                }
                catch (error:Error)
                {
                    AssetClass = null;
                }
                if (!AssetClass)
                {
                    continue;
                }
                supportedViews.push(viewName);
            }
            itemData = {};
            itemData.supportedViews = supportedViews;
            itemData.isInactive = !Boolean(supportedViews.length);
            itemData.className = className;
            return itemData;
        }
    }
}
