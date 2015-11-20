require 'broker'
require 'broker/web'

Broker::Application.boot!
run Broker::Web