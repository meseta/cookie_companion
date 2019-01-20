#!/usr/bin/env python3
""" Game client """

#import os
#import sys
from twisted.application.service import Application, MultiService
from twisted.application.internet import TCPServer, TCPClient

# add current path to PATH due to twistd not having current path in search
#TWISTED_DIR = os.path.dirname(os.path.abspath(__file__))
#sys.path.append(TWISTED_DIR)

from player import PlayerFactory
from redissub import RedisSubFactory
from redispub import RedisPubFactory

port = 61220
redis_server = "redis"
node_id = "test"

application = Application("playernode")

top = MultiService()

redissub_factory = RedisSubFactory()
redissub_service = TCPClient(redis_server, 6379, redissub_factory)
redissub_service.setServiceParent(top)

redispub_factory = RedisPubFactory()
redispub_service = TCPClient(redis_server, 6379, redispub_factory)
redispub_service.setServiceParent(top)

player_factory = PlayerFactory(port, node_id, redispub_factory, redissub_factory)
player_service = TCPServer(port, player_factory)
player_service.setServiceParent(top)

top.setServiceParent(application)
