/**
 * Environment.as
 * Environment
 *
 * Created by Andrew Slotin on 2013-11-19.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio {
public class Environment {
    public static const SANDBOX: Environment    = new Environment("sandbox");
    public static const PRODUCTION: Environment = new Environment("production");

    private static var _restrictNewInstances: Boolean = false;
    {
        _restrictNewInstances = true;
    }

    private var _value: String;

    public function Environment(env: String) {
        if (_restrictNewInstances) {
            throw new Error("Custom environments are not allowed.");
        }

        _value = env;
    }

    public function valueOf(): String {
        return _value;
    }
}
}
