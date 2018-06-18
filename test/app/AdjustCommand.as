package {
    public class AdjustCommand {
        public var functionName:String;
        public var params:Object;
        public var order:int;

        public function AdjustCommand(functionName:String, params:Object, order:int) {
            this.functionName = functionName;
            this.params = params;
            this.order = order;
        }
    }
}
