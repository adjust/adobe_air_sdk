package {
    public class CommandExecutor {
        private var adjustCommandExecutor:AdjustCommandExecutor;

        public function CommandExecutor(baseUrl:String) {
            adjustCommandExecutor = new AdjustCommandExecutor(baseUrl);
        }

        public function scheduleCommand(className:String, functionName:String, params:Object, order:int):void {
            switch (className) {
                case "Adjust":
                    var command:AdjustCommand = new AdjustCommand(functionName, params, order);
                    adjustCommandExecutor.scheduleCommand(command);
                    break;
            }
        }
    }
}
