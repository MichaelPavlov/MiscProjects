package MyLife 
{
    import flash.display.*;
    
    public class MyLifeRockPaperScissors extends Object
    {
        public function MyLifeRockPaperScissors()
        {
            gameCollection = new Array();
            newGameDialogRequestColection = new Array();
            waitingForMeToAcceptNewGame = new Array();
            super();
            if (_instance != null)
            {
                throw new Error("Please use getInstance() to access class.");
            }
            return;
        }

        private function handleLeaveGame(arg1:*):*
        {
            var gameInstance:*;
            var loc2:*;
            var loc3:*;
            var opponentPlayerName:*;
            var opponentServerId:*;

            gameInstance = undefined;
            opponentServerId = arg1;
            opponentPlayerName = "";
            if (opponentServerId && MyLifeInstance.getInstance() && MyLifeInstance.getInstance().getZone())
            {
                opponentPlayerName = MyLifeInstance.getInstance().getZone().getCharacterName(opponentServerId);
            }
            if (opponentPlayerName != "")
            {
                if (newGameRequestOpponentServerId != opponentServerId)
                {
                    if (waitingForMeToAcceptNewGame[opponentServerId])
                    {
                        if (newGameDialogRequestColection[opponentServerId])
                        {
                            MyLifeInstance.getInstance().getInterface().unloadInterface(newGameDialogRequestColection[opponentServerId]);
                            newGameDialogRequestColection[opponentServerId] = null;
                        }
                        MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Request", "message":opponentPlayerName + " canceled the game request.", "autoClose":20, "buttons":[{"name":"OK", "value":"BTN_OK"}]});
                        waitingForMeToAcceptNewGame[opponentServerId] = false;
                    }
                    else 
                    {
                        gameInstance = getGameInstance(opponentServerId);
                        if (gameInstance)
                        {
                            if (!gameInstance.isGameDone())
                            {
                                closeGameWindow(gameInstance);
                                MyLifeInstance.getInstance().getInterface().unloadInterface(gameInstance);
                                if (gameInstance.getPlayCount() >= 2)
                                {
                                    gameInstance.registerGameResult(-1);
                                }
                                else 
                                {
                                    MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game", "message":opponentPlayerName + " has left the Rock Paper Scissors game."});
                                }
                            }
                        }
                    }
                }
                else 
                {
                    try
                    {
                        MyLifeInstance.getInstance().getInterface().unloadInterface(newGameRequestDialog);
                    }
                    catch (e:Error)
                    {
                    };
                    newGameRequestDialog = null;
                    MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Request", "message":opponentPlayerName + " declined your Rock Paper Scissors game request.", "autoClose":20, "buttons":[{"name":"OK", "value":"BTN_OK"}]});
                }
            }
            return;
        }

        private function handleNewGameRequest(arg1:*):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = null;
            if (autoIgnoreAllGames)
            {
                waitingForMeToAcceptNewGame[arg1] = false;
                sendPlayerToPlayerEvent(arg1, "leave_game", {});
                return;
            }
            loc2 = "";
            if (arg1 && MyLifeInstance.getInstance() && MyLifeInstance.getInstance().getZone())
            {
                loc2 = MyLifeInstance.getInstance().getZone().getCharacterName(arg1);
            }
            if (loc2 != "")
            {
                if (MyLifeRockPaperScissors.GAME_COST)
                {
                    loc4 = loc2 + " has requested to play a game of Rock Paper Scissors. This game costs " + MyLifeRockPaperScissors.GAME_COST + " coins to play.\nDo you accept the request?";
                }
                else 
                {
                    loc4 = loc2 + " has requested to play a game of Rock Paper Scissors.\nDo you accept the request?";
                }
                if (gameRequestIgnoreCount < 2)
                {
                    loc3 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Invitation", "message":loc4, "metaData":{"opponentServerId":arg1}, "autoClose":30, "autoCloseCMD":"BTN_NO", "buttons":[{"name":"Accept Request", "value":"BTN_YES"}, {"name":"Decline", "value":"BTN_NO"}]});
                }
                else 
                {
                    loc3 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Invitation", "message":loc4, "metaData":{"opponentServerId":arg1}, "autoClose":30, "autoCloseCMD":"BTN_NO", "buttons":[{"name":"Accept Request", "value":"BTN_YES"}, {"name":"Decline", "value":"BTN_NO"}, {"name":"Ignore All", "value":"BTN_IGNORE"}]});
                }
                loc3.addEventListener(MyLifeEvent.DIALOG_RESPONSE, newGameDialogRequestResponse);
                newGameDialogRequestColection[arg1] = loc3;
                waitingForMeToAcceptNewGame[arg1] = true;
            }
            return;
        }

        private function handlePlayerTurn(arg1:*, arg2:*):*
        {
            var loc3:*;

            loc3 = getGameInstance(arg1);
            if (loc3)
            {
                loc3.playTurn(arg2, true);
            }
            return;
        }

        private function onGameDoneEvent(arg1:MyLife.MyLifeEvent):*
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.eventData.opponentServerId;
            loc3 = getGameInstance(loc2);
            if (loc3)
            {
                closeGameWindow(loc3);
            }
            return;
        }

        private function handleAcceptGameRequest(arg1:*, arg2:*):*
        {
            var firstTurn:*;
            var loc3:*;
            var loc4:*;
            var opponentServerId:*;

            opponentServerId = arg1;
            firstTurn = arg2;
            try
            {
                MyLifeInstance.getInstance().getInterface().unloadInterface(newGameRequestDialog);
                newGameRequestDialog = null;
                startNewGame(opponentServerId, firstTurn);
            }
            catch (e:Error)
            {
            };
            return;
        }

        private function onLeaveGameEvent(arg1:MyLife.MyLifeEvent):*
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.eventData.opponentServerId;
            loc3 = getGameInstance(loc2);
            if (loc3)
            {
                closeGameWindow(loc3);
                sendPlayerToPlayerEvent(loc2, "leave_game", {});
            }
            return;
        }

        public function handleEvent(arg1:Object):void
        {
            var loc2:*;

            MyLifeUtils.deepTrace(arg1);
            loc2 = arg1.params.action;
            switch (loc2) 
            {
                case "new_game":
                    handleNewGameRequest(arg1.sender);
                    break;
                case "leave_game":
                    handleLeaveGame(arg1.sender);
                    break;
                case "accept_request":
                    handleAcceptGameRequest(arg1.sender, arg1.params.firstTurn);
                    break;
                case "player_turn":
                    handlePlayerTurn(arg1.sender, arg1.params.playerMove);
                    break;
                default:
                    break;
            }
            return;
        }

        private function resetIgnoreStatus():*
        {
            gameRequestIgnoreCount = 0;
            autoIgnoreAllGames = false;
            return;
        }

        private function newGameRequestDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            if (newGameRequestDialog)
            {
                newGameRequestDialog.removeEventListener(MyLifeEvent.DIALOG_RESPONSE, newGameRequestDialogResponse);
                newGameRequestDialog = null;
            }
            loc2 = arg1.eventData.metaData.opponentServerId;
            if (arg1.eventData.userResponse == "BTN_CANCEL")
            {
                cancelNewGameRequest(loc2);
            }
            return;
        }

        private function cancelNewGameRequest(arg1:*):*
        {
            newGameRequestOpponentServerId = 0;
            sendPlayerToPlayerEvent(arg1, "leave_game", {});
            return;
        }

        private function closeGameWindow(arg1:*):*
        {
            var gameInstance:*;
            var loc2:*;
            var loc3:*;

            gameInstance = arg1;
            if (gameInstance)
            {
                gameInstance.removeEventListener(MyLifeRockPaperScissors.PLAY_TURN, onPlayTurnEvent);
                gameInstance.removeEventListener(MyLifeRockPaperScissors.GAME_DONE, onGameDoneEvent);
                gameInstance.removeEventListener(MyLifeRockPaperScissors.LEAVE_GAME, onLeaveGameEvent);
                gameInstance.endGame();
                gameInstance.visible = false;
                gameCollection[gameInstance.getOpponentServerId()] = null;
                try
                {
                    MyLifeInstance.getInstance().getInterface().unloadInterface(gameInstance);
                }
                catch (e:Error)
                {
                };
                gameInstance = null;
            }
            return;
        }

        public function getActiveWindowCount():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            loc1 = 0;
            if (newGameRequestDialog)
            {
                ++loc1;
            }
            loc3 = 0;
            loc4 = newGameDialogRequestColection;
            for each (loc2 in loc4)
            {
                if (!loc2)
                {
                    continue;
                }
                ++loc1;
            }
            return loc1;
        }

        public function handleUserLeave(arg1:*):void
        {
            handleLeaveGame(arg1);
            return;
        }

        public function getActiveGameCount():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            loc1 = 0;
            loc3 = 0;
            loc4 = gameCollection;
            for each (loc2 in loc4)
            {
                if (!(loc2 && loc2.visible))
                {
                    continue;
                }
                ++loc1;
            }
            return loc1;
        }

        private function onPlayTurnEvent(arg1:MyLife.MyLifeEvent):*
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.eventData.opponentServerId;
            loc3 = arg1.eventData.playerMove;
            sendPlayerToPlayerEvent(loc2, "player_turn", {"playerMove":loc3});
            return;
        }

        public function closeWindows():*
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = undefined;
            loc2 = 0;
            loc3 = gameCollection;
            for each (loc1 in loc3)
            {
                closeGameWindow(loc1);
            }
            return;
        }

        private function getGameInstance(arg1:*):*
        {
            if (gameCollection[arg1])
            {
                return gameCollection[arg1];
            }
            return false;
        }

        public function sendNewGameRequest(arg1:*):*
        {
            var loc2:*;

            newGameRequestOpponentServerId = arg1;
            if (waitingForMeToAcceptNewGame[arg1])
            {
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Request", "message":"That player has already requested a new game with you."});
                return;
            }
            if (gameCollection[arg1])
            {
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Request", "message":"You are already playing a game with this player."});
                return;
            }
            sendPlayerToPlayerEvent(arg1, "new_game", {});
            loc2 = "";
            if (arg1 && MyLifeInstance.getInstance() && MyLifeInstance.getInstance().getZone())
            {
                loc2 = MyLifeInstance.getInstance().getZone().getCharacterName(arg1);
            }
            if (loc2 != "")
            {
                newGameRequestDialog = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Request", "message":"Please wait for " + loc2 + " to join the game...", "metaData":{"opponentServerId":arg1}, "icon":"loading", "buttons":[{"name":"Cancel Game", "value":"BTN_CANCEL"}]});
                newGameRequestDialog.addEventListener(MyLifeEvent.DIALOG_RESPONSE, newGameRequestDialogResponse);
            }
            else 
            {
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Request", "message":"The player you requested to play with has left the room."});
            }
            resetIgnoreStatus();
            return;
        }

        private function sendPlayerToPlayerEvent(arg1:int, arg2:String, arg3:Object):*
        {
            MyLifeInstance.getInstance().getServer().sendPlayerToPlayerEvent(arg1, "RPS", arg2, arg3);
            return;
        }

        private function newGameDialogRequestResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            loc2 = arg1.eventData.metaData.opponentServerId;
            if (newGameDialogRequestColection[loc2])
            {
                newGameDialogRequestColection[loc2].removeEventListener(MyLifeEvent.DIALOG_RESPONSE, newGameDialogRequestResponse);
                newGameDialogRequestColection[loc2] = null;
            }
            if (arg1.eventData.userResponse != "BTN_YES")
            {
                if (arg1.eventData.userResponse == "BTN_IGNORE")
                {
                    autoIgnoreAllGames = true;
                }
                gameRequestIgnoreCount++;
                sendPlayerToPlayerEvent(loc2, "leave_game", {});
            }
            else 
            {
                loc3 = (Math.random() <= 0.5) ? true : false;
                sendPlayerToPlayerEvent(loc2, "accept_request", {"firstTurn":!loc3});
                startNewGame(loc2, loc3);
            }
            return;
        }

        private function startNewGame(arg1:*, arg2:Boolean):*
        {
            var loc3:*;
            var loc4:*;

            if (newGameRequestOpponentServerId == arg1)
            {
                newGameRequestOpponentServerId = 0;
            }
            resetIgnoreStatus();
            loc3 = "";
            if (arg1 && MyLifeInstance.getInstance() && MyLifeInstance.getInstance().getZone())
            {
                loc3 = MyLifeInstance.getInstance().getZone().getCharacterName(arg1);
            }
            waitingForMeToAcceptNewGame[arg1] = false;
            if (loc3 != "")
            {
                if (MyLifeRockPaperScissors.GAME_COST)
                {
                    MyLifeInstance.getInstance().getServer().callExtension("giveCoins", {"storeId":7, "coins":-MyLifeRockPaperScissors.GAME_COST, "memo":"Rock Paper Scissors (Start)"});
                }
            }
            else 
            {
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Rock Paper Scissors Game Request", "message":"The player you requested to play with has left the room."});
            }
            loc4 = MyLifeInstance.getInstance().getInterface().showInterface("GameWindow_RPS", {"firstTurn":arg2, "opponentServerId":arg1});
            gameCollection[arg1] = loc4;
            loc4.addEventListener(MyLifeRockPaperScissors.PLAY_TURN, onPlayTurnEvent);
            loc4.addEventListener(MyLifeRockPaperScissors.GAME_DONE, onGameDoneEvent);
            loc4.addEventListener(MyLifeRockPaperScissors.LEAVE_GAME, onLeaveGameEvent);
            return;
        }

        public static function getInstance():MyLife.MyLifeRockPaperScissors
        {
            return _instance;
        }

        public static const GAME_COST:int=0;

        private static const _instance:MyLife.MyLifeRockPaperScissors=new MyLifeRockPaperScissors();

        public static const PLAY_TURN:int=1;

        public static const LEAVE_GAME:int=2;

        public static const GAME_DONE:int=3;

        private var newGameRequestOpponentServerId:int=0;

        private var newGameDialogRequestColection:Array;

        private var autoIgnoreAllGames:Boolean=false;

        private var newGameRequestDialog:flash.display.MovieClip;

        private var gameRequestIgnoreCount:int=0;

        private var gameCollection:Array;

        private var waitingForMeToAcceptNewGame:Array;
    }
}
