package MyLife.Assets.Avatar.AvatarActions 
{
    import MyLife.*;
    import MyLife.Assets.Avatar.*;
    import MyLife.Events.*;
    import MyLife.NPC.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class AvatarActionManager extends flash.events.EventDispatcher
    {
        public function AvatarActionManager(arg1:MyLife.Assets.Avatar.Avatar)
        {
            super();
            isBusy = false;
            actionListQueue = new Array();
            this.avatar = arg1;
            this.character = arg1.parentCharacter as SimpleNPC;
            return;
        }

        private function actionLoadedCallback(arg1:flash.display.MovieClip, arg2:Object):void
        {
            var animClass:Class;
            var loc3:*;
            var loc4:*;
            var pAction:flash.display.MovieClip;
            var pContext:Object;
            var pos:int;
            var success:Boolean;

            animClass = null;
            pos = 0;
            pAction = arg1;
            pContext = arg2;
            success = false;
            if (pAction && pContext)
            {
                try
                {
                    animClass = pAction.loaderInfo.applicationDomain.getDefinition(pContext.params.name) as Class;
                    if (animClass)
                    {
                        ActionLibrary.registerActionClass(AnimationAction, pContext.id);
                        ActionLibrary.registerAnimationClipClass(animClass, pContext.params.name);
                        success = true;
                    }
                }
                catch (e:*)
                {
                    trace(undefined);
                }
            }
            if (pContext && !success)
            {
                pos = actionQueue.indexOf(pContext);
                if (pos != -1)
                {
                    actionQueue.splice(pos, 1);
                }
            }
            startNextAction();
            return;
        }

        public function cleanUp():void
        {
            stopCurrentAction(true);
            actionListQueue = null;
            actionQueue = null;
            currentAction.cleanUp();
            currentAction = null;
            avatar = null;
            character = null;
            return;
        }

        public function cancelAllActions(arg1:Boolean=true):void
        {
            stopCurrentAction(true);
            actionListQueue = new Array();
            actionQueue = new Array();
            currentAction.cleanUp();
            currentAction = null;
            onFinishAllActions(arg1);
            return;
        }

        private function startNextAction():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = false;
            if (actionQueue != null)
            {
                if (actionQueue.length == 0)
                {
                    if (currentAction != null)
                    {
                        dispatchEvent(new AvatarActionEvent(AvatarActionEvent.ACTION_LIST_COMPLETE, currentAction.getActionId(), character.serverUserId, currentAction.getActionParams(), currentActionListID));
                    }
                    if (!startNewActionList())
                    {
                        onFinishAllActions();
                        return;
                    }
                    loc1 = true;
                }
            }
            else 
            {
                if (!startNewActionList())
                {
                    onFinishAllActions();
                    return;
                }
                loc1 = true;
            }
            if (actionQueue == null)
            {
                return;
            }
            loc2 = actionQueue.shift();
            if (loc2 == null)
            {
                return;
            }
            loc3 = loc2.id;
            if (currentAction != null)
            {
                currentAction.cleanUp();
            }
            if (ActionLibrary.isActionLoaded(loc2.id))
            {
                currentAction = ActionLibrary.getActionInstance(loc2.id, avatar, loc2.params, loc2.interruptionType, loc2.isWaiting);
                if (currentAction == null)
                {
                    onFinishAllActions();
                    return;
                }
                else 
                {
                    isBusy = true;
                    currentAction.addEventListener(AvatarActionEvent.ACTION_COMPLETE, onActionComplete);
                }
                if (loc1)
                {
                    if (isDoingServerList)
                    {
                        MyLifeInstance.getInstance().getZone().dispatchEvent(new AvatarActionEvent(AvatarActionEvent.SERVER_ACTION_LIST_START, currentAction.getActionId(), character.serverUserId, currentAction.getActionParams(), currentActionListID));
                    }
                    else 
                    {
                        dispatchEvent(new AvatarActionEvent(AvatarActionEvent.ACTION_LIST_START, currentAction.getActionId(), character.serverUserId, currentAction.getActionParams(), currentActionListID));
                    }
                }
                this.character.dispatchEvent(new MyLifeEvent(MyLifeEvent.CHARACTER_ACTION_START));
                dispatchEvent(new AvatarActionEvent(AvatarActionEvent.ACTION_START, currentAction.getActionId(), character.serverUserId, currentAction.getActionParams(), currentActionListID));
                currentAction.start();
            }
            else 
            {
                if (loc2["params"])
                {
                    AssetsManager.getInstance().loadAction(loc2["params"]["name"], loc2, actionLoadedCallback);
                    actionQueue.unshift(loc2);
                }
            }
            return;
        }

        private function sendServerActionMessage(arg1:Number, arg2:Array, arg3:String):void
        {
            var loc4:*;

            (loc4 = new Object()).actions = arg2;
            if (arg3 != null)
            {
                loc4.actionListID = arg3;
            }
            MyLifeInstance.getInstance().server.callExtension("sendJSON", {"uid":arg1, "a":loc4});
            return;
        }

        public function getCurrentActionListId():String
        {
            return currentActionListID;
        }

        private function onFinishAllActions(arg1:Boolean=true):void
        {
            var loc2:*;

            loc2 = NaN;
            if (currentAction != null)
            {
                isBusy = currentAction.isAvatarWaiting();
            }
            else 
            {
                isBusy = false;
            }
            if (avatar != null)
            {
                loc2 = avatar.getDirection();
            }
            if (arg1 == true)
            {
                if (currentAction != null)
                {
                    currentAction.cleanUp();
                }
                if (avatar != null)
                {
                    currentAction = new AnimationAction(String(loc2), avatar, null, AvatarAction.INTERRUPTION_DO_NOW, false);
                    currentAction.start();
                }
            }
            if (isBusy == false)
            {
                if (character != null)
                {
                    character.dispatchEvent(new Event(SimpleNPC.CHARACTER_STOPPED));
                }
            }
            return;
        }

        public function resumeActions():*
        {
            if (currentAction != null)
            {
                currentAction.resume();
            }
            return;
        }

        private function onActionComplete(arg1:MyLife.Events.AvatarActionEvent):void
        {
            currentAction.removeEventListener(AvatarActionEvent.ACTION_COMPLETE, onActionComplete);
            this.character.dispatchEvent(new MyLifeEvent(MyLifeEvent.CHARACTER_ACTION_COMPLETE));
            dispatchEvent(new AvatarActionEvent(AvatarActionEvent.ACTION_COMPLETE, currentAction.getActionId(), character.serverUserId, currentAction.getActionParams(), currentActionListID));
            if (!currentAction.isAvatarWaiting())
            {
                startNextAction();
            }
            return;
        }

        public function doActionList(arg1:Array, arg2:Boolean=true, arg3:String=null, arg4:Boolean=false):Boolean
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc7 = false;
            loc8 = undefined;
            if (avatar == null)
            {
                avatar = character._renderClip.avatarClip as Avatar;
            }
            if (avatar == null)
            {
                return false;
            }
            (loc5 = new Object()).actionList = arg1;
            if (arg3 != null)
            {
                loc5.actionListID = arg3;
            }
            if (arg4 == true)
            {
                arg2 = false;
                loc5.isServerList = true;
            }
            loc6 = false;
            if (isBusy != true)
            {
                actionListQueue.push(loc5);
                loc6 = true;
            }
            else 
            {
                if ((loc8 = currentAction.getInterruptionType()) == AvatarAction.INTERRUPTION_DO_NEVER)
                {
                    return false;
                }
                if (loc8 != AvatarAction.INTERRUPTION_DO_NOW)
                {
                    if (currentAction.isAvatarWaiting())
                    {
                        stopCurrentAction();
                        actionListQueue.push(loc5);
                        loc6 = true;
                    }
                    else 
                    {
                        actionListQueue.push(loc5);
                    }
                }
                else 
                {
                    stopCurrentAction();
                    actionListQueue.splice(0, actionListQueue.length);
                    actionQueue.splice(0, actionQueue.length);
                    actionListQueue.push(loc5);
                    loc6 = true;
                }
            }
            if (!(avatar.parentCharacter == null) && avatar.parentCharacter.hasOwnProperty("isPlayerCharacter"))
            {
                loc7 = avatar.parentCharacter.isPlayerCharacter();
            }
            else 
            {
                loc7 = false;
            }
            if (loc7 && arg2 == true)
            {
                sendServerActionMessage(avatar.parentCharacter.serverUserId, arg1, arg3);
            }
            if (loc6)
            {
                startNextAction();
            }
            return true;
        }

        public function pauseActions():*
        {
            if (currentAction != null)
            {
                currentAction.pause();
            }
            return;
        }

        private function stopCurrentAction(arg1:Boolean=false):void
        {
            var loc2:*;

            loc2 = false;
            if (currentAction != null)
            {
                loc2 = currentAction.isAvatarWaiting();
                currentAction.stop();
                if (!loc2 || arg1)
                {
                    dispatchEvent(new AvatarActionEvent(AvatarActionEvent.ACTION_CANCELLED, currentAction.getActionId(), character.serverUserId, currentAction.getActionParams(), currentActionListID));
                }
                currentAction.removeEventListener(AvatarActionEvent.ACTION_COMPLETE, onActionComplete);
            }
            return;
        }

        public function changeDirection(arg1:Number):void
        {
            if (currentAction == null)
            {
                avatar.changeDirection(arg1);
            }
            else 
            {
                currentAction.changeDirection(arg1);
            }
            return;
        }

        private function startNewActionList():Boolean
        {
            var loc1:*;

            loc1 = actionListQueue.shift();
            if (loc1 == null)
            {
                isBusy = false;
                return false;
            }
            actionQueue = loc1.actionList;
            currentActionListID = loc1.actionListID;
            isDoingServerList = !(loc1.isServerList == null) && loc1.isServerList == true;
            return true;
        }

        public function isAvatarBusy():Boolean
        {
            return isBusy;
        }

        private var isBusy:Boolean;

        private var isDoingServerList:Boolean;

        private var currentAction:MyLife.Assets.Avatar.AvatarActions.AvatarAction;

        public var avatar:MyLife.Assets.Avatar.Avatar;

        private var currentActionListID:String;

        public var character:MyLife.NPC.SimpleNPC;

        private var actionQueue:Array;

        private var actionListQueue:Array;
    }
}
