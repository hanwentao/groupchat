#!/usr/bin/env ruby
# Group chatting on XMPP servers
# Wentao Han (wentao.han@gmail.com)

require 'rubygems'
require 'xmpp4r-simple'

jabber = Jabber::Simple.new('<JID>', '<PASSWORD>')

jabber.roster.wait_for_roster

listener_thread = Thread.new do
  loop do
    if jabber.received_messages?
      jabber.received_messages do |message|
        if message.type == :chat
          sender = message.from.to_s.sub(/\/.*$/, '')
          reply = "#{sender.sub(/@pacman\.cs\.tsinghua\.edu\.cn$/, '')}: #{message.body}"
          jabber.roster.items.each_key do |jid|
            receiver = jid.to_s
            if receiver != sender
              puts "deliver #{reply} from #{sender} to #{receiver}"
              jabber.deliver(receiver, reply)
            end
          end
          puts reply
        end
      end
    end
    sleep 0.1
  end
end
listener_thread.join
