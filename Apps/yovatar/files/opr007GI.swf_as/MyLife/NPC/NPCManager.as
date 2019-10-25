package MyLife.NPC 
{
    import MyLife.*;
    import flash.display.*;
    
    public class NPCManager extends Object
    {
        public function NPCManager()
        {
            super();
            if (!_instance)
            {
                this.init();
            }
            return;
        }

        public function addNPC(arg1:Object, arg2:Function=null):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = SERVER_USER_ID_PREFIX + ++instanceCount;
            loc4 = {};
            trace("NPCManger npcData.type " + arg1.type);
            if (arg1.type == null || !(arg1.type == TYPE_DEFAULT) && !(arg1.type == TYPE_ASYNC_FRIEND))
            {
                arg1.type = TYPE_DEFAULT;
            }
            loc4.type = arg1.type;
            loc4.serverUserId = loc3;
            loc4.isNPC = true;
            loc4.x = arg1.x;
            loc4.y = arg1.y;
            loc4.d = arg1.d;
            loc4.properties = arg1.properties;
            loc4.player = arg1;
            loc4.player.mod_level = NPC_MOD_LEVEL;
            trace("new npc " + loc4.serverUserId);
            (loc5 = myLifeInstance.getZone().addNewCharacter(loc4, arg2)).serverUserId = loc3;
            npcHash[loc3] = loc5;
            return loc5;
        }

        private function init():void
        {
            YoVilleApp._instance = this;
            this.myLifeInstance = MyLifeInstance.getInstance();
            this.npcHash = {};
            this.instanceCount = 0;
            return;
        }

        public static function get instance():MyLife.NPC.NPCManager
        {
            if (!YoVilleApp._instance)
            {
                new NPCManager();
            }
            return YoVilleApp._instance;
        }

        public static const TYPE_DEFAULT:String="npc";

        public static const TYPE_ASYNC_FRIEND:String="asyncFriend";

        public static const NPC_MOD_LEVEL:int=-1;

        public static const SERVER_USER_ID_PREFIX:String="npc";

        private var instanceCount:int;

        private var myLifeInstance:flash.display.MovieClip;

        private var npcHash:Object;

        private static var _instance:MyLife.NPC.NPCManager;
    }
}
