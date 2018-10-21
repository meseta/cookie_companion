#!/usr/bin/env python3
""" redis client """

import json
from twisted.logger import Logger
from txredisapi import SubscriberProtocol, SubscriberFactory

log = Logger()

class RedisSubClient(SubscriberProtocol):
    def connectionMade(self):
        self.factory.client = self
        log.info("Connected")
        self.callbacks = {}

    def unregister_client(self, unclient):
        for channel_name, channel_callbacks in self.callbacks.items():
            delete = None
            for idx, reg in enumerate(channel_callbacks):
                (client, callback) = reg
                if client == unclient:
                    delete = reg
                    break

            if delete:
                log.debug("Client unregistered callback {}".format(channel_name))
                channel_callbacks.remove(delete)

    def register_callback(self, client, channel, callback):
        if channel not in self.callbacks:
            self.callbacks[channel] = []
            self.subscribe(channel)
        if callback not in self.callbacks[channel]:
            self.callbacks[channel].append((client, callback))
            log.debug("Client registered callback on {}".format(channel))

    def messageReceived(self, pattern, channel, message):
        #log.info("pattern=%s, channel=%s message=%s" % (pattern, channel, message))
        if channel in self.callbacks:
            for client, callback in self.callbacks[channel]:
                callback(message)

    def connectionLost(self, reason):
        log.error("Lost connection: {}".format(reason))
        self.factory.client = None

class RedisSubFactory(SubscriberFactory):
    maxDelay = 10
    continueTrying = True
    protocol = RedisSubClient