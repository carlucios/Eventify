import { application } from "./application"
import NotificationsController from "./notifications_controller"
application.register("notifications", NotificationsController)
import TabsController from "./tabs_controller"
application.register("tabs", TabsController)

