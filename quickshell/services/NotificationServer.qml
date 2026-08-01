// services/NotificationServer.qml

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
pragma Singleton

Singleton {
    // no criticalTimeout — critical notifications persist until dismissed

    id: root

    readonly property alias raw: server
    // appName, appIcon, summary, body, image, urgency, hasActions, notifId, time, notifObj
    property ListModel list
    property int defaultTimeout: 5000
    property int lowTimeout: 3000
    property int normalTimeout: 5000

    signal added(var notification)
    signal removed(int notifId)

    function timeoutFor(notification) {
        if (notification.expireTimeout > 0)
            return notification.expireTimeout * 1000;

        // urgency: 0 = low, 1 = normal, 2 = critical
        switch (notification.urgency) {
        case 2:
            return -1; // never auto-expire
        case 0:
            return root.lowTimeout;
        default:
            return root.normalTimeout;
        }
    }

    function indexOf(notifId) {
        for (let i = 0; i < list.count; i++) {
            if (list.get(i).notifId === notifId)
                return i;

        }
        return -1;
    }

    function expire(notifId) {
        const idx = indexOf(notifId);
        if (idx === -1)
            return ;

        const item = list.get(idx);
        if (item.notifObj)
            item.notifObj.dismiss();

        list.remove(idx);
        root.removed(notifId);
    }

    function dismiss(notifId) {
        expire(notifId);
    }

    function invokeAction(notifId, actionId) {
        const idx = indexOf(notifId);
        if (idx === -1)
            return ;

        const item = list.get(idx);
        for (const action of item.notifObj.actions) {
            if (action.identifier === actionId) {
                action.invoke();
                break;
            }
        }
    }

    function clearAll() {
        for (let i = list.count - 1; i >= 0; i--) {
            const item = list.get(i);
            if (item.notifObj)
                item.notifObj.dismiss();

        }
        list.clear();
    }

    function activate(notifId) {
        const idx = indexOf(notifId);
        if (idx === -1)
            return ;

        const notif = list.get(idx).notifObj;
        if (notif) {
            for (const action of notif.actions) {
                if (action.identifier === "default") {
                    action.invoke();
                    return ;
                }
            }
        }
    }

    function resolveIcon(icon) {
        if (icon === "")
            return "";

        if (icon.startsWith("file://") || icon.startsWith("http://") || icon.startsWith("https://") || icon.startsWith("/"))
            return icon;

        return Quickshell.iconPath(icon, true);
    }

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        imageSupported: true
        persistenceSupported: true
        keepOnReload: true
        onNotification: (notification) => {
            notification.tracked = true;
            root.list.insert(0, {
                "notifId": notification.id,
                "appName": notification.appName,
                "appIcon": notification.appIcon,
                "summary": notification.summary,
                "body": notification.body,
                "image": notification.image,
                "urgency": notification.urgency,
                "hasActions": notification.actions.length > 0,
                "time": Date.now(),
                "notifObj": notification
            });
            root.added(notification);
        }
    }

    list: ListModel {
    }

}
