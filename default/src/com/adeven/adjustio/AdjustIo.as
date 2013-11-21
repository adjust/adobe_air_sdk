/**
 * AdjustIo.as
 * AdjustIo
 *
 * Created by Andrew Slotin on 2013-11-19.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio {
import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.InvokeEvent;

public class AdjustIo extends EventDispatcher {
    private static const LOGTAG: String = "AdjustIo SDK: ";
    private static var _instance: AdjustIo;

    private var appToken: String;
    private var environment: String;
    private var logLevel: int;
    private var eventBufferingEnabled: Boolean;

    public function onResume(): Boolean {
        _log("onResume() has been called");

        return true;
    }

    public function onPause(): Boolean {
        _log("onPause() has been called");

        return true;
    }

    public function trackEvent(eventToken: String, parameters: Object = null): Boolean {
        if (parameters) {
            _log("an event with token '" + eventToken + "' has been tracked with parameters", parameters);
        } else {
            _log("an event with token '" + eventToken + "' has been tracked");
        }

        return true;
    }

    public function trackRevenue(amountInCents: Number, eventToken: String = null, parameters: Object = null): Boolean {
        if (! eventToken && parameters) {
            throw new Error("You cannot track revenue parameters without eventToken specified.")
        }

        if (! eventToken) {
            _log("tracked revenue with amount " + amountInCents.toString());
        } else if (! parameters) {
            _log("tracked revenue with amount " + amountInCents.toString() + " with event token '" + eventToken + "'");
        } else {
            _log("tracked revenue with amount " + amountInCents.toString() + " with event token '" + eventToken + "' and parameters", parameters);
        }

        return true;
    }

    public static function initialize(appToken: String, environment: Environment, logLevel: LogLevel = null, eventBufferingEnabled: Boolean = false): void {
        logLevel  ||= LogLevel.INFO;
        _instance ||= new AdjustIo(appToken, environment.valueOf(), logLevel.valueOf(), eventBufferingEnabled, new SingletonEnforcer());
    }

    public static function get instance(): AdjustIo {
        if (! _instance) {
            throw new Error("You need to configure the AdjustIo SDK by calling AdjustIo.initialize() first.");
        }

        return _instance;
    }

    public function dispose(): void {
        _log("disposed");
    }

    public function AdjustIo(appToken: String, environment: String, logLevel: int, eventBufferingEnabled: Boolean, enforcer: SingletonEnforcer) {
        super();

        this.appToken              = appToken;
        this.environment           = environment;
        this.logLevel              = logLevel;
        this.eventBufferingEnabled = eventBufferingEnabled;

        var app: NativeApplication = NativeApplication.nativeApplication;
        app.addEventListener(Event.ACTIVATE, handleActivation);
        app.addEventListener(Event.DEACTIVATE, handleDeactivation);
        app.addEventListener(InvokeEvent.INVOKE, handleAppLaunch)
    }

    protected function handleAppLaunch(event: Event): void {
        _log("initialized with app token '" + appToken + "'");
        _log("using " + environment + " environment");
        _log("log level is set to " + logLevel);
        _log("event buffering is " + (eventBufferingEnabled ? "enabled" : "disabled"));
    }

    protected function handleActivation(event: Event): void {
        onResume();
    }

    protected function handleDeactivation(event: Event): void {
        onPause();
    }

    private function _log(message: String, ...rest): void {
        trace.apply(null, [LOGTAG + message].concat(rest));
    }
}
}

internal class SingletonEnforcer {}
