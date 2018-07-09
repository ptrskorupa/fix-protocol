require 'securerandom'

module Fix
  module Protocol
    module Messages
      class NewOrderSingle < Message
        SIDE_TYPES = {
          buy: 1,
          sell: 2
        }.freeze

        ORDER_TYPE_TYPES = {
          market: '1',
          limit:  '2',
          stop:   '3',
          stop_limit: '4'
        }.freeze

        TIME_IN_FORCE_TYPES = {
          gtc: '1',
          ioc: '3',
          fok: '4',
          post_only: 'P'
        }.freeze

        unordered :body do
          field :handl_inst,    tag: 21, required: true, default: 1
          field :cl_ord_id,     tag: 11, required: true, default: proc { SecureRandom.uuid }
          field :symbol,        tag: 55, required: true
          field :side,          tag: 54, required: true, mapping: SIDE_TYPES
          field :price,         tag: 44, required: true
          field :order_qty,     tag: 38, required: true, type: :qty
          field :ord_type,      tag: 40, required: true, mapping: ORDER_TYPE_TYPES
          field :time_in_force, tag: 59, mapping: TIME_IN_FORCE_TYPES
        end
      end
    end
  end
end
