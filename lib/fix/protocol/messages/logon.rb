module Fix
  module Protocol
    module Messages

      #
      # A FIX logon message
      #
      class Logon < Message

        has_field :encrypt_method,      tag: 98,  required: true, type: :integer, default: 0
        has_field :heart_bt_int,        tag: 108, required: true, type: :integer, default: 30
        has_field :username,            tag: 553, required: true
        has_field :reset_seq_num_flag,  tag: 141

        #
        # Validates the correctness of a FIX logon message
        #
        def validate(force = false)
          super(force)
          errors << "Encryption is not supported, the transport level should handle it" unless (encrypt_method == 0)
          errors << "Heartbeat interval should be between 10 and 60 seconds"            unless heart_bt_int && heart_bt_int <= 60 && heart_bt_int >= 10
        end

      end
    end
  end
end
