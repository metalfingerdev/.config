// services/NotificationServer.qml

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
pragma Singleton

Singleton {
    id: root

    readonly property alias raw: server
    // appName, appIcon, summary, body, image, urgency, hasActions, notifId, time, notifObj
    property ListModel list

    list: ListModel {
    }

    property int defaultTimeout: 5000

    signal added(var notification)
    signal removed(int notifId)

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

    Component {
        id: timeoutComponent

        Timer {
            property var notification

            interval: notification && notification.expireTimeout > 0 ? notification.expireTimeout : root.defaultTimeout
            running: true
            onTriggered: {
                root.expire(notification.id);
                destroy();
            }
        }

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
            root.list.append({
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
            timeoutComponent.createObject(root, {
                "notification": notification
            });
        }
    }

}
