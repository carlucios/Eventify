import * as ActionCable from "@rails/actioncable"

ActionCable.logger.enabled = true

const token = window.jwtToken

const consumer = ActionCable.createConsumer(`ws://localhost:3000/cable?token=${token}`)
export default consumer
