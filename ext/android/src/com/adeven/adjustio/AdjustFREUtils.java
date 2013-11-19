/**
 * AdjustFREUtils.java
 * AdjustFREUtils
 *
 * Created by Andrew Slotin on 2013-11-19.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio;

import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class AdjustFREUtils {
    private static FREObject _fre_true;
    private static FREObject _fre_false;

    public static FREObject getFRETrue() {
        if (_fre_true == null) {
            try {
                _fre_true = FREObject.newObject(true);
            } catch (FREWrongThreadException e) {}
        }

        return _fre_true;
    }

    public static FREObject getFREFalse() {
        if (_fre_false == null) {
            try {
                _fre_false = FREObject.newObject(false);
            } catch (FREWrongThreadException e) {}
        }

        return _fre_false;
    }
}
