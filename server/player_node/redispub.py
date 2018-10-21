#!/usr/bin/env python3
""" redis client """

import json
from twisted.logger import Logger
from txredisapi import RedisProtocol, RedisFactory, ConnectionHandler

log = Logger()

class RedisPubClient(RedisProtocol):
    def connectionMade(self):
        self.factory.client = self
        log.info("Connected")

    def connectionLost(self, reason):
        log.error("Lost connection: {}".format(reason))
        self.factory.client = None

class RedisPubFactory(RedisFactory):
    maxDelay = 10
    protocol = RedisPubClient

    def __init__(self):
        RedisFactory.__init__(self, None, None, 1, isLazy=False, handler=ConnectionHandler)