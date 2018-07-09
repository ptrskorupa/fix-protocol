module Fix
  module Protocol
    module Messages
      class ExecutionReport < Message
        EXEC_TYPES = {
          new_order: '0',
          fill: '1',
          done: '3',
          cancelled: '4',
          stopped: '7',
          rejected: '8',
          order_changed: 'D',
          order_status: 'I'
        }.freeze

        ORD_REJ_REASON_TYPES = {
          insufficient_funds: 3,
          post_only: 8,
          unknown_error: 0
        }.freeze

        unordered :body do
          # common fields
          field :cl_ord_id,     tag: 11
          field :exec_id,       tag: 17
          field :exec_trans_type, tag: 20
          field :order_id,      tag: 37
          field :symbol,        tag: 55
          field :side,          tag: 54
          field :last_shares,   tag: 32, type: :qty
          field :price,         tag: 44, type: :price #, required: true
          field :order_qty,     tag: 38, type: :qty
          field :transact_time, tag: 60, type: :timestamp
          field :exec_type,     tag: 150, mapping: EXEC_TYPES
          field :ord_status,    tag: 39
          field :ord_rej_reason, tag: 103, mapping: ORD_REJ_REASON_TYPES
          field :trade_id, tag: 1003
          field :aggressor_indicator, tag: 1057
        end
      end
    end
  end
end
