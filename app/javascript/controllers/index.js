// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import NotificationsController from "controllers/notifications_controller"
import TabsController from "controllers/tabs_controller"

application.register("notifications", NotificationsController)
application.register("tabs", TabsController)
