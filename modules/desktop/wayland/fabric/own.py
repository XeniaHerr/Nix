from fabric.core import Application
from fabric.notifications import Notification, Notifications
from gi.repository import GdkPixbuf
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.widgets.box import Box
from fabric.widgets.image import Image
from fabric.widgets.label import Label
from fabric.widgets.button import Button
from fabric.utils import get_relative_path, invoke_repeater
from typing import cast

import os
import json

TIMEOUT = 1000 * 10


class NotificationElem(Box):
    def __init__(self, notification: Notification, file,  **kwargs):
        super().__init__(
            size=(300, -1),
            name="notification",
            spacing=8,
            orientation="v",
            **kwargs
        )

        self.savefile = file
        self._notification = notification

        content = Box(spacing=4, orientation="h")


        # Add Image if notification provides one

        header = Box(
            orientation="h").build().add_style_class("header").unwrap()

        if Npixbuf := self._notification.image_pixbuf:
            header.add(Image(
                pixbuf=Npixbuf.scale_simple(24,24, GdkPixbuf.InterpType.BILINEAR)
            ))

        header.add(Box(
                    orientation="h",
                    children=[Label(
                        label=self._notification.summary,
                        ellipsization="middle",
                    ).build().add_style_class("summary").unwrap(),

                              ],
                    h_expand=True,
                    h_fill=True,
                    v_expand=True
                ).build(lambda box, _: box.pack_end(
                    Button(image=Image(
                        icon_name="dialog-close",
                        icon_size=24,
                    ).build().add_style_class("button").unwrap(),
                           v_align="center",
                           h_align="end",
                           on_clicked=lambda *_: self._notification.close()
                           
                           ),
                    False,
                    False,
                    0,))
                   )
                     

        content.add(
            Box(
                spacing=4,
                orientation="v",
                children=[
                    header,
                    Label(
                        label=self._notification.body,
                        line_wrap="word-char",
                        v_align="start",
                        h_align="start",
                    )
                    .build()
                    .add_style_class("body")
                    .unwrap(),
                ],
                h_expand=True,
            ))

        self.add(content)

        if actions := self._notification.actions:
            self.add(
                Box(
                    spacing=4,
                    orientation="h",
                    children=[
                        Button(
                            h_expand=True,
                            v_expand=True,
                            label=action.label,
                            on_clicked=lambda *_, action=action: action.invoke(),
                        )
                        for action in actions
                    ]
                )
            )
        self._notification.connect(
            "closed",
            lambda *_: (
                parent.remove(self) if (parent := self.get_parent()) else None,
                #self._save_to_file(),
                self.destroy(),
            ),
        )
        invoke_repeater(
            TIMEOUT,
            lambda: 
                self._notification.close("expired") if self._notification.urgency != 2 else None,
            initial_call=False,
        )
    def _save_to_file(self):
        if self.savefile is not None:
            content = self._notification.serialize
            content_as_json = json.dumps(obj=content,skipkeys=True)
            file = open(self.savefile, "r+")
            file.write( content_as_json)

            





if __name__ =="__main__":
    SAVE_NOTIFICATIONS = False
    if TMP_DIR := os.getenv("XDG_RUNTIME_DIR"):
        SAVE_NOTIFICATIONS = True
        savefile = os.path.join(TMP_DIR, "my_notifications.json")
    else:
        savefile  = None
    app = Application(
        "notifications",
        Window(
            margin="60% 0px 0px 0px",
            anchor="top right",
            child=Box(
                size=2,
                spacing=4,
                orientation="v",
            ).build(lambda viewport, _: Notifications(on_notification_added=lambda notif_s, nid: viewport.add(
                NotificationElem(
                    cast(
                        Notification,
                        notif_s.get_notification_from_id(nid),
                    ),
                    savefile
                )

            ))
                    ),
            visible=True,
            all_visible=True,
        )
    )


    app.set_stylesheet_from_file(get_relative_path("./ownstyles.css"))

    app.run()
