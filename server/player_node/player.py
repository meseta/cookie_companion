#!/usr/bin/env python3
""" Player client """

import time
import json
import random
from datetime import datetime, timedelta
from twisted.application.service import Service, Application
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver
from twisted.internet.task import LoopingCall
from twisted.logger import Logger

#HUB = "http://manager:61330"
log = Logger()
#TIMEOUT = 60*20

class PlayerClient(LineReceiver):
    """ A connected player client """
    def __init__(self, factory):
        self.factory = factory # reference back to factor, which contains client list
        self.ip = None
        self.port = None
        self.delimiter = b'\0'
        self.functions = {
            "handshake": self.rpc_handshake,
            "login": self.rpc_login,
            "ping": self.rpc_ping,
            "move": self.rpc_move,
            "event": self.rpc_event,
            "mouse": self.rpc_mouse
        }
        self.username = ""
        self.character_class = 0
        self.userid = str(int(random.getrandbits(31))+1)
        self.moveloop_handle = LoopingCall(self.move_loop)
        self.statusloop_handle = LoopingCall(self.status_loop)

        self.moveupdate = {}
        self.mouseupdate = {}
        self.statusupdate = {}

    def connectionMade(self):
        self.factory.clients.append(self) # add client to list
        self.ip, self.port = self.transport.client
        log.info("Client connected ip: {}".format(self.ip))
        self.transport.setTcpNoDelay(True) # turn off Naggle's algorithm

        # register sub callbacks
        self.factory.redissub_factory.client.register_callback(self, "movepub", self.redis_movepub)
        self.factory.redissub_factory.client.register_callback(self, "alivepub", self.redis_alivepub)
        self.factory.redissub_factory.client.register_callback(self, "eventpub", self.redis_eventpub)
        self.factory.redissub_factory.client.register_callback(self, "mousepub", self.redis_mousepub)

        self.moveloop_handle.start(0.1)
        self.statusloop_handle.start(0.5)

    def lineReceived(self, line):
        #log.debug("Client: {} sent {}".format(self.ip, len(line)))

        data = json.loads(line)
        self.execute_rpc(data)

    def execute_rpc(self, data):
        if "params" in data and data["method"] in self.functions:
            retval = self.functions[data["method"]](data["params"])
            if "id" in data:
                reply = {
                    "id": data["id"],
                    "results": retval
                }
                self.sendLine(str.encode(json.dumps(reply)))
        else:
            log.warn("Received unknown RPC {}".format(data))

    def rpc_handshake(self, params):
        return 1

    def rpc_login(self, params):
        if len(params) == 1:
            self.username = params[0]
            log.info("Login username {} userid {}".format(self.username, self.userid))
            return self.userid
        return 0

    def rpc_ping(self, params):
        self.factory.redispub_factory.client.publish("alivepub", json.dumps(params))
        return params[-1]

    def rpc_event(self, params):
        self.factory.redispub_factory.client.publish("eventpub", json.dumps(params))

    def rpc_move(self, params):
        self.factory.redispub_factory.client.publish("movepub", json.dumps(params))

    def rpc_mouse(self, params):
        self.factory.redispub_factory.client.publish("mousepub", json.dumps(params))

    def redis_movepub(self, message):
        data = json.loads(message)
        id = data[0]
        if id != self.userid:
            #log.debug("Got movement for unit {}".format(id))
            self.moveupdate[id] = data

    def redis_alivepub(self, message):
        data = json.loads(message)
        id = data[0]
        if id != self.userid:
            #log.debug("Got username for unit {}".format(id))
            self.statusupdate[id] = data

    def redis_eventpub(self, message):
        data = json.loads(message)
        id = data[0]
        if id != self.userid:
            log.debug("Got attack for unit {}".format(id))
            rpc = {
                "method": "eventtrigger",
                "params": json.dumps(data)
            }
            rpc_str = json.dumps(rpc)
            self.sendLine(str.encode(rpc_str))

    def redis_mousepub(self, message):
        data = json.loads(message)
        id = data[0]
        mouse_id = data[1]
        if id != self.userid:
            #log.debug("Got movement for unit {}".format(id))
            self.mouseupdate[mouse_id] = data

    def move_loop(self):
        rpc = {
            "method": "moveupdate",
            "params": json.dumps(self.moveupdate)
        }
        rpc_str = json.dumps(rpc)
        self.moveupdate = {}
        self.sendLine(str.encode(rpc_str))

        rpc = {
            "method": "mouseupdate",
            "params": json.dumps(self.mouseupdate)
        }
        rpc_str = json.dumps(rpc)
        self.mouseupdate = {}
        self.sendLine(str.encode(rpc_str))

    def status_loop(self):
        rpc = {
            "method": "statusupdate",
            "params": json.dumps(self.statusupdate)
        }
        rpc_str = json.dumps(rpc)
        self.statusupdate = {}
        self.sendLine(str.encode(rpc_str))
        #log.debug("Sent statusupdate")

    def connectionLost(self, reason=None):
        self.factory.clients.remove(self) # remove from client list
        log.info("Client disconnect ip: {}".format(self.ip))
        self.factory.redissub_factory.client.unregister_client(self)
        if self.moveloop_handle.running:
            self.moveloop_handle.stop()
        if self.statusloop_handle.running:
            self.statusloop_handle.stop()

class PlayerFactory(Factory):
    """ Relay factor, contains all client list """
    def __init__(self, port, node_id, redispub_factory, redissub_factory): # initialise internal client list
        self.clients = []
        self.port = port
        self.node_id = node_id
        self.redissub_factory = redissub_factory
        self.redispub_factory = redispub_factory
    #     self.loop_q = LoopingCall(self.quit_detector)
    #     self.loop_q.start(10)
    #
    # def quit_detector(self):
    #     """ detect client disconnect """
    #     if (self.clients_entered and not self.clients) or \
    #     (not self.clients_entered and self.timeout < datetime.now()):
    #         log.info("No clients connected, ready to shut down: {}".format(self.quit_countdown))
    #         self.quit_countdown += 1
    #         if self.quit_countdown > 12:
    #             self.loop_r.stop() # stop reporting
    #             from twisted.internet import reactor
    #             reactor.callLater(2, reactor.stop) #buffer 2 seconds to avoid deletion then PUT
    #     else:
    #         self.quit_countdown = 0

    def buildProtocol(self, addr):
        return PlayerClient(self)

class PlayerService(Service):
    """ service controller """
    def __init__(self, port, node_id):
        # load some configs or something
        self.port = port
        self.node_id = node_id

    def startService(self):
        # announce to matchmaker that server is activae
        # try:
        #     res = requests.post(HUB+"/api/v1.0/register", json={"port": self.port, "id": self.node_id}, timeout=10)
        # except requests.exceptions.RequestException as e:
        #     log.error("Could not notify hub due to request error: {}".format(e))
        # else:
        #     log.info("Service start, notified hub with code {}".format(res.status_code))
        Service.startService(self)

    def stopService(self):
        # annoince to matchmaker that server is shut down
        # try:
        #     res = requests.delete(HUB+"/api/v1.0/register", json={"port": self.port, "id": self.node_id}, timeout=2)
        # except requests.exceptions.RequestException as e:
        #     log.error("Could not notify hub due to request error: {}".format(e))
        # else:
        #     log.info("Service stop, notified hub with code {}".format(res.status_code))
        Service.stopService(self)
