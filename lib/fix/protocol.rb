require 'fix/protocol/version'
require 'fix/protocol/message'
require 'fix/protocol/message_class_mapping'
require 'fix/protocol/parse_failure'

#
# Main Fix namespace
#

module Fix

  #
  # Main protocol namespace
  #
  module Protocol
    MSG_REGEX = /(^8\=[^\x01]+\x019\=([^\x01]+)\x01(35\=([^\x01]+)\x01.+))10\=([^\x01]+)\x01$/
    # m[1] msg without checksum
    # m[2] msg length as string
    # m[3] msg body
    # m[4] msg type
    # m[5] msh checksum

    #
    # Parses a string into a Fix::Protocol::Message instance
    #
    # @param str [String] A FIX message string
    # @return [Fix::Protocol::Message] A +Fix::Protocol::Message+ instance, or a +Fix::Protocol::ParseFailure+ in case of failure
    #
    def self.parse(str)
      errors = []
      m = str.match(MSG_REGEX).to_a

      if m.any?
        klass = MessageClassMapping.get(m[4])
        errors << "Unknown message type <#{m[4]}>" unless klass

        # Check message length
        errors << "Incorrect body length, expected <#{m[3].length}>, got <#{m[2].to_i}>" if m[3].length != m[2].to_i

        # Check checksum
        expected = format('%03d', m[1].bytes.inject(&:+) % 256)
        errors << "Incorrect checksum, expected <#{expected}>, got <#{m[5]}>" if m[5] != expected

        msg = klass.parse(str)

        if msg.valid?
          msg
        else
          FP::ParseFailure.new(msg.errors)
        end
      else
        FP::ParseFailure.new("Malformed message <#{str}>")
      end
    end

    def self.alias_namespace!
      Object.const_set(:FP, Protocol) unless Object.const_defined?(:FP)
    end

    def self.camelcase(s)
      s.to_s.split(' ').map { |str| str.split('_') }.flatten.map(&:capitalize).join.to_sym
    end
    #
    # Alias the +Fix::Protocol+ namespace to +FP+ if possible
    #
    def self.alias_namespace!
      Object.const_set(:FP, Protocol) unless Object.const_defined?(:FP)
    end

  end
end

Fix::Protocol.alias_namespace!

