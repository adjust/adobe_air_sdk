/**
 * LogLevel.as
 * LogLevel
 *
 * Created by Andrew Slotin on 2013-11-19.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio {
public class LogLevel {
    public static const VERBOSE: LogLevel = new LogLevel(0);
    public static const DEBUG: LogLevel   = new LogLevel(1);
    public static const INFO: LogLevel    = new LogLevel(2);
    public static const WARN: LogLevel    = new LogLevel(3);
    public static const ERROR: LogLevel   = new LogLevel(4);
    public static const ASSERT: LogLevel  = new LogLevel(5);

    private static var _restrictNewInstances: Boolean = false;
    {
        _restrictNewInstances = true;
    }

    private var _value: int;

    public function LogLevel(level: int) {
        if (_restrictNewInstances) {
            throw new Error("Custom log levels are not allowed.");
        }

        _value = level;
    }

    public function valueOf(): int {
        return _value;
    }
}
}
