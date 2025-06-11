# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/javascript/channels', under: 'channels'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin "@rails/actioncable", to: "@rails--actioncable.js" # @8.0.200
pin "channels/consumer", to: "channels/consumer.js"

