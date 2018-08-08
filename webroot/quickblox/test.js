/* QuickBlox JavaScript SDK - v2.1.1 - 2016-03-15 */ ! function(a) {
    if ("object" == typeof exports && "undefined" != typeof module) module.exports = a();
    else if ("function" == typeof define && define.amd) define([], a);
    else {
        var b;
        b = "undefined" != typeof window ? window : "undefined" != typeof global ? global : "undefined" != typeof self ? self : this, b.QB = a()
    }
}(function() {
    var a;
    return function b(a, c, d) {
        function e(g, h) {
            if (!c[g]) {
                if (!a[g]) {
                    var i = "function" == typeof require && require;
                    if (!h && i) return i(g, !0);
                    if (f) return f(g, !0);
                    var j = new Error("Cannot find module '" + g + "'");
                    throw j.code = "MODULE_NOT_FOUND", j
                }
                var k = c[g] = {
                    exports: {}
                };
                a[g][0].call(k.exports, function(b) {
                    var c = a[g][1][b];
                    return e(c ? c : b)
                }, k, k.exports, b, a, c, d)
            }
            return c[g].exports
        }
        for (var f = "function" == typeof require && require, g = 0; g < d.length; g++) e(d[g]);
        return e
    }({
        1: [function(a, b, c) {
            function d(a) {
                this.service = a
            }

            function e(a) {
                var b = {
                    application_id: g.creds.appId,
                    auth_key: g.creds.authKey,
                    nonce: h.randomNonce(),
                    timestamp: h.unixTime()
                };
                return a.login && a.password ? b.user = {
                    login: a.login,
                    password: a.password
                } : a.email && a.password ? b.user = {
                    email: a.email,
                    password: a.password
                } : a.provider && (b.provider = a.provider, a.scope && (b.scope = a.scope), a.keys && a.keys.token && (b.keys = {
                    token: a.keys.token
                }), a.keys && a.keys.secret && (b.keys.secret = a.keys.secret)), b
            }

            function f(a, b) {
                var c = Object.keys(a).map(function(b) {
                    return "object" == typeof a[b] ? Object.keys(a[b]).map(function(c) {
                        return b + "[" + c + "]=" + a[b][c]
                    }).sort().join("&") : b + "=" + a[b]
                }).sort().join("&");
                return i(c, b).toString()
            }
            var g = a("../qbConfig"),
                h = a("../qbUtils"),
                i = a("crypto-js/hmac-sha1");
            d.prototype = {
                getSession: function(a) {
                    h.QBLog("[AuthProxy]", "getSession"), this.service.ajax({
                        url: h.getUrl(g.urls.session)
                    }, function(b, c) {
                        b ? a(b, null) : a(b, c)
                    })
                },
                createSession: function(a, b) {
                    if ("" === g.creds.appId || "" === g.creds.authKey || "" === g.creds.authSecret) throw new Error("Cannot create a new session without app credentials (app ID, auth key and auth secret)");
                    var c, d = this;
                    "function" == typeof a && "undefined" == typeof b && (b = a, a = {}), c = e(a), c.signature = f(c, g.creds.authSecret), h.QBLog("[AuthProxy]", "createSession", c), this.service.ajax({
                        url: h.getUrl(g.urls.session),
                        type: "POST",
                        data: c
                    }, function(a, c) {
                        a ? b(a, null) : (d.service.setSession(c.session), b(null, c.session))
                    })
                },
                destroySession: function(a) {
                    var b = this;
                    h.QBLog("[AuthProxy]", "destroySession"), this.service.ajax({
                        url: h.getUrl(g.urls.session),
                        type: "DELETE",
                        dataType: "text"
                    }, function(c, d) {
                        c ? a(c, null) : (b.service.setSession(null), a(null, d))
                    })
                },
                login: function(a, b) {
                    h.QBLog("[AuthProxy]", "login", a), this.service.ajax({
                        url: h.getUrl(g.urls.login),
                        type: "POST",
                        data: a
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c.user)
                    })
                },
                logout: function(a) {
                    h.QBLog("[AuthProxy]", "logout"), this.service.ajax({
                        url: h.getUrl(g.urls.login),
                        type: "DELETE",
                        dataType: "text"
                    }, a)
                }
            }, b.exports = d
        }, {
            "../qbConfig": 15,
            "../qbUtils": 19,
            "crypto-js/hmac-sha1": 27
        }],
        2: [function(a, b, c) {
            function d(a, b, c) {
                var d = this;
                r = b, q = c, this.service = a, o && (this.roster = new e(a), this.muc = new f(a), this.privacylist = new g(a), this._isLogout = !1, this._isDisconnected = !1), this.dialog = new h(a), this.message = new i(a), this.helpers = new j, this._onMessage = function(a) {
                    var b = a.getAttribute("from"),
                        c = (a.getAttribute("to"), a.getAttribute("type")),
                        e = a.querySelector("body"),
                        f = a.querySelector("markable"),
                        g = a.querySelector("received"),
                        h = a.querySelector("displayed"),
                        i = a.querySelector("composing"),
                        j = a.querySelector("paused"),
                        k = a.querySelector("invite"),
                        l = a.querySelector("extraParams"),
                        m = a.querySelector("delay"),
                        o = a.getAttribute("id"),
                        p = "groupchat" === c ? d.helpers.getDialogIdFromNode(b) : null,
                        r = "groupchat" === c ? d.helpers.getIdFromResource(b) : d.helpers.getIdFromNode(b),
                        s = g || h || null;
                    if (k) return !0;
                    var t;
                    if (l && (t = d._parseExtraParams(l), t.dialogId && (p = t.dialogId)), i || j) return "function" != typeof d.onMessageTypingListener || "chat" !== c && "groupchat" !== c && m || n.safeCallbackCall(d.onMessageTypingListener, null != i, r, p), !0;
                    if (s) return g ? "function" == typeof d.onDeliveredStatusListener && "chat" === c && n.safeCallbackCall(d.onDeliveredStatusListener, g.getAttribute("id"), p, r) : "function" == typeof d.onReadStatusListener && "chat" === c && n.safeCallbackCall(d.onReadStatusListener, h.getAttribute("id"), p, r), !0;
                    if (f && r != d.helpers.getIdFromNode(q.jid)) {
                        var u = {
                            messageId: o,
                            userId: r,
                            dialogId: p
                        };
                        d.sendDeliveredStatus(u)
                    }
                    var v = {
                        id: o,
                        dialog_id: p,
                        type: c,
                        body: e && e.textContent || null,
                        extension: t ? t.extension : null,
                        delay: m
                    };
                    return f && (v.markable = 1), "function" != typeof d.onMessageListener || "chat" !== c && "groupchat" !== c || n.safeCallbackCall(d.onMessageListener, r, v), !0
                }, this._onPresence = function(a) {
                    var b = a.getAttribute("from"),
                        c = a.getAttribute("type"),
                        e = d.helpers.getIdFromNode(b);
                    if (c) switch (c) {
                        case "subscribe":
                            u[e] && "to" === u[e].subscription ? (u[e] = {
                                subscription: "both",
                                ask: null
                            }, d.roster._sendSubscriptionPresence({
                                jid: b,
                                type: "subscribed"
                            })) : "function" == typeof d.onSubscribeListener && n.safeCallbackCall(d.onSubscribeListener, e);
                            break;
                        case "subscribed":
                            u[e] && "from" === u[e].subscription ? u[e] = {
                                subscription: "both",
                                ask: null
                            } : (u[e] = {
                                subscription: "to",
                                ask: null
                            }, "function" == typeof d.onConfirmSubscribeListener && n.safeCallbackCall(d.onConfirmSubscribeListener, e));
                            break;
                        case "unsubscribed":
                            u[e] = {
                                subscription: "none",
                                ask: null
                            }, "function" == typeof d.onRejectSubscribeListener && n.safeCallbackCall(d.onRejectSubscribeListener, e);
                            break;
                        case "unsubscribe":
                            u[e] = {
                                subscription: "to",
                                ask: null
                            };
                            break;
                        case "unavailable":
                            "function" == typeof d.onContactListListener && u[e] && "none" !== u[e].subscription && n.safeCallbackCall(d.onContactListListener, e, c)
                    } else "function" == typeof d.onContactListListener && u[e] && "none" !== u[e].subscription && n.safeCallbackCall(d.onContactListListener, e);
                    return !0
                }, this._onIQ = function(a) {
                    return !0
                }, this._onSystemMessageListener = function(a) {
                    var b, c = a.getAttribute("from"),
                        e = (a.getAttribute("to"), a.querySelector("extraParams")),
                        f = e.querySelector("moduleIdentifier").textContent,
                        g = (a.querySelector("delay"), a.getAttribute("id"));
                    if ("SystemNotifications" === f && "function" == typeof d.onSystemMessageListener) {
                        var h = d._parseExtraParams(e);
                        b = {
                            id: g,
                            userId: d.helpers.getIdFromNode(c),
                            extension: h.extension
                        }, n.safeCallbackCall(d.onSystemMessageListener, b)
                    }
                    return !0
                }, this._onMessageErrorListener = function(a) {
                    var b = a.getAttribute("id"),
                        c = k(a);
                    return "function" == typeof d.onMessageErrorListener && n.safeCallbackCall(d.onMessageErrorListener, b, c), !0
                }
            }

            function e(a) {
                this.service = a, this.helpers = new j
            }

            function f(a) {
                this.service = a, this.helpers = new j
            }

            function g(a) {
                this.service = a, this.helpers = new j
            }

            function h(a) {
                this.service = a, this.helpers = new j
            }

            function i(a) {
                this.service = a, this.helpers = new j
            }

            function j() {}

            function k(a) {
                var b = a.getElementsByTagName("error")[0],
                    c = parseInt(b.getAttribute("code")),
                    d = b.getElementsByTagName("text")[0].textContent;
                return n.getError(c, d)
            }

            function l() {
                return (new Date).toTimeString().split(" ")[0]
            }
            var m = a("../qbConfig"),
                n = a("../qbUtils"),
                o = "undefined" != typeof window,
                p = "This function isn't supported outside of the browser (...yet)";
            o && (a("strophe"), Strophe.addNamespace("CARBONS", "urn:xmpp:carbons:2"), Strophe.addNamespace("CHAT_MARKERS", "urn:xmpp:chat-markers:0"), Strophe.addNamespace("PRIVACY_LIST", "jabber:iq:privacy"), Strophe.addNamespace("CHAT_STATES", "http://jabber.org/protocol/chatstates"));
            var q, r, s = m.urls.chat + "/Dialog",
                t = m.urls.chat + "/Message",
                u = {},
                v = {};
            d.prototype = {
                connect: function(a, b) {
                    if (!o) throw p;
                    n.QBLog("[ChatProxy]", "connect", a);
                    var c, d, e, f = this;
                    "userId" in a ? (e = a.userId + "-" + m.creds.appId + "@" + m.endpoints.chat, "resource" in a && (e = e + "/" + a.resource)) : "jid" in a && (e = a.jid), q.connect(e, a.password, function(e) {
                        switch (e) {
                            case Strophe.Status.ERROR:
                                c = n.getError(422, "Status.ERROR - An error has occurred"), "function" == typeof b && b(c, null);
                                break;
                            case Strophe.Status.CONNECTING:
                                n.QBLog("[ChatProxy]", "Status.CONNECTING"), n.QBLog("[ChatProxy]", "Chat Protocol - " + (1 === m.chatProtocol.active ? "BOSH" : "WebSocket"));
                                break;
                            case Strophe.Status.CONNFAIL:
                                c = n.getError(422, "Status.CONNFAIL - The connection attempt failed"), "function" == typeof b && b(c, null);
                                break;
                            case Strophe.Status.AUTHENTICATING:
                                n.QBLog("[ChatProxy]", "Status.AUTHENTICATING");
                                break;
                            case Strophe.Status.AUTHFAIL:
                                c = n.getError(401, "Status.AUTHFAIL - The authentication attempt failed"), "function" == typeof b && b(c, null);
                                break;
                            case Strophe.Status.CONNECTED:
                                n.QBLog("[ChatProxy]", "Status.CONNECTED at " + l()), f._isDisconnected = !1, q.addHandler(f._onMessage, null, "message", "chat"), q.addHandler(f._onMessage, null, "message", "groupchat"), q.addHandler(f._onPresence, null, "presence"), q.addHandler(f._onIQ, null, "iq"), q.addHandler(f._onSystemMessageListener, null, "message", "headline"), q.addHandler(f._onMessageErrorListener, null, "message", "error"), r && q.addHandler(r._onMessage, null, "message", "headline"), f._enableCarbons(function() {
                                    f.roster.get(function(a) {
                                        if (u = a, q.send($pres().tree()), q.addTimedHandler(55e3, f._autoSendPresence), "function" == typeof b) b(null, u);
                                        else {
                                            f._isLogout = !1, d = Object.keys(v);
                                            for (var c = 0, e = d.length; e > c; c++) f.muc.join(d[c]);
                                            "function" == typeof f.onReconnectListener && n.safeCallbackCall(f.onReconnectListener)
                                        }
                                    })
                                });
                                break;
                            case Strophe.Status.DISCONNECTING:
                                n.QBLog("[ChatProxy]", "Status.DISCONNECTING");
                                break;
                            case Strophe.Status.DISCONNECTED:
                                n.QBLog("[ChatProxy]", "Status.DISCONNECTED at " + l()), q.reset(), f._isDisconnected || "function" != typeof f.onDisconnectedListener || n.safeCallbackCall(f.onDisconnectedListener), f._isDisconnected = !0, f._isLogout || f.connect(a);
                                break;
                            case Strophe.Status.ATTACHED:
                                n.QBLog("[ChatProxy]", "Status.ATTACHED")
                        }
                    })
                },
                send: function(a, b) {
                    if (!o) throw p;
                    b.id || (b.id = n.getBsonObjectId());
                    var c = this,
                        d = $msg({
                            from: q.jid,
                            to: this.helpers.jidOrUserId(a),
                            type: b.type,
                            id: b.id
                        });
                    b.body && d.c("body", {
                        xmlns: Strophe.NS.CLIENT
                    }).t(b.body).up(), b.extension && (d.c("extraParams", {
                        xmlns: Strophe.NS.CLIENT
                    }), Object.keys(b.extension).forEach(function(a) {
                        "attachments" === a ? b.extension[a].forEach(function(a) {
                            d.c("attachment", a).up()
                        }) : "object" == typeof b.extension[a] ? c._JStoXML(a, b.extension[a], d) : d.c(a).t(b.extension[a]).up()
                    }), d.up()), b.markable && d.c("markable", {
                        xmlns: Strophe.NS.CHAT_MARKERS
                    }), q.send(d)
                },
                sendSystemMessage: function(a, b) {
                    if (!o) throw p;
                    b.id || (b.id = n.getBsonObjectId());
                    var c = this,
                        d = $msg({
                            id: b.id,
                            type: "headline",
                            to: this.helpers.jidOrUserId(a)
                        });
                    b.extension && (d.c("extraParams", {
                        xmlns: Strophe.NS.CLIENT
                    }).c("moduleIdentifier").t("SystemNotifications").up(), Object.keys(b.extension).forEach(function(a) {
                        "object" == typeof b.extension[a] ? c._JStoXML(a, b.extension[a], d) : d.c(a).t(b.extension[a]).up()
                    }), d.up()), q.send(d)
                },
                sendIsTypingStatus: function(a) {
                    if (!o) throw p;
                    var b = $msg({
                        from: q.jid,
                        to: this.helpers.jidOrUserId(a),
                        type: this.helpers.typeChat(a)
                    });
                    b.c("composing", {
                        xmlns: Strophe.NS.CHAT_STATES
                    }), q.send(b)
                },
                sendIsStopTypingStatus: function(a) {
                    if (!o) throw p;
                    var b = $msg({
                        from: q.jid,
                        to: this.helpers.jidOrUserId(a),
                        type: this.helpers.typeChat(a)
                    });
                    b.c("paused", {
                        xmlns: Strophe.NS.CHAT_STATES
                    }), q.send(b)
                },
                sendPres: function(a) {
                    if (!o) throw p;
                    q.send($pres({
                        from: q.jid,
                        type: a
                    }))
                },
                sendDeliveredStatus: function(a) {
                    if (!o) throw p;
                    var b = $msg({
                        from: q.jid,
                        to: this.helpers.jidOrUserId(a.userId),
                        type: "chat",
                        id: n.getBsonObjectId()
                    });
                    b.c("received", {
                        xmlns: Strophe.NS.CHAT_MARKERS,
                        id: a.messageId
                    }).up(), b.c("extraParams", {
                        xmlns: Strophe.NS.CLIENT
                    }).c("dialog_id").t(a.dialogId), q.send(b)
                },
                sendReadStatus: function(a) {
                    if (!o) throw p;
                    var b = $msg({
                        from: q.jid,
                        to: this.helpers.jidOrUserId(a.userId),
                        type: "chat",
                        id: n.getBsonObjectId()
                    });
                    b.c("displayed", {
                        xmlns: Strophe.NS.CHAT_MARKERS,
                        id: a.messageId
                    }).up(), b.c("extraParams", {
                        xmlns: Strophe.NS.CLIENT
                    }).c("dialog_id").t(a.dialogId), q.send(b)
                },
                disconnect: function() {
                    if (!o) throw p;
                    v = {}, this._isLogout = !0, q.flush(), q.disconnect()
                },
                addListener: function(a, b) {
                    function c() {
                        return b(), a.live !== !1
                    }
                    if (!o) throw p;
                    return q.addHandler(c, null, a.name || null, a.type || null, a.id || null, a.from || null)
                },
                deleteListener: function(a) {
                    if (!o) throw p;
                    q.deleteHandler(a)
                },
                _JStoXML: function(a, b, c) {
                    var d = this;
                    c.c(a), Object.keys(b).forEach(function(a) {
                        "object" == typeof b[a] ? d._JStoXML(a, b[a], c) : c.c(a).t(b[a]).up()
                    }), c.up()
                },
                _XMLtoJS: function(a, b, c) {
                    var d = this;
                    a[b] = {};
                    for (var e = 0, f = c.childNodes.length; f > e; e++) c.childNodes[e].childNodes.length > 1 ? a[b] = d._XMLtoJS(a[b], c.childNodes[e].tagName, c.childNodes[e]) : a[b][c.childNodes[e].tagName] = c.childNodes[e].textContent;
                    return a
                },
                _parseExtraParams: function(a) {
                    if (!a) return null;
                    for (var b, c = {}, d = [], e = 0, f = a.childNodes.length; f > e; e++)
                        if ("attachment" === a.childNodes[e].tagName) {
                            for (var g = {}, h = a.childNodes[e].attributes, i = 0, j = h.length; j > i; i++) g[h[i].name] = h[i].value;
                            d.push(g)
                        } else if ("dialog_id" === a.childNodes[e].tagName) b = a.childNodes[e].textContent, c.dialog_id = b;
                    else if (a.childNodes[e].childNodes.length > 1) {
                        var k = a.childNodes[e].textContent.length;
                        if (k > 4096) {
                            for (var l = "", i = 0; i < a.childNodes[e].childNodes.length; ++i) l += a.childNodes[e].childNodes[i].textContent;
                            c[a.childNodes[e].tagName] = l
                        } else c = self._XMLtoJS(c, a.childNodes[e].tagName, a.childNodes[e])
                    } else c[a.childNodes[e].tagName] = a.childNodes[e].textContent;
                    return d.length > 0 && (c.attachments = d), c.moduleIdentifier && delete c.moduleIdentifier, {
                        extension: c,
                        dialogId: b
                    }
                },
                _autoSendPresence: function() {
                    if (!o) throw p;
                    return q.send($pres().tree()), !0
                },
                _enableCarbons: function(a) {
                    if (!o) throw p;
                    var b;
                    b = $iq({
                        from: q.jid,
                        type: "set",
                        id: q.getUniqueId("enableCarbons")
                    }).c("enable", {
                        xmlns: Strophe.NS.CARBONS
                    }), q.sendIQ(b, function(b) {
                        a()
                    })
                }
            }, e.prototype = {
                get: function(a) {
                    var b, c, d, e = this,
                        f = {};
                    b = $iq({
                        from: q.jid,
                        type: "get",
                        id: q.getUniqueId("getRoster")
                    }).c("query", {
                        xmlns: Strophe.NS.ROSTER
                    }), q.sendIQ(b, function(b) {
                        c = b.getElementsByTagName("item");
                        for (var g = 0, h = c.length; h > g; g++) d = e.helpers.getIdFromNode(c[g].getAttribute("jid")).toString(), f[d] = {
                            subscription: c[g].getAttribute("subscription"),
                            ask: c[g].getAttribute("ask") || null
                        };
                        a(f)
                    })
                },
                add: function(a, b) {
                    var c = this,
                        d = this.helpers.jidOrUserId(a),
                        e = this.helpers.getIdFromNode(d).toString();
                    u[e] = {
                        subscription: "none",
                        ask: "subscribe"
                    }, c._sendSubscriptionPresence({
                        jid: d,
                        type: "subscribe"
                    }), "function" == typeof b && b()
                },
                confirm: function(a, b) {
                    var c = this,
                        d = this.helpers.jidOrUserId(a),
                        e = this.helpers.getIdFromNode(d).toString();
                    u[e] = {
                        subscription: "from",
                        ask: "subscribe"
                    }, c._sendSubscriptionPresence({
                        jid: d,
                        type: "subscribed"
                    }), c._sendSubscriptionPresence({
                        jid: d,
                        type: "subscribe"
                    }), "function" == typeof b && b()
                },
                reject: function(a, b) {
                    var c = this,
                        d = this.helpers.jidOrUserId(a),
                        e = this.helpers.getIdFromNode(d).toString();
                    u[e] = {
                        subscription: "none",
                        ask: null
                    }, c._sendSubscriptionPresence({
                        jid: d,
                        type: "unsubscribed"
                    }), "function" == typeof b && b()
                },
                remove: function(a, b) {
                    var c, d = this.helpers.jidOrUserId(a),
                        e = this.helpers.getIdFromNode(d).toString();
                    c = $iq({
                        from: q.jid,
                        type: "set",
                        id: q.getUniqueId("removeRosterItem")
                    }).c("query", {
                        xmlns: Strophe.NS.ROSTER
                    }).c("item", {
                        jid: d,
                        subscription: "remove"
                    }), q.sendIQ(c, function() {
                        delete u[e], "function" == typeof b && b()
                    })
                },
                _sendSubscriptionPresence: function(a) {
                    var b;
                    b = $pres({
                        to: a.jid,
                        type: a.type
                    }), q.send(b)
                }
            }, f.prototype = {
                join: function(a, b) {
                    var c, d = this,
                        e = q.getUniqueId("join");
                    v[a] = !0, c = $pres({
                        from: q.jid,
                        to: d.helpers.getRoomJid(a),
                        id: e
                    }).c("x", {
                        xmlns: Strophe.NS.MUC
                    }).c("history", {
                        maxstanzas: 0
                    }), "function" == typeof b && q.addHandler(b, null, "presence", null, e), q.send(c)
                },
                leave: function(a, b) {
                    var c, d = this,
                        e = d.helpers.getRoomJid(a);
                    delete v[a], c = $pres({
                        from: q.jid,
                        to: e,
                        type: "unavailable"
                    }), "function" == typeof b && q.addHandler(b, null, "presence", "unavailable", null, e), q.send(c)
                },
                listOnlineUsers: function(a, b) {
                    var c, d = this,
                        e = [];
                    c = $iq({
                        from: q.jid,
                        id: q.getUniqueId("muc_disco_items"),
                        to: a,
                        type: "get"
                    }).c("query", {
                        xmlns: "http://jabber.org/protocol/disco#items"
                    }), q.sendIQ(c, function(a) {
                        for (var c, f = a.getElementsByTagName("item"), g = 0, h = f.length; h > g; g++) c = d.helpers.getUserIdFromRoomJid(f[g].getAttribute("jid")), e.push(c);
                        b(e)
                    })
                }
            }, g.prototype = {
                getNames: function(a) {
                    var b = $iq({
                        from: q.jid,
                        type: "get",
                        id: q.getUniqueId("getNames")
                    }).c("query", {
                        xmlns: Strophe.NS.PRIVACY_LIST
                    });
                    q.sendIQ(b, function(b) {
                        for (var c = [], d = {}, e = b.getElementsByTagName("default"), f = b.getElementsByTagName("active"), g = b.getElementsByTagName("list"), h = e[0].getAttribute("name"), i = f[0].getAttribute("name"), j = 0, k = g.length; k > j; j++) c.push(g[j].getAttribute("name"));
                        d = {
                            "default": h,
                            active: i,
                            names: c
                        }, a(null, d)
                    }, function(b) {
                        if (b) {
                            var c = k(b);
                            a(c, null)
                        } else a(n.getError(408), null)
                    })
                },
                getList: function(a, b) {
                    var c, d, e, f, g = this,
                        h = [],
                        i = {};
                    c = $iq({
                        from: q.jid,
                        type: "get",
                        id: q.getUniqueId("getlist")
                    }).c("query", {
                        xmlns: Strophe.NS.PRIVACY_LIST
                    }).c("list", {
                        name: a
                    }), q.sendIQ(c, function(c) {
                        d = c.getElementsByTagName("item");
                        for (var j = 0, k = d.length; k > j; j += 2) e = d[j].getAttribute("value"), f = g.helpers.getIdFromNode(e), h.push({
                            user_id: f,
                            action: d[j].getAttribute("action")
                        });
                        i = {
                            name: a,
                            items: h
                        }, b(null, i)
                    }, function(a) {
                        if (a) {
                            var c = k(a);
                            b(c, null)
                        } else b(n.getError(408), null)
                    })
                },
                create: function(a, b) {
                    var c, d, e, f, g, h = this,
                        i = {},
                        j = [];
                    c = $iq({
                        from: q.jid,
                        type: "set",
                        id: q.getUniqueId("edit")
                    }).c("query", {
                        xmlns: Strophe.NS.PRIVACY_LIST
                    }).c("list", {
                        name: a.name
                    }), $(a.items).each(function(a, b) {
                        i[b.user_id] = b.action
                    }), j = Object.keys(i);
                    for (var l = 0, m = 0, o = j.length; o > l; l++, m += 2) d = j[l], f = i[d], e = h.helpers.jidOrUserId(parseInt(d, 10)), g = h.helpers.getUserNickWithMucDomain(d), c.c("item", {
                        type: "jid",
                        value: e,
                        action: f,
                        order: m + 1
                    }).c("message", {}).up().c("presence-in", {}).up().c("presence-out", {}).up().c("iq", {}).up().up(), c.c("item", {
                        type: "jid",
                        value: g,
                        action: f,
                        order: m + 2
                    }).c("message", {}).up().c("presence-in", {}).up().c("presence-out", {}).up().c("iq", {}).up().up();
                    q.sendIQ(c, function(a) {
                        b(null)
                    }, function(a) {
                        if (a) {
                            var c = k(a);
                            b(c)
                        } else b(n.getError(408))
                    })
                },
                update: function(a, b) {
                    var c = this;
                    c.getList(a.name, function(d, e) {
                        if (d) b(d, null);
                        else {
                            var f = JSON.parse(JSON.stringify(a)),
                                g = e.items,
                                h = f.items,
                                i = {};
                            f.items = $.merge(g, h), i = f, c.create(i, function(a, c) {
                                d ? b(a, null) : b(null, c)
                            })
                        }
                    })
                },
                "delete": function(a, b) {
                    var c = $iq({
                        from: q.jid,
                        type: "set",
                        id: q.getUniqueId("remove")
                    }).c("query", {
                        xmlns: Strophe.NS.PRIVACY_LIST
                    }).c("list", {
                        name: a ? a : ""
                    });
                    q.sendIQ(c, function(a) {
                        b(null)
                    }, function(a) {
                        if (a) {
                            var c = k(a);
                            b(c)
                        } else b(n.getError(408))
                    })
                },
                setAsDefault: function(a, b) {
                    var c = $iq({
                        from: q.jid,
                        type: "set",
                        id: q.getUniqueId("default")
                    }).c("query", {
                        xmlns: Strophe.NS.PRIVACY_LIST
                    }).c("default", {
                        name: a ? a : ""
                    });
                    q.sendIQ(c, function(a) {
                        b(null)
                    }, function(a) {
                        if (a) {
                            var c = k(a);
                            b(c)
                        } else b(n.getError(408))
                    })
                },
                setAsActive: function(a, b) {
                    var c = $iq({
                        from: q.jid,
                        type: "set",
                        id: q.getUniqueId("active")
                    }).c("query", {
                        xmlns: Strophe.NS.PRIVACY_LIST
                    }).c("active", {
                        name: a ? a : ""
                    });
                    q.sendIQ(c, function(a) {
                        b(null)
                    }, function(a) {
                        if (a) {
                            var c = k(a);
                            b(c)
                        } else b(n.getError(408))
                    })
                }
            }, h.prototype = {
                list: function(a, b) {
                    "function" == typeof a && "undefined" == typeof b && (b = a, a = {}), n.QBLog("[DialogProxy]", "list", a), this.service.ajax({
                        url: n.getUrl(s),
                        data: a
                    }, b)
                },
                create: function(a, b) {
                    a.occupants_ids instanceof Array && (a.occupants_ids = a.occupants_ids.join(", ")), n.QBLog("[DialogProxy]", "create", a), this.service.ajax({
                        url: n.getUrl(s),
                        type: "POST",
                        data: a
                    }, b)
                },
                update: function(a, b, c) {
                    n.QBLog("[DialogProxy]", "update", b), this.service.ajax({
                        url: n.getUrl(s, a),
                        type: "PUT",
                        data: b
                    }, c)
                },
                "delete": function(a, b, c) {
                    n.QBLog("[DialogProxy]", "delete", a), 2 == arguments.length ? this.service.ajax({
                        url: n.getUrl(s, a),
                        type: "DELETE"
                    }, b) : 3 == arguments.length && this.service.ajax({
                        url: n.getUrl(s, a),
                        type: "DELETE",
                        data: b
                    }, c)
                }
            }, i.prototype = {
                list: function(a, b) {
                    n.QBLog("[MessageProxy]", "list", a), this.service.ajax({
                        url: n.getUrl(t),
                        data: a
                    }, b)
                },
                create: function(a, b) {
                    n.QBLog("[MessageProxy]", "create", a), this.service.ajax({
                        url: n.getUrl(t),
                        type: "POST",
                        data: a
                    }, b)
                },
                update: function(a, b, c) {
                    n.QBLog("[MessageProxy]", "update", a, b), this.service.ajax({
                        url: n.getUrl(t, a),
                        type: "PUT",
                        data: b
                    }, c)
                },
                "delete": function(a, b, c) {
                    n.QBLog("[DialogProxy]", "delete", a), 2 == arguments.length ? this.service.ajax({
                        url: n.getUrl(t, a),
                        type: "DELETE",
                        dataType: "text"
                    }, b) : 3 == arguments.length && this.service.ajax({
                        url: n.getUrl(t, a),
                        type: "DELETE",
                        data: b,
                        dataType: "text"
                    }, c)
                },
                unreadCount: function(a, b) {
                    n.QBLog("[MessageProxy]", "unreadCount", a), this.service.ajax({
                        url: n.getUrl(t + "/unread"),
                        data: a
                    }, b)
                }
            }, j.prototype = {
                jidOrUserId: function(a) {
                    var b;
                    if ("string" == typeof a) b = a;
                    else {
                        if ("number" != typeof a) throw p;
                        b = a + "-" + m.creds.appId + "@" + m.endpoints.chat
                    }
                    return b
                },
                typeChat: function(a) {
                    var b;
                    if ("string" == typeof a) b = a.indexOf("muc") > -1 ? "groupchat" : "chat";
                    else {
                        if ("number" != typeof a) throw p;
                        b = "chat"
                    }
                    return b
                },
                getRecipientId: function(a, b) {
                    var c = null;
                    return a.forEach(function(a, d, e) {
                        a != b && (c = a)
                    }), c
                },
                getUserJid: function(a, b) {
                    return b ? a + "-" + b + "@" + m.endpoints.chat : a + "-" + m.creds.appId + "@" + m.endpoints.chat
                },
                getUserNickWithMucDomain: function(a) {
                    return m.endpoints.muc + "/" + a
                },
                getIdFromNode: function(a) {
                    return a.indexOf("@") < 0 ? null : parseInt(a.split("@")[0].split("-")[0])
                },
                getDialogIdFromNode: function(a) {
                    return a.indexOf("@") < 0 ? null : a.split("@")[0].split("_")[1]
                },
                getRoomJidFromDialogId: function(a) {
                    return m.creds.appId + "_" + a + "@" + m.endpoints.muc
                },
                getRoomJid: function(a) {
                    if (!o) throw p;
                    return a + "/" + this.getIdFromNode(q.jid)
                },
                getIdFromResource: function(a) {
                    var b = a.split("/");
                    return b.length < 2 ? null : (b.splice(0, 1), parseInt(b.join("/")))
                },
                getUniqueId: function(a) {
                    if (!o) throw p;
                    return q.getUniqueId(a)
                },
                getBsonObjectId: function() {
                    return n.getBsonObjectId()
                },
                getUserIdFromRoomJid: function(a) {
                    var b = a.toString().split("/");
                    return 0 == b.length ? null : b[b.length - 1]
                }
            }, b.exports = d
        }, {
            "../qbConfig": 15,
            "../qbUtils": 19,
            strophe: 159
        }],
        3: [function(a, b, c) {
            function d(a) {
                this.service = a
            }

            function e(a) {
                for (var b = e.options, c = b.parser[b.strictMode ? "strict" : "loose"].exec(a), d = {}, f = 14; f--;) d[b.key[f]] = c[f] || "";
                return d[b.q.name] = {}, d[b.key[12]].replace(b.q.parser, function(a, c, e) {
                    c && (d[b.q.name][c] = e)
                }), d
            }
            var f = a("../qbConfig"),
                g = a("../qbUtils"),
                h = "undefined" != typeof window;
            if (!h) var i = a("xml2js");
            var j = f.urls.blobs + "/tagged";
            d.prototype = {
                create: function(a, b) {
                    g.QBLog("[ContentProxy]", "create", a), this.service.ajax({
                        url: g.getUrl(f.urls.blobs),
                        data: {
                            blob: a
                        },
                        type: "POST"
                    }, function(a, c) {
                        a ? b(a, null) : b(a, c.blob)
                    })
                },
                list: function(a, b) {
                    "function" == typeof a && "undefined" == typeof b && (b = a, a = null), g.QBLog("[ContentProxy]", "list", a), this.service.ajax({
                        url: g.getUrl(f.urls.blobs),
                        data: a,
                        type: "GET"
                    }, function(a, c) {
                        a ? b(a, null) : b(a, c)
                    })
                },
                "delete": function(a, b) {
                    g.QBLog("[ContentProxy]", "delete"), this.service.ajax({
                        url: g.getUrl(f.urls.blobs, a),
                        type: "DELETE",
                        dataType: "text"
                    }, function(a, c) {
                        a ? b(a, null) : b(null, !0)
                    })
                },
                createAndUpload: function(a, b) {
                    var c, d, f, i, j, k = {},
                        l = this,
                        m = JSON.parse(JSON.stringify(a));
                    m.file.data = "...", g.QBLog("[ContentProxy]", "createAndUpload", m), c = a.file, d = a.name || c.name, f = a.type || c.type, i = a.size || c.size, k.name = d, k.content_type = f, a["public"] && (k["public"] = a["public"]), a.tag_list && (k.tag_list = a.tag_list), this.create(k, function(a, d) {
                        if (a) b(a, null);
                        else {
                            var f, g = e(d.blob_object_access.params),
                                k = {
                                    url: "https://" + g.host
                                };
                            f = h ? new FormData : {}, j = d.id, Object.keys(g.queryKey).forEach(function(a) {
                                h ? f.append(a, decodeURIComponent(g.queryKey[a])) : f[a] = decodeURIComponent(g.queryKey[a])
                            }), h ? f.append("file", c, d.name) : f.file = c, k.data = f, l.upload(k, function(a, c) {
                                a ? b(a, null) : (h ? d.path = c.Location.replace("http://", "https://") : d.path = c.PostResponse.Location, l.markUploaded({
                                    id: j,
                                    size: i
                                }, function(a, c) {
                                    a ? b(a, null) : b(null, d)
                                }))
                            })
                        }
                    })
                },
                upload: function(a, b) {
                    g.QBLog("[ContentProxy]", "upload"), this.service.ajax({
                        url: a.url,
                        data: a.data,
                        dataType: "xml",
                        contentType: !1,
                        processData: !1,
                        type: "POST"
                    }, function(a, c) {
                        if (a) b(a, null);
                        else if (h) {
                            var d, e, f = {},
                                g = c.documentElement,
                                j = g.childNodes;
                            for (d = 0, e = j.length; e > d; d++) f[j[d].nodeName] = j[d].childNodes[0].nodeValue;
                            b(null, f)
                        } else {
                            var k = i.parseString;
                            k(c, function(a, c) {
                                c && b(null, c)
                            })
                        }
                    })
                },
                taggedForCurrentUser: function(a) {
                    g.QBLog("[ContentProxy]", "taggedForCurrentUser"), this.service.ajax({
                        url: g.getUrl(j)
                    }, function(b, c) {
                        b ? a(b, null) : a(null, c)
                    })
                },
                markUploaded: function(a, b) {
                    g.QBLog("[ContentProxy]", "markUploaded", a), this.service.ajax({
                        url: g.getUrl(f.urls.blobs, a.id + "/complete"),
                        type: "PUT",
                        data: {
                            size: a.size
                        },
                        dataType: "text"
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c)
                    })
                },
                getInfo: function(a, b) {
                    g.QBLog("[ContentProxy]", "getInfo", a), this.service.ajax({
                        url: g.getUrl(f.urls.blobs, a)
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c)
                    })
                },
                getFile: function(a, b) {
                    g.QBLog("[ContentProxy]", "getFile", a), this.service.ajax({
                        url: g.getUrl(f.urls.blobs, a)
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c)
                    })
                },
                getFileUrl: function(a, b) {
                    g.QBLog("[ContentProxy]", "getFileUrl", a), this.service.ajax({
                        url: g.getUrl(f.urls.blobs, a + "/getblobobjectbyid"),
                        type: "POST"
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c.blob_object_access.params)
                    })
                },
                update: function(a, b) {
                    g.QBLog("[ContentProxy]", "update", a);
                    var c = {};
                    c.blob = {}, "undefined" != typeof a.name && (c.blob.name = a.name), this.service.ajax({
                        url: g.getUrl(f.urls.blobs, a.id),
                        data: c
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c)
                    })
                },
                privateUrl: function(a) {
                    return "https://" + f.endpoints.api + "/blobs/" + a + "?token=" + this.service.getSession().token
                },
                publicUrl: function(a) {
                    return "https://" + f.endpoints.api + "/blobs/" + a
                }
            }, b.exports = d, e.options = {
                strictMode: !1,
                key: ["source", "protocol", "authority", "userInfo", "user", "password", "host", "port", "relative", "path", "directory", "file", "query", "anchor"],
                q: {
                    name: "queryKey",
                    parser: /(?:^|&)([^&=]*)=?([^&]*)/g
                },
                parser: {
                    strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
                    loose: /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
                }
            }
        }, {
            "../qbConfig": 15,
            "../qbUtils": 19,
            xml2js: 165
        }],
        4: [function(a, b, c) {
            function d(a) {
                this.service = a
            }
            var e = a("../qbConfig"),
                f = a("../qbUtils"),
                g = "undefined" != typeof window;
            d.prototype = {
                create: function(a, b, c) {
                    f.QBLog("[DataProxy]", "create", a, b), this.service.ajax({
                        url: f.getUrl(e.urls.data, a),
                        data: b,
                        type: "POST"
                    }, function(a, b) {
                        a ? c(a, null) : c(a, b)
                    })
                },
                list: function(a, b, c) {
                    "undefined" == typeof c && "function" == typeof b && (c = b, b = null), f.QBLog("[DataProxy]", "list", a, b), this.service.ajax({
                        url: f.getUrl(e.urls.data, a),
                        data: b
                    }, function(a, b) {
                        a ? c(a, null) : c(a, b)
                    })
                },
                update: function(a, b, c) {
                    f.QBLog("[DataProxy]", "update", a, b), this.service.ajax({
                        url: f.getUrl(e.urls.data, a + "/" + b._id),
                        data: b,
                        type: "PUT"
                    }, function(a, b) {
                        a ? c(a, null) : c(a, b)
                    })
                },
                "delete": function(a, b, c) {
                    f.QBLog("[DataProxy]", "delete", a, b), this.service.ajax({
                        url: f.getUrl(e.urls.data, a + "/" + b),
                        type: "DELETE",
                        dataType: "text"
                    }, function(a, b) {
                        a ? c(a, null) : c(a, !0)
                    })
                },
                uploadFile: function(a, b, c) {
                    f.QBLog("[DataProxy]", "uploadFile", a, b);
                    var d;
                    g ? (d = new FormData, d.append("field_name", b.field_name), d.append("file", b.file)) : (d = {}, d.field_name = b.field_name, d.file = b.file), this.service.ajax({
                        url: f.getUrl(e.urls.data, a + "/" + b.id + "/file"),
                        data: d,
                        contentType: !1,
                        processData: !1,
                        type: "POST"
                    }, function(a, b) {
                        a ? c(a, null) : c(a, b)
                    })
                },
                downloadFile: function(a, b, c) {
                    f.QBLog("[DataProxy]", "downloadFile", a, b);
                    var d = f.getUrl(e.urls.data, a + "/" + b.id + "/file");
                    d += "?field_name=" + b.field_name + "&token=" + this.service.getSession().token, c(null, d)
                },
                deleteFile: function(a, b, c) {
                    f.QBLog("[DataProxy]", "deleteFile", a, b), this.service.ajax({
                        url: f.getUrl(e.urls.data, a + "/" + b.id + "/file"),
                        data: {
                            field_name: b.field_name
                        },
                        dataType: "text",
                        type: "DELETE"
                    }, function(a, b) {
                        a ? c(a, null) : c(a, !0)
                    })
                }
            }, b.exports = d
        }, {
            "../qbConfig": 15,
            "../qbUtils": 19
        }],
        5: [function(a, b, c) {
            function d(a) {
                this.service = a, this.geodata = new e(a)
            }

            function e(a) {
                this.service = a
            }
            var f = a("../qbConfig"),
                g = a("../qbUtils"),
                h = f.urls.geodata + "/find";
            e.prototype = {
                create: function(a, b) {
                    g.QBLog("[GeoProxy]", "create", a), this.service.ajax({
                        url: g.getUrl(f.urls.geodata),
                        data: {
                            geo_data: a
                        },
                        type: "POST"
                    }, function(a, c) {
                        a ? b(a, null) : b(a, c.geo_datum)
                    })
                },
                update: function(a, b) {
                    var c, d = ["longitude", "latitude", "status"],
                        e = {};
                    for (c in a) a.hasOwnProperty(c) && d.indexOf(c) > 0 && (e[c] = a[c]);
                    g.QBLog("[GeoProxy]", "update", a), this.service.ajax({
                        url: g.getUrl(f.urls.geodata, a.id),
                        data: {
                            geo_data: e
                        },
                        type: "PUT"
                    }, function(a, c) {
                        a ? b(a, null) : b(a, c.geo_datum)
                    })
                },
                get: function(a, b) {
                    g.QBLog("[GeoProxy]", "get", a), this.service.ajax({
                        url: g.getUrl(f.urls.geodata, a)
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c.geo_datum)
                    })
                },
                list: function(a, b) {
                    "function" == typeof a && (b = a, a = void 0), g.QBLog("[GeoProxy]", "find", a), this.service.ajax({
                        url: g.getUrl(h),
                        data: a
                    }, b)
                },
                "delete": function(a, b) {
                    g.QBLog("[GeoProxy]", "delete", a), this.service.ajax({
                        url: g.getUrl(f.urls.geodata, a),
                        type: "DELETE",
                        dataType: "text"
                    }, function(a, c) {
                        a ? b(a, null) : b(null, !0)
                    })
                },
                purge: function(a, b) {
                    g.QBLog("[GeoProxy]", "purge", a), this.service.ajax({
                        url: g.getUrl(f.urls.geodata),
                        data: {
                            days: a
                        },
                        type: "DELETE",
                        dataType: "text"
                    }, function(a, c) {
                        a ? b(a, null) : b(null, !0)
                    })
                }
            }, b.exports = d
        }, {
            "../qbConfig": 15,
            "../qbUtils": 19
        }],
        6: [function(a, b, c) {
            (function(c) {
                function d(a) {
                    this.service = a, this.subscriptions = new e(a), this.events = new f(a), this.base64Encode = function(a) {
                        return i ? btoa(encodeURIComponent(a).replace(/%([0-9A-F]{2})/g, function(a, b) {
                            return String.fromCharCode("0x" + b)
                        })) : new c(a).toString("base64")
                    }
                }

                function e(a) {
                    this.service = a
                }

                function f(a) {
                    this.service = a
                }
                var g = a("../qbConfig"),
                    h = a("../qbUtils"),
                    i = "undefined" != typeof window;
                e.prototype = {
                    create: function(a, b) {
                        h.QBLog("[SubscriptionsProxy]", "create", a), this.service.ajax({
                            url: h.getUrl(g.urls.subscriptions),
                            type: "POST",
                            data: a
                        }, b)
                    },
                    list: function(a) {
                        h.QBLog("[SubscriptionsProxy]", "list"), this.service.ajax({
                            url: h.getUrl(g.urls.subscriptions)
                        }, a)
                    },
                    "delete": function(a, b) {
                        h.QBLog("[SubscriptionsProxy]", "delete", a), this.service.ajax({
                            url: h.getUrl(g.urls.subscriptions, a),
                            type: "DELETE",
                            dataType: "text"
                        }, function(a, c) {
                            a ? b(a, null) : b(null, !0)
                        })
                    }
                }, f.prototype = {
                    create: function(a, b) {
                        h.QBLog("[EventsProxy]", "create", a);
                        var c = {
                            event: a
                        };
                        this.service.ajax({
                            url: h.getUrl(g.urls.events),
                            type: "POST",
                            data: c
                        }, b)
                    },
                    list: function(a, b) {
                        "function" == typeof a && "undefined" == typeof b && (b = a, a = null), h.QBLog("[EventsProxy]", "list", a), this.service.ajax({
                            url: h.getUrl(g.urls.events),
                            data: a
                        }, b)
                    },
                    get: function(a, b) {
                        h.QBLog("[EventsProxy]", "get", a), this.service.ajax({
                            url: h.getUrl(g.urls.events, a)
                        }, b)
                    },
                    status: function(a, b) {
                        h.QBLog("[EventsProxy]", "status", a), this.service.ajax({
                            url: h.getUrl(g.urls.events, a + "/status")
                        }, b)
                    },
                    "delete": function(a, b) {
                        h.QBLog("[EventsProxy]", "delete", a), this.service.ajax({
                            url: h.getUrl(g.urls.events, a),
                            type: "DELETE"
                        }, b)
                    }
                }, b.exports = d
            }).call(this, a("buffer").Buffer)
        }, {
            "../qbConfig": 15,
            "../qbUtils": 19,
            buffer: 23
        }],
        7: [function(a, b, c) {
            function d(a) {
                this.service = a
            }

            function e(a) {
                var b = a.field in j ? "date" : typeof a.value;
                return (a.value instanceof Array || i.isArray(a.value)) && ("object" == b && (b = typeof a.value[0]), a.value = a.value.toString()), [b, a.field, a.param, a.value].join(" ")
            }

            function f(a) {
                var b = a.field in j ? "date" : a.field in k ? "number" : "string";
                return [a.sort, b, a.field].join(" ")
            }
            var g = a("../qbConfig"),
                h = a("../qbUtils"),
                i = a("util"),
                j = ["created_at", "updated_at", "last_request_at"],
                k = ["id", "external_user_id"],
                l = g.urls.users + "/password/reset";
            d.prototype = {
                listUsers: function(a, b) {
                    h.QBLog("[UsersProxy]", "listUsers", arguments.length > 1 ? a : "");
                    var c, d = {},
                        i = [];
                    "function" == typeof a && "undefined" == typeof b && (b = a, a = {}), a.filter && (a.filter instanceof Array ? a.filter.forEach(function(a) {
                        c = e(a), i.push(c)
                    }) : (c = e(a.filter), i.push(c)), d.filter = i), a.order && (d.order = f(a.order)), a.page && (d.page = a.page), a.per_page && (d.per_page = a.per_page), this.service.ajax({
                        url: h.getUrl(g.urls.users),
                        data: d
                    }, b)
                },
                get: function(a, b) {
                    h.QBLog("[UsersProxy]", "get", a);
                    var c;
                    "number" == typeof a ? (c = a, a = {}) : a.login ? c = "by_login" : a.full_name ? c = "by_full_name" : a.facebook_id ? c = "by_facebook_id" : a.twitter_id ? c = "by_twitter_id" : a.email ? c = "by_email" : a.tags ? c = "by_tags" : a.external && (c = "external/" + a.external, a = {}), this.service.ajax({
                        url: h.getUrl(g.urls.users, c),
                        data: a
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c.user || c)
                    })
                },
                create: function(a, b) {
                    h.QBLog("[UsersProxy]", "create", a), this.service.ajax({
                        url: h.getUrl(g.urls.users),
                        type: "POST",
                        data: {
                            user: a
                        }
                    }, function(a, c) {
                        a ? b(a, null) : b(null, c.user)
                    })
                },
                update: function(a, b, c) {
                    h.QBLog("[UsersProxy]", "update", a, b), this.service.ajax({
                        url: h.getUrl(g.urls.users, a),
                        type: "PUT",
                        data: {
                            user: b
                        }
                    }, function(a, b) {
                        a ? c(a, null) : c(null, b.user)
                    })
                },
                "delete": function(a, b) {
                    h.QBLog("[UsersProxy]", "delete", a);
                    var c;
                    "number" == typeof a ? c = a : a.external && (c = "external/" + a.external), this.service.ajax({
                        url: h.getUrl(g.urls.users, c),
                        type: "DELETE",
                        dataType: "text"
                    }, b)
                },
                resetPassword: function(a, b) {
                    h.QBLog("[UsersProxy]", "resetPassword", a), this.service.ajax({
                        url: h.getUrl(l),
                        data: {
                            email: a
                        }
                    }, b)
                }
            }, b.exports = d
        }, {
            "../qbConfig": 15,
            "../qbUtils": 19,
            util: 162
        }],
        8: [function(a, b, c) {
            function d(a, b, c, d) {
                navigator.mozGetUserMedia ? a.getStats(b, function(a) {
                    var b = [];
                    a.forEach(function(a) {
                        b.push(a)
                    }), c(b)
                }, d) : a.getStats(function(a) {
                    var b = [];
                    a.result().forEach(function(a) {
                        var c = {};
                        a.names().forEach(function(b) {
                            c[b] = a.stat(b)
                        }), c.id = a.id, c.type = a.type, c.timestamp = a.timestamp, b.push(c);
                    }), c(b)
                })
            }
            var e = a("../../qbConfig"),
                f = a("./qbWebRTCHelpers"),
                g = window.RTCPeerConnection || window.webkitRTCPeerConnection || window.mozRTCPeerConnection,
                h = window.RTCSessionDescription || window.mozRTCSessionDescription,
                i = window.RTCIceCandidate || window.mozRTCIceCandidate;
            g.State = {
                NEW: 1,
                CONNECTING: 2,
                CHECKING: 3,
                CONNECTED: 4,
                DISCONNECTED: 5,
                FAILED: 6,
                CLOSED: 7,
                COMPLETED: 8
            }, g.prototype.init = function(a, b, c, d) {
                f.trace("RTCPeerConnection init. userID: " + b + ", sessionID: " + c + ", type: " + d), this.delegate = a, this.sessionID = c, this.userID = b, this.type = d, this.remoteSDP = null, this.state = g.State.NEW, this.onicecandidate = this.onIceCandidateCallback, this.onaddstream = this.onAddRemoteStreamCallback, this.onsignalingstatechange = this.onSignalingStateCallback, this.oniceconnectionstatechange = this.onIceConnectionStateCallback, this.dialingTimer = null, this.answerTimeInterval = 0, this.statsReportTimer = null, this.reconnectTimer = 0, this.iceCandidates = []
            }, g.prototype.release = function() {
                this._clearDialingTimer(), this._clearStatsReportTimer(), "closed" !== this.signalingState && this.close()
            }, g.prototype.updateRemoteSDP = function(a) {
                if (!a) throw new Error("sdp string can't be empty.");
                this.remoteSDP = a
            }, g.prototype.getRemoteSDP = function() {
                return this.remoteSDP
            }, g.prototype.setRemoteSessionDescription = function(a, b, c) {
                function d() {
                    c(null)
                }

                function e(a) {
                    c(a)
                }
                var f = new h({
                    sdp: b,
                    type: a
                });
                this.setRemoteDescription(f, d, e)
            }, g.prototype.addLocalStream = function(a) {
                if (!a) throw new Error("'RTCPeerConnection.addStream' error: stream is 'null'.");
                this.addStream(a)
            }, g.prototype.getAndSetLocalSessionDescription = function(a) {
                function b(b) {
                    d.setLocalDescription(b, function() {
                        a(null)
                    }, c)
                }

                function c(b) {
                    a(b)
                }
                var d = this;
                d.state = g.State.CONNECTING, "offer" === d.type ? d.createOffer(b, c) : d.createAnswer(b, c)
            }, g.prototype.addCandidates = function(a) {
                for (var b, c = 0, d = a.length; d > c; c++) b = {
                    sdpMLineIndex: a[c].sdpMLineIndex,
                    sdpMid: a[c].sdpMid,
                    candidate: a[c].candidate
                }, this.addIceCandidate(new i(b), function() {}, function(a) {
                    f.traceError("Error on 'addIceCandidate': " + a)
                })
            }, g.prototype.toString = function() {
                return "sessionID: " + this.sessionID + ", userID:  " + this.userID + ", type: " + this.type + ", state: " + this.state
            }, g.prototype.onSignalingStateCallback = function() {
                "stable" === this.signalingState && this.iceCandidates.length > 0 && (this.delegate.processIceCandidates(this, this.iceCandidates), this.iceCandidates.length = 0)
            }, g.prototype.onIceCandidateCallback = function(a) {
                var b = a.candidate;
                if (b) {
                    var c = {
                        sdpMLineIndex: b.sdpMLineIndex,
                        sdpMid: b.sdpMid,
                        candidate: b.candidate
                    };
                    "stable" === this.signalingState ? this.delegate.processIceCandidates(this, [c]) : this.iceCandidates.push(c)
                }
            }, g.prototype.onAddRemoteStreamCallback = function(a) {
                var b = this;
                "function" == typeof this.delegate._onRemoteStreamListener && this.delegate._onRemoteStreamListener(this.userID, a.stream), b._getStatsWrap()
            }, g.prototype.onIceConnectionStateCallback = function() {
                var a = this.iceConnectionState;
                if (f.trace("onIceConnectionStateCallback: " + this.iceConnectionState), "function" == typeof this.delegate._onSessionConnectionStateChangedListener) {
                    var b = null;
                    "checking" === a ? (this.state = g.State.CHECKING, b = f.SessionConnectionState.CONNECTING) : "connected" === a ? (this._clearWaitingReconnectTimer(), this.state = g.State.CONNECTED, b = f.SessionConnectionState.CONNECTED) : "completed" === a ? (this._clearWaitingReconnectTimer(), this.state = g.State.COMPLETED, b = f.SessionConnectionState.COMPLETED) : "failed" === a ? (this.state = g.State.FAILED, b = f.SessionConnectionState.FAILED) : "disconnected" === a ? (this._startWaitingReconnectTimer(), this.state = g.State.DISCONNECTED, b = f.SessionConnectionState.DISCONNECTED) : "closed" === a && (this.state = g.State.CLOSED, b = f.SessionConnectionState.CLOSED), b && this.delegate._onSessionConnectionStateChangedListener(this.userID, b)
                }
            }, g.prototype._clearStatsReportTimer = function() {
                this.statsReportTimer && (clearInterval(this.statsReportTimer), this.statsReportTimer = null)
            }, g.prototype._getStatsWrap = function() {
                var a, b = this,
                    c = 1 == b.delegate.callType ? b.getLocalStreams()[0].getVideoTracks()[0] : b.getLocalStreams()[0].getAudioTracks()[0];
                if (e.webrtc || e.webrtc.statsReportTimeInterval) {
                    if (isNaN(+e.webrtc.statsReportTimeInterval)) return void f.traceError("statsReportTimeInterval (" + e.webrtc.statsReportTimeInterval + ") must be integer.");
                    a = 1e3 * e.webrtc.statsReportTimeInterval;
                    var g = function() {
                        d(b, c, function(a) {
                            b.delegate._onCallStatsReport(b.userID, a)
                        }, function(a) {
                            f.traceError("_getStats error. " + a.name + ": " + a.message)
                        })
                    };
                    f.trace("Stats tracker has been started."), b.statsReportTimer = setInterval(g, a)
                }
            }, g.prototype._clearWaitingReconnectTimer = function() {
                this.waitingReconnectTimeoutCallback && (f.trace("_clearWaitingReconnectTimer"), clearTimeout(this.waitingReconnectTimeoutCallback), this.waitingReconnectTimeoutCallback = null)
            }, g.prototype._startWaitingReconnectTimer = function() {
                var a = this,
                    b = 1e3 * e.webrtc.disconnectTimeInterval,
                    c = function() {
                        f.trace("waitingReconnectTimeoutCallback"), clearTimeout(a.waitingReconnectTimeoutCallback), a.release(), a.delegate._closeSessionIfAllConnectionsClosed()
                    };
                f.trace("_startWaitingReconnectTimer, timeout: " + b), a.waitingReconnectTimeoutCallback = setTimeout(c, b)
            }, g.prototype._clearDialingTimer = function() {
                this.dialingTimer && (f.trace("_clearDialingTimer"), clearInterval(this.dialingTimer), this.dialingTimer = null, this.answerTimeInterval = 0)
            }, g.prototype._startDialingTimer = function(a, b) {
                var c = this,
                    d = 1e3 * e.webrtc.dialingTimeInterval;
                f.trace("_startDialingTimer, dialingTimeInterval: " + d);
                var g = function(a, b, d) {
                    d || (c.answerTimeInterval += 1e3 * e.webrtc.dialingTimeInterval), f.trace("_dialingCallback, answerTimeInterval: " + c.answerTimeInterval), c.answerTimeInterval >= 1e3 * e.webrtc.answerTimeInterval ? (c._clearDialingTimer(), b && c.delegate.processOnNotAnswer(c)) : c.delegate.processCall(c, a)
                };
                c.dialingTimer = setInterval(g, d, a, b, !1), g(a, b, !0)
            }, b.exports = g
        }, {
            "../../qbConfig": 15,
            "./qbWebRTCHelpers": 10
        }],
        9: [function(a, b, c) {
            function d(a, b) {
                return d.__instance ? d.__instance : this === window ? new d : (d.__instance = this, this.connection = b, this.signalingProcessor = new h(a, this, b), this.signalingProvider = new i(a, b), this.SessionConnectionState = j.SessionConnectionState, this.CallType = j.CallType, this.PeerConnectionState = k.State, void(this.sessions = {}))
            }

            function e(a, b) {
                var c = !1,
                    d = b.sort();
                return a.length && a.forEach(function(a) {
                    var b = a.sort();
                    c = b.length == d.length && b.every(function(a, b) {
                        return a === d[b]
                    })
                }), c
            }

            function f(a) {
                var b = [];
                return Object.keys(a).length > 0 && Object.keys(a).forEach(function(c, d, e) {
                    var f = a[c];
                    (f.state === g.State.NEW || f.state === g.State.ACTIVE) && b.push(f.opponentsIDs)
                }), b
            }
            var g = a("./qbWebRTCSession"),
                h = a("./qbWebRTCSignalingProcessor"),
                i = a("./qbWebRTCSignalingProvider"),
                j = a("./qbWebRTCHelpers"),
                k = a("./qbRTCPeerConnection"),
                l = a("./qbWebRTCSignalingConstants"),
                m = a("../../qbUtils");
            d.prototype.sessions = {}, d.prototype.createNewSession = function(a, b, c) {
                var d = f(this.sessions),
                    g = c || j.getIdFromNode(this.connection.jid),
                    h = !1,
                    i = b || 2;
                if (!a) throw new Error("Can't create a session without the opponentsIDs.");
                if (h = e(d, a)) throw new Error("Can't create a session with the same opponentsIDs. There is a session already in NEW or ACTIVE state.");
                return this._createAndStoreSession(null, g, a, i)
            }, d.prototype._createAndStoreSession = function(a, b, c, d) {
                var e = new g(a, b, c, d, this.signalingProvider, j.getIdFromNode(this.connection.jid));
                return e.onUserNotAnswerListener = this.onUserNotAnswerListener, e.onRemoteStreamListener = this.onRemoteStreamListener, e.onSessionConnectionStateChangedListener = this.onSessionConnectionStateChangedListener, e.onSessionCloseListener = this.onSessionCloseListener, e.onCallStatsReport = this.onCallStatsReport, this.sessions[e.ID] = e, e
            }, d.prototype.clearSession = function(a) {
                delete d.sessions[a]
            }, d.prototype.isExistNewOrActiveSessionExceptSessionID = function(a) {
                var b = this,
                    c = !1;
                return Object.keys(b.sessions).length > 0 && Object.keys(b.sessions).forEach(function(d, e, f) {
                    var h = b.sessions[d];
                    (h.state === g.State.NEW || h.state === g.State.ACTIVE) && h.ID !== a && (c = !0)
                }), c
            }, d.prototype._onCallListener = function(a, b, c) {
                if (j.trace("onCall. UserID:" + a + ". SessionID: " + b), this.isExistNewOrActiveSessionExceptSessionID(b)) j.trace("User with id " + a + " is busy at the moment."), delete c.sdp, delete c.platform, c.sessionID = b, this.signalingProvider.sendMessage(a, c, l.SignalingType.REJECT);
                else {
                    var d = this.sessions[b];
                    if (!d) {
                        d = this._createAndStoreSession(b, c.callerID, c.opponentsIDs, c.callType);
                        var e = JSON.parse(JSON.stringify(c));
                        this._cleanupExtension(e), "function" == typeof this.onCallListener && m.safeCallbackCall(this.onCallListener, d, e)
                    }
                    d.processOnCall(a, c)
                }
            }, d.prototype._onAcceptListener = function(a, b, c) {
                var d = this.sessions[b];
                if (j.trace("onAccept. UserID:" + a + ". SessionID: " + b), d)
                    if (d.state === g.State.ACTIVE) {
                        var e = JSON.parse(JSON.stringify(c));
                        this._cleanupExtension(e), "function" == typeof this.onAcceptCallListener && m.safeCallbackCall(this.onAcceptCallListener, d, a, e), d.processOnAccept(a, c)
                    } else j.traceWarning("Ignore 'onAccept', the session( " + b + " ) has invalid state.");
                else j.traceError("Ignore 'onAccept', there is no information about session " + b + " by some reason.")
            }, d.prototype._onRejectListener = function(a, b, c) {
                var d = this,
                    e = d.sessions[b];
                if (j.trace("onReject. UserID:" + a + ". SessionID: " + b), e) {
                    var f = JSON.parse(JSON.stringify(c));
                    d._cleanupExtension(f), "function" == typeof this.onRejectCallListener && m.safeCallbackCall(d.onRejectCallListener, e, a, f), e.processOnReject(a, c)
                } else j.traceError("Ignore 'onReject', there is no information about session " + b + " by some reason.")
            }, d.prototype._onStopListener = function(a, b, c) {
                j.trace("onStop. UserID:" + a + ". SessionID: " + b);
                var d = this.sessions[b],
                    e = JSON.parse(JSON.stringify(c));
                !d || d.state !== g.State.ACTIVE && d.state !== g.State.NEW ? j.traceError("Ignore 'onStop', there is no information about session " + b + " by some reason.") : (this._cleanupExtension(e), "function" == typeof this.onStopCallListener && m.safeCallbackCall(this.onStopCallListener, d, a, e), d.processOnStop(a, c))
            }, d.prototype._onIceCandidatesListener = function(a, b, c) {
                var d = this.sessions[b];
                j.trace("onIceCandidates. UserID:" + a + ". SessionID: " + b + ". ICE candidates count: " + c.iceCandidates.length), d ? d.state === g.State.ACTIVE ? d.processOnIceCandidates(a, c) : j.traceWarning("Ignore 'OnIceCandidates', the session ( " + b + " ) has invalid state.") : j.traceError("Ignore 'OnIceCandidates', there is no information about session " + b + " by some reason.")
            }, d.prototype._onUpdateListener = function(a, b, c) {
                var d = this.sessions[b];
                j.trace("onUpdate. UserID:" + a + ". SessionID: " + b + ". Extension: " + JSON.stringify(c)), "function" == typeof this.onUpdateCallListener && m.safeCallbackCall(this.onUpdateCallListener, d, a, c)
            }, d.prototype._cleanupExtension = function(a) {
                delete a.platform, delete a.sdp, delete a.opponentsIDs, delete a.callerID, delete a.callType
            }, b.exports = d
        }, {
            "../../qbUtils": 19,
            "./qbRTCPeerConnection": 8,
            "./qbWebRTCHelpers": 10,
            "./qbWebRTCSession": 11,
            "./qbWebRTCSignalingConstants": 12,
            "./qbWebRTCSignalingProcessor": 13,
            "./qbWebRTCSignalingProvider": 14
        }],
        10: [function(a, b, c) {
            var d = a("../../qbConfig"),
                e = {};
            e = {
                getUserJid: function(a, b) {
                    return a + "-" + b + "@" + d.endpoints.chat
                },
                getIdFromNode: function(a) {
                    return a.indexOf("@") < 0 ? null : parseInt(a.split("@")[0].split("-")[0])
                },
                trace: function(a) {
                    d.debug && console.log("[QBWebRTC]:", a)
                },
                traceWarning: function(a) {
                    d.debug && console.warn("[QBWebRTC]:", a)
                },
                traceError: function(a) {
                    d.debug && console.error("[QBWebRTC]:", a)
                },
                getLocalTime: function() {
                    var a = (new Date).toString().split(" ");
                    return a.slice(1, 5).join("-")
                },
                dataURItoBlob: function(a, b) {
                    for (var c = [], d = window.atob(a.split(",")[1]), e = 0, f = d.length; f > e; e++) c.push(d.charCodeAt(e));
                    return new Blob([new Uint8Array(c)], {
                        type: b
                    })
                }
            }, e.SessionConnectionState = {
                UNDEFINED: 0,
                CONNECTING: 1,
                CONNECTED: 2,
                FAILED: 3,
                DISCONNECTED: 4,
                CLOSED: 5,
                COMPLETED: 6
            }, e.CallType = {
                VIDEO: 1,
                AUDIO: 2
            }, b.exports = e
        }, {
            "../../qbConfig": 15
        }],
        11: [function(a, b, c) {
            function d(a, b, c, f, g, h) {
                this.ID = a ? a : e(), this.state = d.State.NEW, this.initiatorID = parseInt(b), this.opponentsIDs = c, this.callType = parseInt(f), this.peerConnections = {}, this.localStream = null, this.signalingProvider = g, this.currentUserID = h, this.answerTimer = null, this.startCallTime = 0, this.acceptCallTime = 0
            }

            function e() {
                var a = (new Date).getTime(),
                    b = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(b) {
                        var c = (a + 16 * Math.random()) % 16 | 0;
                        return a = Math.floor(a / 16), ("x" == b ? c : 3 & c | 8).toString(16)
                    });
                return b
            }

            function f(a) {
                try {
                    return JSON.parse(JSON.stringify(a).replace(/null/g, '""'))
                } catch (b) {
                    return {}
                }
            }

            function g(a) {
                var b = JSON.parse(JSON.stringify(a));
                return Object.keys(b).forEach(function(a, c, d) {
                    b[c].hasOwnProperty("url") ? b[c].urls = b[c].url : b[c].url = b[c].urls
                }), b
            }
            var h = a("../../qbConfig"),
                i = a("./qbRTCPeerConnection"),
                j = a("../../qbUtils"),
                k = a("./qbWebRTCHelpers"),
                l = a("./qbWebRTCSignalingConstants");
            d.State = {
                NEW: 1,
                ACTIVE: 2,
                HUNGUP: 3,
                REJECTED: 4,
                CLOSED: 5
            }, d.prototype.getUserMedia = function(a, b) {
                var c = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
                if (!c) throw new Error("getUserMedia() is not supported in your browser");
                c = c.bind(navigator);
                var d = this;
                c({
                    audio: a.audio || !1,
                    video: a.video || !1
                }, function(c) {
                    d.localStream = c, a.elemId && d.attachMediaStream(a.elemId, c, a.options), b(null, c)
                }, function(a) {
                    b(a, null)
                })
            }, d.prototype.attachMediaStream = function(a, b, c) {
                var d = document.getElementById(a);
                if (!d) throw new Error("Unable to attach media stream, element " + a + " is undefined");
                var e = window.URL || window.webkitURL;
                d.src = e.createObjectURL(b), c && c.muted && (d.muted = !0), c && c.mirror && (d.style.webkitTransform = "scaleX(-1)", d.style.transform = "scaleX(-1)"), d.play()
            }, d.prototype.connectionStateForUser = function(a) {
                var b = this.peerConnections[a];
                return b ? b.state : null
            }, d.prototype.detachMediaStream = function(a) {
                var b = document.getElementById(a);
                b && (b.pause(), b.src = "")
            }, d.prototype.call = function(a, b) {
                var c = this,
                    e = f(a),
                    g = window.navigator.onLine,
                    h = null;
                k.trace("Call, extension: " + JSON.stringify(e)), g ? (c.state = d.State.ACTIVE, c.opponentsIDs.forEach(function(a, b, d) {
                    c._callInternal(a, e, !0)
                })) : (c.state = d.State.CLOSED, h = j.getError(408, "Call.ERROR - ERR_INTERNET_DISCONNECTED")), "function" == typeof b && b(h)
            }, d.prototype._callInternal = function(a, b, c) {
                var d = this._createPeer(a, "offer");
                d.addLocalStream(this.localStream), this.peerConnections[a] = d, d.getAndSetLocalSessionDescription(function(a) {
                    a ? k.trace("getAndSetLocalSessionDescription error: " + a) : (k.trace("getAndSetLocalSessionDescription success"), d._startDialingTimer(b, c))
                })
            }, d.prototype.accept = function(a) {
                var b = this,
                    c = f(a);
                if (k.trace("Accept, extension: " + JSON.stringify(c)), b.state === d.State.ACTIVE) return void k.traceError("Can't accept, the session is already active, return.");
                if (b.state === d.State.CLOSED) return k.traceError("Can't accept, the session is already closed, return."), void b.stop({});
                b.state = d.State.ACTIVE, b.acceptCallTime = new Date, b._clearAnswerTimer(), b._acceptInternal(b.initiatorID, c);
                var e = b._uniqueOpponentsIDsWithoutInitiator();
                if (e.length > 0) {
                    var g = (b.acceptCallTime - b.startCallTime) / 1e3;
                    b._startWaitingOfferOrAnswerTimer(g), e.forEach(function(a, c, d) {
                        b.currentUserID > a && b._callInternal(a, {}, !0)
                    })
                }
            }, d.prototype._acceptInternal = function(a, b) {
                var c = this,
                    d = this.peerConnections[a];
                d ? (d.addLocalStream(this.localStream), d.setRemoteSessionDescription("offer", d.getRemoteSDP(), function(e) {
                    e ? k.traceError("'setRemoteSessionDescription' error: " + e) : (k.trace("'setRemoteSessionDescription' success"), d.getAndSetLocalSessionDescription(function(e) {
                        e ? k.trace("getAndSetLocalSessionDescription error: " + e) : (b.sessionID = c.ID, b.callType = c.callType, b.callerID = c.initiatorID, b.opponentsIDs = c.opponentsIDs, b.sdp = d.localDescription.sdp, c.signalingProvider.sendMessage(a, b, l.SignalingType.ACCEPT))
                    }))
                })) : k.traceError("Can't accept the call, there is no information about peer connection by some reason.")
            }, d.prototype.reject = function(a) {
                var b = this,
                    c = f(a),
                    e = Object.keys(b.peerConnections).length;
                if (k.trace("Reject, extension: " + JSON.stringify(c)), b.state = d.State.REJECTED, b._clearAnswerTimer(), c.sessionID = b.ID, c.callType = b.callType, c.callerID = b.initiatorID, c.opponentsIDs = b.opponentsIDs, e > 0)
                    for (var g in b.peerConnections) {
                        var h = b.peerConnections[g];
                        b.signalingProvider.sendMessage(h.userID, c, l.SignalingType.REJECT)
                    }
                b._close()
            }, d.prototype.stop = function(a) {
                var b = this,
                    c = f(a),
                    e = Object.keys(b.peerConnections).length;
                if (k.trace("Stop, extension: " + JSON.stringify(c)), b.state = d.State.HUNGUP, b._clearAnswerTimer(), c.sessionID = b.ID, c.callType = b.callType, c.callerID = b.initiatorID, c.opponentsIDs = b.opponentsIDs, e > 0)
                    for (var g in b.peerConnections) {
                        var h = b.peerConnections[g];
                        b.signalingProvider.sendMessage(h.userID, c, l.SignalingType.STOP)
                    }
                b._close()
            }, d.prototype.closeConnection = function(a) {
                var b = this,
                    c = this.peerConnections[a];
                c ? (c.release(), b._closeSessionIfAllConnectionsClosed()) : k.traceWarn("Not found connection with user (" + a + ")")
            }, d.prototype.update = function(a) {
                var b = this,
                    c = {};
                if (k.trace("Update, extension: " + JSON.stringify(a)), null == a) return void k.trace("extension is null, no parameters to update");
                c = f(a), c.sessionID = this.ID;
                for (var d in b.peerConnections) {
                    var e = b.peerConnections[d];
                    b.signalingProvider.sendMessage(e.userID, c, l.SignalingType.PARAMETERS_CHANGED)
                }
            }, d.prototype.mute = function(a) {
                this._muteStream(0, a)
            }, d.prototype.unmute = function(a) {
                this._muteStream(1, a)
            }, d.snapshot = function(a) {
                var b, c, d = document.getElementById(a),
                    e = document.createElement("canvas"),
                    f = e.getContext("2d");
                return d ? (e.width = d.clientWidth, e.height = d.clientHeight, "scaleX(-1)" === d.style.transform && (f.translate(e.width, 0), f.scale(-1, 1)), f.drawImage(d, 0, 0, d.clientWidth, d.clientHeight), b = e.toDataURL(), c = k.dataURItoBlob(b, "image/png"), c.name = "snapshot_" + getLocalTime() + ".png", c.url = b, c) : void 0
            }, d.filter = function(a, b) {
                var c = document.getElementById(a);
                c && (c.style.webkitFilter = b, c.style.filter = b)
            }, d.prototype.processOnCall = function(a, b) {
                var c = this,
                    e = c._uniqueOpponentsIDs();
                e.forEach(function(e, f, g) {
                    var h = c.peerConnections[e];
                    if (h) e == a && (h.updateRemoteSDP(b.sdp), a != c.initiatorID && c.state === d.State.ACTIVE && c._acceptInternal(a, {}));
                    else {
                        var i;
                        i = e != a && c.currentUserID > e ? c._createPeer(e, "offer") : c._createPeer(e, "answer"), c.peerConnections[e] = i, e == a && (i.updateRemoteSDP(b.sdp), c._startAnswerTimer())
                    }
                })
            }, d.prototype.processOnAccept = function(a, b) {
                var c = this.peerConnections[a];
                c ? (c._clearDialingTimer(), c.setRemoteSessionDescription("answer", b.sdp, function(a) {
                    a ? k.traceError("'setRemoteSessionDescription' error: " + a) : k.trace("'setRemoteSessionDescription' success")
                })) : k.traceError("Ignore 'OnAccept', there is no information about peer connection by some reason.")
            }, d.prototype.processOnReject = function(a, b) {
                var c = this.peerConnections[a];
                this._clearWaitingOfferOrAnswerTimer(), c ? c.release() : k.traceError("Ignore 'OnReject', there is no information about peer connection by some reason."), this._closeSessionIfAllConnectionsClosed()
            }, d.prototype.processOnStop = function(a, b) {
                var c = this;
                if (this._clearAnswerTimer(), a === c.initiatorID) Object.keys(c.peerConnections).length ? Object.keys(c.peerConnections).forEach(function(a) {
                    c.peerConnections[a].release()
                }) : k.traceError("Ignore 'OnStop', there is no information about peer connections by some reason.");
                else {
                    var d = c.peerConnections[a];
                    d ? d.release() : k.traceError("Ignore 'OnStop', there is no information about peer connection by some reason.")
                }
                this._closeSessionIfAllConnectionsClosed()
            }, d.prototype.processOnIceCandidates = function(a, b) {
                var c = this.peerConnections[a];
                c ? c.addCandidates(b.iceCandidates) : k.traceError("Ignore 'OnIceCandidates', there is no information about peer connection by some reason.")
            }, d.prototype.processCall = function(a, b) {
                var b = b || {};
                b.sessionID = this.ID, b.callType = this.callType, b.callerID = this.initiatorID, b.opponentsIDs = this.opponentsIDs, b.sdp = a.localDescription.sdp, this.signalingProvider.sendMessage(a.userID, b, l.SignalingType.CALL)
            }, d.prototype.processIceCandidates = function(a, b) {
                var c = {};
                c.sessionID = this.ID, c.callType = this.callType, c.callerID = this.initiatorID, c.opponentsIDs = this.opponentsIDs, this.signalingProvider.sendCandidate(a.userID, b, c)
            }, d.prototype.processOnNotAnswer = function(a) {
                k.trace("Answer timeout callback for session " + this.ID + " for user " + a.userID), this._clearWaitingOfferOrAnswerTimer(), a.release(), "function" == typeof this.onUserNotAnswerListener && j.safeCallbackCall(this.onUserNotAnswerListener, this, a.userID), this._closeSessionIfAllConnectionsClosed()
            }, d.prototype._onRemoteStreamListener = function(a, b) {
                "function" == typeof this.onRemoteStreamListener && j.safeCallbackCall(this.onRemoteStreamListener, this, a, b)
            }, d.prototype._onCallStatsReport = function(a, b) {
                "function" == typeof this.onCallStatsReport && j.safeCallbackCall(this.onCallStatsReport, this, a, b)
            }, d.prototype._onSessionConnectionStateChangedListener = function(a, b) {
                var c = this;
                "function" == typeof c.onSessionConnectionStateChangedListener && j.safeCallbackCall(c.onSessionConnectionStateChangedListener, c, a, b)
            }, d.prototype._createPeer = function(a, b) {
                if (!i) throw new Error("_createPeer error: RTCPeerConnection() is not supported in your browser");
                this.startCallTime = new Date;
                var c = {
                    iceServers: g(h.webrtc.iceServers)
                };
                k.trace("_createPeer, iceServers: " + JSON.stringify(c));
                var d = new i(c);
                return d.init(this, a, this.ID, b), d
            }, d.prototype._close = function() {
                k.trace("_close");
                for (var a in this.peerConnections) {
                    var b = this.peerConnections[a];
                    b.release()
                }
                this._closeLocalMediaStream(), this.state = d.State.CLOSED, "function" == typeof this.onSessionCloseListener && j.safeCallbackCall(this.onSessionCloseListener, this)
            }, d.prototype._closeSessionIfAllConnectionsClosed = function() {
                var a = !0;
                for (var b in this.peerConnections) {
                    var c = this.peerConnections[b];
                    if ("closed" !== c.signalingState) {
                        a = !1;
                        break
                    }
                }
                k.trace("All peer connections closed: " + a), a && (this._closeLocalMediaStream(), "function" == typeof this.onSessionCloseListener && this.onSessionCloseListener(this), this.state = d.State.CLOSED)
            }, d.prototype._closeLocalMediaStream = function() {
                this.localStream && (this.localStream.getAudioTracks().forEach(function(a) {
                    a.stop()
                }), this.localStream.getVideoTracks().forEach(function(a) {
                    a.stop()
                }), this.localStream = null)
            }, d.prototype._muteStream = function(a, b) {
                return "audio" === b && this.localStream.getAudioTracks().length > 0 ? void this.localStream.getAudioTracks().forEach(function(b) {
                    b.enabled = !!a
                }) : "video" === b && this.localStream.getVideoTracks().length > 0 ? void this.localStream.getVideoTracks().forEach(function(b) {
                    b.enabled = !!a
                }) : void 0
            }, d.prototype._clearAnswerTimer = function() {
                this.answerTimer && (k.trace("_clearAnswerTimer"), clearTimeout(this.answerTimer), this.answerTimer = null)
            }, d.prototype._startAnswerTimer = function() {
                k.trace("_startAnswerTimer");
                var a = this,
                    b = function() {
                        k.trace("_answerTimeoutCallback"), "function" == typeof a.onSessionCloseListener && a._close(), a.answerTimer = null
                    },
                    c = 1e3 * h.webrtc.answerTimeInterval;
                this.answerTimer = setTimeout(b, c)
            }, d.prototype._clearWaitingOfferOrAnswerTimer = function() {
                this.waitingOfferOrAnswerTimer && (k.trace("_clearWaitingOfferOrAnswerTimer"), clearTimeout(this.waitingOfferOrAnswerTimer), this.waitingOfferOrAnswerTimer = null)
            }, d.prototype._startWaitingOfferOrAnswerTimer = function(a) {
                var b = this,
                    c = h.webrtc.answerTimeInterval - a < 0 ? 1 : h.webrtc.answerTimeInterval - a,
                    d = function() {
                        k.trace("waitingOfferOrAnswerTimeoutCallback"), Object.keys(b.peerConnections).length > 0 && Object.keys(b.peerConnections).forEach(function(a) {
                            var c = b.peerConnections[a];
                            (c.state === i.State.CONNECTING || c.state === i.State.NEW) && b.processOnNotAnswer(c)
                        }), b.waitingOfferOrAnswerTimer = null
                    };
                k.trace("_startWaitingOfferOrAnswerTimer, timeout: " + c), this.waitingOfferOrAnswerTimer = setTimeout(d, 1e3 * c)
            }, d.prototype._uniqueOpponentsIDs = function() {
                var a = this,
                    b = [];
                return this.initiatorID !== this.currentUserID && b.push(this.initiatorID), this.opponentsIDs.forEach(function(c, d, e) {
                    c != a.currentUserID && b.push(parseInt(c))
                }), b
            }, d.prototype._uniqueOpponentsIDsWithoutInitiator = function() {
                var a = this,
                    b = [];
                return this.opponentsIDs.forEach(function(c, d, e) {
                    c != a.currentUserID && b.push(parseInt(c))
                }), b
            }, d.prototype.toString = function() {
                return "ID: " + this.ID + ", initiatorID:  " + this.initiatorID + ", opponentsIDs: " + this.opponentsIDs + ", state: " + this.state + ", callType: " + this.callType
            }, b.exports = d
        }, {
            "../../qbConfig": 15,
            "../../qbUtils": 19,
            "./qbRTCPeerConnection": 8,
            "./qbWebRTCHelpers": 10,
            "./qbWebRTCSignalingConstants": 12
        }],
        12: [function(a, b, c) {
            function d() {}
            d.MODULE_ID = "WebRTCVideoChat", d.SignalingType = {
                CALL: "call",
                ACCEPT: "accept",
                REJECT: "reject",
                STOP: "hangUp",
                CANDIDATE: "iceCandidates",
                PARAMETERS_CHANGED: "update"
            }, b.exports = d
        }, {}],
        13: [function(a, b, c) {
            function d(a, b, c) {
                var d = this;
                d.service = a, d.delegate = b, d.connection = c, this._onMessage = function(a) {
                    var b = a.getAttribute("from"),
                        c = a.querySelector("extraParams"),
                        g = a.querySelector("delay"),
                        h = e.getIdFromNode(b),
                        i = d._getExtension(c);
                    if (g || i.moduleIdentifier !== f.MODULE_ID) return !0;
                    var j = i.sessionID,
                        k = i.signalType;
                    switch (delete i.moduleIdentifier, delete i.sessionID, delete i.signalType, k) {
                        case f.SignalingType.CALL:
                            "function" == typeof d.delegate._onCallListener && d.delegate._onCallListener(h, j, i);
                            break;
                        case f.SignalingType.ACCEPT:
                            "function" == typeof d.delegate._onAcceptListener && d.delegate._onAcceptListener(h, j, i);
                            break;
                        case f.SignalingType.REJECT:
                            "function" == typeof d.delegate._onRejectListener && d.delegate._onRejectListener(h, j, i);
                            break;
                        case f.SignalingType.STOP:
                            "function" == typeof d.delegate._onStopListener && d.delegate._onStopListener(h, j, i);
                            break;
                        case f.SignalingType.CANDIDATE:
                            "function" == typeof d.delegate._onIceCandidatesListener && d.delegate._onIceCandidatesListener(h, j, i);
                            break;
                        case f.SignalingType.PARAMETERS_CHANGED:
                            "function" == typeof d.delegate._onUpdateListener && d.delegate._onUpdateListener(h, j, i)
                    }
                    return !0
                }, this._getExtension = function(a) {
                    if (!a) return null;
                    for (var b, c, e, f, g = {}, h = [], i = [], j = 0, k = a.childNodes.length; k > j; j++)
                        if ("iceCandidates" === a.childNodes[j].tagName) {
                            e = a.childNodes[j].childNodes;
                            for (var l = 0, m = e.length; m > l; l++) {
                                b = {}, f = e[l].childNodes;
                                for (var n = 0, o = f.length; o > n; n++) b[f[n].tagName] = f[n].textContent;
                                h.push(b)
                            }
                        } else if ("opponentsIDs" === a.childNodes[j].tagName) {
                        e = a.childNodes[j].childNodes;
                        for (var p = 0, q = e.length; q > p; p++) c = e[p].textContent, i.push(parseInt(c))
                    } else if (a.childNodes[j].childNodes.length > 1) {
                        var r = a.childNodes[j].textContent.length;
                        if (r > 4096) {
                            for (var s = "", t = 0; t < a.childNodes[j].childNodes.length; ++t) s += a.childNodes[j].childNodes[t].textContent;
                            g[a.childNodes[j].tagName] = s
                        } else g = d._XMLtoJS(g, a.childNodes[j].tagName, a.childNodes[j])
                    } else g[a.childNodes[j].tagName] = a.childNodes[j].textContent;
                    return h.length > 0 && (g.iceCandidates = h), i.length > 0 && (g.opponentsIDs = i), g
                }, this._XMLtoJS = function(a, b, c) {
                    var d = this;
                    a[b] = {};
                    for (var e = 0, f = c.childNodes.length; f > e; e++) c.childNodes[e].childNodes.length > 1 ? a[b] = d._XMLtoJS(a[b], c.childNodes[e].tagName, c.childNodes[e]) : a[b][c.childNodes[e].tagName] = c.childNodes[e].textContent;
                    return a
                }
            }
            a("strophe");
            var e = a("./qbWebRTCHelpers"),
                f = a("./qbWebRTCSignalingConstants");
            b.exports = d
        }, {
            "./qbWebRTCHelpers": 10,
            "./qbWebRTCSignalingConstants": 12,
            strophe: 159
        }],
        14: [function(a, b, c) {
            function d(a, b) {
                this.service = a, this.connection = b
            }
            a("strophe");
            var e = a("./qbWebRTCHelpers"),
                f = a("./qbWebRTCSignalingConstants"),
                g = a("../../qbUtils"),
                h = a("../../qbConfig");
            d.prototype.sendCandidate = function(a, b, c) {
                var d = c || {};
                d.iceCandidates = b, this.sendMessage(a, d, f.SignalingType.CANDIDATE)
            }, d.prototype.sendMessage = function(a, b, c) {
                var d, i, j = b || {},
                    k = this;
                j.moduleIdentifier = f.MODULE_ID, j.signalType = c, j.platform = "web", i = {
                    to: e.getUserJid(a, h.creds.appId),
                    type: "headline",
                    id: g.getBsonObjectId()
                }, d = $msg(i).c("extraParams", {
                    xmlns: Strophe.NS.CLIENT
                }), Object.keys(j).forEach(function(a) {
                    "iceCandidates" === a ? (d = d.c("iceCandidates"), j[a].forEach(function(a) {
                        d = d.c("iceCandidate"), Object.keys(a).forEach(function(b) {
                            d.c(b).t(a[b]).up()
                        }), d.up()
                    }), d.up()) : "opponentsIDs" === a ? (d = d.c("opponentsIDs"), j[a].forEach(function(a) {
                        d = d.c("opponentID").t(a).up()
                    }), d.up()) : "object" == typeof j[a] ? k._JStoXML(a, j[a], d) : d.c(a).t(j[a]).up()
                }), this.connection.send(d)
            }, d.prototype._JStoXML = function(a, b, c) {
                var d = this;
                c.c(a), Object.keys(b).forEach(function(a) {
                    "object" == typeof b[a] ? d._JStoXML(a, b[a], c) : c.c(a).t(b[a]).up()
                }), c.up()
            }, b.exports = d
        }, {
            "../../qbConfig": 15,
            "../../qbUtils": 19,
            "./qbWebRTCHelpers": 10,
            "./qbWebRTCSignalingConstants": 12,
            strophe: 159
        }],
        15: [function(a, b, c) {
            var d = {
                version: "2.1.1",
                creds: {
                    appId: "",
                    authKey: "",
                    authSecret: ""
                },
                endpoints: {
                    api: "api.quickblox.com",
                    chat: "chat.quickblox.com",
                    muc: "muc.chat.quickblox.com"
                },
                chatProtocol: {
                    bosh: "https://chat.quickblox.com:5281",
                    websocket: "wss://chat.quickblox.com:5291",
                    active: 2
                },
                webrtc: {
                    answerTimeInterval: 60,
                    dialingTimeInterval: 5,
                    disconnectTimeInterval: 30,
                    statsReportTimeInterval: 10,
                    iceServers: [{
                        url: "stun:stun.l.google.com:19302"
                    }, {
                        url: "stun:turn.quickblox.com",
                        username: "quickblox",
                        credential: "baccb97ba2d92d71e26eb9886da5f1e0"
                    }, {
                        url: "turn:turn.quickblox.com:3478?transport=udp",
                        username: "quickblox",
                        credential: "baccb97ba2d92d71e26eb9886da5f1e0"
                    }, {
                        url: "turn:turn.quickblox.com:3478?transport=tcp",
                        username: "quickblox",
                        credential: "baccb97ba2d92d71e26eb9886da5f1e0"
                    }, {
                        url: "turn:turnsingapor.quickblox.com:3478?transport=udp",
                        username: "quickblox",
                        credential: "baccb97ba2d92d71e26eb9886da5f1e0"
                    }, {
                        url: "turn:turnsingapore.quickblox.com:3478?transport=tcp",
                        username: "quickblox",
                        credential: "baccb97ba2d92d71e26eb9886da5f1e0"
                    }, {
                        url: "turn:turnireland.quickblox.com:3478?transport=udp",
                        username: "quickblox",
                        credential: "baccb97ba2d92d71e26eb9886da5f1e0"
                    }, {
                        url: "turn:turnireland.quickblox.com:3478?transport=tcp",
                        username: "quickblox",
                        credential: "baccb97ba2d92d71e26eb9886da5f1e0"
                    }]
                },
                urls: {
                    session: "session",
                    login: "login",
                    users: "users",
                    chat: "chat",
                    blobs: "blobs",
                    geodata: "geodata",
                    pushtokens: "push_tokens",
                    subscriptions: "subscriptions",
                    events: "events",
                    data: "data",
                    type: ".json"
                },
                on: {
                    sessionExpired: null
                },
                timeout: null,
                debug: {
                    mode: 0,
                    file: null
                },
                addISOTime: !1
            };
            d.set = function(a) {
                "object" == typeof a.endpoints && a.endpoints.chat && (d.endpoints.muc = "muc." + a.endpoints.chat, d.chatProtocol.bosh = "https://" + a.endpoints.chat + ":5281", d.chatProtocol.websocket = "wss://" + a.endpoints.chat + ":5291"), Object.keys(a).forEach(function(b) {
                    "set" !== b && d.hasOwnProperty(b) && ("object" != typeof a[b] ? d[b] = a[b] : Object.keys(a[b]).forEach(function(c) {
                        d[b].hasOwnProperty(c) && (d[b][c] = a[b][c])
                    })), "iceServers" === b && (d.webrtc.iceServers = a[b])
                })
            }, b.exports = d
        }, {}],
        16: [function(a, b, c) {
            function d() {}
            var e = a("./qbConfig"),
                f = a("./qbUtils"),
                g = "undefined" != typeof window;
            d.prototype = {
                init: function(b, c, d, h) {
                    h && "object" == typeof h && e.set(h);
                    var i = a("./qbProxy");
                    this.service = new i;
                    var j, k = a("./modules/qbAuth"),
                        l = a("./modules/qbUsers"),
                        m = a("./modules/qbChat"),
                        n = a("./modules/qbContent"),
                        o = a("./modules/qbLocation"),
                        p = a("./modules/qbPushNotifications"),
                        q = a("./modules/qbData");
                    if (g) {
                        var r = a("./qbStrophe");
                        if (j = new r, f.isWebRTCAvailble()) {
                            var s = a("./modules/webrtc/qbWebRTCClient");
                            this.webrtc = new s(this.service, j || null)
                        } else this.webrtc = !1
                    } else this.webrtc = !1;
                    this.auth = new k(this.service), this.users = new l(this.service), this.chat = new m(this.service, this.webrtc ? this.webrtc.signalingProcessor : null, j || null), this.content = new n(this.service), this.location = new o(this.service), this.pushnotifications = new p(this.service), this.data = new q(this.service), "string" != typeof b || c && "number" != typeof c || d ? (e.creds.appId = b, e.creds.authKey = c, e.creds.authSecret = d) : ("number" == typeof c && (e.creds.appId = c), this.service.setSession({
                        token: b
                    }))
                },
                getSession: function(a) {
                    this.auth.getSession(a)
                },
                createSession: function(a, b) {
                    this.auth.createSession(a, b)
                },
                destroySession: function(a) {
                    this.auth.destroySession(a)
                },
                login: function(a, b) {
                    this.auth.login(a, b)
                },
                logout: function(a) {
                    this.auth.logout(a)
                }
            };
            var h = new d;
            h.QuickBlox = d, b.exports = h
        }, {
            "./modules/qbAuth": 1,
            "./modules/qbChat": 2,
            "./modules/qbContent": 3,
            "./modules/qbData": 4,
            "./modules/qbLocation": 5,
            "./modules/qbPushNotifications": 6,
            "./modules/qbUsers": 7,
            "./modules/webrtc/qbWebRTCClient": 9,
            "./qbConfig": 15,
            "./qbProxy": 17,
            "./qbStrophe": 18,
            "./qbUtils": 19
        }],
        17: [function(a, b, c) {
            function d() {
                this.qbInst = {
                    config: e,
                    session: null
                }
            }
            var e = a("./qbConfig"),
                f = a("./qbUtils"),
                g = e.version,
                h = "undefined" != typeof window;
            if (!h) var i = a("request");
            var j = h && window.jQuery && window.jQuery.ajax || h && window.Zepto && window.Zepto.ajax;
            if (h && !j) throw new Error("Quickblox requires jQuery or Zepto");
            d.prototype = {
                setSession: function(a) {
                    this.qbInst.session = a
                },
                getSession: function() {
                    return this.qbInst.session
                },
                handleResponse: function(a, b, c, d) {
                    !a || "function" != typeof e.on.sessionExpired || "Unauthorized" !== a.message && "401 Unauthorized" !== a.status ? a ? c(a, null) : (e.addISOTime && (b = f.injectISOTimes(b)),
                        c(null, b)) : e.on.sessionExpired(function() {
                        c(a, b)
                    }, d)
                },
                ajax: function(a, b) {
                    var c;
                    a.data && a.data.file ? (c = JSON.parse(JSON.stringify(a)), c.data.file = "...") : c = a, f.QBLog("[ServiceProxy]", "Request: ", a.type || "GET", {
                        data: JSON.stringify(c)
                    });
                    var d = this,
                        k = function(c) {
                            c && d.setSession(c), d.ajax(a, b)
                        },
                        l = {
                            url: a.url,
                            type: a.type || "GET",
                            dataType: a.dataType || "json",
                            data: a.data || " ",
                            timeout: e.timeout,
                            beforeSend: function(a, b) {
                                -1 === b.url.indexOf("s3.amazonaws.com") && d.qbInst.session && d.qbInst.session.token && (a.setRequestHeader("QB-Token", d.qbInst.session.token), a.setRequestHeader("QB-SDK", "JS " + g + " - Client"))
                            },
                            success: function(c, g, h) {
                                f.QBLog("[ServiceProxy]", "Response: ", {
                                    data: JSON.stringify(c)
                                }), -1 === a.url.indexOf(e.urls.session) ? d.handleResponse(null, c, b, k) : b(null, c)
                            },
                            error: function(c, g, h) {
                                f.QBLog("[ServiceProxy]", "ajax error", c.status, h, c.responseText);
                                var i = {
                                    code: c.status,
                                    status: g,
                                    message: h,
                                    detail: c.responseText
                                }; - 1 === a.url.indexOf(e.urls.session) ? d.handleResponse(i, null, b, k) : b(i, null)
                            }
                        };
                    if (!h) var m = "json" === l.dataType,
                        n = -1 === a.url.indexOf("s3.amazonaws.com") && d.qbInst && d.qbInst.session && d.qbInst.session.token || !1,
                        o = {
                            url: l.url,
                            method: l.type,
                            timeout: e.timeout,
                            json: m ? l.data : null,
                            headers: n ? {
                                "QB-Token": d.qbInst.session.token,
                                "QB-SDK": "JS " + g + " - Server"
                            } : null
                        },
                        p = function(a, c, f) {
                            if (a || 200 !== c.statusCode && 201 !== c.statusCode && 202 !== c.statusCode) {
                                var g;
                                try {
                                    g = {
                                        code: c && c.statusCode || a && a.code,
                                        status: c && c.headers && c.headers.status || "error",
                                        message: f || a && a.errno,
                                        detail: f && f.errors || a && a.syscall
                                    }
                                } catch (h) {
                                    g = a
                                } - 1 === o.url.indexOf(e.urls.session) ? d.handleResponse(g, null, b, k) : b(g, null)
                            } else -1 === o.url.indexOf(e.urls.session) ? d.handleResponse(null, f, b, k) : b(null, f)
                        };
                    if (("boolean" == typeof a.contentType || "string" == typeof a.contentType) && (l.contentType = a.contentType), "boolean" == typeof a.processData && (l.processData = a.processData), h) j(l);
                    else {
                        var q = i(o, p);
                        if (!m) {
                            var r = q.form();
                            Object.keys(l.data).forEach(function(a, b, c) {
                                r.append(a, l.data[a])
                            })
                        }
                    }
                }
            }, b.exports = d
        }, {
            "./qbConfig": 15,
            "./qbUtils": 19,
            request: 22
        }],
        18: [function(a, b, c) {
            function d() {
                var a = 1 === e.chatProtocol.active ? e.chatProtocol.bosh : e.chatProtocol.websocket,
                    b = new Strophe.Connection(a);
                return 1 === e.chatProtocol.active ? (b.xmlInput = function(a) {
                    if (a.childNodes[0])
                        for (var b = 0, c = a.childNodes.length; c > b; b++) f.QBLog("[QBChat]", "RECV:", a.childNodes[b])
                }, b.xmlOutput = function(a) {
                    if (a.childNodes[0])
                        for (var b = 0, c = a.childNodes.length; c > b; b++) f.QBLog("[QBChat]", "SENT:", a.childNodes[b])
                }) : (b.xmlInput = function(a) {
                    f.QBLog("[QBChat]", "RECV:", a)
                }, b.xmlOutput = function(a) {
                    f.QBLog("[QBChat]", "SENT:", a)
                }), b
            }
            a("strophe");
            var e = a("./qbConfig"),
                f = a("./qbUtils");
            b.exports = d
        }, {
            "./qbConfig": 15,
            "./qbUtils": 19,
            strophe: 159
        }],
        19: [function(a, b, c) {
            var d = a("./qbConfig"),
                e = "undefined" != typeof window,
                f = "This function isn't supported outside of the browser (...yet)";
            if (!e) var g = a("fs");
            var h = {
                    machine: Math.floor(16777216 * Math.random()).toString(16),
                    pid: Math.floor(32767 * Math.random()).toString(16),
                    increment: 0
                },
                i = {
                    safeCallbackCall: function() {
                        if (!e) throw f;
                        for (var a, b = arguments[0].toString(), c = b.split("(")[0].split(" ")[1], d = [], g = 0; g < arguments.length; g++) d.push(arguments[g]);
                        a = d.shift();
                        try {
                            a.apply(null, d)
                        } catch (h) {
                            "" === c ? console.error("Error: " + h) : console.error("Error in listener " + c + ": " + h)
                        }
                    },
                    randomNonce: function() {
                        return Math.floor(1e4 * Math.random())
                    },
                    unixTime: function() {
                        return Math.floor(Date.now() / 1e3)
                    },
                    getUrl: function(a, b) {
                        var c = b ? "/" + b : "";
                        return "https://" + d.endpoints.api + "/" + a + c + d.urls.type
                    },
                    getBsonObjectId: function() {
                        var a = this.unixTime().toString(16),
                            b = (h.increment++).toString(16);
                        return b > 16777215 && (h.increment = 0), "00000000".substr(0, 8 - a.length) + a + "000000".substr(0, 6 - h.machine.length) + h.machine + "0000".substr(0, 4 - h.pid.length) + h.pid + "000000".substr(0, 6 - b.length) + b
                    },
                    injectISOTimes: function(a) {
                        if (a.created_at) "number" == typeof a.created_at && (a.iso_created_at = new Date(1e3 * a.created_at).toISOString()), "number" == typeof a.updated_at && (a.iso_updated_at = new Date(1e3 * a.updated_at).toISOString());
                        else if (a.items)
                            for (var b = 0, c = a.items.length; c > b; ++b) "number" == typeof a.items[b].created_at && (a.items[b].iso_created_at = new Date(1e3 * a.items[b].created_at).toISOString()), "number" == typeof a.items[b].updated_at && (a.items[b].iso_updated_at = new Date(1e3 * a.items[b].updated_at).toISOString());
                        return a
                    },
                    QBLog: function() {
                        if (this.loggers)
                            for (var a = 0; a < this.loggers.length; ++a) this.loggers[a](arguments);
                        else {
                            this.loggers = [];
                            var b = function() {
                                    var a = function(a) {
                                        console.log.apply(console, Array.prototype.slice.call(a))
                                    };
                                    return a
                                },
                                c = function() {
                                    var a = function(a) {
                                        if (e) throw f;
                                        for (var b = [], c = 0; c < a.length; c++) b.push(JSON.stringify(a[c]));
                                        b = b.join(" ");
                                        var h = "\n" + new Date + ". " + b;
                                        g.appendFile(d.debug.file, h, function(a) {
                                            return a ? console.error("Error while writing log to file. Error: " + a) : void 0
                                        })
                                    };
                                    return a
                                };
                            if ("object" == typeof d.debug) {
                                if ("number" == typeof d.debug.mode) {
                                    if (1 == d.debug.mode) {
                                        var h = b();
                                        this.loggers.push(h)
                                    } else if (2 == d.debug.mode) {
                                        var h = c();
                                        this.loggers.push(h)
                                    }
                                } else if ("object" == typeof d.debug.mode) {
                                    var i = this;
                                    d.debug.mode.forEach(function(a, d, e) {
                                        if (1 === a) {
                                            var f = b();
                                            i.loggers.push(f)
                                        } else if (2 === a) {
                                            var f = c();
                                            i.loggers.push(f)
                                        }
                                    })
                                }
                            } else if ("boolean" == typeof d.debug && d.debug) {
                                var h = b();
                                this.loggers.push(h)
                            }
                            if (this.loggers)
                                for (var a = 0; a < this.loggers.length; ++a) this.loggers[a](arguments)
                        }
                    },
                    isWebRTCAvailble: function() {
                        var a = window.mozRTCPeerConnection || window.webkitRTCPeerConnection,
                            b = window.mozRTCIceCandidate || window.RTCIceCandidate,
                            c = window.mozRTCSessionDescription || window.RTCSessionDescription,
                            d = !0;
                        return a && b && c || (d = !1), d
                    },
                    getError: function(a, b, c) {
                        var d = {
                            code: a,
                            status: "error",
                            detail: b
                        };
                        switch (a) {
                            case 401:
                                d.message = "Unauthorized";
                                break;
                            case 403:
                                d.message = "Forbidden";
                                break;
                            case 408:
                                d.message = "Request Timeout";
                                break;
                            case 422:
                                d.message = "Unprocessable Entity";
                                break;
                            case 502:
                                d.message = "Bad Gateway";
                                break;
                            default:
                                d.message = "Unknown error"
                        }
                        return this.QBLog("[" + c + "]", "error: ", b), d
                    }
                };
            b.exports = i
        }, {
            "./qbConfig": 15,
            fs: 22
        }],
        20: [function(a, b, c) {
            var d = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            ! function(a) {
                "use strict";

                function b(a) {
                    var b = a.charCodeAt(0);
                    return b === g || b === l ? 62 : b === h || b === m ? 63 : i > b ? -1 : i + 10 > b ? b - i + 26 + 26 : k + 26 > b ? b - k : j + 26 > b ? b - j + 26 : void 0
                }

                function c(a) {
                    function c(a) {
                        j[l++] = a
                    }
                    var d, e, g, h, i, j;
                    if (a.length % 4 > 0) throw new Error("Invalid string. Length must be a multiple of 4");
                    var k = a.length;
                    i = "=" === a.charAt(k - 2) ? 2 : "=" === a.charAt(k - 1) ? 1 : 0, j = new f(3 * a.length / 4 - i), g = i > 0 ? a.length - 4 : a.length;
                    var l = 0;
                    for (d = 0, e = 0; g > d; d += 4, e += 3) h = b(a.charAt(d)) << 18 | b(a.charAt(d + 1)) << 12 | b(a.charAt(d + 2)) << 6 | b(a.charAt(d + 3)), c((16711680 & h) >> 16), c((65280 & h) >> 8), c(255 & h);
                    return 2 === i ? (h = b(a.charAt(d)) << 2 | b(a.charAt(d + 1)) >> 4, c(255 & h)) : 1 === i && (h = b(a.charAt(d)) << 10 | b(a.charAt(d + 1)) << 4 | b(a.charAt(d + 2)) >> 2, c(h >> 8 & 255), c(255 & h)), j
                }

                function e(a) {
                    function b(a) {
                        return d.charAt(a)
                    }

                    function c(a) {
                        return b(a >> 18 & 63) + b(a >> 12 & 63) + b(a >> 6 & 63) + b(63 & a)
                    }
                    var e, f, g, h = a.length % 3,
                        i = "";
                    for (e = 0, g = a.length - h; g > e; e += 3) f = (a[e] << 16) + (a[e + 1] << 8) + a[e + 2], i += c(f);
                    switch (h) {
                        case 1:
                            f = a[a.length - 1], i += b(f >> 2), i += b(f << 4 & 63), i += "==";
                            break;
                        case 2:
                            f = (a[a.length - 2] << 8) + a[a.length - 1], i += b(f >> 10), i += b(f >> 4 & 63), i += b(f << 2 & 63), i += "="
                    }
                    return i
                }
                var f = "undefined" != typeof Uint8Array ? Uint8Array : Array,
                    g = "+".charCodeAt(0),
                    h = "/".charCodeAt(0),
                    i = "0".charCodeAt(0),
                    j = "a".charCodeAt(0),
                    k = "A".charCodeAt(0),
                    l = "-".charCodeAt(0),
                    m = "_".charCodeAt(0);
                a.toByteArray = c, a.fromByteArray = e
            }("undefined" == typeof c ? this.base64js = {} : c)
        }, {}],
        21: [function(a, b, c) {}, {}],
        22: [function(a, b, c) {
            arguments[4][21][0].apply(c, arguments)
        }, {
            dup: 21
        }],
        23: [function(a, b, c) {
            (function(b) {
                "use strict";

                function d() {
                    function a() {}
                    try {
                        var b = new Uint8Array(1);
                        return b.foo = function() {
                            return 42
                        }, b.constructor = a, 42 === b.foo() && b.constructor === a && "function" == typeof b.subarray && 0 === b.subarray(1, 1).byteLength
                    } catch (c) {
                        return !1
                    }
                }

                function e() {
                    return f.TYPED_ARRAY_SUPPORT ? 2147483647 : 1073741823
                }

                function f(a) {
                    return this instanceof f ? (f.TYPED_ARRAY_SUPPORT || (this.length = 0, this.parent = void 0), "number" == typeof a ? g(this, a) : "string" == typeof a ? h(this, a, arguments.length > 1 ? arguments[1] : "utf8") : i(this, a)) : arguments.length > 1 ? new f(a, arguments[1]) : new f(a)
                }

                function g(a, b) {
                    if (a = p(a, 0 > b ? 0 : 0 | q(b)), !f.TYPED_ARRAY_SUPPORT)
                        for (var c = 0; b > c; c++) a[c] = 0;
                    return a
                }

                function h(a, b, c) {
                    ("string" != typeof c || "" === c) && (c = "utf8");
                    var d = 0 | s(b, c);
                    return a = p(a, d), a.write(b, c), a
                }

                function i(a, b) {
                    if (f.isBuffer(b)) return j(a, b);
                    if (Y(b)) return k(a, b);
                    if (null == b) throw new TypeError("must start with number, buffer, array or string");
                    if ("undefined" != typeof ArrayBuffer) {
                        if (b.buffer instanceof ArrayBuffer) return l(a, b);
                        if (b instanceof ArrayBuffer) return m(a, b)
                    }
                    return b.length ? n(a, b) : o(a, b)
                }

                function j(a, b) {
                    var c = 0 | q(b.length);
                    return a = p(a, c), b.copy(a, 0, 0, c), a
                }

                function k(a, b) {
                    var c = 0 | q(b.length);
                    a = p(a, c);
                    for (var d = 0; c > d; d += 1) a[d] = 255 & b[d];
                    return a
                }

                function l(a, b) {
                    var c = 0 | q(b.length);
                    a = p(a, c);
                    for (var d = 0; c > d; d += 1) a[d] = 255 & b[d];
                    return a
                }

                function m(a, b) {
                    return f.TYPED_ARRAY_SUPPORT ? (b.byteLength, a = f._augment(new Uint8Array(b))) : a = l(a, new Uint8Array(b)), a
                }

                function n(a, b) {
                    var c = 0 | q(b.length);
                    a = p(a, c);
                    for (var d = 0; c > d; d += 1) a[d] = 255 & b[d];
                    return a
                }

                function o(a, b) {
                    var c, d = 0;
                    "Buffer" === b.type && Y(b.data) && (c = b.data, d = 0 | q(c.length)), a = p(a, d);
                    for (var e = 0; d > e; e += 1) a[e] = 255 & c[e];
                    return a
                }

                function p(a, b) {
                    f.TYPED_ARRAY_SUPPORT ? (a = f._augment(new Uint8Array(b)), a.__proto__ = f.prototype) : (a.length = b, a._isBuffer = !0);
                    var c = 0 !== b && b <= f.poolSize >>> 1;
                    return c && (a.parent = Z), a
                }

                function q(a) {
                    if (a >= e()) throw new RangeError("Attempt to allocate Buffer larger than maximum size: 0x" + e().toString(16) + " bytes");
                    return 0 | a
                }

                function r(a, b) {
                    if (!(this instanceof r)) return new r(a, b);
                    var c = new f(a, b);
                    return delete c.parent, c
                }

                function s(a, b) {
                    "string" != typeof a && (a = "" + a);
                    var c = a.length;
                    if (0 === c) return 0;
                    for (var d = !1;;) switch (b) {
                        case "ascii":
                        case "binary":
                        case "raw":
                        case "raws":
                            return c;
                        case "utf8":
                        case "utf-8":
                            return R(a).length;
                        case "ucs2":
                        case "ucs-2":
                        case "utf16le":
                        case "utf-16le":
                            return 2 * c;
                        case "hex":
                            return c >>> 1;
                        case "base64":
                            return U(a).length;
                        default:
                            if (d) return R(a).length;
                            b = ("" + b).toLowerCase(), d = !0
                    }
                }

                function t(a, b, c) {
                    var d = !1;
                    if (b = 0 | b, c = void 0 === c || c === 1 / 0 ? this.length : 0 | c, a || (a = "utf8"), 0 > b && (b = 0), c > this.length && (c = this.length), b >= c) return "";
                    for (;;) switch (a) {
                        case "hex":
                            return F(this, b, c);
                        case "utf8":
                        case "utf-8":
                            return B(this, b, c);
                        case "ascii":
                            return D(this, b, c);
                        case "binary":
                            return E(this, b, c);
                        case "base64":
                            return A(this, b, c);
                        case "ucs2":
                        case "ucs-2":
                        case "utf16le":
                        case "utf-16le":
                            return G(this, b, c);
                        default:
                            if (d) throw new TypeError("Unknown encoding: " + a);
                            a = (a + "").toLowerCase(), d = !0
                    }
                }

                function u(a, b, c, d) {
                    c = Number(c) || 0;
                    var e = a.length - c;
                    d ? (d = Number(d), d > e && (d = e)) : d = e;
                    var f = b.length;
                    if (f % 2 !== 0) throw new Error("Invalid hex string");
                    d > f / 2 && (d = f / 2);
                    for (var g = 0; d > g; g++) {
                        var h = parseInt(b.substr(2 * g, 2), 16);
                        if (isNaN(h)) throw new Error("Invalid hex string");
                        a[c + g] = h
                    }
                    return g
                }

                function v(a, b, c, d) {
                    return V(R(b, a.length - c), a, c, d)
                }

                function w(a, b, c, d) {
                    return V(S(b), a, c, d)
                }

                function x(a, b, c, d) {
                    return w(a, b, c, d)
                }

                function y(a, b, c, d) {
                    return V(U(b), a, c, d)
                }

                function z(a, b, c, d) {
                    return V(T(b, a.length - c), a, c, d)
                }

                function A(a, b, c) {
                    return 0 === b && c === a.length ? W.fromByteArray(a) : W.fromByteArray(a.slice(b, c))
                }

                function B(a, b, c) {
                    c = Math.min(a.length, c);
                    for (var d = [], e = b; c > e;) {
                        var f = a[e],
                            g = null,
                            h = f > 239 ? 4 : f > 223 ? 3 : f > 191 ? 2 : 1;
                        if (c >= e + h) {
                            var i, j, k, l;
                            switch (h) {
                                case 1:
                                    128 > f && (g = f);
                                    break;
                                case 2:
                                    i = a[e + 1], 128 === (192 & i) && (l = (31 & f) << 6 | 63 & i, l > 127 && (g = l));
                                    break;
                                case 3:
                                    i = a[e + 1], j = a[e + 2], 128 === (192 & i) && 128 === (192 & j) && (l = (15 & f) << 12 | (63 & i) << 6 | 63 & j, l > 2047 && (55296 > l || l > 57343) && (g = l));
                                    break;
                                case 4:
                                    i = a[e + 1], j = a[e + 2], k = a[e + 3], 128 === (192 & i) && 128 === (192 & j) && 128 === (192 & k) && (l = (15 & f) << 18 | (63 & i) << 12 | (63 & j) << 6 | 63 & k, l > 65535 && 1114112 > l && (g = l))
                            }
                        }
                        null === g ? (g = 65533, h = 1) : g > 65535 && (g -= 65536, d.push(g >>> 10 & 1023 | 55296), g = 56320 | 1023 & g), d.push(g), e += h
                    }
                    return C(d)
                }

                function C(a) {
                    var b = a.length;
                    if ($ >= b) return String.fromCharCode.apply(String, a);
                    for (var c = "", d = 0; b > d;) c += String.fromCharCode.apply(String, a.slice(d, d += $));
                    return c
                }

                function D(a, b, c) {
                    var d = "";
                    c = Math.min(a.length, c);
                    for (var e = b; c > e; e++) d += String.fromCharCode(127 & a[e]);
                    return d
                }

                function E(a, b, c) {
                    var d = "";
                    c = Math.min(a.length, c);
                    for (var e = b; c > e; e++) d += String.fromCharCode(a[e]);
                    return d
                }

                function F(a, b, c) {
                    var d = a.length;
                    (!b || 0 > b) && (b = 0), (!c || 0 > c || c > d) && (c = d);
                    for (var e = "", f = b; c > f; f++) e += Q(a[f]);
                    return e
                }

                function G(a, b, c) {
                    for (var d = a.slice(b, c), e = "", f = 0; f < d.length; f += 2) e += String.fromCharCode(d[f] + 256 * d[f + 1]);
                    return e
                }

                function H(a, b, c) {
                    if (a % 1 !== 0 || 0 > a) throw new RangeError("offset is not uint");
                    if (a + b > c) throw new RangeError("Trying to access beyond buffer length")
                }

                function I(a, b, c, d, e, g) {
                    if (!f.isBuffer(a)) throw new TypeError("buffer must be a Buffer instance");
                    if (b > e || g > b) throw new RangeError("value is out of bounds");
                    if (c + d > a.length) throw new RangeError("index out of range")
                }

                function J(a, b, c, d) {
                    0 > b && (b = 65535 + b + 1);
                    for (var e = 0, f = Math.min(a.length - c, 2); f > e; e++) a[c + e] = (b & 255 << 8 * (d ? e : 1 - e)) >>> 8 * (d ? e : 1 - e)
                }

                function K(a, b, c, d) {
                    0 > b && (b = 4294967295 + b + 1);
                    for (var e = 0, f = Math.min(a.length - c, 4); f > e; e++) a[c + e] = b >>> 8 * (d ? e : 3 - e) & 255
                }

                function L(a, b, c, d, e, f) {
                    if (b > e || f > b) throw new RangeError("value is out of bounds");
                    if (c + d > a.length) throw new RangeError("index out of range");
                    if (0 > c) throw new RangeError("index out of range")
                }

                function M(a, b, c, d, e) {
                    return e || L(a, b, c, 4, 3.4028234663852886e38, -3.4028234663852886e38), X.write(a, b, c, d, 23, 4), c + 4
                }

                function N(a, b, c, d, e) {
                    return e || L(a, b, c, 8, 1.7976931348623157e308, -1.7976931348623157e308), X.write(a, b, c, d, 52, 8), c + 8
                }

                function O(a) {
                    if (a = P(a).replace(aa, ""), a.length < 2) return "";
                    for (; a.length % 4 !== 0;) a += "=";
                    return a
                }

                function P(a) {
                    return a.trim ? a.trim() : a.replace(/^\s+|\s+$/g, "")
                }

                function Q(a) {
                    return 16 > a ? "0" + a.toString(16) : a.toString(16)
                }

                function R(a, b) {
                    b = b || 1 / 0;
                    for (var c, d = a.length, e = null, f = [], g = 0; d > g; g++) {
                        if (c = a.charCodeAt(g), c > 55295 && 57344 > c) {
                            if (!e) {
                                if (c > 56319) {
                                    (b -= 3) > -1 && f.push(239, 191, 189);
                                    continue
                                }
                                if (g + 1 === d) {
                                    (b -= 3) > -1 && f.push(239, 191, 189);
                                    continue
                                }
                                e = c;
                                continue
                            }
                            if (56320 > c) {
                                (b -= 3) > -1 && f.push(239, 191, 189), e = c;
                                continue
                            }
                            c = (e - 55296 << 10 | c - 56320) + 65536
                        } else e && (b -= 3) > -1 && f.push(239, 191, 189);
                        if (e = null, 128 > c) {
                            if ((b -= 1) < 0) break;
                            f.push(c)
                        } else if (2048 > c) {
                            if ((b -= 2) < 0) break;
                            f.push(c >> 6 | 192, 63 & c | 128)
                        } else if (65536 > c) {
                            if ((b -= 3) < 0) break;
                            f.push(c >> 12 | 224, c >> 6 & 63 | 128, 63 & c | 128)
                        } else {
                            if (!(1114112 > c)) throw new Error("Invalid code point");
                            if ((b -= 4) < 0) break;
                            f.push(c >> 18 | 240, c >> 12 & 63 | 128, c >> 6 & 63 | 128, 63 & c | 128)
                        }
                    }
                    return f
                }

                function S(a) {
                    for (var b = [], c = 0; c < a.length; c++) b.push(255 & a.charCodeAt(c));
                    return b
                }

                function T(a, b) {
                    for (var c, d, e, f = [], g = 0; g < a.length && !((b -= 2) < 0); g++) c = a.charCodeAt(g), d = c >> 8, e = c % 256, f.push(e), f.push(d);
                    return f
                }

                function U(a) {
                    return W.toByteArray(O(a))
                }

                function V(a, b, c, d) {
                    for (var e = 0; d > e && !(e + c >= b.length || e >= a.length); e++) b[e + c] = a[e];
                    return e
                }
                var W = a("base64-js"),
                    X = a("ieee754"),
                    Y = a("isarray");
                c.Buffer = f, c.SlowBuffer = r, c.INSPECT_MAX_BYTES = 50, f.poolSize = 8192;
                var Z = {};
                f.TYPED_ARRAY_SUPPORT = void 0 !== b.TYPED_ARRAY_SUPPORT ? b.TYPED_ARRAY_SUPPORT : d(), f.TYPED_ARRAY_SUPPORT ? (f.prototype.__proto__ = Uint8Array.prototype, f.__proto__ = Uint8Array) : (f.prototype.length = void 0, f.prototype.parent = void 0), f.isBuffer = function(a) {
                    return !(null == a || !a._isBuffer)
                }, f.compare = function(a, b) {
                    if (!f.isBuffer(a) || !f.isBuffer(b)) throw new TypeError("Arguments must be Buffers");
                    if (a === b) return 0;
                    for (var c = a.length, d = b.length, e = 0, g = Math.min(c, d); g > e && a[e] === b[e];) ++e;
                    return e !== g && (c = a[e], d = b[e]), d > c ? -1 : c > d ? 1 : 0
                }, f.isEncoding = function(a) {
                    switch (String(a).toLowerCase()) {
                        case "hex":
                        case "utf8":
                        case "utf-8":
                        case "ascii":
                        case "binary":
                        case "base64":
                        case "raw":
                        case "ucs2":
                        case "ucs-2":
                        case "utf16le":
                        case "utf-16le":
                            return !0;
                        default:
                            return !1
                    }
                }, f.concat = function(a, b) {
                    if (!Y(a)) throw new TypeError("list argument must be an Array of Buffers.");
                    if (0 === a.length) return new f(0);
                    var c;
                    if (void 0 === b)
                        for (b = 0, c = 0; c < a.length; c++) b += a[c].length;
                    var d = new f(b),
                        e = 0;
                    for (c = 0; c < a.length; c++) {
                        var g = a[c];
                        g.copy(d, e), e += g.length
                    }
                    return d
                }, f.byteLength = s, f.prototype.toString = function() {
                    var a = 0 | this.length;
                    return 0 === a ? "" : 0 === arguments.length ? B(this, 0, a) : t.apply(this, arguments)
                }, f.prototype.equals = function(a) {
                    if (!f.isBuffer(a)) throw new TypeError("Argument must be a Buffer");
                    return this === a ? !0 : 0 === f.compare(this, a)
                }, f.prototype.inspect = function() {
                    var a = "",
                        b = c.INSPECT_MAX_BYTES;
                    return this.length > 0 && (a = this.toString("hex", 0, b).match(/.{2}/g).join(" "), this.length > b && (a += " ... ")), "<Buffer " + a + ">"
                }, f.prototype.compare = function(a) {
                    if (!f.isBuffer(a)) throw new TypeError("Argument must be a Buffer");
                    return this === a ? 0 : f.compare(this, a)
                }, f.prototype.indexOf = function(a, b) {
                    function c(a, b, c) {
                        for (var d = -1, e = 0; c + e < a.length; e++)
                            if (a[c + e] === b[-1 === d ? 0 : e - d]) {
                                if (-1 === d && (d = e), e - d + 1 === b.length) return c + d
                            } else d = -1;
                        return -1
                    }
                    if (b > 2147483647 ? b = 2147483647 : -2147483648 > b && (b = -2147483648), b >>= 0, 0 === this.length) return -1;
                    if (b >= this.length) return -1;
                    if (0 > b && (b = Math.max(this.length + b, 0)), "string" == typeof a) return 0 === a.length ? -1 : String.prototype.indexOf.call(this, a, b);
                    if (f.isBuffer(a)) return c(this, a, b);
                    if ("number" == typeof a) return f.TYPED_ARRAY_SUPPORT && "function" === Uint8Array.prototype.indexOf ? Uint8Array.prototype.indexOf.call(this, a, b) : c(this, [a], b);
                    throw new TypeError("val must be string, number or Buffer")
                }, f.prototype.get = function(a) {
                    return console.log(".get() is deprecated. Access using array indexes instead."), this.readUInt8(a)
                }, f.prototype.set = function(a, b) {
                    return console.log(".set() is deprecated. Access using array indexes instead."), this.writeUInt8(a, b)
                }, f.prototype.write = function(a, b, c, d) {
                    if (void 0 === b) d = "utf8", c = this.length, b = 0;
                    else if (void 0 === c && "string" == typeof b) d = b, c = this.length, b = 0;
                    else if (isFinite(b)) b = 0 | b, isFinite(c) ? (c = 0 | c, void 0 === d && (d = "utf8")) : (d = c, c = void 0);
                    else {
                        var e = d;
                        d = b, b = 0 | c, c = e
                    }
                    var f = this.length - b;
                    if ((void 0 === c || c > f) && (c = f), a.length > 0 && (0 > c || 0 > b) || b > this.length) throw new RangeError("attempt to write outside buffer bounds");
                    d || (d = "utf8");
                    for (var g = !1;;) switch (d) {
                        case "hex":
                            return u(this, a, b, c);
                        case "utf8":
                        case "utf-8":
                            return v(this, a, b, c);
                        case "ascii":
                            return w(this, a, b, c);
                        case "binary":
                            return x(this, a, b, c);
                        case "base64":
                            return y(this, a, b, c);
                        case "ucs2":
                        case "ucs-2":
                        case "utf16le":
                        case "utf-16le":
                            return z(this, a, b, c);
                        default:
                            if (g) throw new TypeError("Unknown encoding: " + d);
                            d = ("" + d).toLowerCase(), g = !0
                    }
                }, f.prototype.toJSON = function() {
                    return {
                        type: "Buffer",
                        data: Array.prototype.slice.call(this._arr || this, 0)
                    }
                };
                var $ = 4096;
                f.prototype.slice = function(a, b) {
                    var c = this.length;
                    a = ~~a, b = void 0 === b ? c : ~~b, 0 > a ? (a += c, 0 > a && (a = 0)) : a > c && (a = c), 0 > b ? (b += c, 0 > b && (b = 0)) : b > c && (b = c), a > b && (b = a);
                    var d;
                    if (f.TYPED_ARRAY_SUPPORT) d = f._augment(this.subarray(a, b));
                    else {
                        var e = b - a;
                        d = new f(e, void 0);
                        for (var g = 0; e > g; g++) d[g] = this[g + a]
                    }
                    return d.length && (d.parent = this.parent || this), d
                }, f.prototype.readUIntLE = function(a, b, c) {
                    a = 0 | a, b = 0 | b, c || H(a, b, this.length);
                    for (var d = this[a], e = 1, f = 0; ++f < b && (e *= 256);) d += this[a + f] * e;
                    return d
                }, f.prototype.readUIntBE = function(a, b, c) {
                    a = 0 | a, b = 0 | b, c || H(a, b, this.length);
                    for (var d = this[a + --b], e = 1; b > 0 && (e *= 256);) d += this[a + --b] * e;
                    return d
                }, f.prototype.readUInt8 = function(a, b) {
                    return b || H(a, 1, this.length), this[a]
                }, f.prototype.readUInt16LE = function(a, b) {
                    return b || H(a, 2, this.length), this[a] | this[a + 1] << 8
                }, f.prototype.readUInt16BE = function(a, b) {
                    return b || H(a, 2, this.length), this[a] << 8 | this[a + 1]
                }, f.prototype.readUInt32LE = function(a, b) {
                    return b || H(a, 4, this.length), (this[a] | this[a + 1] << 8 | this[a + 2] << 16) + 16777216 * this[a + 3]
                }, f.prototype.readUInt32BE = function(a, b) {
                    return b || H(a, 4, this.length), 16777216 * this[a] + (this[a + 1] << 16 | this[a + 2] << 8 | this[a + 3])
                }, f.prototype.readIntLE = function(a, b, c) {
                    a = 0 | a, b = 0 | b, c || H(a, b, this.length);
                    for (var d = this[a], e = 1, f = 0; ++f < b && (e *= 256);) d += this[a + f] * e;
                    return e *= 128, d >= e && (d -= Math.pow(2, 8 * b)), d
                }, f.prototype.readIntBE = function(a, b, c) {
                    a = 0 | a, b = 0 | b, c || H(a, b, this.length);
                    for (var d = b, e = 1, f = this[a + --d]; d > 0 && (e *= 256);) f += this[a + --d] * e;
                    return e *= 128, f >= e && (f -= Math.pow(2, 8 * b)), f
                }, f.prototype.readInt8 = function(a, b) {
                    return b || H(a, 1, this.length), 128 & this[a] ? -1 * (255 - this[a] + 1) : this[a]
                }, f.prototype.readInt16LE = function(a, b) {
                    b || H(a, 2, this.length);
                    var c = this[a] | this[a + 1] << 8;
                    return 32768 & c ? 4294901760 | c : c
                }, f.prototype.readInt16BE = function(a, b) {
                    b || H(a, 2, this.length);
                    var c = this[a + 1] | this[a] << 8;
                    return 32768 & c ? 4294901760 | c : c
                }, f.prototype.readInt32LE = function(a, b) {
                    return b || H(a, 4, this.length), this[a] | this[a + 1] << 8 | this[a + 2] << 16 | this[a + 3] << 24
                }, f.prototype.readInt32BE = function(a, b) {
                    return b || H(a, 4, this.length), this[a] << 24 | this[a + 1] << 16 | this[a + 2] << 8 | this[a + 3]
                }, f.prototype.readFloatLE = function(a, b) {
                    return b || H(a, 4, this.length), X.read(this, a, !0, 23, 4)
                }, f.prototype.readFloatBE = function(a, b) {
                    return b || H(a, 4, this.length), X.read(this, a, !1, 23, 4)
                }, f.prototype.readDoubleLE = function(a, b) {
                    return b || H(a, 8, this.length), X.read(this, a, !0, 52, 8)
                }, f.prototype.readDoubleBE = function(a, b) {
                    return b || H(a, 8, this.length), X.read(this, a, !1, 52, 8)
                }, f.prototype.writeUIntLE = function(a, b, c, d) {
                    a = +a, b = 0 | b, c = 0 | c, d || I(this, a, b, c, Math.pow(2, 8 * c), 0);
                    var e = 1,
                        f = 0;
                    for (this[b] = 255 & a; ++f < c && (e *= 256);) this[b + f] = a / e & 255;
                    return b + c
                }, f.prototype.writeUIntBE = function(a, b, c, d) {
                    a = +a, b = 0 | b, c = 0 | c, d || I(this, a, b, c, Math.pow(2, 8 * c), 0);
                    var e = c - 1,
                        f = 1;
                    for (this[b + e] = 255 & a; --e >= 0 && (f *= 256);) this[b + e] = a / f & 255;
                    return b + c
                }, f.prototype.writeUInt8 = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 1, 255, 0), f.TYPED_ARRAY_SUPPORT || (a = Math.floor(a)), this[b] = 255 & a, b + 1
                }, f.prototype.writeUInt16LE = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 2, 65535, 0), f.TYPED_ARRAY_SUPPORT ? (this[b] = 255 & a, this[b + 1] = a >>> 8) : J(this, a, b, !0), b + 2
                }, f.prototype.writeUInt16BE = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 2, 65535, 0), f.TYPED_ARRAY_SUPPORT ? (this[b] = a >>> 8, this[b + 1] = 255 & a) : J(this, a, b, !1), b + 2
                }, f.prototype.writeUInt32LE = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 4, 4294967295, 0), f.TYPED_ARRAY_SUPPORT ? (this[b + 3] = a >>> 24, this[b + 2] = a >>> 16, this[b + 1] = a >>> 8, this[b] = 255 & a) : K(this, a, b, !0), b + 4
                }, f.prototype.writeUInt32BE = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 4, 4294967295, 0), f.TYPED_ARRAY_SUPPORT ? (this[b] = a >>> 24, this[b + 1] = a >>> 16, this[b + 2] = a >>> 8, this[b + 3] = 255 & a) : K(this, a, b, !1), b + 4
                }, f.prototype.writeIntLE = function(a, b, c, d) {
                    if (a = +a, b = 0 | b, !d) {
                        var e = Math.pow(2, 8 * c - 1);
                        I(this, a, b, c, e - 1, -e)
                    }
                    var f = 0,
                        g = 1,
                        h = 0 > a ? 1 : 0;
                    for (this[b] = 255 & a; ++f < c && (g *= 256);) this[b + f] = (a / g >> 0) - h & 255;
                    return b + c
                }, f.prototype.writeIntBE = function(a, b, c, d) {
                    if (a = +a, b = 0 | b, !d) {
                        var e = Math.pow(2, 8 * c - 1);
                        I(this, a, b, c, e - 1, -e)
                    }
                    var f = c - 1,
                        g = 1,
                        h = 0 > a ? 1 : 0;
                    for (this[b + f] = 255 & a; --f >= 0 && (g *= 256);) this[b + f] = (a / g >> 0) - h & 255;
                    return b + c
                }, f.prototype.writeInt8 = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 1, 127, -128), f.TYPED_ARRAY_SUPPORT || (a = Math.floor(a)), 0 > a && (a = 255 + a + 1), this[b] = 255 & a, b + 1
                }, f.prototype.writeInt16LE = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 2, 32767, -32768), f.TYPED_ARRAY_SUPPORT ? (this[b] = 255 & a, this[b + 1] = a >>> 8) : J(this, a, b, !0), b + 2
                }, f.prototype.writeInt16BE = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 2, 32767, -32768), f.TYPED_ARRAY_SUPPORT ? (this[b] = a >>> 8, this[b + 1] = 255 & a) : J(this, a, b, !1), b + 2
                }, f.prototype.writeInt32LE = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 4, 2147483647, -2147483648), f.TYPED_ARRAY_SUPPORT ? (this[b] = 255 & a, this[b + 1] = a >>> 8, this[b + 2] = a >>> 16, this[b + 3] = a >>> 24) : K(this, a, b, !0), b + 4
                }, f.prototype.writeInt32BE = function(a, b, c) {
                    return a = +a, b = 0 | b, c || I(this, a, b, 4, 2147483647, -2147483648), 0 > a && (a = 4294967295 + a + 1), f.TYPED_ARRAY_SUPPORT ? (this[b] = a >>> 24, this[b + 1] = a >>> 16, this[b + 2] = a >>> 8, this[b + 3] = 255 & a) : K(this, a, b, !1), b + 4
                }, f.prototype.writeFloatLE = function(a, b, c) {
                    return M(this, a, b, !0, c)
                }, f.prototype.writeFloatBE = function(a, b, c) {
                    return M(this, a, b, !1, c)
                }, f.prototype.writeDoubleLE = function(a, b, c) {
                    return N(this, a, b, !0, c)
                }, f.prototype.writeDoubleBE = function(a, b, c) {
                    return N(this, a, b, !1, c)
                }, f.prototype.copy = function(a, b, c, d) {
                    if (c || (c = 0), d || 0 === d || (d = this.length), b >= a.length && (b = a.length), b || (b = 0), d > 0 && c > d && (d = c), d === c) return 0;
                    if (0 === a.length || 0 === this.length) return 0;
                    if (0 > b) throw new RangeError("targetStart out of bounds");
                    if (0 > c || c >= this.length) throw new RangeError("sourceStart out of bounds");
                    if (0 > d) throw new RangeError("sourceEnd out of bounds");
                    d > this.length && (d = this.length), a.length - b < d - c && (d = a.length - b + c);
                    var e, g = d - c;
                    if (this === a && b > c && d > b)
                        for (e = g - 1; e >= 0; e--) a[e + b] = this[e + c];
                    else if (1e3 > g || !f.TYPED_ARRAY_SUPPORT)
                        for (e = 0; g > e; e++) a[e + b] = this[e + c];
                    else a._set(this.subarray(c, c + g), b);
                    return g
                }, f.prototype.fill = function(a, b, c) {
                    if (a || (a = 0), b || (b = 0), c || (c = this.length), b > c) throw new RangeError("end < start");
                    if (c !== b && 0 !== this.length) {
                        if (0 > b || b >= this.length) throw new RangeError("start out of bounds");
                        if (0 > c || c > this.length) throw new RangeError("end out of bounds");
                        var d;
                        if ("number" == typeof a)
                            for (d = b; c > d; d++) this[d] = a;
                        else {
                            var e = R(a.toString()),
                                f = e.length;
                            for (d = b; c > d; d++) this[d] = e[d % f]
                        }
                        return this
                    }
                }, f.prototype.toArrayBuffer = function() {
                    if ("undefined" != typeof Uint8Array) {
                        if (f.TYPED_ARRAY_SUPPORT) return new f(this).buffer;
                        for (var a = new Uint8Array(this.length), b = 0, c = a.length; c > b; b += 1) a[b] = this[b];
                        return a.buffer
                    }
                    throw new TypeError("Buffer.toArrayBuffer not supported in this browser")
                };
                var _ = f.prototype;
                f._augment = function(a) {
                    return a.constructor = f, a._isBuffer = !0, a._set = a.set, a.get = _.get, a.set = _.set, a.write = _.write, a.toString = _.toString, a.toLocaleString = _.toString, a.toJSON = _.toJSON, a.equals = _.equals, a.compare = _.compare, a.indexOf = _.indexOf, a.copy = _.copy, a.slice = _.slice, a.readUIntLE = _.readUIntLE, a.readUIntBE = _.readUIntBE, a.readUInt8 = _.readUInt8, a.readUInt16LE = _.readUInt16LE, a.readUInt16BE = _.readUInt16BE, a.readUInt32LE = _.readUInt32LE, a.readUInt32BE = _.readUInt32BE, a.readIntLE = _.readIntLE, a.readIntBE = _.readIntBE, a.readInt8 = _.readInt8, a.readInt16LE = _.readInt16LE, a.readInt16BE = _.readInt16BE, a.readInt32LE = _.readInt32LE, a.readInt32BE = _.readInt32BE, a.readFloatLE = _.readFloatLE, a.readFloatBE = _.readFloatBE, a.readDoubleLE = _.readDoubleLE, a.readDoubleBE = _.readDoubleBE, a.writeUInt8 = _.writeUInt8, a.writeUIntLE = _.writeUIntLE, a.writeUIntBE = _.writeUIntBE, a.writeUInt16LE = _.writeUInt16LE, a.writeUInt16BE = _.writeUInt16BE, a.writeUInt32LE = _.writeUInt32LE, a.writeUInt32BE = _.writeUInt32BE, a.writeIntLE = _.writeIntLE, a.writeIntBE = _.writeIntBE, a.writeInt8 = _.writeInt8, a.writeInt16LE = _.writeInt16LE, a.writeInt16BE = _.writeInt16BE, a.writeInt32LE = _.writeInt32LE, a.writeInt32BE = _.writeInt32BE, a.writeFloatLE = _.writeFloatLE, a.writeFloatBE = _.writeFloatBE, a.writeDoubleLE = _.writeDoubleLE, a.writeDoubleBE = _.writeDoubleBE, a.fill = _.fill, a.inspect = _.inspect, a.toArrayBuffer = _.toArrayBuffer, a
                };
                var aa = /[^+\/0-9A-Za-z-_]/g
            }).call(this, "undefined" != typeof global ? global : "undefined" != typeof self ? self : "undefined" != typeof window ? window : {})
        }, {
            "base64-js": 20,
            ieee754: 31,
            isarray: 24
        }],
        24: [function(a, b, c) {
            var d = {}.toString;
            b.exports = Array.isArray || function(a) {
                return "[object Array]" == d.call(a)
            }
        }, {}],
        25: [function(a, b, c) {
            (function(a) {
                function b(a) {
                    return Array.isArray ? Array.isArray(a) : "[object Array]" === q(a)
                }

                function d(a) {
                    return "boolean" == typeof a
                }

                function e(a) {
                    return null === a
                }

                function f(a) {
                    return null == a
                }

                function g(a) {
                    return "number" == typeof a
                }

                function h(a) {
                    return "string" == typeof a
                }

                function i(a) {
                    return "symbol" == typeof a
                }

                function j(a) {
                    return void 0 === a
                }

                function k(a) {
                    return "[object RegExp]" === q(a)
                }

                function l(a) {
                    return "object" == typeof a && null !== a
                }

                function m(a) {
                    return "[object Date]" === q(a)
                }

                function n(a) {
                    return "[object Error]" === q(a) || a instanceof Error
                }

                function o(a) {
                    return "function" == typeof a
                }

                function p(a) {
                    return null === a || "boolean" == typeof a || "number" == typeof a || "string" == typeof a || "symbol" == typeof a || "undefined" == typeof a
                }

                function q(a) {
                    return Object.prototype.toString.call(a)
                }
                c.isArray = b, c.isBoolean = d, c.isNull = e, c.isNullOrUndefined = f, c.isNumber = g, c.isString = h, c.isSymbol = i, c.isUndefined = j, c.isRegExp = k, c.isObject = l, c.isDate = m, c.isError = n, c.isFunction = o, c.isPrimitive = p, c.isBuffer = a.isBuffer
            }).call(this, {
                isBuffer: a("../../is-buffer/index.js")
            })
        }, {
            "../../is-buffer/index.js": 33
        }],
        26: [function(b, c, d) {
            ! function(b, e) {
                "object" == typeof d ? c.exports = d = e() : "function" == typeof a && a.amd ? a([], e) : b.CryptoJS = e()
            }(this, function() {
                var a = a || function(a, b) {
                    var c = {},
                        d = c.lib = {},
                        e = d.Base = function() {
                            function a() {}
                            return {
                                extend: function(b) {
                                    a.prototype = this;
                                    var c = new a;
                                    return b && c.mixIn(b), c.hasOwnProperty("init") || (c.init = function() {
                                        c.$super.init.apply(this, arguments)
                                    }), c.init.prototype = c, c.$super = this, c
                                },
                                create: function() {
                                    var a = this.extend();
                                    return a.init.apply(a, arguments), a
                                },
                                init: function() {},
                                mixIn: function(a) {
                                    for (var b in a) a.hasOwnProperty(b) && (this[b] = a[b]);
                                    a.hasOwnProperty("toString") && (this.toString = a.toString)
                                },
                                clone: function() {
                                    return this.init.prototype.extend(this)
                                }
                            }
                        }(),
                        f = d.WordArray = e.extend({
                            init: function(a, c) {
                                a = this.words = a || [], this.sigBytes = c != b ? c : 4 * a.length
                            },
                            toString: function(a) {
                                return (a || h).stringify(this)
                            },
                            concat: function(a) {
                                var b = this.words,
                                    c = a.words,
                                    d = this.sigBytes,
                                    e = a.sigBytes;
                                if (this.clamp(), d % 4)
                                    for (var f = 0; e > f; f++) {
                                        var g = 255 & c[f >>> 2] >>> 24 - 8 * (f % 4);
                                        b[d + f >>> 2] |= g << 24 - 8 * ((d + f) % 4)
                                    } else if (c.length > 65535)
                                        for (var f = 0; e > f; f += 4) b[d + f >>> 2] = c[f >>> 2];
                                    else b.push.apply(b, c);
                                return this.sigBytes += e, this
                            },
                            clamp: function() {
                                var b = this.words,
                                    c = this.sigBytes;
                                b[c >>> 2] &= 4294967295 << 32 - 8 * (c % 4), b.length = a.ceil(c / 4)
                            },
                            clone: function() {
                                var a = e.clone.call(this);
                                return a.words = this.words.slice(0), a
                            },
                            random: function(b) {
                                for (var c = [], d = 0; b > d; d += 4) c.push(0 | 4294967296 * a.random());
                                return new f.init(c, b)
                            }
                        }),
                        g = c.enc = {},
                        h = g.Hex = {
                            stringify: function(a) {
                                for (var b = a.words, c = a.sigBytes, d = [], e = 0; c > e; e++) {
                                    var f = 255 & b[e >>> 2] >>> 24 - 8 * (e % 4);
                                    d.push((f >>> 4).toString(16)), d.push((15 & f).toString(16))
                                }
                                return d.join("")
                            },
                            parse: function(a) {
                                for (var b = a.length, c = [], d = 0; b > d; d += 2) c[d >>> 3] |= parseInt(a.substr(d, 2), 16) << 24 - 4 * (d % 8);
                                return new f.init(c, b / 2)
                            }
                        },
                        i = g.Latin1 = {
                            stringify: function(a) {
                                for (var b = a.words, c = a.sigBytes, d = [], e = 0; c > e; e++) {
                                    var f = 255 & b[e >>> 2] >>> 24 - 8 * (e % 4);
                                    d.push(String.fromCharCode(f))
                                }
                                return d.join("")
                            },
                            parse: function(a) {
                                for (var b = a.length, c = [], d = 0; b > d; d++) c[d >>> 2] |= (255 & a.charCodeAt(d)) << 24 - 8 * (d % 4);
                                return new f.init(c, b)
                            }
                        },
                        j = g.Utf8 = {
                            stringify: function(a) {
                                try {
                                    return decodeURIComponent(escape(i.stringify(a)))
                                } catch (b) {
                                    throw Error("Malformed UTF-8 data")
                                }
                            },
                            parse: function(a) {
                                return i.parse(unescape(encodeURIComponent(a)))
                            }
                        },
                        k = d.BufferedBlockAlgorithm = e.extend({
                            reset: function() {
                                this._data = new f.init, this._nDataBytes = 0
                            },
                            _append: function(a) {
                                "string" == typeof a && (a = j.parse(a)), this._data.concat(a), this._nDataBytes += a.sigBytes
                            },
                            _process: function(b) {
                                var c = this._data,
                                    d = c.words,
                                    e = c.sigBytes,
                                    g = this.blockSize,
                                    h = 4 * g,
                                    i = e / h;
                                i = b ? a.ceil(i) : a.max((0 | i) - this._minBufferSize, 0);
                                var j = i * g,
                                    k = a.min(4 * j, e);
                                if (j) {
                                    for (var l = 0; j > l; l += g) this._doProcessBlock(d, l);
                                    var m = d.splice(0, j);
                                    c.sigBytes -= k
                                }
                                return new f.init(m, k)
                            },
                            clone: function() {
                                var a = e.clone.call(this);
                                return a._data = this._data.clone(), a
                            },
                            _minBufferSize: 0
                        });
                    d.Hasher = k.extend({
                        cfg: e.extend(),
                        init: function(a) {
                            this.cfg = this.cfg.extend(a), this.reset()
                        },
                        reset: function() {
                            k.reset.call(this), this._doReset()
                        },
                        update: function(a) {
                            return this._append(a), this._process(), this
                        },
                        finalize: function(a) {
                            a && this._append(a);
                            var b = this._doFinalize();
                            return b
                        },
                        blockSize: 16,
                        _createHelper: function(a) {
                            return function(b, c) {
                                return new a.init(c).finalize(b)
                            }
                        },
                        _createHmacHelper: function(a) {
                            return function(b, c) {
                                return new l.HMAC.init(a, c).finalize(b)
                            }
                        }
                    });
                    var l = c.algo = {};
                    return c
                }(Math);
                return a
            })
        }, {}],
        27: [function(b, c, d) {
            ! function(e, f) {
                "object" == typeof d ? c.exports = d = f(b("./core"), b("./sha1"), b("./hmac")) : "function" == typeof a && a.amd ? a(["./core", "./sha1", "./hmac"], f) : f(e.CryptoJS)
            }(this, function(a) {
                return a.HmacSHA1
            })
        }, {
            "./core": 26,
            "./hmac": 28,
            "./sha1": 29
        }],
        28: [function(b, c, d) {
            ! function(e, f) {
                "object" == typeof d ? c.exports = d = f(b("./core")) : "function" == typeof a && a.amd ? a(["./core"], f) : f(e.CryptoJS)
            }(this, function(a) {
                ! function() {
                    var b = a,
                        c = b.lib,
                        d = c.Base,
                        e = b.enc,
                        f = e.Utf8,
                        g = b.algo;
                    g.HMAC = d.extend({
                        init: function(a, b) {
                            a = this._hasher = new a.init, "string" == typeof b && (b = f.parse(b));
                            var c = a.blockSize,
                                d = 4 * c;
                            b.sigBytes > d && (b = a.finalize(b)), b.clamp();
                            for (var e = this._oKey = b.clone(), g = this._iKey = b.clone(), h = e.words, i = g.words, j = 0; c > j; j++) h[j] ^= 1549556828, i[j] ^= 909522486;
                            e.sigBytes = g.sigBytes = d, this.reset()
                        },
                        reset: function() {
                            var a = this._hasher;
                            a.reset(), a.update(this._iKey)
                        },
                        update: function(a) {
                            return this._hasher.update(a), this
                        },
                        finalize: function(a) {
                            var b = this._hasher,
                                c = b.finalize(a);
                            b.reset();
                            var d = b.finalize(this._oKey.clone().concat(c));
                            return d
                        }
                    })
                }()
            })
        }, {
            "./core": 26
        }],
        29: [function(b, c, d) {
            ! function(e, f) {
                "object" == typeof d ? c.exports = d = f(b("./core")) : "function" == typeof a && a.amd ? a(["./core"], f) : f(e.CryptoJS)
            }(this, function(a) {
                return function() {
                    var b = a,
                        c = b.lib,
                        d = c.WordArray,
                        e = c.Hasher,
                        f = b.algo,
                        g = [],
                        h = f.SHA1 = e.extend({
                            _doReset: function() {
                                this._hash = new d.init([1732584193, 4023233417, 2562383102, 271733878, 3285377520])
                            },
                            _doProcessBlock: function(a, b) {
                                for (var c = this._hash.words, d = c[0], e = c[1], f = c[2], h = c[3], i = c[4], j = 0; 80 > j; j++) {
                                    if (16 > j) g[j] = 0 | a[b + j];
                                    else {
                                        var k = g[j - 3] ^ g[j - 8] ^ g[j - 14] ^ g[j - 16];
                                        g[j] = k << 1 | k >>> 31
                                    }
                                    var l = (d << 5 | d >>> 27) + i + g[j];
                                    l += 20 > j ? (e & f | ~e & h) + 1518500249 : 40 > j ? (e ^ f ^ h) + 1859775393 : 60 > j ? (e & f | e & h | f & h) - 1894007588 : (e ^ f ^ h) - 899497514, i = h, h = f, f = e << 30 | e >>> 2, e = d, d = l
                                }
                                c[0] = 0 | c[0] + d, c[1] = 0 | c[1] + e, c[2] = 0 | c[2] + f, c[3] = 0 | c[3] + h, c[4] = 0 | c[4] + i
                            },
                            _doFinalize: function() {
                                var a = this._data,
                                    b = a.words,
                                    c = 8 * this._nDataBytes,
                                    d = 8 * a.sigBytes;
                                return b[d >>> 5] |= 128 << 24 - d % 32, b[(d + 64 >>> 9 << 4) + 14] = Math.floor(c / 4294967296), b[(d + 64 >>> 9 << 4) + 15] = c, a.sigBytes = 4 * b.length, this._process(), this._hash
                            },
                            clone: function() {
                                var a = e.clone.call(this);
                                return a._hash = this._hash.clone(), a
                            }
                        });
                    b.SHA1 = e._createHelper(h), b.HmacSHA1 = e._createHmacHelper(h)
                }(), a.SHA1
            })
        }, {
            "./core": 26
        }],
        30: [function(a, b, c) {
            function d() {
                this._events = this._events || {}, this._maxListeners = this._maxListeners || void 0
            }

            function e(a) {
                return "function" == typeof a
            }

            function f(a) {
                return "number" == typeof a
            }

            function g(a) {
                return "object" == typeof a && null !== a
            }

            function h(a) {
                return void 0 === a
            }
            b.exports = d, d.EventEmitter = d, d.prototype._events = void 0, d.prototype._maxListeners = void 0, d.defaultMaxListeners = 10, d.prototype.setMaxListeners = function(a) {
                if (!f(a) || 0 > a || isNaN(a)) throw TypeError("n must be a positive number");
                return this._maxListeners = a, this
            }, d.prototype.emit = function(a) {
                var b, c, d, f, i, j;
                if (this._events || (this._events = {}), "error" === a && (!this._events.error || g(this._events.error) && !this._events.error.length)) {
                    if (b = arguments[1], b instanceof Error) throw b;
                    throw TypeError('Uncaught, unspecified "error" event.')
                }
                if (c = this._events[a], h(c)) return !1;
                if (e(c)) switch (arguments.length) {
                    case 1:
                        c.call(this);
                        break;
                    case 2:
                        c.call(this, arguments[1]);
                        break;
                    case 3:
                        c.call(this, arguments[1], arguments[2]);
                        break;
                    default:
                        for (d = arguments.length, f = new Array(d - 1), i = 1; d > i; i++) f[i - 1] = arguments[i];
                        c.apply(this, f)
                } else if (g(c)) {
                    for (d = arguments.length, f = new Array(d - 1), i = 1; d > i; i++) f[i - 1] = arguments[i];
                    for (j = c.slice(), d = j.length, i = 0; d > i; i++) j[i].apply(this, f)
                }
                return !0
            }, d.prototype.addListener = function(a, b) {
                var c;
                if (!e(b)) throw TypeError("listener must be a function");
                if (this._events || (this._events = {}), this._events.newListener && this.emit("newListener", a, e(b.listener) ? b.listener : b), this._events[a] ? g(this._events[a]) ? this._events[a].push(b) : this._events[a] = [this._events[a], b] : this._events[a] = b, g(this._events[a]) && !this._events[a].warned) {
                    var c;
                    c = h(this._maxListeners) ? d.defaultMaxListeners : this._maxListeners, c && c > 0 && this._events[a].length > c && (this._events[a].warned = !0, console.error("(node) warning: possible EventEmitter memory leak detected. %d listeners added. Use emitter.setMaxListeners() to increase limit.", this._events[a].length), "function" == typeof console.trace && console.trace())
                }
                return this
            }, d.prototype.on = d.prototype.addListener, d.prototype.once = function(a, b) {
                function c() {
                    this.removeListener(a, c), d || (d = !0, b.apply(this, arguments))
                }
                if (!e(b)) throw TypeError("listener must be a function");
                var d = !1;
                return c.listener = b, this.on(a, c), this
            }, d.prototype.removeListener = function(a, b) {
                var c, d, f, h;
                if (!e(b)) throw TypeError("listener must be a function");
                if (!this._events || !this._events[a]) return this;
                if (c = this._events[a], f = c.length, d = -1, c === b || e(c.listener) && c.listener === b) delete this._events[a], this._events.removeListener && this.emit("removeListener", a, b);
                else if (g(c)) {
                    for (h = f; h-- > 0;)
                        if (c[h] === b || c[h].listener && c[h].listener === b) {
                            d = h;
                            break
                        }
                    if (0 > d) return this;
                    1 === c.length ? (c.length = 0, delete this._events[a]) : c.splice(d, 1), this._events.removeListener && this.emit("removeListener", a, b)
                }
                return this
            }, d.prototype.removeAllListeners = function(a) {
                var b, c;
                if (!this._events) return this;
                if (!this._events.removeListener) return 0 === arguments.length ? this._events = {} : this._events[a] && delete this._events[a], this;
                if (0 === arguments.length) {
                    for (b in this._events) "removeListener" !== b && this.removeAllListeners(b);
                    return this.removeAllListeners("removeListener"), this._events = {}, this
                }
                if (c = this._events[a], e(c)) this.removeListener(a, c);
                else
                    for (; c.length;) this.removeListener(a, c[c.length - 1]);
                return delete this._events[a], this
            }, d.prototype.listeners = function(a) {
                var b;
                return b = this._events && this._events[a] ? e(this._events[a]) ? [this._events[a]] : this._events[a].slice() : []
            }, d.listenerCount = function(a, b) {
                var c;
                return c = a._events && a._events[b] ? e(a._events[b]) ? 1 : a._events[b].length : 0
            }
        }, {}],
        31: [function(a, b, c) {
            c.read = function(a, b, c, d, e) {
                var f, g, h = 8 * e - d - 1,
                    i = (1 << h) - 1,
                    j = i >> 1,
                    k = -7,
                    l = c ? e - 1 : 0,
                    m = c ? -1 : 1,
                    n = a[b + l];
                for (l += m, f = n & (1 << -k) - 1, n >>= -k, k += h; k > 0; f = 256 * f + a[b + l], l += m, k -= 8);
                for (g = f & (1 << -k) - 1, f >>= -k, k += d; k > 0; g = 256 * g + a[b + l], l += m, k -= 8);
                if (0 === f) f = 1 - j;
                else {
                    if (f === i) return g ? NaN : (n ? -1 : 1) * (1 / 0);
                    g += Math.pow(2, d), f -= j
                }
                return (n ? -1 : 1) * g * Math.pow(2, f - d)
            }, c.write = function(a, b, c, d, e, f) {
                var g, h, i, j = 8 * f - e - 1,
                    k = (1 << j) - 1,
                    l = k >> 1,
                    m = 23 === e ? Math.pow(2, -24) - Math.pow(2, -77) : 0,
                    n = d ? 0 : f - 1,
                    o = d ? 1 : -1,
                    p = 0 > b || 0 === b && 0 > 1 / b ? 1 : 0;
                for (b = Math.abs(b), isNaN(b) || b === 1 / 0 ? (h = isNaN(b) ? 1 : 0, g = k) : (g = Math.floor(Math.log(b) / Math.LN2), b * (i = Math.pow(2, -g)) < 1 && (g--, i *= 2), b += g + l >= 1 ? m / i : m * Math.pow(2, 1 - l), b * i >= 2 && (g++, i /= 2), g + l >= k ? (h = 0, g = k) : g + l >= 1 ? (h = (b * i - 1) * Math.pow(2, e), g += l) : (h = b * Math.pow(2, l - 1) * Math.pow(2, e), g = 0)); e >= 8; a[c + n] = 255 & h, n += o, h /= 256, e -= 8);
                for (g = g << e | h, j += e; j > 0; a[c + n] = 255 & g, n += o, g /= 256, j -= 8);
                a[c + n - o] |= 128 * p
            }
        }, {}],
        32: [function(a, b, c) {
            "function" == typeof Object.create ? b.exports = function(a, b) {
                a.super_ = b, a.prototype = Object.create(b.prototype, {
                    constructor: {
                        value: a,
                        enumerable: !1,
                        writable: !0,
                        configurable: !0
                    }
                })
            } : b.exports = function(a, b) {
                a.super_ = b;
                var c = function() {};
                c.prototype = b.prototype, a.prototype = new c, a.prototype.constructor = a
            }
        }, {}],
        33: [function(a, b, c) {
            b.exports = function(a) {
                return !(null == a || !(a._isBuffer || a.constructor && "function" == typeof a.constructor.isBuffer && a.constructor.isBuffer(a)))
            }
        }, {}],
        34: [function(a, b, c) {
            b.exports = Array.isArray || function(a) {
                return "[object Array]" == Object.prototype.toString.call(a)
            }
        }, {}],
        35: [function(a, b, c) {
            function d() {}
            var e = a("./_nativeCreate"),
                f = Object.prototype;
            d.prototype = e ? e(null) : f, b.exports = d
        }, {
            "./_nativeCreate": 107
        }],
        36: [function(a, b, c) {
            var d = a("./_getNative"),
                e = a("./_root"),
                f = d(e, "Map");
            b.exports = f
        }, {
            "./_getNative": 86,
            "./_root": 109
        }],
        37: [function(a, b, c) {
            function d(a) {
                var b = -1,
                    c = a ? a.length : 0;
                for (this.clear(); ++b < c;) {
                    var d = a[b];
                    this.set(d[0], d[1])
                }
            }
            var e = a("./_mapClear"),
                f = a("./_mapDelete"),
                g = a("./_mapGet"),
                h = a("./_mapHas"),
                i = a("./_mapSet");
            d.prototype.clear = e, d.prototype["delete"] = f, d.prototype.get = g, d.prototype.has = h, d.prototype.set = i, b.exports = d
        }, {
            "./_mapClear": 101,
            "./_mapDelete": 102,
            "./_mapGet": 103,
            "./_mapHas": 104,
            "./_mapSet": 105
        }],
        38: [function(a, b, c) {
            var d = a("./_getNative"),
                e = a("./_root"),
                f = d(e, "Set");
            b.exports = f
        }, {
            "./_getNative": 86,
            "./_root": 109
        }],
        39: [function(a, b, c) {
            function d(a) {
                var b = -1,
                    c = a ? a.length : 0;
                for (this.clear(); ++b < c;) {
                    var d = a[b];
                    this.set(d[0], d[1])
                }
            }
            var e = a("./_stackClear"),
                f = a("./_stackDelete"),
                g = a("./_stackGet"),
                h = a("./_stackHas"),
                i = a("./_stackSet");
            d.prototype.clear = e, d.prototype["delete"] = f, d.prototype.get = g, d.prototype.has = h, d.prototype.set = i, b.exports = d
        }, {
            "./_stackClear": 111,
            "./_stackDelete": 112,
            "./_stackGet": 113,
            "./_stackHas": 114,
            "./_stackSet": 115
        }],
        40: [function(a, b, c) {
            var d = a("./_root"),
                e = d.Symbol;
            b.exports = e
        }, {
            "./_root": 109
        }],
        41: [function(a, b, c) {
            var d = a("./_root"),
                e = d.Uint8Array;
            b.exports = e
        }, {
            "./_root": 109
        }],
        42: [function(a, b, c) {
            var d = a("./_getNative"),
                e = a("./_root"),
                f = d(e, "WeakMap");
            b.exports = f
        }, {
            "./_getNative": 86,
            "./_root": 109
        }],
        43: [function(a, b, c) {
            function d(a, b, c) {
                var d = c.length;
                switch (d) {
                    case 0:
                        return a.call(b);
                    case 1:
                        return a.call(b, c[0]);
                    case 2:
                        return a.call(b, c[0], c[1]);
                    case 3:
                        return a.call(b, c[0], c[1], c[2])
                }
                return a.apply(b, c)
            }
            b.exports = d
        }, {}],
        44: [function(a, b, c) {
            function d(a, b) {
                for (var c = -1, d = a.length; ++c < d;)
                    if (!b(a[c], c, a)) return !1;
                return !0
            }
            b.exports = d
        }, {}],
        45: [function(a, b, c) {
            function d(a, b) {
                for (var c = -1, d = a.length, e = Array(d); ++c < d;) e[c] = b(a[c], c, a);
                return e
            }
            b.exports = d
        }, {}],
        46: [function(a, b, c) {
            function d(a, b) {
                for (var c = -1, d = a.length; ++c < d;)
                    if (b(a[c], c, a)) return !0;
                return !1
            }
            b.exports = d
        }, {}],
        47: [function(a, b, c) {
            function d(a, b, c) {
                var d = a[b];
                (!e(d, c) || e(d, f[b]) && !g.call(a, b) || void 0 === c && !(b in a)) && (a[b] = c)
            }
            var e = a("./eq"),
                f = Object.prototype,
                g = f.hasOwnProperty;
            b.exports = d
        }, {
            "./eq": 119
        }],
        48: [function(a, b, c) {
            function d(a, b) {
                var c = e(a, b);
                if (0 > c) return !1;
                var d = a.length - 1;
                return c == d ? a.pop() : g.call(a, c, 1), !0
            }
            var e = a("./_assocIndexOf"),
                f = Array.prototype,
                g = f.splice;
            b.exports = d
        }, {
            "./_assocIndexOf": 51
        }],
        49: [function(a, b, c) {
            function d(a, b) {
                var c = e(a, b);
                return 0 > c ? void 0 : a[c][1]
            }
            var e = a("./_assocIndexOf");
            b.exports = d
        }, {
            "./_assocIndexOf": 51
        }],
        50: [function(a, b, c) {
            function d(a, b) {
                return e(a, b) > -1
            }
            var e = a("./_assocIndexOf");
            b.exports = d
        }, {
            "./_assocIndexOf": 51
        }],
        51: [function(a, b, c) {
            function d(a, b) {
                for (var c = a.length; c--;)
                    if (e(a[c][0], b)) return c;
                return -1
            }
            var e = a("./eq");
            b.exports = d
        }, {
            "./eq": 119
        }],
        52: [function(a, b, c) {
            function d(a, b, c) {
                var d = e(a, b);
                0 > d ? a.push([b, c]) : a[d][1] = c
            }
            var e = a("./_assocIndexOf");
            b.exports = d
        }, {
            "./_assocIndexOf": 51
        }],
        53: [function(a, b, c) {
            function d(a, b) {
                return a && e(b, f(b), a)
            }
            var e = a("./_copyObject"),
                f = a("./keys");
            b.exports = d
        }, {
            "./_copyObject": 76,
            "./keys": 137
        }],
        54: [function(a, b, c) {
            function d(a) {
                return e(a) ? a : f(a)
            }
            var e = a("./isArray"),
                f = a("./_stringToPath");
            b.exports = d
        }, {
            "./_stringToPath": 116,
            "./isArray": 125
        }],
        55: [function(a, b, c) {
            function d(a) {
                return e(a) ? f(a) : {}
            }
            var e = a("./isObject"),
                f = Object.create;
            b.exports = d
        }, {
            "./isObject": 132
        }],
        56: [function(a, b, c) {
            var d = a("./_baseForOwn"),
                e = a("./_createBaseEach"),
                f = e(d);
            b.exports = f
        }, {
            "./_baseForOwn": 59,
            "./_createBaseEach": 79
        }],
        57: [function(a, b, c) {
            function d(a, b) {
                var c = !0;
                return e(a, function(a, d, e) {
                    return c = !!b(a, d, e)
                }), c
            }
            var e = a("./_baseEach");
            b.exports = d
        }, {
            "./_baseEach": 56
        }],
        58: [function(a, b, c) {
            var d = a("./_createBaseFor"),
                e = d();
            b.exports = e
        }, {
            "./_createBaseFor": 80
        }],
        59: [function(a, b, c) {
            function d(a, b) {
                return a && e(a, b, f)
            }
            var e = a("./_baseFor"),
                f = a("./keys");
            b.exports = d
        }, {
            "./_baseFor": 58,
            "./keys": 137
        }],
        60: [function(a, b, c) {
            function d(a, b) {
                b = f(b, a) ? [b + ""] : e(b);
                for (var c = 0, d = b.length; null != a && d > c;) a = a[b[c++]];
                return c && c == d ? a : void 0
            }
            var e = a("./_baseCastPath"),
                f = a("./_isKey");
            b.exports = d
        }, {
            "./_baseCastPath": 54,
            "./_isKey": 97
        }],
        61: [function(a, b, c) {
            function d(a, b) {
                return f.call(a, b) || "object" == typeof a && b in a && null === g(a)
            }
            var e = Object.prototype,
                f = e.hasOwnProperty,
                g = Object.getPrototypeOf;
            b.exports = d
        }, {}],
        62: [function(a, b, c) {
            function d(a, b) {
                return b in Object(a)
            }
            b.exports = d
        }, {}],
        63: [function(a, b, c) {
            function d(a, b, c, h, i) {
                return a === b ? !0 : null == a || null == b || !f(a) && !g(b) ? a !== a && b !== b : e(a, b, d, c, h, i)
            }
            var e = a("./_baseIsEqualDeep"),
                f = a("./isObject"),
                g = a("./isObjectLike");
            b.exports = d
        }, {
            "./_baseIsEqualDeep": 64,
            "./isObject": 132,
            "./isObjectLike": 133
        }],
        64: [function(a, b, c) {
            function d(a, b, c, d, q, s) {
                var t = j(a),
                    u = j(b),
                    v = o,
                    w = o;
                t || (v = i(a), v == n ? v = p : v != p && (t = l(a))), u || (w = i(b), w == n ? w = p : w != p && (u = l(b)));
                var x = v == p && !k(a),
                    y = w == p && !k(b),
                    z = v == w;
                if (z && !t && !x) return g(a, b, v, c, d, q);
                var A = q & m;
                if (!A) {
                    var B = x && r.call(a, "__wrapped__"),
                        C = y && r.call(b, "__wrapped__");
                    if (B || C) return c(B ? a.value() : a, C ? b.value() : b, d, q, s)
                }
                return z ? (s || (s = new e), (t ? f : h)(a, b, c, d, q, s)) : !1
            }
            var e = a("./_Stack"),
                f = a("./_equalArrays"),
                g = a("./_equalByTag"),
                h = a("./_equalObjects"),
                i = a("./_getTag"),
                j = a("./isArray"),
                k = a("./_isHostObject"),
                l = a("./isTypedArray"),
                m = 2,
                n = "[object Arguments]",
                o = "[object Array]",
                p = "[object Object]",
                q = Object.prototype,
                r = q.hasOwnProperty;
            b.exports = d
        }, {
            "./_Stack": 39,
            "./_equalArrays": 81,
            "./_equalByTag": 82,
            "./_equalObjects": 83,
            "./_getTag": 87,
            "./_isHostObject": 94,
            "./isArray": 125,
            "./isTypedArray": 136
        }],
        65: [function(a, b, c) {
            function d(a, b, c, d) {
                var i = c.length,
                    j = i,
                    k = !d;
                if (null == a) return !j;
                for (a = Object(a); i--;) {
                    var l = c[i];
                    if (k && l[2] ? l[1] !== a[l[0]] : !(l[0] in a)) return !1
                }
                for (; ++i < j;) {
                    l = c[i];
                    var m = l[0],
                        n = a[m],
                        o = l[1];
                    if (k && l[2]) {
                        if (void 0 === n && !(m in a)) return !1
                    } else {
                        var p = new e,
                            q = d ? d(n, o, m, a, b, p) : void 0;
                        if (!(void 0 === q ? f(o, n, d, g | h, p) : q)) return !1
                    }
                }
                return !0
            }
            var e = a("./_Stack"),
                f = a("./_baseIsEqual"),
                g = 1,
                h = 2;
            b.exports = d
        }, {
            "./_Stack": 39,
            "./_baseIsEqual": 63
        }],
        66: [function(a, b, c) {
            function d(a) {
                var b = typeof a;
                return "function" == b ? a : null == a ? g : "object" == b ? h(a) ? f(a[0], a[1]) : e(a) : i(a)
            }
            var e = a("./_baseMatches"),
                f = a("./_baseMatchesProperty"),
                g = a("./identity"),
                h = a("./isArray"),
                i = a("./property");
            b.exports = d
        }, {
            "./_baseMatches": 68,
            "./_baseMatchesProperty": 69,
            "./identity": 123,
            "./isArray": 125,
            "./property": 139
        }],
        67: [function(a, b, c) {
            function d(a) {
                return e(Object(a))
            }
            var e = Object.keys;
            b.exports = d
        }, {}],
        68: [function(a, b, c) {
            function d(a) {
                var b = f(a);
                if (1 == b.length && b[0][2]) {
                    var c = b[0][0],
                        d = b[0][1];
                    return function(a) {
                        return null == a ? !1 : a[c] === d && (void 0 !== d || c in Object(a))
                    }
                }
                return function(c) {
                    return c === a || e(c, a, b)
                }
            }
            var e = a("./_baseIsMatch"),
                f = a("./_getMatchData");
            b.exports = d
        }, {
            "./_baseIsMatch": 65,
            "./_getMatchData": 85
        }],
        69: [function(a, b, c) {
            function d(a, b) {
                return function(c) {
                    var d = f(c, a);
                    return void 0 === d && d === b ? g(c, a) : e(b, d, void 0, h | i)
                }
            }
            var e = a("./_baseIsEqual"),
                f = a("./get"),
                g = a("./hasIn"),
                h = 1,
                i = 2;
            b.exports = d
        }, {
            "./_baseIsEqual": 63,
            "./get": 121,
            "./hasIn": 122
        }],
        70: [function(a, b, c) {
            function d(a) {
                return function(b) {
                    return null == b ? void 0 : b[a]
                }
            }
            b.exports = d
        }, {}],
        71: [function(a, b, c) {
            function d(a) {
                return function(b) {
                    return e(b, a)
                }
            }
            var e = a("./_baseGet");
            b.exports = d
        }, {
            "./_baseGet": 60
        }],
        72: [function(a, b, c) {
            function d(a, b, c) {
                var d = -1,
                    e = a.length;
                0 > b && (b = -b > e ? 0 : e + b), c = c > e ? e : c, 0 > c && (c += e), e = b > c ? 0 : c - b >>> 0, b >>>= 0;
                for (var f = Array(e); ++d < e;) f[d] = a[d + b];
                return f
            }
            b.exports = d
        }, {}],
        73: [function(a, b, c) {
            function d(a, b) {
                for (var c = -1, d = Array(a); ++c < a;) d[c] = b(c);
                return d
            }
            b.exports = d
        }, {}],
        74: [function(a, b, c) {
            function d(a, b) {
                return e(b, function(b) {
                    return [b, a[b]]
                })
            }
            var e = a("./_arrayMap");
            b.exports = d
        }, {
            "./_arrayMap": 45
        }],
        75: [function(a, b, c) {
            function d(a) {
                return a && a.Object === Object ? a : null
            }
            b.exports = d
        }, {}],
        76: [function(a, b, c) {
            function d(a, b, c) {
                return e(a, b, c)
            }
            var e = a("./_copyObjectWith");
            b.exports = d
        }, {
            "./_copyObjectWith": 77
        }],
        77: [function(a, b, c) {
            function d(a, b, c, d) {
                c || (c = {});
                for (var f = -1, g = b.length; ++f < g;) {
                    var h = b[f],
                        i = d ? d(c[h], a[h], h, c, a) : a[h];
                    e(c, h, i)
                }
                return c
            }
            var e = a("./_assignValue");
            b.exports = d
        }, {
            "./_assignValue": 47
        }],
        78: [function(a, b, c) {
            function d(a) {
                return f(function(b, c) {
                    var d = -1,
                        f = c.length,
                        g = f > 1 ? c[f - 1] : void 0,
                        h = f > 2 ? c[2] : void 0;
                    for (g = "function" == typeof g ? (f--, g) : void 0, h && e(c[0], c[1], h) && (g = 3 > f ? void 0 : g, f = 1), b = Object(b); ++d < f;) {
                        var i = c[d];
                        i && a(b, i, d, g)
                    }
                    return b
                })
            }
            var e = a("./_isIterateeCall"),
                f = a("./rest");
            b.exports = d
        }, {
            "./_isIterateeCall": 96,
            "./rest": 140
        }],
        79: [function(a, b, c) {
            function d(a, b) {
                return function(c, d) {
                    if (null == c) return c;
                    if (!e(c)) return a(c, d);
                    for (var f = c.length, g = b ? f : -1, h = Object(c);
                        (b ? g-- : ++g < f) && d(h[g], g, h) !== !1;);
                    return c
                }
            }
            var e = a("./isArrayLike");
            b.exports = d
        }, {
            "./isArrayLike": 126
        }],
        80: [function(a, b, c) {
            function d(a) {
                return function(b, c, d) {
                    for (var e = -1, f = Object(b), g = d(b), h = g.length; h--;) {
                        var i = g[a ? h : ++e];
                        if (c(f[i], i, f) === !1) break
                    }
                    return b
                }
            }
            b.exports = d
        }, {}],
        81: [function(a, b, c) {
            function d(a, b, c, d, h, i) {
                var j = -1,
                    k = h & g,
                    l = h & f,
                    m = a.length,
                    n = b.length;
                if (m != n && !(k && n > m)) return !1;
                var o = i.get(a);
                if (o) return o == b;
                var p = !0;
                for (i.set(a, b); ++j < m;) {
                    var q = a[j],
                        r = b[j];
                    if (d) var s = k ? d(r, q, j, b, a, i) : d(q, r, j, a, b, i);
                    if (void 0 !== s) {
                        if (s) continue;
                        p = !1;
                        break
                    }
                    if (l) {
                        if (!e(b, function(a) {
                                return q === a || c(q, a, d, h, i)
                            })) {
                            p = !1;
                            break
                        }
                    } else if (q !== r && !c(q, r, d, h, i)) {
                        p = !1;
                        break
                    }
                }
                return i["delete"](a), p
            }
            var e = a("./_arraySome"),
                f = 1,
                g = 2;
            b.exports = d
        }, {
            "./_arraySome": 46
        }],
        82: [function(a, b, c) {
            function d(a, b, c, d, u, w) {
                switch (c) {
                    case t:
                        return a.byteLength == b.byteLength && d(new f(a), new f(b)) ? !0 : !1;
                    case k:
                    case l:
                        return +a == +b;
                    case m:
                        return a.name == b.name && a.message == b.message;
                    case o:
                        return a != +a ? b != +b : a == +b;
                    case p:
                    case r:
                        return a == b + "";
                    case n:
                        var x = g;
                    case q:
                        var y = w & j;
                        return x || (x = h), (y || a.size == b.size) && d(x(a), x(b), u, w | i);
                    case s:
                        return !!e && v.call(a) == v.call(b)
                }
                return !1
            }
            var e = a("./_Symbol"),
                f = a("./_Uint8Array"),
                g = a("./_mapToArray"),
                h = a("./_setToArray"),
                i = 1,
                j = 2,
                k = "[object Boolean]",
                l = "[object Date]",
                m = "[object Error]",
                n = "[object Map]",
                o = "[object Number]",
                p = "[object RegExp]",
                q = "[object Set]",
                r = "[object String]",
                s = "[object Symbol]",
                t = "[object ArrayBuffer]",
                u = e ? e.prototype : void 0,
                v = e ? u.valueOf : void 0;
            b.exports = d
        }, {
            "./_Symbol": 40,
            "./_Uint8Array": 41,
            "./_mapToArray": 106,
            "./_setToArray": 110
        }],
        83: [function(a, b, c) {
            function d(a, b, c, d, h, i) {
                var j = h & g,
                    k = f(a),
                    l = k.length,
                    m = f(b),
                    n = m.length;
                if (l != n && !j) return !1;
                for (var o = l; o--;) {
                    var p = k[o];
                    if (!(j ? p in b : e(b, p))) return !1
                }
                var q = i.get(a);
                if (q) return q == b;
                var r = !0;
                i.set(a, b);
                for (var s = j; ++o < l;) {
                    p = k[o];
                    var t = a[p],
                        u = b[p];
                    if (d) var v = j ? d(u, t, p, b, a, i) : d(t, u, p, a, b, i);
                    if (!(void 0 === v ? t === u || c(t, u, d, h, i) : v)) {
                        r = !1;
                        break
                    }
                    s || (s = "constructor" == p)
                }
                if (r && !s) {
                    var w = a.constructor,
                        x = b.constructor;
                    w != x && "constructor" in a && "constructor" in b && !("function" == typeof w && w instanceof w && "function" == typeof x && x instanceof x) && (r = !1)
                }
                return i["delete"](a), r
            }
            var e = a("./_baseHas"),
                f = a("./keys"),
                g = 2;
            b.exports = d
        }, {
            "./_baseHas": 61,
            "./keys": 137
        }],
        84: [function(a, b, c) {
            var d = a("./_baseProperty"),
                e = d("length");
            b.exports = e
        }, {
            "./_baseProperty": 70
        }],
        85: [function(a, b, c) {
            function d(a) {
                for (var b = f(a), c = b.length; c--;) b[c][2] = e(b[c][1]);
                return b
            }
            var e = a("./_isStrictComparable"),
                f = a("./toPairs");
            b.exports = d
        }, {
            "./_isStrictComparable": 100,
            "./toPairs": 143
        }],
        86: [function(a, b, c) {
            function d(a, b) {
                var c = null == a ? void 0 : a[b];
                return e(c) ? c : void 0
            }
            var e = a("./isNative");
            b.exports = d
        }, {
            "./isNative": 131
        }],
        87: [function(a, b, c) {
            function d(a) {
                return n.call(a)
            }
            var e = a("./_Map"),
                f = a("./_Set"),
                g = a("./_WeakMap"),
                h = "[object Map]",
                i = "[object Object]",
                j = "[object Set]",
                k = "[object WeakMap]",
                l = Object.prototype,
                m = Function.prototype.toString,
                n = l.toString,
                o = e ? m.call(e) : "",
                p = f ? m.call(f) : "",
                q = g ? m.call(g) : "";
            (e && d(new e) != h || f && d(new f) != j || g && d(new g) != k) && (d = function(a) {
                var b = n.call(a),
                    c = b == i ? a.constructor : null,
                    d = "function" == typeof c ? m.call(c) : "";
                if (d) switch (d) {
                    case o:
                        return h;
                    case p:
                        return j;
                    case q:
                        return k
                }
                return b
            }), b.exports = d
        }, {
            "./_Map": 36,
            "./_Set": 38,
            "./_WeakMap": 42
        }],
        88: [function(a, b, c) {
            function d(a, b, c) {
                if (null == a) return !1;
                var d = c(a, b);
                d || i(b) || (b = e(b), a = m(a, b), null != a && (b = l(b), d = c(a, b)));
                var n = a ? a.length : void 0;
                return d || !!n && j(n) && h(b, n) && (g(a) || k(a) || f(a))
            }
            var e = a("./_baseCastPath"),
                f = a("./isArguments"),
                g = a("./isArray"),
                h = a("./_isIndex"),
                i = a("./_isKey"),
                j = a("./isLength"),
                k = a("./isString"),
                l = a("./last"),
                m = a("./_parent");
            b.exports = d
        }, {
            "./_baseCastPath": 54,
            "./_isIndex": 95,
            "./_isKey": 97,
            "./_parent": 108,
            "./isArguments": 124,
            "./isArray": 125,
            "./isLength": 130,
            "./isString": 134,
            "./last": 138
        }],
        89: [function(a, b, c) {
            function d(a, b) {
                return e(a, b) && delete a[b]
            }
            var e = a("./_hashHas");
            b.exports = d
        }, {
            "./_hashHas": 91
        }],
        90: [function(a, b, c) {
            function d(a, b) {
                if (e) {
                    var c = a[b];
                    return c === f ? void 0 : c
                }
                return h.call(a, b) ? a[b] : void 0
            }
            var e = a("./_nativeCreate"),
                f = "__lodash_hash_undefined__",
                g = Object.prototype,
                h = g.hasOwnProperty;
            b.exports = d
        }, {
            "./_nativeCreate": 107
        }],
        91: [function(a, b, c) {
            function d(a, b) {
                return e ? void 0 !== a[b] : g.call(a, b)
            }
            var e = a("./_nativeCreate"),
                f = Object.prototype,
                g = f.hasOwnProperty;
            b.exports = d
        }, {
            "./_nativeCreate": 107
        }],
        92: [function(a, b, c) {
            function d(a, b, c) {
                a[b] = e && void 0 === c ? f : c
            }
            var e = a("./_nativeCreate"),
                f = "__lodash_hash_undefined__";
            b.exports = d
        }, {
            "./_nativeCreate": 107
        }],
        93: [function(a, b, c) {
            function d(a) {
                var b = a ? a.length : void 0;
                return h(b) && (g(a) || i(a) || f(a)) ? e(b, String) : null
            }
            var e = a("./_baseTimes"),
                f = a("./isArguments"),
                g = a("./isArray"),
                h = a("./isLength"),
                i = a("./isString");
            b.exports = d
        }, {
            "./_baseTimes": 73,
            "./isArguments": 124,
            "./isArray": 125,
            "./isLength": 130,
            "./isString": 134
        }],
        94: [function(a, b, c) {
            function d(a) {
                var b = !1;
                if (null != a && "function" != typeof a.toString) try {
                    b = !!(a + "")
                } catch (c) {}
                return b
            }
            b.exports = d
        }, {}],
        95: [function(a, b, c) {
            function d(a, b) {
                return a = "number" == typeof a || f.test(a) ? +a : -1, b = null == b ? e : b, a > -1 && a % 1 == 0 && b > a
            }
            var e = 9007199254740991,
                f = /^(?:0|[1-9]\d*)$/;
            b.exports = d
        }, {}],
        96: [function(a, b, c) {
            function d(a, b, c) {
                if (!h(c)) return !1;
                var d = typeof b;
                return ("number" == d ? f(c) && g(b, c.length) : "string" == d && b in c) ? e(c[b], a) : !1
            }
            var e = a("./eq"),
                f = a("./isArrayLike"),
                g = a("./_isIndex"),
                h = a("./isObject");
            b.exports = d
        }, {
            "./_isIndex": 95,
            "./eq": 119,
            "./isArrayLike": 126,
            "./isObject": 132
        }],
        97: [function(a, b, c) {
            function d(a, b) {
                return "number" == typeof a ? !0 : !e(a) && (g.test(a) || !f.test(a) || null != b && a in Object(b))
            }
            var e = a("./isArray"),
                f = /\.|\[(?:[^[\]]*|(["'])(?:(?!\1)[^\\]|\\.)*?\1)\]/,
                g = /^\w*$/;
            b.exports = d
        }, {
            "./isArray": 125
        }],
        98: [function(a, b, c) {
            function d(a) {
                var b = typeof a;
                return "number" == b || "boolean" == b || "string" == b && "__proto__" != a || null == a
            }
            b.exports = d
        }, {}],
        99: [function(a, b, c) {
            function d(a) {
                var b = a && a.constructor,
                    c = "function" == typeof b && b.prototype || e;
                return a === c
            }
            var e = Object.prototype;
            b.exports = d
        }, {}],
        100: [function(a, b, c) {
            function d(a) {
                return a === a && !e(a)
            }
            var e = a("./isObject");
            b.exports = d
        }, {
            "./isObject": 132
        }],
        101: [function(a, b, c) {
            function d() {
                this.__data__ = {
                    hash: new e,
                    map: f ? new f : [],
                    string: new e
                }
            }
            var e = a("./_Hash"),
                f = a("./_Map");
            b.exports = d
        }, {
            "./_Hash": 35,
            "./_Map": 36
        }],
        102: [function(a, b, c) {
            function d(a) {
                var b = this.__data__;
                return h(a) ? g("string" == typeof a ? b.string : b.hash, a) : e ? b.map["delete"](a) : f(b.map, a)
            }
            var e = a("./_Map"),
                f = a("./_assocDelete"),
                g = a("./_hashDelete"),
                h = a("./_isKeyable");
            b.exports = d
        }, {
            "./_Map": 36,
            "./_assocDelete": 48,
            "./_hashDelete": 89,
            "./_isKeyable": 98
        }],
        103: [function(a, b, c) {
            function d(a) {
                var b = this.__data__;
                return h(a) ? g("string" == typeof a ? b.string : b.hash, a) : e ? b.map.get(a) : f(b.map, a)
            }
            var e = a("./_Map"),
                f = a("./_assocGet"),
                g = a("./_hashGet"),
                h = a("./_isKeyable");
            b.exports = d
        }, {
            "./_Map": 36,
            "./_assocGet": 49,
            "./_hashGet": 90,
            "./_isKeyable": 98
        }],
        104: [function(a, b, c) {
            function d(a) {
                var b = this.__data__;
                return h(a) ? g("string" == typeof a ? b.string : b.hash, a) : e ? b.map.has(a) : f(b.map, a)
            }
            var e = a("./_Map"),
                f = a("./_assocHas"),
                g = a("./_hashHas"),
                h = a("./_isKeyable");
            b.exports = d
        }, {
            "./_Map": 36,
            "./_assocHas": 50,
            "./_hashHas": 91,
            "./_isKeyable": 98
        }],
        105: [function(a, b, c) {
            function d(a, b) {
                var c = this.__data__;
                return h(a) ? g("string" == typeof a ? c.string : c.hash, a, b) : e ? c.map.set(a, b) : f(c.map, a, b), this
            }
            var e = a("./_Map"),
                f = a("./_assocSet"),
                g = a("./_hashSet"),
                h = a("./_isKeyable");
            b.exports = d
        }, {
            "./_Map": 36,
            "./_assocSet": 52,
            "./_hashSet": 92,
            "./_isKeyable": 98
        }],
        106: [function(a, b, c) {
            function d(a) {
                var b = -1,
                    c = Array(a.size);
                return a.forEach(function(a, d) {
                    c[++b] = [d, a]
                }), c
            }
            b.exports = d
        }, {}],
        107: [function(a, b, c) {
            var d = a("./_getNative"),
                e = d(Object, "create");
            b.exports = e
        }, {
            "./_getNative": 86
        }],
        108: [function(a, b, c) {
            function d(a, b) {
                return 1 == b.length ? a : f(a, e(b, 0, -1))
            }
            var e = a("./_baseSlice"),
                f = a("./get");
            b.exports = d
        }, {
            "./_baseSlice": 72,
            "./get": 121
        }],
        109: [function(a, b, c) {
            (function(d) {
                var e = a("./_checkGlobal"),
                    f = {
                        "function": !0,
                        object: !0
                    },
                    g = f[typeof c] && c && !c.nodeType ? c : void 0,
                    h = f[typeof b] && b && !b.nodeType ? b : void 0,
                    i = e(g && h && "object" == typeof d && d),
                    j = e(f[typeof self] && self),
                    k = e(f[typeof window] && window),
                    l = e(f[typeof this] && this),
                    m = i || k !== (l && l.window) && k || j || l || Function("return this")();
                b.exports = m
            }).call(this, "undefined" != typeof global ? global : "undefined" != typeof self ? self : "undefined" != typeof window ? window : {})
        }, {
            "./_checkGlobal": 75
        }],
        110: [function(a, b, c) {
            function d(a) {
                var b = -1,
                    c = Array(a.size);
                return a.forEach(function(a) {
                    c[++b] = a
                }), c
            }
            b.exports = d
        }, {}],
        111: [function(a, b, c) {
            function d() {
                this.__data__ = {
                    array: [],
                    map: null
                }
            }
            b.exports = d
        }, {}],
        112: [function(a, b, c) {
            function d(a) {
                var b = this.__data__,
                    c = b.array;
                return c ? e(c, a) : b.map["delete"](a)
            }
            var e = a("./_assocDelete");
            b.exports = d
        }, {
            "./_assocDelete": 48
        }],
        113: [function(a, b, c) {
            function d(a) {
                var b = this.__data__,
                    c = b.array;
                return c ? e(c, a) : b.map.get(a)
            }
            var e = a("./_assocGet");
            b.exports = d
        }, {
            "./_assocGet": 49
        }],
        114: [function(a, b, c) {
            function d(a) {
                var b = this.__data__,
                    c = b.array;
                return c ? e(c, a) : b.map.has(a)
            }
            var e = a("./_assocHas");
            b.exports = d
        }, {
            "./_assocHas": 50
        }],
        115: [function(a, b, c) {
            function d(a, b) {
                var c = this.__data__,
                    d = c.array;
                d && (d.length < g - 1 ? f(d, a, b) : (c.array = null, c.map = new e(d)));
                var h = c.map;
                return h && h.set(a, b), this
            }
            var e = a("./_MapCache"),
                f = a("./_assocSet"),
                g = 200;
            b.exports = d
        }, {
            "./_MapCache": 37,
            "./_assocSet": 52
        }],
        116: [function(a, b, c) {
            function d(a) {
                var b = [];
                return e(a).replace(f, function(a, c, d, e) {
                    b.push(d ? e.replace(g, "$1") : c || a)
                }), b
            }
            var e = a("./toString"),
                f = /[^.[\]]+|\[(?:(-?\d+(?:\.\d+)?)|(["'])((?:(?!\2)[^\\]|\\.)*?)\2)\]/g,
                g = /\\(\\)?/g;
            b.exports = d
        }, {
            "./toString": 144
        }],
        117: [function(a, b, c) {
            var d = a("./_copyObject"),
                e = a("./_createAssigner"),
                f = a("./keys"),
                g = e(function(a, b) {
                    d(b, f(b), a)
                });
            b.exports = g
        }, {
            "./_copyObject": 76,
            "./_createAssigner": 78,
            "./keys": 137
        }],
        118: [function(a, b, c) {
            function d(a, b) {
                var c = f(a);
                return b ? e(c, b) : c
            }
            var e = a("./_baseAssign"),
                f = a("./_baseCreate");
            b.exports = d
        }, {
            "./_baseAssign": 53,
            "./_baseCreate": 55
        }],
        119: [function(a, b, c) {
            function d(a, b) {
                return a === b || a !== a && b !== b
            }
            b.exports = d
        }, {}],
        120: [function(a, b, c) {
            function d(a, b, c) {
                var d = h(a) ? e : f;
                return c && i(a, b, c) && (b = void 0), d(a, g(b, 3))
            }
            var e = a("./_arrayEvery"),
                f = a("./_baseEvery"),
                g = a("./_baseIteratee"),
                h = a("./isArray"),
                i = a("./_isIterateeCall");
            b.exports = d
        }, {
            "./_arrayEvery": 44,
            "./_baseEvery": 57,
            "./_baseIteratee": 66,
            "./_isIterateeCall": 96,
            "./isArray": 125
        }],
        121: [function(a, b, c) {
            function d(a, b, c) {
                var d = null == a ? void 0 : e(a, b);
                return void 0 === d ? c : d
            }
            var e = a("./_baseGet");
            b.exports = d
        }, {
            "./_baseGet": 60
        }],
        122: [function(a, b, c) {
            function d(a, b) {
                return f(a, b, e)
            }
            var e = a("./_baseHasIn"),
                f = a("./_hasPath");
            b.exports = d
        }, {
            "./_baseHasIn": 62,
            "./_hasPath": 88
        }],
        123: [function(a, b, c) {
            function d(a) {
                return a
            }
            b.exports = d
        }, {}],
        124: [function(a, b, c) {
            function d(a) {
                return e(a) && h.call(a, "callee") && (!j.call(a, "callee") || i.call(a) == f)
            }
            var e = a("./isArrayLikeObject"),
                f = "[object Arguments]",
                g = Object.prototype,
                h = g.hasOwnProperty,
                i = g.toString,
                j = g.propertyIsEnumerable;
            b.exports = d
        }, {
            "./isArrayLikeObject": 127
        }],
        125: [function(a, b, c) {
            var d = Array.isArray;
            b.exports = d
        }, {}],
        126: [function(a, b, c) {
            function d(a) {
                return null != a && !("function" == typeof a && f(a)) && g(e(a))
            }
            var e = a("./_getLength"),
                f = a("./isFunction"),
                g = a("./isLength");
            b.exports = d
        }, {
            "./_getLength": 84,
            "./isFunction": 129,
            "./isLength": 130
        }],
        127: [function(a, b, c) {
            function d(a) {
                return f(a) && e(a)
            }
            var e = a("./isArrayLike"),
                f = a("./isObjectLike");
            b.exports = d
        }, {
            "./isArrayLike": 126,
            "./isObjectLike": 133
        }],
        128: [function(a, b, c) {
            function d(a) {
                if (g(a) && (f(a) || i(a) || h(a.splice) || e(a))) return !a.length;
                for (var b in a)
                    if (k.call(a, b)) return !1;
                return !0
            }
            var e = a("./isArguments"),
                f = a("./isArray"),
                g = a("./isArrayLike"),
                h = a("./isFunction"),
                i = a("./isString"),
                j = Object.prototype,
                k = j.hasOwnProperty;
            b.exports = d
        }, {
            "./isArguments": 124,
            "./isArray": 125,
            "./isArrayLike": 126,
            "./isFunction": 129,
            "./isString": 134
        }],
        129: [function(a, b, c) {
            function d(a) {
                var b = e(a) ? i.call(a) : "";
                return b == f || b == g
            }
            var e = a("./isObject"),
                f = "[object Function]",
                g = "[object GeneratorFunction]",
                h = Object.prototype,
                i = h.toString;
            b.exports = d
        }, {
            "./isObject": 132
        }],
        130: [function(a, b, c) {
            function d(a) {
                return "number" == typeof a && a > -1 && a % 1 == 0 && e >= a
            }
            var e = 9007199254740991;
            b.exports = d
        }, {}],
        131: [function(a, b, c) {
            function d(a) {
                return null == a ? !1 : e(a) ? m.test(k.call(a)) : g(a) && (f(a) ? m : i).test(a)
            }
            var e = a("./isFunction"),
                f = a("./_isHostObject"),
                g = a("./isObjectLike"),
                h = /[\\^$.*+?()[\]{}|]/g,
                i = /^\[object .+?Constructor\]$/,
                j = Object.prototype,
                k = Function.prototype.toString,
                l = j.hasOwnProperty,
                m = RegExp("^" + k.call(l).replace(h, "\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, "$1.*?") + "$");
            b.exports = d
        }, {
            "./_isHostObject": 94,
            "./isFunction": 129,
            "./isObjectLike": 133
        }],
        132: [function(a, b, c) {
            function d(a) {
                var b = typeof a;
                return !!a && ("object" == b || "function" == b)
            }
            b.exports = d
        }, {}],
        133: [function(a, b, c) {
            function d(a) {
                return !!a && "object" == typeof a
            }
            b.exports = d
        }, {}],
        134: [function(a, b, c) {
            function d(a) {
                return "string" == typeof a || !e(a) && f(a) && i.call(a) == g
            }
            var e = a("./isArray"),
                f = a("./isObjectLike"),
                g = "[object String]",
                h = Object.prototype,
                i = h.toString;
            b.exports = d
        }, {
            "./isArray": 125,
            "./isObjectLike": 133
        }],
        135: [function(a, b, c) {
            function d(a) {
                return "symbol" == typeof a || e(a) && h.call(a) == f
            }
            var e = a("./isObjectLike"),
                f = "[object Symbol]",
                g = Object.prototype,
                h = g.toString;
            b.exports = d
        }, {
            "./isObjectLike": 133
        }],
        136: [function(a, b, c) {
            function d(a) {
                return f(a) && e(a.length) && !!D[F.call(a)]
            }
            var e = a("./isLength"),
                f = a("./isObjectLike"),
                g = "[object Arguments]",
                h = "[object Array]",
                i = "[object Boolean]",
                j = "[object Date]",
                k = "[object Error]",
                l = "[object Function]",
                m = "[object Map]",
                n = "[object Number]",
                o = "[object Object]",
                p = "[object RegExp]",
                q = "[object Set]",
                r = "[object String]",
                s = "[object WeakMap]",
                t = "[object ArrayBuffer]",
                u = "[object Float32Array]",
                v = "[object Float64Array]",
                w = "[object Int8Array]",
                x = "[object Int16Array]",
                y = "[object Int32Array]",
                z = "[object Uint8Array]",
                A = "[object Uint8ClampedArray]",
                B = "[object Uint16Array]",
                C = "[object Uint32Array]",
                D = {};
            D[u] = D[v] = D[w] = D[x] = D[y] = D[z] = D[A] = D[B] = D[C] = !0, D[g] = D[h] = D[t] = D[i] = D[j] = D[k] = D[l] = D[m] = D[n] = D[o] = D[p] = D[q] = D[r] = D[s] = !1;
            var E = Object.prototype,
                F = E.toString;
            b.exports = d
        }, {
            "./isLength": 130,
            "./isObjectLike": 133
        }],
        137: [function(a, b, c) {
            function d(a) {
                var b = j(a);
                if (!b && !h(a)) return f(a);
                var c = g(a),
                    d = !!c,
                    k = c || [],
                    l = k.length;
                for (var m in a) !e(a, m) || d && ("length" == m || i(m, l)) || b && "constructor" == m || k.push(m);
                return k
            }
            var e = a("./_baseHas"),
                f = a("./_baseKeys"),
                g = a("./_indexKeys"),
                h = a("./isArrayLike"),
                i = a("./_isIndex"),
                j = a("./_isPrototype");
            b.exports = d
        }, {
            "./_baseHas": 61,
            "./_baseKeys": 67,
            "./_indexKeys": 93,
            "./_isIndex": 95,
            "./_isPrototype": 99,
            "./isArrayLike": 126
        }],
        138: [function(a, b, c) {
            function d(a) {
                var b = a ? a.length : 0;
                return b ? a[b - 1] : void 0
            }
            b.exports = d
        }, {}],
        139: [function(a, b, c) {
            function d(a) {
                return g(a) ? e(a) : f(a)
            }
            var e = a("./_baseProperty"),
                f = a("./_basePropertyDeep"),
                g = a("./_isKey");
            b.exports = d
        }, {
            "./_baseProperty": 70,
            "./_basePropertyDeep": 71,
            "./_isKey": 97
        }],
        140: [function(a, b, c) {
            function d(a, b) {
                if ("function" != typeof a) throw new TypeError(g);
                return b = h(void 0 === b ? a.length - 1 : f(b), 0),
                    function() {
                        for (var c = arguments, d = -1, f = h(c.length - b, 0), g = Array(f); ++d < f;) g[d] = c[b + d];
                        switch (b) {
                            case 0:
                                return a.call(this, g);
                            case 1:
                                return a.call(this, c[0], g);
                            case 2:
                                return a.call(this, c[0], c[1], g)
                        }
                        var i = Array(b + 1);
                        for (d = -1; ++d < b;) i[d] = c[d];
                        return i[b] = g, e(a, this, i)
                    }
            }
            var e = a("./_apply"),
                f = a("./toInteger"),
                g = "Expected a function",
                h = Math.max;
            b.exports = d
        }, {
            "./_apply": 43,
            "./toInteger": 141
        }],
        141: [function(a, b, c) {
            function d(a) {
                if (!a) return 0 === a ? a : 0;
                if (a = e(a), a === f || a === -f) {
                    var b = 0 > a ? -1 : 1;
                    return b * g
                }
                var c = a % 1;
                return a === a ? c ? a - c : a : 0
            }
            var e = a("./toNumber"),
                f = 1 / 0,
                g = 1.7976931348623157e308;
            b.exports = d
        }, {
            "./toNumber": 142
        }],
        142: [function(a, b, c) {
            function d(a) {
                if (f(a)) {
                    var b = e(a.valueOf) ? a.valueOf() : a;
                    a = f(b) ? b + "" : b
                }
                if ("string" != typeof a) return 0 === a ? a : +a;
                a = a.replace(h, "");
                var c = j.test(a);
                return c || k.test(a) ? l(a.slice(2), c ? 2 : 8) : i.test(a) ? g : +a
            }
            var e = a("./isFunction"),
                f = a("./isObject"),
                g = NaN,
                h = /^\s+|\s+$/g,
                i = /^[-+]0x[0-9a-f]+$/i,
                j = /^0b[01]+$/i,
                k = /^0o[0-7]+$/i,
                l = parseInt;
            b.exports = d
        }, {
            "./isFunction": 129,
            "./isObject": 132
        }],
        143: [function(a, b, c) {
            function d(a) {
                return e(a, f(a))
            }
            var e = a("./_baseToPairs"),
                f = a("./keys");
            b.exports = d
        }, {
            "./_baseToPairs": 74,
            "./keys": 137
        }],
        144: [function(a, b, c) {
            function d(a) {
                if ("string" == typeof a) return a;
                if (null == a) return "";
                if (f(a)) return e ? i.call(a) : "";
                var b = a + "";
                return "0" == b && 1 / a == -g ? "-0" : b
            }
            var e = a("./_Symbol"),
                f = a("./isSymbol"),
                g = 1 / 0,
                h = e ? e.prototype : void 0,
                i = e ? h.toString : void 0;
            b.exports = d
        }, {
            "./_Symbol": 40,
            "./isSymbol": 135
        }],
        145: [function(a, b, c) {
            function d() {
                k = !1, h.length ? j = h.concat(j) : l = -1, j.length && e()
            }

            function e() {
                if (!k) {
                    var a = setTimeout(d);
                    k = !0;
                    for (var b = j.length; b;) {
                        for (h = j, j = []; ++l < b;) h && h[l].run();
                        l = -1, b = j.length
                    }
                    h = null, k = !1, clearTimeout(a)
                }
            }

            function f(a, b) {
                this.fun = a, this.array = b
            }

            function g() {}
            var h, i = b.exports = {},
                j = [],
                k = !1,
                l = -1;
            i.nextTick = function(a) {
                var b = new Array(arguments.length - 1);
                if (arguments.length > 1)
                    for (var c = 1; c < arguments.length; c++) b[c - 1] = arguments[c];
                j.push(new f(a, b)), 1 !== j.length || k || setTimeout(e, 0)
            }, f.prototype.run = function() {
                this.fun.apply(null, this.array)
            }, i.title = "browser", i.browser = !0, i.env = {}, i.argv = [], i.version = "", i.versions = {}, i.on = g, i.addListener = g, i.once = g, i.off = g, i.removeListener = g, i.removeAllListeners = g, i.emit = g, i.binding = function(a) {
                throw new Error("process.binding is not supported")
            }, i.cwd = function() {
                return "/"
            }, i.chdir = function(a) {
                throw new Error("process.chdir is not supported")
            }, i.umask = function() {
                return 0
            }
        }, {}],
        146: [function(a, b, c) {
            (function(b) {
                ! function(c) {
                    function d(a, b) {
                        if (!(this instanceof d)) return new d(a, b);
                        var e = this;
                        f(e), e.q = e.c = "", e.bufferCheckPosition = c.MAX_BUFFER_LENGTH, e.opt = b || {}, e.opt.lowercase = e.opt.lowercase || e.opt.lowercasetags, e.looseCase = e.opt.lowercase ? "toLowerCase" : "toUpperCase", e.tags = [], e.closed = e.closedRoot = e.sawRoot = !1,
                            e.tag = e.error = null, e.strict = !!a, e.noscript = !(!a && !e.opt.noscript), e.state = V.BEGIN, e.strictEntities = e.opt.strictEntities, e.ENTITIES = e.strictEntities ? Object.create(c.XML_ENTITIES) : Object.create(c.ENTITIES), e.attribList = [], e.opt.xmlns && (e.ns = Object.create(Q)), e.trackPosition = e.opt.position !== !1, e.trackPosition && (e.position = e.line = e.column = 0), n(e, "onready")
                    }

                    function e(a) {
                        for (var b = Math.max(c.MAX_BUFFER_LENGTH, 10), d = 0, e = 0, f = D.length; f > e; e++) {
                            var g = a[D[e]].length;
                            if (g > b) switch (D[e]) {
                                case "textNode":
                                    p(a);
                                    break;
                                case "cdata":
                                    o(a, "oncdata", a.cdata), a.cdata = "";
                                    break;
                                case "script":
                                    o(a, "onscript", a.script), a.script = "";
                                    break;
                                default:
                                    r(a, "Max buffer length exceeded: " + D[e])
                            }
                            d = Math.max(d, g)
                        }
                        var h = c.MAX_BUFFER_LENGTH - d;
                        a.bufferCheckPosition = h + a.position
                    }

                    function f(a) {
                        for (var b = 0, c = D.length; c > b; b++) a[D[b]] = ""
                    }

                    function g(a) {
                        p(a), "" !== a.cdata && (o(a, "oncdata", a.cdata), a.cdata = ""), "" !== a.script && (o(a, "onscript", a.script), a.script = "")
                    }

                    function h(a, b) {
                        return new i(a, b)
                    }

                    function i(a, b) {
                        if (!(this instanceof i)) return new i(a, b);
                        E.apply(this), this._parser = new d(a, b), this.writable = !0, this.readable = !0;
                        var c = this;
                        this._parser.onend = function() {
                            c.emit("end")
                        }, this._parser.onerror = function(a) {
                            c.emit("error", a), c._parser.error = null
                        }, this._decoder = null, G.forEach(function(a) {
                            Object.defineProperty(c, "on" + a, {
                                get: function() {
                                    return c._parser["on" + a]
                                },
                                set: function(b) {
                                    return b ? void c.on(a, b) : (c.removeAllListeners(a), c._parser["on" + a] = b, b)
                                },
                                enumerable: !0,
                                configurable: !1
                            })
                        })
                    }

                    function j(a) {
                        return a.split("").reduce(function(a, b) {
                            return a[b] = !0, a
                        }, {})
                    }

                    function k(a) {
                        return "[object RegExp]" === Object.prototype.toString.call(a)
                    }

                    function l(a, b) {
                        return k(a) ? !!b.match(a) : a[b]
                    }

                    function m(a, b) {
                        return !l(a, b)
                    }

                    function n(a, b, c) {
                        a[b] && a[b](c)
                    }

                    function o(a, b, c) {
                        a.textNode && p(a), n(a, b, c)
                    }

                    function p(a) {
                        a.textNode = q(a.opt, a.textNode), a.textNode && n(a, "ontext", a.textNode), a.textNode = ""
                    }

                    function q(a, b) {
                        return a.trim && (b = b.trim()), a.normalize && (b = b.replace(/\s+/g, " ")), b
                    }

                    function r(a, b) {
                        return p(a), a.trackPosition && (b += "\nLine: " + a.line + "\nColumn: " + a.column + "\nChar: " + a.c), b = new Error(b), a.error = b, n(a, "onerror", b), a
                    }

                    function s(a) {
                        return a.sawRoot && !a.closedRoot && t(a, "Unclosed root tag"), a.state !== V.BEGIN && a.state !== V.BEGIN_WHITESPACE && a.state !== V.TEXT && r(a, "Unexpected end"), p(a), a.c = "", a.closed = !0, n(a, "onend"), d.call(a, a.strict, a.opt), a
                    }

                    function t(a, b) {
                        if ("object" != typeof a || !(a instanceof d)) throw new Error("bad call to strictFail");
                        a.strict && r(a, b)
                    }

                    function u(a) {
                        a.strict || (a.tagName = a.tagName[a.looseCase]());
                        var b = a.tags[a.tags.length - 1] || a,
                            c = a.tag = {
                                name: a.tagName,
                                attributes: {}
                            };
                        a.opt.xmlns && (c.ns = b.ns), a.attribList.length = 0
                    }

                    function v(a, b) {
                        var c = a.indexOf(":"),
                            d = 0 > c ? ["", a] : a.split(":"),
                            e = d[0],
                            f = d[1];
                        return b && "xmlns" === a && (e = "xmlns", f = ""), {
                            prefix: e,
                            local: f
                        }
                    }

                    function w(a) {
                        if (a.strict || (a.attribName = a.attribName[a.looseCase]()), -1 !== a.attribList.indexOf(a.attribName) || a.tag.attributes.hasOwnProperty(a.attribName)) return void(a.attribName = a.attribValue = "");
                        if (a.opt.xmlns) {
                            var b = v(a.attribName, !0),
                                c = b.prefix,
                                d = b.local;
                            if ("xmlns" === c)
                                if ("xml" === d && a.attribValue !== O) t(a, "xml: prefix must be bound to " + O + "\nActual: " + a.attribValue);
                                else if ("xmlns" === d && a.attribValue !== P) t(a, "xmlns: prefix must be bound to " + P + "\nActual: " + a.attribValue);
                            else {
                                var e = a.tag,
                                    f = a.tags[a.tags.length - 1] || a;
                                e.ns === f.ns && (e.ns = Object.create(f.ns)), e.ns[d] = a.attribValue
                            }
                            a.attribList.push([a.attribName, a.attribValue])
                        } else a.tag.attributes[a.attribName] = a.attribValue, o(a, "onattribute", {
                            name: a.attribName,
                            value: a.attribValue
                        });
                        a.attribName = a.attribValue = ""
                    }

                    function x(a, b) {
                        if (a.opt.xmlns) {
                            var c = a.tag,
                                d = v(a.tagName);
                            c.prefix = d.prefix, c.local = d.local, c.uri = c.ns[d.prefix] || "", c.prefix && !c.uri && (t(a, "Unbound namespace prefix: " + JSON.stringify(a.tagName)), c.uri = d.prefix);
                            var e = a.tags[a.tags.length - 1] || a;
                            c.ns && e.ns !== c.ns && Object.keys(c.ns).forEach(function(b) {
                                o(a, "onopennamespace", {
                                    prefix: b,
                                    uri: c.ns[b]
                                })
                            });
                            for (var f = 0, g = a.attribList.length; g > f; f++) {
                                var h = a.attribList[f],
                                    i = h[0],
                                    j = h[1],
                                    k = v(i, !0),
                                    l = k.prefix,
                                    m = k.local,
                                    n = "" === l ? "" : c.ns[l] || "",
                                    p = {
                                        name: i,
                                        value: j,
                                        prefix: l,
                                        local: m,
                                        uri: n
                                    };
                                l && "xmlns" !== l && !n && (t(a, "Unbound namespace prefix: " + JSON.stringify(l)), p.uri = l), a.tag.attributes[i] = p, o(a, "onattribute", p)
                            }
                            a.attribList.length = 0
                        }
                        a.tag.isSelfClosing = !!b, a.sawRoot = !0, a.tags.push(a.tag), o(a, "onopentag", a.tag), b || (a.noscript || "script" !== a.tagName.toLowerCase() ? a.state = V.TEXT : a.state = V.SCRIPT, a.tag = null, a.tagName = ""), a.attribName = a.attribValue = "", a.attribList.length = 0
                    }

                    function y(a) {
                        if (!a.tagName) return t(a, "Weird empty close tag."), a.textNode += "</>", void(a.state = V.TEXT);
                        if (a.script) {
                            if ("script" !== a.tagName) return a.script += "</" + a.tagName + ">", a.tagName = "", void(a.state = V.SCRIPT);
                            o(a, "onscript", a.script), a.script = ""
                        }
                        var b = a.tags.length,
                            c = a.tagName;
                        a.strict || (c = c[a.looseCase]());
                        for (var d = c; b--;) {
                            var e = a.tags[b];
                            if (e.name === d) break;
                            t(a, "Unexpected close tag")
                        }
                        if (0 > b) return t(a, "Unmatched closing tag: " + a.tagName), a.textNode += "</" + a.tagName + ">", void(a.state = V.TEXT);
                        a.tagName = c;
                        for (var f = a.tags.length; f-- > b;) {
                            var g = a.tag = a.tags.pop();
                            a.tagName = a.tag.name, o(a, "onclosetag", a.tagName);
                            var h = {};
                            for (var i in g.ns) h[i] = g.ns[i];
                            var j = a.tags[a.tags.length - 1] || a;
                            a.opt.xmlns && g.ns !== j.ns && Object.keys(g.ns).forEach(function(b) {
                                var c = g.ns[b];
                                o(a, "onclosenamespace", {
                                    prefix: b,
                                    uri: c
                                })
                            })
                        }
                        0 === b && (a.closedRoot = !0), a.tagName = a.attribValue = a.attribName = "", a.attribList.length = 0, a.state = V.TEXT
                    }

                    function z(a) {
                        var b, c = a.entity,
                            d = c.toLowerCase(),
                            e = "";
                        return a.ENTITIES[c] ? a.ENTITIES[c] : a.ENTITIES[d] ? a.ENTITIES[d] : (c = d, "#" === c.charAt(0) && ("x" === c.charAt(1) ? (c = c.slice(2), b = parseInt(c, 16), e = b.toString(16)) : (c = c.slice(1), b = parseInt(c, 10), e = b.toString(10))), c = c.replace(/^0+/, ""), e.toLowerCase() !== c ? (t(a, "Invalid character entity"), "&" + a.entity + ";") : String.fromCodePoint(b))
                    }

                    function A(a, b) {
                        "<" === b ? (a.state = V.OPEN_WAKA, a.startTagPosition = a.position) : m(H, b) && (t(a, "Non-whitespace before first tag."), a.textNode = b, a.state = V.TEXT)
                    }

                    function B(a, b) {
                        var c = "";
                        return b < a.length && (c = a.charAt(b)), c
                    }

                    function C(a) {
                        var b = this;
                        if (this.error) throw this.error;
                        if (b.closed) return r(b, "Cannot write after close. Assign an onready handler.");
                        if (null === a) return s(b);
                        for (var c = 0, d = "";;) {
                            if (d = B(a, c++), b.c = d, !d) break;
                            switch (b.trackPosition && (b.position++, "\n" === d ? (b.line++, b.column = 0) : b.column++), b.state) {
                                case V.BEGIN:
                                    if (b.state = V.BEGIN_WHITESPACE, "\ufeff" === d) continue;
                                    A(b, d);
                                    continue;
                                case V.BEGIN_WHITESPACE:
                                    A(b, d);
                                    continue;
                                case V.TEXT:
                                    if (b.sawRoot && !b.closedRoot) {
                                        for (var f = c - 1; d && "<" !== d && "&" !== d;) d = B(a, c++), d && b.trackPosition && (b.position++, "\n" === d ? (b.line++, b.column = 0) : b.column++);
                                        b.textNode += a.substring(f, c - 1)
                                    }
                                    "<" !== d || b.sawRoot && b.closedRoot && !b.strict ? (!m(H, d) || b.sawRoot && !b.closedRoot || t(b, "Text data outside of root node."), "&" === d ? b.state = V.TEXT_ENTITY : b.textNode += d) : (b.state = V.OPEN_WAKA, b.startTagPosition = b.position);
                                    continue;
                                case V.SCRIPT:
                                    "<" === d ? b.state = V.SCRIPT_ENDING : b.script += d;
                                    continue;
                                case V.SCRIPT_ENDING:
                                    "/" === d ? b.state = V.CLOSE_TAG : (b.script += "<" + d, b.state = V.SCRIPT);
                                    continue;
                                case V.OPEN_WAKA:
                                    if ("!" === d) b.state = V.SGML_DECL, b.sgmlDecl = "";
                                    else if (l(H, d));
                                    else if (l(R, d)) b.state = V.OPEN_TAG, b.tagName = d;
                                    else if ("/" === d) b.state = V.CLOSE_TAG, b.tagName = "";
                                    else if ("?" === d) b.state = V.PROC_INST, b.procInstName = b.procInstBody = "";
                                    else {
                                        if (t(b, "Unencoded <"), b.startTagPosition + 1 < b.position) {
                                            var g = b.position - b.startTagPosition;
                                            d = new Array(g).join(" ") + d
                                        }
                                        b.textNode += "<" + d, b.state = V.TEXT
                                    }
                                    continue;
                                case V.SGML_DECL:
                                    (b.sgmlDecl + d).toUpperCase() === M ? (o(b, "onopencdata"), b.state = V.CDATA, b.sgmlDecl = "", b.cdata = "") : b.sgmlDecl + d === "--" ? (b.state = V.COMMENT, b.comment = "", b.sgmlDecl = "") : (b.sgmlDecl + d).toUpperCase() === N ? (b.state = V.DOCTYPE, (b.doctype || b.sawRoot) && t(b, "Inappropriately located doctype declaration"), b.doctype = "", b.sgmlDecl = "") : ">" === d ? (o(b, "onsgmldeclaration", b.sgmlDecl), b.sgmlDecl = "", b.state = V.TEXT) : l(K, d) ? (b.state = V.SGML_DECL_QUOTED, b.sgmlDecl += d) : b.sgmlDecl += d;
                                    continue;
                                case V.SGML_DECL_QUOTED:
                                    d === b.q && (b.state = V.SGML_DECL, b.q = ""), b.sgmlDecl += d;
                                    continue;
                                case V.DOCTYPE:
                                    ">" === d ? (b.state = V.TEXT, o(b, "ondoctype", b.doctype), b.doctype = !0) : (b.doctype += d, "[" === d ? b.state = V.DOCTYPE_DTD : l(K, d) && (b.state = V.DOCTYPE_QUOTED, b.q = d));
                                    continue;
                                case V.DOCTYPE_QUOTED:
                                    b.doctype += d, d === b.q && (b.q = "", b.state = V.DOCTYPE);
                                    continue;
                                case V.DOCTYPE_DTD:
                                    b.doctype += d, "]" === d ? b.state = V.DOCTYPE : l(K, d) && (b.state = V.DOCTYPE_DTD_QUOTED, b.q = d);
                                    continue;
                                case V.DOCTYPE_DTD_QUOTED:
                                    b.doctype += d, d === b.q && (b.state = V.DOCTYPE_DTD, b.q = "");
                                    continue;
                                case V.COMMENT:
                                    "-" === d ? b.state = V.COMMENT_ENDING : b.comment += d;
                                    continue;
                                case V.COMMENT_ENDING:
                                    "-" === d ? (b.state = V.COMMENT_ENDED, b.comment = q(b.opt, b.comment), b.comment && o(b, "oncomment", b.comment), b.comment = "") : (b.comment += "-" + d, b.state = V.COMMENT);
                                    continue;
                                case V.COMMENT_ENDED:
                                    ">" !== d ? (t(b, "Malformed comment"), b.comment += "--" + d, b.state = V.COMMENT) : b.state = V.TEXT;
                                    continue;
                                case V.CDATA:
                                    "]" === d ? b.state = V.CDATA_ENDING : b.cdata += d;
                                    continue;
                                case V.CDATA_ENDING:
                                    "]" === d ? b.state = V.CDATA_ENDING_2 : (b.cdata += "]" + d, b.state = V.CDATA);
                                    continue;
                                case V.CDATA_ENDING_2:
                                    ">" === d ? (b.cdata && o(b, "oncdata", b.cdata), o(b, "onclosecdata"), b.cdata = "", b.state = V.TEXT) : "]" === d ? b.cdata += "]" : (b.cdata += "]]" + d, b.state = V.CDATA);
                                    continue;
                                case V.PROC_INST:
                                    "?" === d ? b.state = V.PROC_INST_ENDING : l(H, d) ? b.state = V.PROC_INST_BODY : b.procInstName += d;
                                    continue;
                                case V.PROC_INST_BODY:
                                    if (!b.procInstBody && l(H, d)) continue;
                                    "?" === d ? b.state = V.PROC_INST_ENDING : b.procInstBody += d;
                                    continue;
                                case V.PROC_INST_ENDING:
                                    ">" === d ? (o(b, "onprocessinginstruction", {
                                        name: b.procInstName,
                                        body: b.procInstBody
                                    }), b.procInstName = b.procInstBody = "", b.state = V.TEXT) : (b.procInstBody += "?" + d, b.state = V.PROC_INST_BODY);
                                    continue;
                                case V.OPEN_TAG:
                                    l(S, d) ? b.tagName += d : (u(b), ">" === d ? x(b) : "/" === d ? b.state = V.OPEN_TAG_SLASH : (m(H, d) && t(b, "Invalid character in tag name"), b.state = V.ATTRIB));
                                    continue;
                                case V.OPEN_TAG_SLASH:
                                    ">" === d ? (x(b, !0), y(b)) : (t(b, "Forward-slash in opening tag not followed by >"), b.state = V.ATTRIB);
                                    continue;
                                case V.ATTRIB:
                                    if (l(H, d)) continue;
                                    ">" === d ? x(b) : "/" === d ? b.state = V.OPEN_TAG_SLASH : l(R, d) ? (b.attribName = d, b.attribValue = "", b.state = V.ATTRIB_NAME) : t(b, "Invalid attribute name");
                                    continue;
                                case V.ATTRIB_NAME:
                                    "=" === d ? b.state = V.ATTRIB_VALUE : ">" === d ? (t(b, "Attribute without value"), b.attribValue = b.attribName, w(b), x(b)) : l(H, d) ? b.state = V.ATTRIB_NAME_SAW_WHITE : l(S, d) ? b.attribName += d : t(b, "Invalid attribute name");
                                    continue;
                                case V.ATTRIB_NAME_SAW_WHITE:
                                    if ("=" === d) b.state = V.ATTRIB_VALUE;
                                    else {
                                        if (l(H, d)) continue;
                                        t(b, "Attribute without value"), b.tag.attributes[b.attribName] = "", b.attribValue = "", o(b, "onattribute", {
                                            name: b.attribName,
                                            value: ""
                                        }), b.attribName = "", ">" === d ? x(b) : l(R, d) ? (b.attribName = d, b.state = V.ATTRIB_NAME) : (t(b, "Invalid attribute name"), b.state = V.ATTRIB)
                                    }
                                    continue;
                                case V.ATTRIB_VALUE:
                                    if (l(H, d)) continue;
                                    l(K, d) ? (b.q = d, b.state = V.ATTRIB_VALUE_QUOTED) : (t(b, "Unquoted attribute value"), b.state = V.ATTRIB_VALUE_UNQUOTED, b.attribValue = d);
                                    continue;
                                case V.ATTRIB_VALUE_QUOTED:
                                    if (d !== b.q) {
                                        "&" === d ? b.state = V.ATTRIB_VALUE_ENTITY_Q : b.attribValue += d;
                                        continue
                                    }
                                    w(b), b.q = "", b.state = V.ATTRIB_VALUE_CLOSED;
                                    continue;
                                case V.ATTRIB_VALUE_CLOSED:
                                    l(H, d) ? b.state = V.ATTRIB : ">" === d ? x(b) : "/" === d ? b.state = V.OPEN_TAG_SLASH : l(R, d) ? (t(b, "No whitespace between attributes"), b.attribName = d, b.attribValue = "", b.state = V.ATTRIB_NAME) : t(b, "Invalid attribute name");
                                    continue;
                                case V.ATTRIB_VALUE_UNQUOTED:
                                    if (m(L, d)) {
                                        "&" === d ? b.state = V.ATTRIB_VALUE_ENTITY_U : b.attribValue += d;
                                        continue
                                    }
                                    w(b), ">" === d ? x(b) : b.state = V.ATTRIB;
                                    continue;
                                case V.CLOSE_TAG:
                                    if (b.tagName) ">" === d ? y(b) : l(S, d) ? b.tagName += d : b.script ? (b.script += "</" + b.tagName, b.tagName = "", b.state = V.SCRIPT) : (m(H, d) && t(b, "Invalid tagname in closing tag"), b.state = V.CLOSE_TAG_SAW_WHITE);
                                    else {
                                        if (l(H, d)) continue;
                                        m(R, d) ? b.script ? (b.script += "</" + d, b.state = V.SCRIPT) : t(b, "Invalid tagname in closing tag.") : b.tagName = d
                                    }
                                    continue;
                                case V.CLOSE_TAG_SAW_WHITE:
                                    if (l(H, d)) continue;
                                    ">" === d ? y(b) : t(b, "Invalid characters in closing tag");
                                    continue;
                                case V.TEXT_ENTITY:
                                case V.ATTRIB_VALUE_ENTITY_Q:
                                case V.ATTRIB_VALUE_ENTITY_U:
                                    var h, i;
                                    switch (b.state) {
                                        case V.TEXT_ENTITY:
                                            h = V.TEXT, i = "textNode";
                                            break;
                                        case V.ATTRIB_VALUE_ENTITY_Q:
                                            h = V.ATTRIB_VALUE_QUOTED, i = "attribValue";
                                            break;
                                        case V.ATTRIB_VALUE_ENTITY_U:
                                            h = V.ATTRIB_VALUE_UNQUOTED, i = "attribValue"
                                    }
                                    ";" === d ? (b[i] += z(b), b.entity = "", b.state = h) : l(b.entity.length ? U : T, d) ? b.entity += d : (t(b, "Invalid character in entity name"), b[i] += "&" + b.entity + d, b.entity = "", b.state = h);
                                    continue;
                                default:
                                    throw new Error(b, "Unknown state: " + b.state)
                            }
                        }
                        return b.position >= b.bufferCheckPosition && e(b), b
                    }
                    c.parser = function(a, b) {
                        return new d(a, b)
                    }, c.SAXParser = d, c.SAXStream = i, c.createStream = h, c.MAX_BUFFER_LENGTH = 65536;
                    var D = ["comment", "sgmlDecl", "textNode", "tagName", "doctype", "procInstName", "procInstBody", "entity", "attribName", "attribValue", "cdata", "script"];
                    c.EVENTS = ["text", "processinginstruction", "sgmldeclaration", "doctype", "comment", "attribute", "opentag", "closetag", "opencdata", "cdata", "closecdata", "error", "end", "ready", "script", "opennamespace", "closenamespace"], Object.create || (Object.create = function(a) {
                        function b() {}
                        b.prototype = a;
                        var c = new b;
                        return c
                    }), Object.keys || (Object.keys = function(a) {
                        var b = [];
                        for (var c in a) a.hasOwnProperty(c) && b.push(c);
                        return b
                    }), d.prototype = {
                        end: function() {
                            s(this)
                        },
                        write: C,
                        resume: function() {
                            return this.error = null, this
                        },
                        close: function() {
                            return this.write(null)
                        },
                        flush: function() {
                            g(this)
                        }
                    };
                    var E;
                    try {
                        E = a("stream").Stream
                    } catch (F) {
                        E = function() {}
                    }
                    var G = c.EVENTS.filter(function(a) {
                        return "error" !== a && "end" !== a
                    });
                    i.prototype = Object.create(E.prototype, {
                        constructor: {
                            value: i
                        }
                    }), i.prototype.write = function(c) {
                        if ("function" == typeof b && "function" == typeof b.isBuffer && b.isBuffer(c)) {
                            if (!this._decoder) {
                                var d = a("string_decoder").StringDecoder;
                                this._decoder = new d("utf8")
                            }
                            c = this._decoder.write(c)
                        }
                        return this._parser.write(c.toString()), this.emit("data", c), !0
                    }, i.prototype.end = function(a) {
                        return a && a.length && this.write(a), this._parser.end(), !0
                    }, i.prototype.on = function(a, b) {
                        var c = this;
                        return c._parser["on" + a] || -1 === G.indexOf(a) || (c._parser["on" + a] = function() {
                            var b = 1 === arguments.length ? [arguments[0]] : Array.apply(null, arguments);
                            b.splice(0, 0, a), c.emit.apply(c, b)
                        }), E.prototype.on.call(c, a, b)
                    };
                    var H = "\r\n	 ",
                        I = "0124356789",
                        J = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                        K = "'\"",
                        L = H + ">",
                        M = "[CDATA[",
                        N = "DOCTYPE",
                        O = "http://www.w3.org/XML/1998/namespace",
                        P = "http://www.w3.org/2000/xmlns/",
                        Q = {
                            xml: O,
                            xmlns: P
                        };
                    H = j(H), I = j(I), J = j(J);
                    var R = /[:_A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD]/,
                        S = /[:_A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\u00B7\u0300-\u036F\u203F-\u2040\.\d-]/,
                        T = /[#:_A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD]/,
                        U = /[#:_A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\u00B7\u0300-\u036F\u203F-\u2040\.\d-]/;
                    K = j(K), L = j(L);
                    var V = 0;
                    c.STATE = {
                        BEGIN: V++,
                        BEGIN_WHITESPACE: V++,
                        TEXT: V++,
                        TEXT_ENTITY: V++,
                        OPEN_WAKA: V++,
                        SGML_DECL: V++,
                        SGML_DECL_QUOTED: V++,
                        DOCTYPE: V++,
                        DOCTYPE_QUOTED: V++,
                        DOCTYPE_DTD: V++,
                        DOCTYPE_DTD_QUOTED: V++,
                        COMMENT_STARTING: V++,
                        COMMENT: V++,
                        COMMENT_ENDING: V++,
                        COMMENT_ENDED: V++,
                        CDATA: V++,
                        CDATA_ENDING: V++,
                        CDATA_ENDING_2: V++,
                        PROC_INST: V++,
                        PROC_INST_BODY: V++,
                        PROC_INST_ENDING: V++,
                        OPEN_TAG: V++,
                        OPEN_TAG_SLASH: V++,
                        ATTRIB: V++,
                        ATTRIB_NAME: V++,
                        ATTRIB_NAME_SAW_WHITE: V++,
                        ATTRIB_VALUE: V++,
                        ATTRIB_VALUE_QUOTED: V++,
                        ATTRIB_VALUE_CLOSED: V++,
                        ATTRIB_VALUE_UNQUOTED: V++,
                        ATTRIB_VALUE_ENTITY_Q: V++,
                        ATTRIB_VALUE_ENTITY_U: V++,
                        CLOSE_TAG: V++,
                        CLOSE_TAG_SAW_WHITE: V++,
                        SCRIPT: V++,
                        SCRIPT_ENDING: V++
                    }, c.XML_ENTITIES = {
                        amp: "&",
                        gt: ">",
                        lt: "<",
                        quot: '"',
                        apos: "'"
                    }, c.ENTITIES = {
                        amp: "&",
                        gt: ">",
                        lt: "<",
                        quot: '"',
                        apos: "'",
                        AElig: 198,
                        Aacute: 193,
                        Acirc: 194,
                        Agrave: 192,
                        Aring: 197,
                        Atilde: 195,
                        Auml: 196,
                        Ccedil: 199,
                        ETH: 208,
                        Eacute: 201,
                        Ecirc: 202,
                        Egrave: 200,
                        Euml: 203,
                        Iacute: 205,
                        Icirc: 206,
                        Igrave: 204,
                        Iuml: 207,
                        Ntilde: 209,
                        Oacute: 211,
                        Ocirc: 212,
                        Ograve: 210,
                        Oslash: 216,
                        Otilde: 213,
                        Ouml: 214,
                        THORN: 222,
                        Uacute: 218,
                        Ucirc: 219,
                        Ugrave: 217,
                        Uuml: 220,
                        Yacute: 221,
                        aacute: 225,
                        acirc: 226,
                        aelig: 230,
                        agrave: 224,
                        aring: 229,
                        atilde: 227,
                        auml: 228,
                        ccedil: 231,
                        eacute: 233,
                        ecirc: 234,
                        egrave: 232,
                        eth: 240,
                        euml: 235,
                        iacute: 237,
                        icirc: 238,
                        igrave: 236,
                        iuml: 239,
                        ntilde: 241,
                        oacute: 243,
                        ocirc: 244,
                        ograve: 242,
                        oslash: 248,
                        otilde: 245,
                        ouml: 246,
                        szlig: 223,
                        thorn: 254,
                        uacute: 250,
                        ucirc: 251,
                        ugrave: 249,
                        uuml: 252,
                        yacute: 253,
                        yuml: 255,
                        copy: 169,
                        reg: 174,
                        nbsp: 160,
                        iexcl: 161,
                        cent: 162,
                        pound: 163,
                        curren: 164,
                        yen: 165,
                        brvbar: 166,
                        sect: 167,
                        uml: 168,
                        ordf: 170,
                        laquo: 171,
                        not: 172,
                        shy: 173,
                        macr: 175,
                        deg: 176,
                        plusmn: 177,
                        sup1: 185,
                        sup2: 178,
                        sup3: 179,
                        acute: 180,
                        micro: 181,
                        para: 182,
                        middot: 183,
                        cedil: 184,
                        ordm: 186,
                        raquo: 187,
                        frac14: 188,
                        frac12: 189,
                        frac34: 190,
                        iquest: 191,
                        times: 215,
                        divide: 247,
                        OElig: 338,
                        oelig: 339,
                        Scaron: 352,
                        scaron: 353,
                        Yuml: 376,
                        fnof: 402,
                        circ: 710,
                        tilde: 732,
                        Alpha: 913,
                        Beta: 914,
                        Gamma: 915,
                        Delta: 916,
                        Epsilon: 917,
                        Zeta: 918,
                        Eta: 919,
                        Theta: 920,
                        Iota: 921,
                        Kappa: 922,
                        Lambda: 923,
                        Mu: 924,
                        Nu: 925,
                        Xi: 926,
                        Omicron: 927,
                        Pi: 928,
                        Rho: 929,
                        Sigma: 931,
                        Tau: 932,
                        Upsilon: 933,
                        Phi: 934,
                        Chi: 935,
                        Psi: 936,
                        Omega: 937,
                        alpha: 945,
                        beta: 946,
                        gamma: 947,
                        delta: 948,
                        epsilon: 949,
                        zeta: 950,
                        eta: 951,
                        theta: 952,
                        iota: 953,
                        kappa: 954,
                        lambda: 955,
                        mu: 956,
                        nu: 957,
                        xi: 958,
                        omicron: 959,
                        pi: 960,
                        rho: 961,
                        sigmaf: 962,
                        sigma: 963,
                        tau: 964,
                        upsilon: 965,
                        phi: 966,
                        chi: 967,
                        psi: 968,
                        omega: 969,
                        thetasym: 977,
                        upsih: 978,
                        piv: 982,
                        ensp: 8194,
                        emsp: 8195,
                        thinsp: 8201,
                        zwnj: 8204,
                        zwj: 8205,
                        lrm: 8206,
                        rlm: 8207,
                        ndash: 8211,
                        mdash: 8212,
                        lsquo: 8216,
                        rsquo: 8217,
                        sbquo: 8218,
                        ldquo: 8220,
                        rdquo: 8221,
                        bdquo: 8222,
                        dagger: 8224,
                        Dagger: 8225,
                        bull: 8226,
                        hellip: 8230,
                        permil: 8240,
                        prime: 8242,
                        Prime: 8243,
                        lsaquo: 8249,
                        rsaquo: 8250,
                        oline: 8254,
                        frasl: 8260,
                        euro: 8364,
                        image: 8465,
                        weierp: 8472,
                        real: 8476,
                        trade: 8482,
                        alefsym: 8501,
                        larr: 8592,
                        uarr: 8593,
                        rarr: 8594,
                        darr: 8595,
                        harr: 8596,
                        crarr: 8629,
                        lArr: 8656,
                        uArr: 8657,
                        rArr: 8658,
                        dArr: 8659,
                        hArr: 8660,
                        forall: 8704,
                        part: 8706,
                        exist: 8707,
                        empty: 8709,
                        nabla: 8711,
                        isin: 8712,
                        notin: 8713,
                        ni: 8715,
                        prod: 8719,
                        sum: 8721,
                        minus: 8722,
                        lowast: 8727,
                        radic: 8730,
                        prop: 8733,
                        infin: 8734,
                        ang: 8736,
                        and: 8743,
                        or: 8744,
                        cap: 8745,
                        cup: 8746,
                        "int": 8747,
                        there4: 8756,
                        sim: 8764,
                        cong: 8773,
                        asymp: 8776,
                        ne: 8800,
                        equiv: 8801,
                        le: 8804,
                        ge: 8805,
                        sub: 8834,
                        sup: 8835,
                        nsub: 8836,
                        sube: 8838,
                        supe: 8839,
                        oplus: 8853,
                        otimes: 8855,
                        perp: 8869,
                        sdot: 8901,
                        lceil: 8968,
                        rceil: 8969,
                        lfloor: 8970,
                        rfloor: 8971,
                        lang: 9001,
                        rang: 9002,
                        loz: 9674,
                        spades: 9824,
                        clubs: 9827,
                        hearts: 9829,
                        diams: 9830
                    }, Object.keys(c.ENTITIES).forEach(function(a) {
                        var b = c.ENTITIES[a],
                            d = "number" == typeof b ? String.fromCharCode(b) : b;
                        c.ENTITIES[a] = d
                    });
                    for (var W in c.STATE) c.STATE[c.STATE[W]] = W;
                    V = c.STATE, String.fromCodePoint || ! function() {
                        var a = String.fromCharCode,
                            b = Math.floor,
                            c = function() {
                                var c, d, e = 16384,
                                    f = [],
                                    g = -1,
                                    h = arguments.length;
                                if (!h) return "";
                                for (var i = ""; ++g < h;) {
                                    var j = Number(arguments[g]);
                                    if (!isFinite(j) || 0 > j || j > 1114111 || b(j) !== j) throw RangeError("Invalid code point: " + j);
                                    65535 >= j ? f.push(j) : (j -= 65536, c = (j >> 10) + 55296, d = j % 1024 + 56320, f.push(c, d)), (g + 1 === h || f.length > e) && (i += a.apply(null, f), f.length = 0)
                                }
                                return i
                            };
                        Object.defineProperty ? Object.defineProperty(String, "fromCodePoint", {
                            value: c,
                            configurable: !0,
                            writable: !0
                        }) : String.fromCodePoint = c
                    }()
                }("undefined" == typeof c ? this.sax = {} : c)
            }).call(this, a("buffer").Buffer)
        }, {
            buffer: 23,
            stream: 147,
            string_decoder: 158
        }],
        147: [function(a, b, c) {
            function d() {
                e.call(this)
            }
            b.exports = d;
            var e = a("events").EventEmitter,
                f = a("inherits");
            f(d, e), d.Readable = a("readable-stream/readable.js"), d.Writable = a("readable-stream/writable.js"), d.Duplex = a("readable-stream/duplex.js"), d.Transform = a("readable-stream/transform.js"), d.PassThrough = a("readable-stream/passthrough.js"), d.Stream = d, d.prototype.pipe = function(a, b) {
                function c(b) {
                    a.writable && !1 === a.write(b) && j.pause && j.pause()
                }

                function d() {
                    j.readable && j.resume && j.resume()
                }

                function f() {
                    k || (k = !0, a.end())
                }

                function g() {
                    k || (k = !0, "function" == typeof a.destroy && a.destroy())
                }

                function h(a) {
                    if (i(), 0 === e.listenerCount(this, "error")) throw a
                }

                function i() {
                    j.removeListener("data", c), a.removeListener("drain", d), j.removeListener("end", f), j.removeListener("close", g), j.removeListener("error", h), a.removeListener("error", h), j.removeListener("end", i), j.removeListener("close", i), a.removeListener("close", i)
                }
                var j = this;
                j.on("data", c), a.on("drain", d), a._isStdio || b && b.end === !1 || (j.on("end", f), j.on("close", g));
                var k = !1;
                return j.on("error", h), a.on("error", h), j.on("end", i), j.on("close", i), a.on("close", i), a.emit("pipe", j), a
            }
        }, {
            events: 30,
            inherits: 32,
            "readable-stream/duplex.js": 148,
            "readable-stream/passthrough.js": 154,
            "readable-stream/readable.js": 155,
            "readable-stream/transform.js": 156,
            "readable-stream/writable.js": 157
        }],
        148: [function(a, b, c) {
            b.exports = a("./lib/_stream_duplex.js")
        }, {
            "./lib/_stream_duplex.js": 149
        }],
        149: [function(a, b, c) {
            (function(c) {
                function d(a) {
                    return this instanceof d ? (i.call(this, a), j.call(this, a), a && a.readable === !1 && (this.readable = !1), a && a.writable === !1 && (this.writable = !1), this.allowHalfOpen = !0, a && a.allowHalfOpen === !1 && (this.allowHalfOpen = !1), void this.once("end", e)) : new d(a)
                }

                function e() {
                    this.allowHalfOpen || this._writableState.ended || c.nextTick(this.end.bind(this))
                }

                function f(a, b) {
                    for (var c = 0, d = a.length; d > c; c++) b(a[c], c)
                }
                b.exports = d;
                var g = Object.keys || function(a) {
                        var b = [];
                        for (var c in a) b.push(c);
                        return b
                    },
                    h = a("core-util-is");
                h.inherits = a("inherits");
                var i = a("./_stream_readable"),
                    j = a("./_stream_writable");
                h.inherits(d, i), f(g(j.prototype), function(a) {
                    d.prototype[a] || (d.prototype[a] = j.prototype[a])
                })
            }).call(this, a("_process"))
        }, {
            "./_stream_readable": 151,
            "./_stream_writable": 153,
            _process: 145,
            "core-util-is": 25,
            inherits: 32
        }],
        150: [function(a, b, c) {
            function d(a) {
                return this instanceof d ? void e.call(this, a) : new d(a)
            }
            b.exports = d;
            var e = a("./_stream_transform"),
                f = a("core-util-is");
            f.inherits = a("inherits"), f.inherits(d, e), d.prototype._transform = function(a, b, c) {
                c(null, a)
            }
        }, {
            "./_stream_transform": 152,
            "core-util-is": 25,
            inherits: 32
        }],
        151: [function(a, b, c) {
            (function(c) {
                function d(b, c) {
                    var d = a("./_stream_duplex");
                    b = b || {};
                    var e = b.highWaterMark,
                        f = b.objectMode ? 16 : 16384;
                    this.highWaterMark = e || 0 === e ? e : f, this.highWaterMark = ~~this.highWaterMark, this.buffer = [], this.length = 0, this.pipes = null, this.pipesCount = 0, this.flowing = null, this.ended = !1, this.endEmitted = !1, this.reading = !1, this.sync = !0, this.needReadable = !1, this.emittedReadable = !1, this.readableListening = !1, this.objectMode = !!b.objectMode, c instanceof d && (this.objectMode = this.objectMode || !!b.readableObjectMode), this.defaultEncoding = b.defaultEncoding || "utf8", this.ranOut = !1, this.awaitDrain = 0, this.readingMore = !1, this.decoder = null, this.encoding = null, b.encoding && (C || (C = a("string_decoder/").StringDecoder), this.decoder = new C(b.encoding), this.encoding = b.encoding)
                }

                function e(b) {
                    a("./_stream_duplex");
                    return this instanceof e ? (this._readableState = new d(b, this), this.readable = !0, void A.call(this)) : new e(b)
                }

                function f(a, b, c, d, e) {
                    var f = j(b, c);
                    if (f) a.emit("error", f);
                    else if (B.isNullOrUndefined(c)) b.reading = !1, b.ended || k(a, b);
                    else if (b.objectMode || c && c.length > 0)
                        if (b.ended && !e) {
                            var h = new Error("stream.push() after EOF");
                            a.emit("error", h)
                        } else if (b.endEmitted && e) {
                        var h = new Error("stream.unshift() after end event");
                        a.emit("error", h)
                    } else !b.decoder || e || d || (c = b.decoder.write(c)), e || (b.reading = !1), b.flowing && 0 === b.length && !b.sync ? (a.emit("data", c), a.read(0)) : (b.length += b.objectMode ? 1 : c.length, e ? b.buffer.unshift(c) : b.buffer.push(c), b.needReadable && l(a)), n(a, b);
                    else e || (b.reading = !1);
                    return g(b)
                }

                function g(a) {
                    return !a.ended && (a.needReadable || a.length < a.highWaterMark || 0 === a.length)
                }

                function h(a) {
                    if (a >= E) a = E;
                    else {
                        a--;
                        for (var b = 1; 32 > b; b <<= 1) a |= a >> b;
                        a++
                    }
                    return a
                }

                function i(a, b) {
                    return 0 === b.length && b.ended ? 0 : b.objectMode ? 0 === a ? 0 : 1 : isNaN(a) || B.isNull(a) ? b.flowing && b.buffer.length ? b.buffer[0].length : b.length : 0 >= a ? 0 : (a > b.highWaterMark && (b.highWaterMark = h(a)), a > b.length ? b.ended ? b.length : (b.needReadable = !0, 0) : a)
                }

                function j(a, b) {
                    var c = null;
                    return B.isBuffer(b) || B.isString(b) || B.isNullOrUndefined(b) || a.objectMode || (c = new TypeError("Invalid non-string/buffer chunk")), c
                }

                function k(a, b) {
                    if (b.decoder && !b.ended) {
                        var c = b.decoder.end();
                        c && c.length && (b.buffer.push(c), b.length += b.objectMode ? 1 : c.length)
                    }
                    b.ended = !0, l(a)
                }

                function l(a) {
                    var b = a._readableState;
                    b.needReadable = !1, b.emittedReadable || (D("emitReadable", b.flowing), b.emittedReadable = !0, b.sync ? c.nextTick(function() {
                        m(a)
                    }) : m(a))
                }

                function m(a) {
                    D("emit readable"), a.emit("readable"), s(a)
                }

                function n(a, b) {
                    b.readingMore || (b.readingMore = !0, c.nextTick(function() {
                        o(a, b)
                    }))
                }

                function o(a, b) {
                    for (var c = b.length; !b.reading && !b.flowing && !b.ended && b.length < b.highWaterMark && (D("maybeReadMore read 0"), a.read(0), c !== b.length);) c = b.length;
                    b.readingMore = !1
                }

                function p(a) {
                    return function() {
                        var b = a._readableState;
                        D("pipeOnDrain", b.awaitDrain), b.awaitDrain && b.awaitDrain--, 0 === b.awaitDrain && z.listenerCount(a, "data") && (b.flowing = !0, s(a))
                    }
                }

                function q(a, b) {
                    b.resumeScheduled || (b.resumeScheduled = !0, c.nextTick(function() {
                        r(a, b)
                    }))
                }

                function r(a, b) {
                    b.resumeScheduled = !1, a.emit("resume"), s(a), b.flowing && !b.reading && a.read(0)
                }

                function s(a) {
                    var b = a._readableState;
                    if (D("flow", b.flowing), b.flowing)
                        do var c = a.read(); while (null !== c && b.flowing)
                }

                function t(a, b) {
                    var c, d = b.buffer,
                        e = b.length,
                        f = !!b.decoder,
                        g = !!b.objectMode;
                    if (0 === d.length) return null;
                    if (0 === e) c = null;
                    else if (g) c = d.shift();
                    else if (!a || a >= e) c = f ? d.join("") : y.concat(d, e), d.length = 0;
                    else if (a < d[0].length) {
                        var h = d[0];
                        c = h.slice(0, a), d[0] = h.slice(a)
                    } else if (a === d[0].length) c = d.shift();
                    else {
                        c = f ? "" : new y(a);
                        for (var i = 0, j = 0, k = d.length; k > j && a > i; j++) {
                            var h = d[0],
                                l = Math.min(a - i, h.length);
                            f ? c += h.slice(0, l) : h.copy(c, i, 0, l), l < h.length ? d[0] = h.slice(l) : d.shift(), i += l
                        }
                    }
                    return c
                }

                function u(a) {
                    var b = a._readableState;
                    if (b.length > 0) throw new Error("endReadable called on non-empty stream");
                    b.endEmitted || (b.ended = !0, c.nextTick(function() {
                        b.endEmitted || 0 !== b.length || (b.endEmitted = !0, a.readable = !1, a.emit("end"))
                    }))
                }

                function v(a, b) {
                    for (var c = 0, d = a.length; d > c; c++) b(a[c], c)
                }

                function w(a, b) {
                    for (var c = 0, d = a.length; d > c; c++)
                        if (a[c] === b) return c;
                    return -1
                }
                b.exports = e;
                var x = a("isarray"),
                    y = a("buffer").Buffer;
                e.ReadableState = d;
                var z = a("events").EventEmitter;
                z.listenerCount || (z.listenerCount = function(a, b) {
                    return a.listeners(b).length
                });
                var A = a("stream"),
                    B = a("core-util-is");
                B.inherits = a("inherits");
                var C, D = a("util");
                D = D && D.debuglog ? D.debuglog("stream") : function() {}, B.inherits(e, A), e.prototype.push = function(a, b) {
                    var c = this._readableState;
                    return B.isString(a) && !c.objectMode && (b = b || c.defaultEncoding, b !== c.encoding && (a = new y(a, b), b = "")), f(this, c, a, b, !1)
                }, e.prototype.unshift = function(a) {
                    var b = this._readableState;
                    return f(this, b, a, "", !0)
                }, e.prototype.setEncoding = function(b) {
                    return C || (C = a("string_decoder/").StringDecoder), this._readableState.decoder = new C(b), this._readableState.encoding = b, this
                };
                var E = 8388608;
                e.prototype.read = function(a) {
                    D("read", a);
                    var b = this._readableState,
                        c = a;
                    if ((!B.isNumber(a) || a > 0) && (b.emittedReadable = !1), 0 === a && b.needReadable && (b.length >= b.highWaterMark || b.ended)) return D("read: emitReadable", b.length, b.ended), 0 === b.length && b.ended ? u(this) : l(this), null;
                    if (a = i(a, b), 0 === a && b.ended) return 0 === b.length && u(this), null;
                    var d = b.needReadable;
                    D("need readable", d), (0 === b.length || b.length - a < b.highWaterMark) && (d = !0, D("length less than watermark", d)), (b.ended || b.reading) && (d = !1, D("reading or ended", d)), d && (D("do read"), b.reading = !0, b.sync = !0, 0 === b.length && (b.needReadable = !0), this._read(b.highWaterMark), b.sync = !1), d && !b.reading && (a = i(c, b));
                    var e;
                    return e = a > 0 ? t(a, b) : null, B.isNull(e) && (b.needReadable = !0, a = 0), b.length -= a, 0 !== b.length || b.ended || (b.needReadable = !0), c !== a && b.ended && 0 === b.length && u(this), B.isNull(e) || this.emit("data", e), e
                }, e.prototype._read = function(a) {
                    this.emit("error", new Error("not implemented"))
                }, e.prototype.pipe = function(a, b) {
                    function d(a) {
                        D("onunpipe"), a === l && f()
                    }

                    function e() {
                        D("onend"), a.end()
                    }

                    function f() {
                        D("cleanup"), a.removeListener("close", i), a.removeListener("finish", j), a.removeListener("drain", q), a.removeListener("error", h), a.removeListener("unpipe", d), l.removeListener("end", e), l.removeListener("end", f), l.removeListener("data", g), !m.awaitDrain || a._writableState && !a._writableState.needDrain || q()
                    }

                    function g(b) {
                        D("ondata");
                        var c = a.write(b);
                        !1 === c && (D("false write response, pause", l._readableState.awaitDrain), l._readableState.awaitDrain++, l.pause())
                    }

                    function h(b) {
                        D("onerror", b), k(), a.removeListener("error", h), 0 === z.listenerCount(a, "error") && a.emit("error", b)
                    }

                    function i() {
                        a.removeListener("finish", j), k()
                    }

                    function j() {
                        D("onfinish"), a.removeListener("close", i), k()
                    }

                    function k() {
                        D("unpipe"), l.unpipe(a)
                    }
                    var l = this,
                        m = this._readableState;
                    switch (m.pipesCount) {
                        case 0:
                            m.pipes = a;
                            break;
                        case 1:
                            m.pipes = [m.pipes, a];
                            break;
                        default:
                            m.pipes.push(a)
                    }
                    m.pipesCount += 1, D("pipe count=%d opts=%j", m.pipesCount, b);
                    var n = (!b || b.end !== !1) && a !== c.stdout && a !== c.stderr,
                        o = n ? e : f;
                    m.endEmitted ? c.nextTick(o) : l.once("end", o), a.on("unpipe", d);
                    var q = p(l);
                    return a.on("drain", q), l.on("data", g), a._events && a._events.error ? x(a._events.error) ? a._events.error.unshift(h) : a._events.error = [h, a._events.error] : a.on("error", h), a.once("close", i), a.once("finish", j), a.emit("pipe", l), m.flowing || (D("pipe resume"), l.resume()), a
                }, e.prototype.unpipe = function(a) {
                    var b = this._readableState;
                    if (0 === b.pipesCount) return this;
                    if (1 === b.pipesCount) return a && a !== b.pipes ? this : (a || (a = b.pipes), b.pipes = null, b.pipesCount = 0, b.flowing = !1, a && a.emit("unpipe", this), this);
                    if (!a) {
                        var c = b.pipes,
                            d = b.pipesCount;
                        b.pipes = null, b.pipesCount = 0, b.flowing = !1;
                        for (var e = 0; d > e; e++) c[e].emit("unpipe", this);
                        return this
                    }
                    var e = w(b.pipes, a);
                    return -1 === e ? this : (b.pipes.splice(e, 1), b.pipesCount -= 1, 1 === b.pipesCount && (b.pipes = b.pipes[0]), a.emit("unpipe", this), this)
                }, e.prototype.on = function(a, b) {
                    var d = A.prototype.on.call(this, a, b);
                    if ("data" === a && !1 !== this._readableState.flowing && this.resume(), "readable" === a && this.readable) {
                        var e = this._readableState;
                        if (!e.readableListening)
                            if (e.readableListening = !0, e.emittedReadable = !1, e.needReadable = !0, e.reading) e.length && l(this, e);
                            else {
                                var f = this;
                                c.nextTick(function() {
                                    D("readable nexttick read 0"), f.read(0)
                                })
                            }
                    }
                    return d
                }, e.prototype.addListener = e.prototype.on, e.prototype.resume = function() {
                    var a = this._readableState;
                    return a.flowing || (D("resume"), a.flowing = !0, a.reading || (D("resume read 0"), this.read(0)), q(this, a)), this
                }, e.prototype.pause = function() {
                    return D("call pause flowing=%j", this._readableState.flowing), !1 !== this._readableState.flowing && (D("pause"), this._readableState.flowing = !1, this.emit("pause")), this
                }, e.prototype.wrap = function(a) {
                    var b = this._readableState,
                        c = !1,
                        d = this;
                    a.on("end", function() {
                        if (D("wrapped end"), b.decoder && !b.ended) {
                            var a = b.decoder.end();
                            a && a.length && d.push(a)
                        }
                        d.push(null)
                    }), a.on("data", function(e) {
                        if (D("wrapped data"), b.decoder && (e = b.decoder.write(e)), e && (b.objectMode || e.length)) {
                            var f = d.push(e);
                            f || (c = !0, a.pause())
                        }
                    });
                    for (var e in a) B.isFunction(a[e]) && B.isUndefined(this[e]) && (this[e] = function(b) {
                        return function() {
                            return a[b].apply(a, arguments)
                        }
                    }(e));
                    var f = ["error", "close", "destroy", "pause", "resume"];
                    return v(f, function(b) {
                        a.on(b, d.emit.bind(d, b))
                    }), d._read = function(b) {
                        D("wrapped _read", b), c && (c = !1, a.resume())
                    }, d
                }, e._fromList = t
            }).call(this, a("_process"))
        }, {
            "./_stream_duplex": 149,
            _process: 145,
            buffer: 23,
            "core-util-is": 25,
            events: 30,
            inherits: 32,
            isarray: 34,
            stream: 147,
            "string_decoder/": 158,
            util: 21
        }],
        152: [function(a, b, c) {
            function d(a, b) {
                this.afterTransform = function(a, c) {
                    return e(b, a, c)
                }, this.needTransform = !1, this.transforming = !1, this.writecb = null, this.writechunk = null
            }

            function e(a, b, c) {
                var d = a._transformState;
                d.transforming = !1;
                var e = d.writecb;
                if (!e) return a.emit("error", new Error("no writecb in Transform class"));
                d.writechunk = null, d.writecb = null, i.isNullOrUndefined(c) || a.push(c), e && e(b);
                var f = a._readableState;
                f.reading = !1, (f.needReadable || f.length < f.highWaterMark) && a._read(f.highWaterMark)
            }

            function f(a) {
                if (!(this instanceof f)) return new f(a);
                h.call(this, a), this._transformState = new d(a, this);
                var b = this;
                this._readableState.needReadable = !0, this._readableState.sync = !1, this.once("prefinish", function() {
                    i.isFunction(this._flush) ? this._flush(function(a) {
                        g(b, a)
                    }) : g(b)
                })
            }

            function g(a, b) {
                if (b) return a.emit("error", b);
                var c = a._writableState,
                    d = a._transformState;
                if (c.length) throw new Error("calling transform done when ws.length != 0");
                if (d.transforming) throw new Error("calling transform done when still transforming");
                return a.push(null)
            }
            b.exports = f;
            var h = a("./_stream_duplex"),
                i = a("core-util-is");
            i.inherits = a("inherits"), i.inherits(f, h), f.prototype.push = function(a, b) {
                return this._transformState.needTransform = !1, h.prototype.push.call(this, a, b);
            }, f.prototype._transform = function(a, b, c) {
                throw new Error("not implemented")
            }, f.prototype._write = function(a, b, c) {
                var d = this._transformState;
                if (d.writecb = c, d.writechunk = a, d.writeencoding = b, !d.transforming) {
                    var e = this._readableState;
                    (d.needTransform || e.needReadable || e.length < e.highWaterMark) && this._read(e.highWaterMark)
                }
            }, f.prototype._read = function(a) {
                var b = this._transformState;
                i.isNull(b.writechunk) || !b.writecb || b.transforming ? b.needTransform = !0 : (b.transforming = !0, this._transform(b.writechunk, b.writeencoding, b.afterTransform))
            }
        }, {
            "./_stream_duplex": 149,
            "core-util-is": 25,
            inherits: 32
        }],
        153: [function(a, b, c) {
            (function(c) {
                function d(a, b, c) {
                    this.chunk = a, this.encoding = b, this.callback = c
                }

                function e(b, c) {
                    var d = a("./_stream_duplex");
                    b = b || {};
                    var e = b.highWaterMark,
                        f = b.objectMode ? 16 : 16384;
                    this.highWaterMark = e || 0 === e ? e : f, this.objectMode = !!b.objectMode, c instanceof d && (this.objectMode = this.objectMode || !!b.writableObjectMode), this.highWaterMark = ~~this.highWaterMark, this.needDrain = !1, this.ending = !1, this.ended = !1, this.finished = !1;
                    var g = b.decodeStrings === !1;
                    this.decodeStrings = !g, this.defaultEncoding = b.defaultEncoding || "utf8", this.length = 0, this.writing = !1, this.corked = 0, this.sync = !0, this.bufferProcessing = !1, this.onwrite = function(a) {
                        n(c, a)
                    }, this.writecb = null, this.writelen = 0, this.buffer = [], this.pendingcb = 0, this.prefinished = !1, this.errorEmitted = !1
                }

                function f(b) {
                    var c = a("./_stream_duplex");
                    return this instanceof f || this instanceof c ? (this._writableState = new e(b, this), this.writable = !0, void x.call(this)) : new f(b)
                }

                function g(a, b, d) {
                    var e = new Error("write after end");
                    a.emit("error", e), c.nextTick(function() {
                        d(e)
                    })
                }

                function h(a, b, d, e) {
                    var f = !0;
                    if (!(w.isBuffer(d) || w.isString(d) || w.isNullOrUndefined(d) || b.objectMode)) {
                        var g = new TypeError("Invalid non-string/buffer chunk");
                        a.emit("error", g), c.nextTick(function() {
                            e(g)
                        }), f = !1
                    }
                    return f
                }

                function i(a, b, c) {
                    return !a.objectMode && a.decodeStrings !== !1 && w.isString(b) && (b = new v(b, c)), b
                }

                function j(a, b, c, e, f) {
                    c = i(b, c, e), w.isBuffer(c) && (e = "buffer");
                    var g = b.objectMode ? 1 : c.length;
                    b.length += g;
                    var h = b.length < b.highWaterMark;
                    return h || (b.needDrain = !0), b.writing || b.corked ? b.buffer.push(new d(c, e, f)) : k(a, b, !1, g, c, e, f), h
                }

                function k(a, b, c, d, e, f, g) {
                    b.writelen = d, b.writecb = g, b.writing = !0, b.sync = !0, c ? a._writev(e, b.onwrite) : a._write(e, f, b.onwrite), b.sync = !1
                }

                function l(a, b, d, e, f) {
                    d ? c.nextTick(function() {
                        b.pendingcb--, f(e)
                    }) : (b.pendingcb--, f(e)), a._writableState.errorEmitted = !0, a.emit("error", e)
                }

                function m(a) {
                    a.writing = !1, a.writecb = null, a.length -= a.writelen, a.writelen = 0
                }

                function n(a, b) {
                    var d = a._writableState,
                        e = d.sync,
                        f = d.writecb;
                    if (m(d), b) l(a, d, e, b, f);
                    else {
                        var g = r(a, d);
                        g || d.corked || d.bufferProcessing || !d.buffer.length || q(a, d), e ? c.nextTick(function() {
                            o(a, d, g, f)
                        }) : o(a, d, g, f)
                    }
                }

                function o(a, b, c, d) {
                    c || p(a, b), b.pendingcb--, d(), t(a, b)
                }

                function p(a, b) {
                    0 === b.length && b.needDrain && (b.needDrain = !1, a.emit("drain"))
                }

                function q(a, b) {
                    if (b.bufferProcessing = !0, a._writev && b.buffer.length > 1) {
                        for (var c = [], d = 0; d < b.buffer.length; d++) c.push(b.buffer[d].callback);
                        b.pendingcb++, k(a, b, !0, b.length, b.buffer, "", function(a) {
                            for (var d = 0; d < c.length; d++) b.pendingcb--, c[d](a)
                        }), b.buffer = []
                    } else {
                        for (var d = 0; d < b.buffer.length; d++) {
                            var e = b.buffer[d],
                                f = e.chunk,
                                g = e.encoding,
                                h = e.callback,
                                i = b.objectMode ? 1 : f.length;
                            if (k(a, b, !1, i, f, g, h), b.writing) {
                                d++;
                                break
                            }
                        }
                        d < b.buffer.length ? b.buffer = b.buffer.slice(d) : b.buffer.length = 0
                    }
                    b.bufferProcessing = !1
                }

                function r(a, b) {
                    return b.ending && 0 === b.length && !b.finished && !b.writing
                }

                function s(a, b) {
                    b.prefinished || (b.prefinished = !0, a.emit("prefinish"))
                }

                function t(a, b) {
                    var c = r(a, b);
                    return c && (0 === b.pendingcb ? (s(a, b), b.finished = !0, a.emit("finish")) : s(a, b)), c
                }

                function u(a, b, d) {
                    b.ending = !0, t(a, b), d && (b.finished ? c.nextTick(d) : a.once("finish", d)), b.ended = !0
                }
                b.exports = f;
                var v = a("buffer").Buffer;
                f.WritableState = e;
                var w = a("core-util-is");
                w.inherits = a("inherits");
                var x = a("stream");
                w.inherits(f, x), f.prototype.pipe = function() {
                    this.emit("error", new Error("Cannot pipe. Not readable."))
                }, f.prototype.write = function(a, b, c) {
                    var d = this._writableState,
                        e = !1;
                    return w.isFunction(b) && (c = b, b = null), w.isBuffer(a) ? b = "buffer" : b || (b = d.defaultEncoding), w.isFunction(c) || (c = function() {}), d.ended ? g(this, d, c) : h(this, d, a, c) && (d.pendingcb++, e = j(this, d, a, b, c)), e
                }, f.prototype.cork = function() {
                    var a = this._writableState;
                    a.corked++
                }, f.prototype.uncork = function() {
                    var a = this._writableState;
                    a.corked && (a.corked--, a.writing || a.corked || a.finished || a.bufferProcessing || !a.buffer.length || q(this, a))
                }, f.prototype._write = function(a, b, c) {
                    c(new Error("not implemented"))
                }, f.prototype._writev = null, f.prototype.end = function(a, b, c) {
                    var d = this._writableState;
                    w.isFunction(a) ? (c = a, a = null, b = null) : w.isFunction(b) && (c = b, b = null), w.isNullOrUndefined(a) || this.write(a, b), d.corked && (d.corked = 1, this.uncork()), d.ending || d.finished || u(this, d, c)
                }
            }).call(this, a("_process"))
        }, {
            "./_stream_duplex": 149,
            _process: 145,
            buffer: 23,
            "core-util-is": 25,
            inherits: 32,
            stream: 147
        }],
        154: [function(a, b, c) {
            b.exports = a("./lib/_stream_passthrough.js")
        }, {
            "./lib/_stream_passthrough.js": 150
        }],
        155: [function(a, b, c) {
            c = b.exports = a("./lib/_stream_readable.js"), c.Stream = a("stream"), c.Readable = c, c.Writable = a("./lib/_stream_writable.js"), c.Duplex = a("./lib/_stream_duplex.js"), c.Transform = a("./lib/_stream_transform.js"), c.PassThrough = a("./lib/_stream_passthrough.js")
        }, {
            "./lib/_stream_duplex.js": 149,
            "./lib/_stream_passthrough.js": 150,
            "./lib/_stream_readable.js": 151,
            "./lib/_stream_transform.js": 152,
            "./lib/_stream_writable.js": 153,
            stream: 147
        }],
        156: [function(a, b, c) {
            b.exports = a("./lib/_stream_transform.js")
        }, {
            "./lib/_stream_transform.js": 152
        }],
        157: [function(a, b, c) {
            b.exports = a("./lib/_stream_writable.js")
        }, {
            "./lib/_stream_writable.js": 153
        }],
        158: [function(a, b, c) {
            function d(a) {
                if (a && !i(a)) throw new Error("Unknown encoding: " + a)
            }

            function e(a) {
                return a.toString(this.encoding)
            }

            function f(a) {
                this.charReceived = a.length % 2, this.charLength = this.charReceived ? 2 : 0
            }

            function g(a) {
                this.charReceived = a.length % 3, this.charLength = this.charReceived ? 3 : 0
            }
            var h = a("buffer").Buffer,
                i = h.isEncoding || function(a) {
                    switch (a && a.toLowerCase()) {
                        case "hex":
                        case "utf8":
                        case "utf-8":
                        case "ascii":
                        case "binary":
                        case "base64":
                        case "ucs2":
                        case "ucs-2":
                        case "utf16le":
                        case "utf-16le":
                        case "raw":
                            return !0;
                        default:
                            return !1
                    }
                },
                j = c.StringDecoder = function(a) {
                    switch (this.encoding = (a || "utf8").toLowerCase().replace(/[-_]/, ""), d(a), this.encoding) {
                        case "utf8":
                            this.surrogateSize = 3;
                            break;
                        case "ucs2":
                        case "utf16le":
                            this.surrogateSize = 2, this.detectIncompleteChar = f;
                            break;
                        case "base64":
                            this.surrogateSize = 3, this.detectIncompleteChar = g;
                            break;
                        default:
                            return void(this.write = e)
                    }
                    this.charBuffer = new h(6), this.charReceived = 0, this.charLength = 0
                };
            j.prototype.write = function(a) {
                for (var b = ""; this.charLength;) {
                    var c = a.length >= this.charLength - this.charReceived ? this.charLength - this.charReceived : a.length;
                    if (a.copy(this.charBuffer, this.charReceived, 0, c), this.charReceived += c, this.charReceived < this.charLength) return "";
                    a = a.slice(c, a.length), b = this.charBuffer.slice(0, this.charLength).toString(this.encoding);
                    var d = b.charCodeAt(b.length - 1);
                    if (!(d >= 55296 && 56319 >= d)) {
                        if (this.charReceived = this.charLength = 0, 0 === a.length) return b;
                        break
                    }
                    this.charLength += this.surrogateSize, b = ""
                }
                this.detectIncompleteChar(a);
                var e = a.length;
                this.charLength && (a.copy(this.charBuffer, 0, a.length - this.charReceived, e), e -= this.charReceived), b += a.toString(this.encoding, 0, e);
                var e = b.length - 1,
                    d = b.charCodeAt(e);
                if (d >= 55296 && 56319 >= d) {
                    var f = this.surrogateSize;
                    return this.charLength += f, this.charReceived += f, this.charBuffer.copy(this.charBuffer, f, 0, f), a.copy(this.charBuffer, 0, 0, f), b.substring(0, e)
                }
                return b
            }, j.prototype.detectIncompleteChar = function(a) {
                for (var b = a.length >= 3 ? 3 : a.length; b > 0; b--) {
                    var c = a[a.length - b];
                    if (1 == b && c >> 5 == 6) {
                        this.charLength = 2;
                        break
                    }
                    if (2 >= b && c >> 4 == 14) {
                        this.charLength = 3;
                        break
                    }
                    if (3 >= b && c >> 3 == 30) {
                        this.charLength = 4;
                        break
                    }
                }
                this.charReceived = b
            }, j.prototype.end = function(a) {
                var b = "";
                if (a && a.length && (b = this.write(a)), this.charReceived) {
                    var c = this.charReceived,
                        d = this.charBuffer,
                        e = this.encoding;
                    b += d.slice(0, c).toString(e)
                }
                return b
            }
        }, {
            buffer: 23
        }],
        159: [function(b, c, d) {
            ! function(c) {
                if (function(b, c) {
                        "function" == typeof a && a.amd ? a("strophe-base64", function() {
                            return c()
                        }) : b.Base64 = c()
                    }(this, function() {
                        var a = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
                            b = {
                                encode: function(b) {
                                    var c, d, e, f, g, h, i, j = "",
                                        k = 0;
                                    do c = b.charCodeAt(k++), d = b.charCodeAt(k++), e = b.charCodeAt(k++), f = c >> 2, g = (3 & c) << 4 | d >> 4, h = (15 & d) << 2 | e >> 6, i = 63 & e, isNaN(d) ? (g = (3 & c) << 4, h = i = 64) : isNaN(e) && (i = 64), j = j + a.charAt(f) + a.charAt(g) + a.charAt(h) + a.charAt(i); while (k < b.length);
                                    return j
                                },
                                decode: function(b) {
                                    var c, d, e, f, g, h, i, j = "",
                                        k = 0;
                                    b = b.replace(/[^A-Za-z0-9\+\/\=]/g, "");
                                    do f = a.indexOf(b.charAt(k++)), g = a.indexOf(b.charAt(k++)), h = a.indexOf(b.charAt(k++)), i = a.indexOf(b.charAt(k++)), c = f << 2 | g >> 4, d = (15 & g) << 4 | h >> 2, e = (3 & h) << 6 | i, j += String.fromCharCode(c), 64 != h && (j += String.fromCharCode(d)), 64 != i && (j += String.fromCharCode(e)); while (k < b.length);
                                    return j
                                }
                            };
                        return b
                    }), function(b, c) {
                        "function" == typeof a && a.amd ? a("strophe-sha1", function() {
                            return c()
                        }) : b.SHA1 = c()
                    }(this, function() {
                        function a(a, d) {
                            a[d >> 5] |= 128 << 24 - d % 32, a[(d + 64 >> 9 << 4) + 15] = d;
                            var g, h, i, j, k, l, m, n, o = new Array(80),
                                p = 1732584193,
                                q = -271733879,
                                r = -1732584194,
                                s = 271733878,
                                t = -1009589776;
                            for (g = 0; g < a.length; g += 16) {
                                for (j = p, k = q, l = r, m = s, n = t, h = 0; 80 > h; h++) 16 > h ? o[h] = a[g + h] : o[h] = f(o[h - 3] ^ o[h - 8] ^ o[h - 14] ^ o[h - 16], 1), i = e(e(f(p, 5), b(h, q, r, s)), e(e(t, o[h]), c(h))), t = s, s = r, r = f(q, 30), q = p, p = i;
                                p = e(p, j), q = e(q, k), r = e(r, l), s = e(s, m), t = e(t, n)
                            }
                            return [p, q, r, s, t]
                        }

                        function b(a, b, c, d) {
                            return 20 > a ? b & c | ~b & d : 40 > a ? b ^ c ^ d : 60 > a ? b & c | b & d | c & d : b ^ c ^ d
                        }

                        function c(a) {
                            return 20 > a ? 1518500249 : 40 > a ? 1859775393 : 60 > a ? -1894007588 : -899497514
                        }

                        function d(b, c) {
                            var d = g(b);
                            d.length > 16 && (d = a(d, 8 * b.length));
                            for (var e = new Array(16), f = new Array(16), h = 0; 16 > h; h++) e[h] = 909522486 ^ d[h], f[h] = 1549556828 ^ d[h];
                            var i = a(e.concat(g(c)), 512 + 8 * c.length);
                            return a(f.concat(i), 672)
                        }

                        function e(a, b) {
                            var c = (65535 & a) + (65535 & b),
                                d = (a >> 16) + (b >> 16) + (c >> 16);
                            return d << 16 | 65535 & c
                        }

                        function f(a, b) {
                            return a << b | a >>> 32 - b
                        }

                        function g(a) {
                            for (var b = [], c = 255, d = 0; d < 8 * a.length; d += 8) b[d >> 5] |= (a.charCodeAt(d / 8) & c) << 24 - d % 32;
                            return b
                        }

                        function h(a) {
                            for (var b = "", c = 255, d = 0; d < 32 * a.length; d += 8) b += String.fromCharCode(a[d >> 5] >>> 24 - d % 32 & c);
                            return b
                        }

                        function i(a) {
                            for (var b, c, d = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", e = "", f = 0; f < 4 * a.length; f += 3)
                                for (b = (a[f >> 2] >> 8 * (3 - f % 4) & 255) << 16 | (a[f + 1 >> 2] >> 8 * (3 - (f + 1) % 4) & 255) << 8 | a[f + 2 >> 2] >> 8 * (3 - (f + 2) % 4) & 255, c = 0; 4 > c; c++) e += 8 * f + 6 * c > 32 * a.length ? "=" : d.charAt(b >> 6 * (3 - c) & 63);
                            return e
                        }
                        return {
                            b64_hmac_sha1: function(a, b) {
                                return i(d(a, b))
                            },
                            b64_sha1: function(b) {
                                return i(a(g(b), 8 * b.length))
                            },
                            binb2str: h,
                            core_hmac_sha1: d,
                            str_hmac_sha1: function(a, b) {
                                return h(d(a, b))
                            },
                            str_sha1: function(b) {
                                return h(a(g(b), 8 * b.length))
                            }
                        }
                    }), function(b, c) {
                        "function" == typeof a && a.amd ? a("strophe-md5", function() {
                            return c()
                        }) : b.MD5 = c()
                    }(this, function(a) {
                        var b = function(a, b) {
                                var c = (65535 & a) + (65535 & b),
                                    d = (a >> 16) + (b >> 16) + (c >> 16);
                                return d << 16 | 65535 & c
                            },
                            c = function(a, b) {
                                return a << b | a >>> 32 - b
                            },
                            d = function(a) {
                                for (var b = [], c = 0; c < 8 * a.length; c += 8) b[c >> 5] |= (255 & a.charCodeAt(c / 8)) << c % 32;
                                return b
                            },
                            e = function(a) {
                                for (var b = "", c = 0; c < 32 * a.length; c += 8) b += String.fromCharCode(a[c >> 5] >>> c % 32 & 255);
                                return b
                            },
                            f = function(a) {
                                for (var b = "0123456789abcdef", c = "", d = 0; d < 4 * a.length; d++) c += b.charAt(a[d >> 2] >> d % 4 * 8 + 4 & 15) + b.charAt(a[d >> 2] >> d % 4 * 8 & 15);
                                return c
                            },
                            g = function(a, d, e, f, g, h) {
                                return b(c(b(b(d, a), b(f, h)), g), e)
                            },
                            h = function(a, b, c, d, e, f, h) {
                                return g(b & c | ~b & d, a, b, e, f, h)
                            },
                            i = function(a, b, c, d, e, f, h) {
                                return g(b & d | c & ~d, a, b, e, f, h)
                            },
                            j = function(a, b, c, d, e, f, h) {
                                return g(b ^ c ^ d, a, b, e, f, h)
                            },
                            k = function(a, b, c, d, e, f, h) {
                                return g(c ^ (b | ~d), a, b, e, f, h)
                            },
                            l = function(a, c) {
                                a[c >> 5] |= 128 << c % 32, a[(c + 64 >>> 9 << 4) + 14] = c;
                                for (var d, e, f, g, l = 1732584193, m = -271733879, n = -1732584194, o = 271733878, p = 0; p < a.length; p += 16) d = l, e = m, f = n, g = o, l = h(l, m, n, o, a[p + 0], 7, -680876936), o = h(o, l, m, n, a[p + 1], 12, -389564586), n = h(n, o, l, m, a[p + 2], 17, 606105819), m = h(m, n, o, l, a[p + 3], 22, -1044525330), l = h(l, m, n, o, a[p + 4], 7, -176418897), o = h(o, l, m, n, a[p + 5], 12, 1200080426), n = h(n, o, l, m, a[p + 6], 17, -1473231341), m = h(m, n, o, l, a[p + 7], 22, -45705983), l = h(l, m, n, o, a[p + 8], 7, 1770035416), o = h(o, l, m, n, a[p + 9], 12, -1958414417), n = h(n, o, l, m, a[p + 10], 17, -42063), m = h(m, n, o, l, a[p + 11], 22, -1990404162), l = h(l, m, n, o, a[p + 12], 7, 1804603682), o = h(o, l, m, n, a[p + 13], 12, -40341101), n = h(n, o, l, m, a[p + 14], 17, -1502002290), m = h(m, n, o, l, a[p + 15], 22, 1236535329), l = i(l, m, n, o, a[p + 1], 5, -165796510), o = i(o, l, m, n, a[p + 6], 9, -1069501632), n = i(n, o, l, m, a[p + 11], 14, 643717713), m = i(m, n, o, l, a[p + 0], 20, -373897302), l = i(l, m, n, o, a[p + 5], 5, -701558691), o = i(o, l, m, n, a[p + 10], 9, 38016083), n = i(n, o, l, m, a[p + 15], 14, -660478335), m = i(m, n, o, l, a[p + 4], 20, -405537848), l = i(l, m, n, o, a[p + 9], 5, 568446438), o = i(o, l, m, n, a[p + 14], 9, -1019803690), n = i(n, o, l, m, a[p + 3], 14, -187363961), m = i(m, n, o, l, a[p + 8], 20, 1163531501), l = i(l, m, n, o, a[p + 13], 5, -1444681467), o = i(o, l, m, n, a[p + 2], 9, -51403784), n = i(n, o, l, m, a[p + 7], 14, 1735328473), m = i(m, n, o, l, a[p + 12], 20, -1926607734), l = j(l, m, n, o, a[p + 5], 4, -378558), o = j(o, l, m, n, a[p + 8], 11, -2022574463), n = j(n, o, l, m, a[p + 11], 16, 1839030562), m = j(m, n, o, l, a[p + 14], 23, -35309556), l = j(l, m, n, o, a[p + 1], 4, -1530992060), o = j(o, l, m, n, a[p + 4], 11, 1272893353), n = j(n, o, l, m, a[p + 7], 16, -155497632), m = j(m, n, o, l, a[p + 10], 23, -1094730640), l = j(l, m, n, o, a[p + 13], 4, 681279174), o = j(o, l, m, n, a[p + 0], 11, -358537222), n = j(n, o, l, m, a[p + 3], 16, -722521979), m = j(m, n, o, l, a[p + 6], 23, 76029189), l = j(l, m, n, o, a[p + 9], 4, -640364487), o = j(o, l, m, n, a[p + 12], 11, -421815835), n = j(n, o, l, m, a[p + 15], 16, 530742520), m = j(m, n, o, l, a[p + 2], 23, -995338651), l = k(l, m, n, o, a[p + 0], 6, -198630844), o = k(o, l, m, n, a[p + 7], 10, 1126891415), n = k(n, o, l, m, a[p + 14], 15, -1416354905), m = k(m, n, o, l, a[p + 5], 21, -57434055), l = k(l, m, n, o, a[p + 12], 6, 1700485571), o = k(o, l, m, n, a[p + 3], 10, -1894986606), n = k(n, o, l, m, a[p + 10], 15, -1051523), m = k(m, n, o, l, a[p + 1], 21, -2054922799), l = k(l, m, n, o, a[p + 8], 6, 1873313359), o = k(o, l, m, n, a[p + 15], 10, -30611744), n = k(n, o, l, m, a[p + 6], 15, -1560198380), m = k(m, n, o, l, a[p + 13], 21, 1309151649), l = k(l, m, n, o, a[p + 4], 6, -145523070), o = k(o, l, m, n, a[p + 11], 10, -1120210379), n = k(n, o, l, m, a[p + 2], 15, 718787259), m = k(m, n, o, l, a[p + 9], 21, -343485551), l = b(l, d), m = b(m, e), n = b(n, f), o = b(o, g);
                                return [l, m, n, o]
                            },
                            m = {
                                hexdigest: function(a) {
                                    return f(l(d(a), 8 * a.length))
                                },
                                hash: function(a) {
                                    return e(l(d(a), 8 * a.length))
                                }
                            };
                        return m
                    }), function(b, c) {
                        "function" == typeof a && a.amd ? a("strophe-utils", function() {
                            return c()
                        }) : b.stropheUtils = c()
                    }(this, function() {
                        var a = {
                            utf16to8: function(a) {
                                var b, c, d = "",
                                    e = a.length;
                                for (b = 0; e > b; b++) c = a.charCodeAt(b), c >= 0 && 127 >= c ? d += a.charAt(b) : c > 2047 ? (d += String.fromCharCode(224 | c >> 12 & 15), d += String.fromCharCode(128 | c >> 6 & 63), d += String.fromCharCode(128 | c >> 0 & 63)) : (d += String.fromCharCode(192 | c >> 6 & 31), d += String.fromCharCode(128 | c >> 0 & 63));
                                return d
                            }
                        };
                        return a
                    }), function(b, c) {
                        return "function" == typeof a && a.amd ? void a("strophe-polyfill", [], function() {
                            return c()
                        }) : c()
                    }(this, function() {
                        Function.prototype.bind || (Function.prototype.bind = function(a) {
                            var b = this,
                                c = Array.prototype.slice,
                                d = Array.prototype.concat,
                                e = c.call(arguments, 1);
                            return function() {
                                return b.apply(a ? a : this, d.call(e, c.call(arguments, 0)))
                            }
                        }), Array.isArray || (Array.isArray = function(a) {
                            return "[object Array]" === Object.prototype.toString.call(a)
                        }), Array.prototype.indexOf || (Array.prototype.indexOf = function(a) {
                            var b = this.length,
                                c = Number(arguments[1]) || 0;
                            for (c = 0 > c ? Math.ceil(c) : Math.floor(c), 0 > c && (c += b); b > c; c++)
                                if (c in this && this[c] === a) return c;
                            return -1
                        })
                    }), function(b, c) {
                        if ("function" == typeof a && a.amd) a("strophe-core", ["strophe-sha1", "strophe-base64", "strophe-md5", "strophe-utils", "strophe-polyfill"], function() {
                            return c.apply(this, arguments)
                        });
                        else {
                            var d = c(b.SHA1, b.Base64, b.MD5, b.stropheUtils);
                            window.Strophe = d.Strophe, window.$build = d.$build, window.$iq = d.$iq, window.$msg = d.$msg, window.$pres = d.$pres, window.SHA1 = d.SHA1, window.Base64 = d.Base64, window.MD5 = d.MD5, window.b64_hmac_sha1 = d.SHA1.b64_hmac_sha1, window.b64_sha1 = d.SHA1.b64_sha1, window.str_hmac_sha1 = d.SHA1.str_hmac_sha1, window.str_sha1 = d.SHA1.str_sha1
                        }
                    }(this, function(a, b, c, d) {
                        function e(a, b) {
                            return new i.Builder(a, b)
                        }

                        function f(a) {
                            return new i.Builder("message", a)
                        }

                        function g(a) {
                            return new i.Builder("iq", a)
                        }

                        function h(a) {
                            return new i.Builder("presence", a)
                        }
                        var i;
                        return i = {
                            VERSION: "1.2.4",
                            NS: {
                                HTTPBIND: "http://jabber.org/protocol/httpbind",
                                BOSH: "urn:xmpp:xbosh",
                                CLIENT: "jabber:client",
                                AUTH: "jabber:iq:auth",
                                ROSTER: "jabber:iq:roster",
                                PROFILE: "jabber:iq:profile",
                                DISCO_INFO: "http://jabber.org/protocol/disco#info",
                                DISCO_ITEMS: "http://jabber.org/protocol/disco#items",
                                MUC: "http://jabber.org/protocol/muc",
                                SASL: "urn:ietf:params:xml:ns:xmpp-sasl",
                                STREAM: "http://etherx.jabber.org/streams",
                                FRAMING: "urn:ietf:params:xml:ns:xmpp-framing",
                                BIND: "urn:ietf:params:xml:ns:xmpp-bind",
                                SESSION: "urn:ietf:params:xml:ns:xmpp-session",
                                VERSION: "jabber:iq:version",
                                STANZAS: "urn:ietf:params:xml:ns:xmpp-stanzas",
                                XHTML_IM: "http://jabber.org/protocol/xhtml-im",
                                XHTML: "http://www.w3.org/1999/xhtml"
                            },
                            XHTML: {
                                tags: ["a", "blockquote", "br", "cite", "em", "img", "li", "ol", "p", "span", "strong", "ul", "body"],
                                attributes: {
                                    a: ["href"],
                                    blockquote: ["style"],
                                    br: [],
                                    cite: ["style"],
                                    em: [],
                                    img: ["src", "alt", "style", "height", "width"],
                                    li: ["style"],
                                    ol: ["style"],
                                    p: ["style"],
                                    span: ["style"],
                                    strong: [],
                                    ul: ["style"],
                                    body: []
                                },
                                css: ["background-color", "color", "font-family", "font-size", "font-style", "font-weight", "margin-left", "margin-right", "text-align", "text-decoration"],
                                validTag: function(a) {
                                    for (var b = 0; b < i.XHTML.tags.length; b++)
                                        if (a == i.XHTML.tags[b]) return !0;
                                    return !1
                                },
                                validAttribute: function(a, b) {
                                    if ("undefined" != typeof i.XHTML.attributes[a] && i.XHTML.attributes[a].length > 0)
                                        for (var c = 0; c < i.XHTML.attributes[a].length; c++)
                                            if (b == i.XHTML.attributes[a][c]) return !0;
                                    return !1
                                },
                                validCSS: function(a) {
                                    for (var b = 0; b < i.XHTML.css.length; b++)
                                        if (a == i.XHTML.css[b]) return !0;
                                    return !1
                                }
                            },
                            Status: {
                                ERROR: 0,
                                CONNECTING: 1,
                                CONNFAIL: 2,
                                AUTHENTICATING: 3,
                                AUTHFAIL: 4,
                                CONNECTED: 5,
                                DISCONNECTED: 6,
                                DISCONNECTING: 7,
                                ATTACHED: 8,
                                REDIRECT: 9
                            },
                            LogLevel: {
                                DEBUG: 0,
                                INFO: 1,
                                WARN: 2,
                                ERROR: 3,
                                FATAL: 4
                            },
                            ElementType: {
                                NORMAL: 1,
                                TEXT: 3,
                                CDATA: 4,
                                FRAGMENT: 11
                            },
                            TIMEOUT: 1.1,
                            SECONDARY_TIMEOUT: .1,
                            addNamespace: function(a, b) {
                                i.NS[a] = b
                            },
                            forEachChild: function(a, b, c) {
                                var d, e;
                                for (d = 0; d < a.childNodes.length; d++) e = a.childNodes[d], e.nodeType != i.ElementType.NORMAL || b && !this.isTagEqual(e, b) || c(e)
                            },
                            isTagEqual: function(a, b) {
                                return a.tagName == b
                            },
                            _xmlGenerator: null,
                            _makeGenerator: function() {
                                var a;
                                return void 0 === document.implementation.createDocument || document.implementation.createDocument && document.documentMode && document.documentMode < 10 ? (a = this._getIEXmlDom(), a.appendChild(a.createElement("strophe"))) : a = document.implementation.createDocument("jabber:client", "strophe", null), a
                            },
                            xmlGenerator: function() {
                                return i._xmlGenerator || (i._xmlGenerator = i._makeGenerator()), i._xmlGenerator
                            },
                            _getIEXmlDom: function() {
                                for (var a = null, b = ["Msxml2.DOMDocument.6.0", "Msxml2.DOMDocument.5.0", "Msxml2.DOMDocument.4.0", "MSXML2.DOMDocument.3.0", "MSXML2.DOMDocument", "MSXML.DOMDocument", "Microsoft.XMLDOM"], c = 0; c < b.length && null === a; c++) try {
                                    a = new ActiveXObject(b[c])
                                } catch (d) {
                                    a = null
                                }
                                return a
                            },
                            xmlElement: function(a) {
                                if (!a) return null;
                                var b, c, d, e = i.xmlGenerator().createElement(a);
                                for (b = 1; b < arguments.length; b++) {
                                    var f = arguments[b];
                                    if (f)
                                        if ("string" == typeof f || "number" == typeof f) e.appendChild(i.xmlTextNode(f));
                                        else if ("object" == typeof f && "function" == typeof f.sort)
                                        for (c = 0; c < f.length; c++) {
                                            var g = f[c];
                                            "object" == typeof g && "function" == typeof g.sort && void 0 !== g[1] && null !== g[1] && e.setAttribute(g[0], g[1])
                                        } else if ("object" == typeof f)
                                            for (d in f) f.hasOwnProperty(d) && void 0 !== f[d] && null !== f[d] && e.setAttribute(d, f[d])
                                }
                                return e
                            },
                            xmlescape: function(a) {
                                return a = a.replace(/\&/g, "&amp;"), a = a.replace(/</g, "&lt;"), a = a.replace(/>/g, "&gt;"), a = a.replace(/'/g, "&apos;"), a = a.replace(/"/g, "&quot;")
                            },
                            xmlunescape: function(a) {
                                return a = a.replace(/\&amp;/g, "&"), a = a.replace(/&lt;/g, "<"), a = a.replace(/&gt;/g, ">"), a = a.replace(/&apos;/g, "'"), a = a.replace(/&quot;/g, '"')
                            },
                            xmlTextNode: function(a) {
                                return i.xmlGenerator().createTextNode(a)
                            },
                            xmlHtmlNode: function(a) {
                                var b;
                                if (window.DOMParser) {
                                    var c = new DOMParser;
                                    b = c.parseFromString(a, "text/xml")
                                } else b = new ActiveXObject("Microsoft.XMLDOM"), b.async = "false", b.loadXML(a);
                                return b
                            },
                            getText: function(a) {
                                if (!a) return null;
                                var b = "";
                                0 === a.childNodes.length && a.nodeType == i.ElementType.TEXT && (b += a.nodeValue);
                                for (var c = 0; c < a.childNodes.length; c++) a.childNodes[c].nodeType == i.ElementType.TEXT && (b += a.childNodes[c].nodeValue);
                                return i.xmlescape(b)
                            },
                            copyElement: function(a) {
                                var b, c;
                                if (a.nodeType == i.ElementType.NORMAL) {
                                    for (c = i.xmlElement(a.tagName), b = 0; b < a.attributes.length; b++) c.setAttribute(a.attributes[b].nodeName, a.attributes[b].value);
                                    for (b = 0; b < a.childNodes.length; b++) c.appendChild(i.copyElement(a.childNodes[b]))
                                } else a.nodeType == i.ElementType.TEXT && (c = i.xmlGenerator().createTextNode(a.nodeValue));
                                return c
                            },
                            createHtml: function(a) {
                                var b, c, d, e, f, g, h, j, k, l, m;
                                if (a.nodeType == i.ElementType.NORMAL)
                                    if (e = a.nodeName.toLowerCase(), i.XHTML.validTag(e)) try {
                                        for (c = i.xmlElement(e), b = 0; b < i.XHTML.attributes[e].length; b++)
                                            if (f = i.XHTML.attributes[e][b], g = a.getAttribute(f), "undefined" != typeof g && null !== g && "" !== g && g !== !1 && 0 !== g)
                                                if ("style" == f && "object" == typeof g && "undefined" != typeof g.cssText && (g = g.cssText), "style" == f) {
                                                    for (h = [], j = g.split(";"), d = 0; d < j.length; d++) k = j[d].split(":"), l = k[0].replace(/^\s*/, "").replace(/\s*$/, "").toLowerCase(), i.XHTML.validCSS(l) && (m = k[1].replace(/^\s*/, "").replace(/\s*$/, ""), h.push(l + ": " + m));
                                                    h.length > 0 && (g = h.join("; "), c.setAttribute(f, g))
                                                } else c.setAttribute(f, g);
                                        for (b = 0; b < a.childNodes.length; b++) c.appendChild(i.createHtml(a.childNodes[b]))
                                    } catch (n) {
                                        c = i.xmlTextNode("")
                                    } else
                                        for (c = i.xmlGenerator().createDocumentFragment(), b = 0; b < a.childNodes.length; b++) c.appendChild(i.createHtml(a.childNodes[b]));
                                    else if (a.nodeType == i.ElementType.FRAGMENT)
                                    for (c = i.xmlGenerator().createDocumentFragment(), b = 0; b < a.childNodes.length; b++) c.appendChild(i.createHtml(a.childNodes[b]));
                                else a.nodeType == i.ElementType.TEXT && (c = i.xmlTextNode(a.nodeValue));
                                return c
                            },
                            escapeNode: function(a) {
                                return "string" != typeof a ? a : a.replace(/^\s+|\s+$/g, "").replace(/\\/g, "\\5c").replace(/ /g, "\\20").replace(/\"/g, "\\22").replace(/\&/g, "\\26").replace(/\'/g, "\\27").replace(/\//g, "\\2f").replace(/:/g, "\\3a").replace(/</g, "\\3c").replace(/>/g, "\\3e").replace(/@/g, "\\40")
                            },
                            unescapeNode: function(a) {
                                return "string" != typeof a ? a : a.replace(/\\20/g, " ").replace(/\\22/g, '"').replace(/\\26/g, "&").replace(/\\27/g, "'").replace(/\\2f/g, "/").replace(/\\3a/g, ":").replace(/\\3c/g, "<").replace(/\\3e/g, ">").replace(/\\40/g, "@").replace(/\\5c/g, "\\")
                            },
                            getNodeFromJid: function(a) {
                                return a.indexOf("@") < 0 ? null : a.split("@")[0]
                            },
                            getDomainFromJid: function(a) {
                                var b = i.getBareJidFromJid(a);
                                if (b.indexOf("@") < 0) return b;
                                var c = b.split("@");
                                return c.splice(0, 1), c.join("@")
                            },
                            getResourceFromJid: function(a) {
                                var b = a.split("/");
                                return b.length < 2 ? null : (b.splice(0, 1), b.join("/"))
                            },
                            getBareJidFromJid: function(a) {
                                return a ? a.split("/")[0] : null
                            },
                            log: function(a, b) {},
                            debug: function(a) {
                                this.log(this.LogLevel.DEBUG, a)
                            },
                            info: function(a) {
                                this.log(this.LogLevel.INFO, a)
                            },
                            warn: function(a) {
                                this.log(this.LogLevel.WARN, a)
                            },
                            error: function(a) {
                                this.log(this.LogLevel.ERROR, a)
                            },
                            fatal: function(a) {
                                this.log(this.LogLevel.FATAL, a)
                            },
                            serialize: function(a) {
                                var b;
                                if (!a) return null;
                                "function" == typeof a.tree && (a = a.tree());
                                var c, d, e = a.nodeName;
                                for (a.getAttribute("_realname") && (e = a.getAttribute("_realname")), b = "<" + e, c = 0; c < a.attributes.length; c++) "_realname" != a.attributes[c].nodeName && (b += " " + a.attributes[c].nodeName + "='" + a.attributes[c].value.replace(/&/g, "&amp;").replace(/\'/g, "&apos;").replace(/>/g, "&gt;").replace(/</g, "&lt;") + "'");
                                if (a.childNodes.length > 0) {
                                    for (b += ">", c = 0; c < a.childNodes.length; c++) switch (d = a.childNodes[c], d.nodeType) {
                                        case i.ElementType.NORMAL:
                                            b += i.serialize(d);
                                            break;
                                        case i.ElementType.TEXT:
                                            b += i.xmlescape(d.nodeValue);
                                            break;
                                        case i.ElementType.CDATA:
                                            b += "<![CDATA[" + d.nodeValue + "]]>"
                                    }
                                    b += "</" + e + ">"
                                } else b += "/>";
                                return b
                            },
                            _requestId: 0,
                            _connectionPlugins: {},
                            addConnectionPlugin: function(a, b) {
                                i._connectionPlugins[a] = b
                            }
                        }, i.Builder = function(a, b) {
                            ("presence" == a || "message" == a || "iq" == a) && (b && !b.xmlns ? b.xmlns = i.NS.CLIENT : b || (b = {
                                xmlns: i.NS.CLIENT
                            })), this.nodeTree = i.xmlElement(a, b), this.node = this.nodeTree
                        }, i.Builder.prototype = {
                            tree: function() {
                                return this.nodeTree
                            },
                            toString: function() {
                                return i.serialize(this.nodeTree)
                            },
                            up: function() {
                                return this.node = this.node.parentNode, this
                            },
                            attrs: function(a) {
                                for (var b in a) a.hasOwnProperty(b) && (void 0 === a[b] ? this.node.removeAttribute(b) : this.node.setAttribute(b, a[b]));
                                return this
                            },
                            c: function(a, b, c) {
                                var d = i.xmlElement(a, b, c);
                                return this.node.appendChild(d), "string" != typeof c && (this.node = d), this
                            },
                            cnode: function(a) {
                                var b, c = i.xmlGenerator();
                                try {
                                    b = void 0 !== c.importNode
                                } catch (d) {
                                    b = !1
                                }
                                var e = b ? c.importNode(a, !0) : i.copyElement(a);
                                return this.node.appendChild(e), this.node = e, this
                            },
                            t: function(a) {
                                var b = i.xmlTextNode(a);
                                return this.node.appendChild(b), this
                            },
                            h: function(a) {
                                var b = document.createElement("body");
                                b.innerHTML = a;
                                for (var c = i.createHtml(b); c.childNodes.length > 0;) this.node.appendChild(c.childNodes[0]);
                                return this
                            }
                        }, i.Handler = function(a, b, c, d, e, f, g) {
                            this.handler = a, this.ns = b, this.name = c, this.type = d, this.id = e, this.options = g || {
                                matchBare: !1
                            }, this.options.matchBare || (this.options.matchBare = !1), this.options.matchBare ? this.from = f ? i.getBareJidFromJid(f) : null : this.from = f, this.user = !0
                        }, i.Handler.prototype = {
                            isMatch: function(a) {
                                var b, c = null;
                                if (c = this.options.matchBare ? i.getBareJidFromJid(a.getAttribute("from")) : a.getAttribute("from"), b = !1, this.ns) {
                                    var d = this;
                                    i.forEachChild(a, null, function(a) {
                                        a.getAttribute("xmlns") == d.ns && (b = !0)
                                    }), b = b || a.getAttribute("xmlns") == this.ns
                                } else b = !0;
                                var e = a.getAttribute("type");
                                return !b || this.name && !i.isTagEqual(a, this.name) || this.type && (Array.isArray(this.type) ? -1 == this.type.indexOf(e) : e != this.type) || this.id && a.getAttribute("id") != this.id || this.from && c != this.from ? !1 : !0
                            },
                            run: function(a) {
                                var b = null;
                                try {
                                    b = this.handler(a)
                                } catch (c) {
                                    throw c.sourceURL ? i.fatal("error: " + this.handler + " " + c.sourceURL + ":" + c.line + " - " + c.name + ": " + c.message) : c.fileName ? ("undefined" != typeof console && (console.trace(), console.error(this.handler, " - error - ", c, c.message)), i.fatal("error: " + this.handler + " " + c.fileName + ":" + c.lineNumber + " - " + c.name + ": " + c.message)) : i.fatal("error: " + c.message + "\n" + c.stack), c
                                }
                                return b
                            },
                            toString: function() {
                                return "{Handler: " + this.handler + "(" + this.name + "," + this.id + "," + this.ns + ")}"
                            }
                        }, i.TimedHandler = function(a, b) {
                            this.period = a, this.handler = b, this.lastCalled = (new Date).getTime(), this.user = !0
                        }, i.TimedHandler.prototype = {
                            run: function() {
                                return this.lastCalled = (new Date).getTime(), this.handler()
                            },
                            reset: function() {
                                this.lastCalled = (new Date).getTime()
                            },
                            toString: function() {
                                return "{TimedHandler: " + this.handler + "(" + this.period + ")}"
                            }
                        }, i.Connection = function(a, b) {
                            this.service = a, this.options = b || {};
                            var c = this.options.protocol || "";
                            0 === a.indexOf("ws:") || 0 === a.indexOf("wss:") || 0 === c.indexOf("ws") ? this._proto = new i.Websocket(this) : this._proto = new i.Bosh(this), this.jid = "", this.domain = null, this.features = null, this._sasl_data = {}, this.do_session = !1, this.do_bind = !1, this.timedHandlers = [], this.handlers = [], this.removeTimeds = [], this.removeHandlers = [], this.addTimeds = [], this.addHandlers = [], this._authentication = {}, this._idleTimeout = null, this._disconnectTimeout = null, this.authenticated = !1, this.connected = !1, this.disconnecting = !1, this.do_authentication = !0, this.paused = !1, this.restored = !1, this._data = [], this._uniqueId = 0, this._sasl_success_handler = null, this._sasl_failure_handler = null, this._sasl_challenge_handler = null, this.maxRetries = 5, this._idleTimeout = setTimeout(this._onIdle.bind(this), 100);
                            for (var d in i._connectionPlugins)
                                if (i._connectionPlugins.hasOwnProperty(d)) {
                                    var e = i._connectionPlugins[d],
                                        f = function() {};
                                    f.prototype = e, this[d] = new f, this[d].init(this)
                                }
                        }, i.Connection.prototype = {
                            reset: function() {
                                this._proto._reset(), this.do_session = !1, this.do_bind = !1, this.timedHandlers = [], this.handlers = [], this.removeTimeds = [], this.removeHandlers = [], this.addTimeds = [], this.addHandlers = [], this._authentication = {}, this.authenticated = !1, this.connected = !1, this.disconnecting = !1, this.restored = !1, this._data = [], this._requests = [], this._uniqueId = 0
                            },
                            pause: function() {
                                this.paused = !0
                            },
                            resume: function() {
                                this.paused = !1
                            },
                            getUniqueId: function(a) {
                                var b = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(a) {
                                    var b = 16 * Math.random() | 0,
                                        c = "x" == a ? b : 3 & b | 8;
                                    return c.toString(16)
                                });
                                return "string" == typeof a || "number" == typeof a ? b + ":" + a : b + ""
                            },
                            connect: function(a, b, c, d, e, f, g) {
                                this.jid = a, this.authzid = i.getBareJidFromJid(this.jid), this.authcid = g || i.getNodeFromJid(this.jid), this.pass = b, this.servtype = "xmpp", this.connect_callback = c, this.disconnecting = !1, this.connected = !1, this.authenticated = !1, this.restored = !1, this.domain = i.getDomainFromJid(this.jid), this._changeConnectStatus(i.Status.CONNECTING, null), this._proto._connect(d, e, f)
                            },
                            attach: function(a, b, c, d, e, f, g) {
                                if (!(this._proto instanceof i.Bosh)) throw {
                                    name: "StropheSessionError",
                                    message: 'The "attach" method can only be used with a BOSH connection.'
                                };
                                this._proto._attach(a, b, c, d, e, f, g)
                            },
                            restore: function(a, b, c, d, e) {
                                if (!this._sessionCachingSupported()) throw {
                                    name: "StropheSessionError",
                                    message: 'The "restore" method can only be used with a BOSH connection.'
                                };
                                this._proto._restore(a, b, c, d, e)
                            },
                            _sessionCachingSupported: function() {
                                if (this._proto instanceof i.Bosh) {
                                    if (!JSON) return !1;
                                    try {
                                        window.sessionStorage.setItem("_strophe_", "_strophe_"), window.sessionStorage.removeItem("_strophe_")
                                    } catch (a) {
                                        return !1
                                    }
                                    return !0
                                }
                                return !1
                            },
                            xmlInput: function(a) {},
                            xmlOutput: function(a) {},
                            rawInput: function(a) {},
                            rawOutput: function(a) {},
                            nextValidRid: function(a) {},
                            send: function(a) {
                                if (null !== a) {
                                    if ("function" == typeof a.sort)
                                        for (var b = 0; b < a.length; b++) this._queueData(a[b]);
                                    else "function" == typeof a.tree ? this._queueData(a.tree()) : this._queueData(a);
                                    this._proto._send()
                                }
                            },
                            flush: function() {
                                clearTimeout(this._idleTimeout), this._onIdle()
                            },
                            sendIQ: function(a, b, c, d) {
                                var e = null,
                                    f = this;
                                "function" == typeof a.tree && (a = a.tree());
                                var g = a.getAttribute("id");
                                g || (g = this.getUniqueId("sendIQ"), a.setAttribute("id", g));
                                var h = a.getAttribute("to"),
                                    j = this.jid,
                                    k = this.addHandler(function(a) {
                                        e && f.deleteTimedHandler(e);
                                        var d = !1,
                                            g = a.getAttribute("from");
                                        if (g !== h && (h || g !== i.getBareJidFromJid(j) && g !== i.getDomainFromJid(j) && g !== j) || (d = !0), !d) throw {
                                            name: "StropheError",
                                            message: "Got answer to IQ from wrong jid:" + g + "\nExpected jid: " + h
                                        };
                                        var k = a.getAttribute("type");
                                        if ("result" == k) b && b(a);
                                        else {
                                            if ("error" != k) throw {
                                                name: "StropheError",
                                                message: "Got bad IQ type of " + k
                                            };
                                            c && c(a)
                                        }
                                    }, null, "iq", ["error", "result"], g);
                                return d && (e = this.addTimedHandler(d, function() {
                                    return f.deleteHandler(k), c && c(null), !1
                                })), this.send(a), g
                            },
                            _queueData: function(a) {
                                if (null === a || !a.tagName || !a.childNodes) throw {
                                    name: "StropheError",
                                    message: "Cannot queue non-DOMElement."
                                };
                                this._data.push(a)
                            },
                            _sendRestart: function() {
                                this._data.push("restart"), this._proto._sendRestart(), this._idleTimeout = setTimeout(this._onIdle.bind(this), 100)
                            },
                            addTimedHandler: function(a, b) {
                                var c = new i.TimedHandler(a, b);
                                return this.addTimeds.push(c), c
                            },
                            deleteTimedHandler: function(a) {
                                this.removeTimeds.push(a)
                            },
                            addHandler: function(a, b, c, d, e, f, g) {
                                var h = new i.Handler(a, b, c, d, e, f, g);
                                return this.addHandlers.push(h), h
                            },
                            deleteHandler: function(a) {
                                this.removeHandlers.push(a);
                                var b = this.addHandlers.indexOf(a);
                                b >= 0 && this.addHandlers.splice(b, 1)
                            },
                            disconnect: function(a) {
                                if (this._changeConnectStatus(i.Status.DISCONNECTING, a), i.info("Disconnect was called because: " + a), this.connected) {
                                    var b = !1;
                                    this.disconnecting = !0, this.authenticated && (b = h({
                                        xmlns: i.NS.CLIENT,
                                        type: "unavailable"
                                    })), this._disconnectTimeout = this._addSysTimedHandler(3e3, this._onDisconnectTimeout.bind(this)), this._proto._disconnect(b)
                                } else i.info("Disconnect was called before Strophe connected to the server"), this._proto._abortAllRequests()
                            },
                            _changeConnectStatus: function(a, b) {
                                for (var c in i._connectionPlugins)
                                    if (i._connectionPlugins.hasOwnProperty(c)) {
                                        var d = this[c];
                                        if (d.statusChanged) try {
                                            d.statusChanged(a, b)
                                        } catch (e) {
                                            i.error("" + c + " plugin caused an exception changing status: " + e)
                                        }
                                    }
                                if (this.connect_callback) try {
                                    this.connect_callback(a, b)
                                } catch (f) {
                                    i.error("User connection callback caused an exception: " + f)
                                }
                            },
                            _doDisconnect: function(a) {
                                "number" == typeof this._idleTimeout && clearTimeout(this._idleTimeout), null !== this._disconnectTimeout && (this.deleteTimedHandler(this._disconnectTimeout), this._disconnectTimeout = null), i.info("_doDisconnect was called"), this._proto._doDisconnect(), this.authenticated = !1, this.disconnecting = !1, this.restored = !1, this.handlers = [], this.timedHandlers = [], this.removeTimeds = [], this.removeHandlers = [], this.addTimeds = [], this.addHandlers = [], this._changeConnectStatus(i.Status.DISCONNECTED, a),
                                    this.connected = !1
                            },
                            _dataRecv: function(a, b) {
                                i.info("_dataRecv called");
                                var c = this._proto._reqToData(a);
                                if (null !== c) {
                                    this.xmlInput !== i.Connection.prototype.xmlInput && (c.nodeName === this._proto.strip && c.childNodes.length ? this.xmlInput(c.childNodes[0]) : this.xmlInput(c)), this.rawInput !== i.Connection.prototype.rawInput && (b ? this.rawInput(b) : this.rawInput(i.serialize(c)));
                                    for (var d, e; this.removeHandlers.length > 0;) e = this.removeHandlers.pop(), d = this.handlers.indexOf(e), d >= 0 && this.handlers.splice(d, 1);
                                    for (; this.addHandlers.length > 0;) this.handlers.push(this.addHandlers.pop());
                                    if (this.disconnecting && this._proto._emptyQueue()) return void this._doDisconnect();
                                    var f, g, h = c.getAttribute("type");
                                    if (null !== h && "terminate" == h) {
                                        if (this.disconnecting) return;
                                        return f = c.getAttribute("condition"), g = c.getElementsByTagName("conflict"), null !== f ? ("remote-stream-error" == f && g.length > 0 && (f = "conflict"), this._changeConnectStatus(i.Status.CONNFAIL, f)) : this._changeConnectStatus(i.Status.CONNFAIL, "unknown"), void this._doDisconnect(f)
                                    }
                                    var j = this;
                                    i.forEachChild(c, null, function(a) {
                                        var b, c;
                                        for (c = j.handlers, j.handlers = [], b = 0; b < c.length; b++) {
                                            var d = c[b];
                                            try {
                                                !d.isMatch(a) || !j.authenticated && d.user ? j.handlers.push(d) : d.run(a) && j.handlers.push(d)
                                            } catch (e) {
                                                i.warn("Removing Strophe handlers due to uncaught exception: " + e.message)
                                            }
                                        }
                                    })
                                }
                            },
                            mechanisms: {},
                            _connect_cb: function(a, b, c) {
                                i.info("_connect_cb was called"), this.connected = !0;
                                var d;
                                try {
                                    d = this._proto._reqToData(a)
                                } catch (e) {
                                    if ("badformat" != e) throw e;
                                    this._changeConnectStatus(i.Status.CONNFAIL, "bad-format"), this._doDisconnect("bad-format")
                                }
                                if (d) {
                                    this.xmlInput !== i.Connection.prototype.xmlInput && (d.nodeName === this._proto.strip && d.childNodes.length ? this.xmlInput(d.childNodes[0]) : this.xmlInput(d)), this.rawInput !== i.Connection.prototype.rawInput && (c ? this.rawInput(c) : this.rawInput(i.serialize(d)));
                                    var f = this._proto._connect_cb(d);
                                    if (f !== i.Status.CONNFAIL) {
                                        this._authentication.sasl_scram_sha1 = !1, this._authentication.sasl_plain = !1, this._authentication.sasl_digest_md5 = !1, this._authentication.sasl_anonymous = !1, this._authentication.legacy_auth = !1;
                                        var g;
                                        g = d.getElementsByTagNameNS ? d.getElementsByTagNameNS(i.NS.STREAM, "features").length > 0 : d.getElementsByTagName("stream:features").length > 0 || d.getElementsByTagName("features").length > 0;
                                        var h, j, k = d.getElementsByTagName("mechanism"),
                                            l = [],
                                            m = !1;
                                        if (!g) return void this._proto._no_auth_received(b);
                                        if (k.length > 0)
                                            for (h = 0; h < k.length; h++) j = i.getText(k[h]), this.mechanisms[j] && l.push(this.mechanisms[j]);
                                        return this._authentication.legacy_auth = d.getElementsByTagName("auth").length > 0, (m = this._authentication.legacy_auth || l.length > 0) ? void(this.do_authentication !== !1 && this.authenticate(l)) : void this._proto._no_auth_received(b)
                                    }
                                }
                            },
                            authenticate: function(a) {
                                var c;
                                for (c = 0; c < a.length - 1; ++c) {
                                    for (var d = c, f = c + 1; f < a.length; ++f) a[f].prototype.priority > a[d].prototype.priority && (d = f);
                                    if (d != c) {
                                        var h = a[c];
                                        a[c] = a[d], a[d] = h
                                    }
                                }
                                var j = !1;
                                for (c = 0; c < a.length; ++c)
                                    if (a[c].test(this)) {
                                        this._sasl_success_handler = this._addSysHandler(this._sasl_success_cb.bind(this), null, "success", null, null), this._sasl_failure_handler = this._addSysHandler(this._sasl_failure_cb.bind(this), null, "failure", null, null), this._sasl_challenge_handler = this._addSysHandler(this._sasl_challenge_cb.bind(this), null, "challenge", null, null), this._sasl_mechanism = new a[c], this._sasl_mechanism.onStart(this);
                                        var k = e("auth", {
                                            xmlns: i.NS.SASL,
                                            mechanism: this._sasl_mechanism.name
                                        });
                                        if (this._sasl_mechanism.isClientFirst) {
                                            var l = this._sasl_mechanism.onChallenge(this, null);
                                            k.t(b.encode(l))
                                        }
                                        this.send(k.tree()), j = !0;
                                        break
                                    }
                                j || (null === i.getNodeFromJid(this.jid) ? (this._changeConnectStatus(i.Status.CONNFAIL, "x-strophe-bad-non-anon-jid"), this.disconnect("x-strophe-bad-non-anon-jid")) : (this._changeConnectStatus(i.Status.AUTHENTICATING, null), this._addSysHandler(this._auth1_cb.bind(this), null, null, null, "_auth_1"), this.send(g({
                                    type: "get",
                                    to: this.domain,
                                    id: "_auth_1"
                                }).c("query", {
                                    xmlns: i.NS.AUTH
                                }).c("username", {}).t(i.getNodeFromJid(this.jid)).tree())))
                            },
                            _sasl_challenge_cb: function(a) {
                                var c = b.decode(i.getText(a)),
                                    d = this._sasl_mechanism.onChallenge(this, c),
                                    f = e("response", {
                                        xmlns: i.NS.SASL
                                    });
                                return "" !== d && f.t(b.encode(d)), this.send(f.tree()), !0
                            },
                            _auth1_cb: function(a) {
                                var b = g({
                                    type: "set",
                                    id: "_auth_2"
                                }).c("query", {
                                    xmlns: i.NS.AUTH
                                }).c("username", {}).t(i.getNodeFromJid(this.jid)).up().c("password").t(this.pass);
                                return i.getResourceFromJid(this.jid) || (this.jid = i.getBareJidFromJid(this.jid) + "/strophe"), b.up().c("resource", {}).t(i.getResourceFromJid(this.jid)), this._addSysHandler(this._auth2_cb.bind(this), null, null, null, "_auth_2"), this.send(b.tree()), !1
                            },
                            _sasl_success_cb: function(a) {
                                if (this._sasl_data["server-signature"]) {
                                    var c, d = b.decode(i.getText(a)),
                                        e = /([a-z]+)=([^,]+)(,|$)/,
                                        f = d.match(e);
                                    if ("v" == f[1] && (c = f[2]), c != this._sasl_data["server-signature"]) return this.deleteHandler(this._sasl_failure_handler), this._sasl_failure_handler = null, this._sasl_challenge_handler && (this.deleteHandler(this._sasl_challenge_handler), this._sasl_challenge_handler = null), this._sasl_data = {}, this._sasl_failure_cb(null)
                                }
                                i.info("SASL authentication succeeded."), this._sasl_mechanism && this._sasl_mechanism.onSuccess(), this.deleteHandler(this._sasl_failure_handler), this._sasl_failure_handler = null, this._sasl_challenge_handler && (this.deleteHandler(this._sasl_challenge_handler), this._sasl_challenge_handler = null);
                                var g = [],
                                    h = function(a, b) {
                                        for (; a.length;) this.deleteHandler(a.pop());
                                        return this._sasl_auth1_cb.bind(this)(b), !1
                                    };
                                return g.push(this._addSysHandler(function(a) {
                                    h.bind(this)(g, a)
                                }.bind(this), null, "stream:features", null, null)), g.push(this._addSysHandler(function(a) {
                                    h.bind(this)(g, a)
                                }.bind(this), i.NS.STREAM, "features", null, null)), this._sendRestart(), !1
                            },
                            _sasl_auth1_cb: function(a) {
                                this.features = a;
                                var b, c;
                                for (b = 0; b < a.childNodes.length; b++) c = a.childNodes[b], "bind" == c.nodeName && (this.do_bind = !0), "session" == c.nodeName && (this.do_session = !0);
                                if (!this.do_bind) return this._changeConnectStatus(i.Status.AUTHFAIL, null), !1;
                                this._addSysHandler(this._sasl_bind_cb.bind(this), null, null, null, "_bind_auth_2");
                                var d = i.getResourceFromJid(this.jid);
                                return d ? this.send(g({
                                    type: "set",
                                    id: "_bind_auth_2"
                                }).c("bind", {
                                    xmlns: i.NS.BIND
                                }).c("resource", {}).t(d).tree()) : this.send(g({
                                    type: "set",
                                    id: "_bind_auth_2"
                                }).c("bind", {
                                    xmlns: i.NS.BIND
                                }).tree()), !1
                            },
                            _sasl_bind_cb: function(a) {
                                if ("error" == a.getAttribute("type")) {
                                    i.info("SASL binding failed.");
                                    var b, c = a.getElementsByTagName("conflict");
                                    return c.length > 0 && (b = "conflict"), this._changeConnectStatus(i.Status.AUTHFAIL, b), !1
                                }
                                var d, e = a.getElementsByTagName("bind");
                                return e.length > 0 ? (d = e[0].getElementsByTagName("jid"), void(d.length > 0 && (this.jid = i.getText(d[0]), this.do_session ? (this._addSysHandler(this._sasl_session_cb.bind(this), null, null, null, "_session_auth_2"), this.send(g({
                                    type: "set",
                                    id: "_session_auth_2"
                                }).c("session", {
                                    xmlns: i.NS.SESSION
                                }).tree())) : (this.authenticated = !0, this._changeConnectStatus(i.Status.CONNECTED, null))))) : (i.info("SASL binding failed."), this._changeConnectStatus(i.Status.AUTHFAIL, null), !1)
                            },
                            _sasl_session_cb: function(a) {
                                if ("result" == a.getAttribute("type")) this.authenticated = !0, this._changeConnectStatus(i.Status.CONNECTED, null);
                                else if ("error" == a.getAttribute("type")) return i.info("Session creation failed."), this._changeConnectStatus(i.Status.AUTHFAIL, null), !1;
                                return !1
                            },
                            _sasl_failure_cb: function(a) {
                                return this._sasl_success_handler && (this.deleteHandler(this._sasl_success_handler), this._sasl_success_handler = null), this._sasl_challenge_handler && (this.deleteHandler(this._sasl_challenge_handler), this._sasl_challenge_handler = null), this._sasl_mechanism && this._sasl_mechanism.onFailure(), this._changeConnectStatus(i.Status.AUTHFAIL, null), !1
                            },
                            _auth2_cb: function(a) {
                                return "result" == a.getAttribute("type") ? (this.authenticated = !0, this._changeConnectStatus(i.Status.CONNECTED, null)) : "error" == a.getAttribute("type") && (this._changeConnectStatus(i.Status.AUTHFAIL, null), this.disconnect("authentication failed")), !1
                            },
                            _addSysTimedHandler: function(a, b) {
                                var c = new i.TimedHandler(a, b);
                                return c.user = !1, this.addTimeds.push(c), c
                            },
                            _addSysHandler: function(a, b, c, d, e) {
                                var f = new i.Handler(a, b, c, d, e);
                                return f.user = !1, this.addHandlers.push(f), f
                            },
                            _onDisconnectTimeout: function() {
                                return i.info("_onDisconnectTimeout was called"), this._proto._onDisconnectTimeout(), this._doDisconnect(), !1
                            },
                            _onIdle: function() {
                                for (var a, b, c, d; this.addTimeds.length > 0;) this.timedHandlers.push(this.addTimeds.pop());
                                for (; this.removeTimeds.length > 0;) b = this.removeTimeds.pop(), a = this.timedHandlers.indexOf(b), a >= 0 && this.timedHandlers.splice(a, 1);
                                var e = (new Date).getTime();
                                for (d = [], a = 0; a < this.timedHandlers.length; a++) b = this.timedHandlers[a], (this.authenticated || !b.user) && (c = b.lastCalled + b.period, 0 >= c - e ? b.run() && d.push(b) : d.push(b));
                                this.timedHandlers = d, clearTimeout(this._idleTimeout), this._proto._onIdle(), this.connected && (this._idleTimeout = setTimeout(this._onIdle.bind(this), 100))
                            }
                        }, i.SASLMechanism = function(a, b, c) {
                            this.name = a, this.isClientFirst = b, this.priority = c
                        }, i.SASLMechanism.prototype = {
                            test: function(a) {
                                return !0
                            },
                            onStart: function(a) {
                                this._connection = a
                            },
                            onChallenge: function(a, b) {
                                throw new Error("You should implement challenge handling!")
                            },
                            onFailure: function() {
                                this._connection = null
                            },
                            onSuccess: function() {
                                this._connection = null
                            }
                        }, i.SASLAnonymous = function() {}, i.SASLAnonymous.prototype = new i.SASLMechanism("ANONYMOUS", !1, 10), i.SASLAnonymous.test = function(a) {
                            return null === a.authcid
                        }, i.Connection.prototype.mechanisms[i.SASLAnonymous.prototype.name] = i.SASLAnonymous, i.SASLPlain = function() {}, i.SASLPlain.prototype = new i.SASLMechanism("PLAIN", !0, 20), i.SASLPlain.test = function(a) {
                            return null !== a.authcid
                        }, i.SASLPlain.prototype.onChallenge = function(a) {
                            var b = a.authzid;
                            return b += "\x00", b += a.authcid, b += "\x00", b += a.pass, d.utf16to8(b)
                        }, i.Connection.prototype.mechanisms[i.SASLPlain.prototype.name] = i.SASLPlain, i.SASLSHA1 = function() {}, i.SASLSHA1.prototype = new i.SASLMechanism("SCRAM-SHA-1", !0, 40), i.SASLSHA1.test = function(a) {
                            return null !== a.authcid
                        }, i.SASLSHA1.prototype.onChallenge = function(e, f, g) {
                            var h = g || c.hexdigest(1234567890 * Math.random()),
                                i = "n=" + d.utf16to8(e.authcid);
                            return i += ",r=", i += h, e._sasl_data.cnonce = h, e._sasl_data["client-first-message-bare"] = i, i = "n,," + i, this.onChallenge = function(c, e) {
                                for (var f, g, h, i, j, k, l, m, n, o, p, q, r = "c=biws,", s = c._sasl_data["client-first-message-bare"] + "," + e + ",", t = c._sasl_data.cnonce, u = /([a-z]+)=([^,]+)(,|$)/; e.match(u);) {
                                    var v = e.match(u);
                                    switch (e = e.replace(v[0], ""), v[1]) {
                                        case "r":
                                            f = v[2];
                                            break;
                                        case "s":
                                            g = v[2];
                                            break;
                                        case "i":
                                            h = v[2]
                                    }
                                }
                                if (f.substr(0, t.length) !== t) return c._sasl_data = {}, c._sasl_failure_cb();
                                for (r += "r=" + f, s += r, g = b.decode(g), g += "\x00\x00\x00", n = d.utf16to8(c.pass), i = k = a.core_hmac_sha1(n, g), l = 1; h > l; l++) {
                                    for (j = a.core_hmac_sha1(n, a.binb2str(k)), m = 0; 5 > m; m++) i[m] ^= j[m];
                                    k = j
                                }
                                for (i = a.binb2str(i), o = a.core_hmac_sha1(i, "Client Key"), p = a.str_hmac_sha1(i, "Server Key"), q = a.core_hmac_sha1(a.str_sha1(a.binb2str(o)), s), c._sasl_data["server-signature"] = a.b64_hmac_sha1(p, s), m = 0; 5 > m; m++) o[m] ^= q[m];
                                return r += ",p=" + b.encode(a.binb2str(o))
                            }.bind(this), i
                        }, i.Connection.prototype.mechanisms[i.SASLSHA1.prototype.name] = i.SASLSHA1, i.SASLMD5 = function() {}, i.SASLMD5.prototype = new i.SASLMechanism("DIGEST-MD5", !1, 30), i.SASLMD5.test = function(a) {
                            return null !== a.authcid
                        }, i.SASLMD5.prototype._quote = function(a) {
                            return '"' + a.replace(/\\/g, "\\\\").replace(/"/g, '\\"') + '"'
                        }, i.SASLMD5.prototype.onChallenge = function(a, b, e) {
                            for (var f, g = /([a-z]+)=("[^"]+"|[^,"]+)(?:,|$)/, h = e || c.hexdigest("" + 1234567890 * Math.random()), i = "", j = null, k = "", l = ""; b.match(g);) switch (f = b.match(g), b = b.replace(f[0], ""), f[2] = f[2].replace(/^"(.+)"$/, "$1"), f[1]) {
                                case "realm":
                                    i = f[2];
                                    break;
                                case "nonce":
                                    k = f[2];
                                    break;
                                case "qop":
                                    l = f[2];
                                    break;
                                case "host":
                                    j = f[2]
                            }
                            var m = a.servtype + "/" + a.domain;
                            null !== j && (m = m + "/" + j);
                            var n = d.utf16to8(a.authcid + ":" + i + ":" + this._connection.pass),
                                o = c.hash(n) + ":" + k + ":" + h,
                                p = "AUTHENTICATE:" + m,
                                q = "";
                            return q += "charset=utf-8,", q += "username=" + this._quote(d.utf16to8(a.authcid)) + ",", q += "realm=" + this._quote(i) + ",", q += "nonce=" + this._quote(k) + ",", q += "nc=00000001,", q += "cnonce=" + this._quote(h) + ",", q += "digest-uri=" + this._quote(m) + ",", q += "response=" + c.hexdigest(c.hexdigest(o) + ":" + k + ":00000001:" + h + ":auth:" + c.hexdigest(p)) + ",", q += "qop=auth", this.onChallenge = function() {
                                return ""
                            }.bind(this), q
                        }, i.Connection.prototype.mechanisms[i.SASLMD5.prototype.name] = i.SASLMD5, {
                            Strophe: i,
                            $build: e,
                            $msg: f,
                            $iq: g,
                            $pres: h,
                            SHA1: a,
                            Base64: b,
                            MD5: c
                        }
                    }), function(b, c) {
                        return "function" == typeof a && a.amd ? void a("strophe-bosh", ["strophe-core"], function(a) {
                            return c(a.Strophe, a.$build)
                        }) : c(Strophe, $build)
                    }(this, function(a, b) {
                        return a.Request = function(b, c, d, e) {
                            this.id = ++a._requestId, this.xmlData = b, this.data = a.serialize(b), this.origFunc = c, this.func = c, this.rid = d, this.date = NaN, this.sends = e || 0, this.abort = !1, this.dead = null, this.age = function() {
                                if (!this.date) return 0;
                                var a = new Date;
                                return (a - this.date) / 1e3
                            }, this.timeDead = function() {
                                if (!this.dead) return 0;
                                var a = new Date;
                                return (a - this.dead) / 1e3
                            }, this.xhr = this._newXHR()
                        }, a.Request.prototype = {
                            getResponse: function() {
                                var b = null;
                                if (this.xhr.responseXML && this.xhr.responseXML.documentElement) {
                                    if (b = this.xhr.responseXML.documentElement, "parsererror" == b.tagName) throw a.error("invalid response received"), a.error("responseText: " + this.xhr.responseText), a.error("responseXML: " + a.serialize(this.xhr.responseXML)), "parsererror"
                                } else if (this.xhr.responseText) throw a.error("invalid response received"), a.error("responseText: " + this.xhr.responseText), "badformat";
                                return b
                            },
                            _newXHR: function() {
                                var a = null;
                                return window.XMLHttpRequest ? (a = new XMLHttpRequest, a.overrideMimeType && a.overrideMimeType("text/xml; charset=utf-8")) : window.ActiveXObject && (a = new ActiveXObject("Microsoft.XMLHTTP")), a.onreadystatechange = this.func.bind(null, this), a
                            }
                        }, a.Bosh = function(a) {
                            this._conn = a, this.rid = Math.floor(4294967295 * Math.random()), this.sid = null, this.hold = 1, this.wait = 60, this.window = 5, this.errors = 0, this._requests = []
                        }, a.Bosh.prototype = {
                            strip: null,
                            _buildBody: function() {
                                var c = b("body", {
                                    rid: this.rid++,
                                    xmlns: a.NS.HTTPBIND
                                });
                                return null !== this.sid && c.attrs({
                                    sid: this.sid
                                }), this._conn.options.keepalive && this._cacheSession(), c
                            },
                            _reset: function() {
                                this.rid = Math.floor(4294967295 * Math.random()), this.sid = null, this.errors = 0, window.sessionStorage.removeItem("strophe-bosh-session"), this._conn.nextValidRid(this.rid)
                            },
                            _connect: function(b, c, d) {
                                this.wait = b || this.wait, this.hold = c || this.hold, this.errors = 0;
                                var e = this._buildBody().attrs({
                                    to: this._conn.domain,
                                    "xml:lang": "en",
                                    wait: this.wait,
                                    hold: this.hold,
                                    content: "text/xml; charset=utf-8",
                                    ver: "1.6",
                                    "xmpp:version": "1.0",
                                    "xmlns:xmpp": a.NS.BOSH
                                });
                                d && e.attrs({
                                    route: d
                                });
                                var f = this._conn._connect_cb;
                                this._requests.push(new a.Request(e.tree(), this._onRequestStateChange.bind(this, f.bind(this._conn)), e.tree().getAttribute("rid"))), this._throttledRequestHandler()
                            },
                            _attach: function(b, c, d, e, f, g, h) {
                                this._conn.jid = b, this.sid = c, this.rid = d, this._conn.connect_callback = e, this._conn.domain = a.getDomainFromJid(this._conn.jid), this._conn.authenticated = !0, this._conn.connected = !0, this.wait = f || this.wait, this.hold = g || this.hold, this.window = h || this.window, this._conn._changeConnectStatus(a.Status.ATTACHED, null)
                            },
                            _restore: function(b, c, d, e, f) {
                                var g = JSON.parse(window.sessionStorage.getItem("strophe-bosh-session"));
                                if (!("undefined" != typeof g && null !== g && g.rid && g.sid && g.jid) || "undefined" != typeof b && "null" !== b && a.getBareJidFromJid(g.jid) != a.getBareJidFromJid(b)) throw {
                                    name: "StropheSessionError",
                                    message: "_restore: no restoreable session."
                                };
                                this._conn.restored = !0, this._attach(g.jid, g.sid, g.rid, c, d, e, f)
                            },
                            _cacheSession: function() {
                                this._conn.authenticated ? this._conn.jid && this.rid && this.sid && window.sessionStorage.setItem("strophe-bosh-session", JSON.stringify({
                                    jid: this._conn.jid,
                                    rid: this.rid,
                                    sid: this.sid
                                })) : window.sessionStorage.removeItem("strophe-bosh-session")
                            },
                            _connect_cb: function(b) {
                                var c, d, e = b.getAttribute("type");
                                if (null !== e && "terminate" == e) return c = b.getAttribute("condition"), a.error("BOSH-Connection failed: " + c), d = b.getElementsByTagName("conflict"), null !== c ? ("remote-stream-error" == c && d.length > 0 && (c = "conflict"), this._conn._changeConnectStatus(a.Status.CONNFAIL, c)) : this._conn._changeConnectStatus(a.Status.CONNFAIL, "unknown"), this._conn._doDisconnect(c), a.Status.CONNFAIL;
                                this.sid || (this.sid = b.getAttribute("sid"));
                                var f = b.getAttribute("requests");
                                f && (this.window = parseInt(f, 10));
                                var g = b.getAttribute("hold");
                                g && (this.hold = parseInt(g, 10));
                                var h = b.getAttribute("wait");
                                h && (this.wait = parseInt(h, 10))
                            },
                            _disconnect: function(a) {
                                this._sendTerminate(a)
                            },
                            _doDisconnect: function() {
                                this.sid = null, this.rid = Math.floor(4294967295 * Math.random()), window.sessionStorage.removeItem("strophe-bosh-session"), this._conn.nextValidRid(this.rid)
                            },
                            _emptyQueue: function() {
                                return 0 === this._requests.length
                            },
                            _hitError: function(b) {
                                this.errors++, a.warn("request errored, status: " + b + ", number of errors: " + this.errors), this.errors > 4 && this._conn._onDisconnectTimeout()
                            },
                            _no_auth_received: function(b) {
                                b = b ? b.bind(this._conn) : this._conn._connect_cb.bind(this._conn);
                                var c = this._buildBody();
                                this._requests.push(new a.Request(c.tree(), this._onRequestStateChange.bind(this, b.bind(this._conn)), c.tree().getAttribute("rid"))), this._throttledRequestHandler()
                            },
                            _onDisconnectTimeout: function() {
                                this._abortAllRequests()
                            },
                            _abortAllRequests: function() {
                                for (var a; this._requests.length > 0;) a = this._requests.pop(), a.abort = !0, a.xhr.abort(), a.xhr.onreadystatechange = function() {}
                            },
                            _onIdle: function() {
                                var b = this._conn._data;
                                if (this._conn.authenticated && 0 === this._requests.length && 0 === b.length && !this._conn.disconnecting && (a.info("no requests during idle cycle, sending blank request"), b.push(null)), !this._conn.paused) {
                                    if (this._requests.length < 2 && b.length > 0) {
                                        for (var c = this._buildBody(), d = 0; d < b.length; d++) null !== b[d] && ("restart" === b[d] ? c.attrs({
                                            to: this._conn.domain,
                                            "xml:lang": "en",
                                            "xmpp:restart": "true",
                                            "xmlns:xmpp": a.NS.BOSH
                                        }) : c.cnode(b[d]).up());
                                        delete this._conn._data, this._conn._data = [], this._requests.push(new a.Request(c.tree(), this._onRequestStateChange.bind(this, this._conn._dataRecv.bind(this._conn)), c.tree().getAttribute("rid"))), this._throttledRequestHandler()
                                    }
                                    if (this._requests.length > 0) {
                                        var e = this._requests[0].age();
                                        null !== this._requests[0].dead && this._requests[0].timeDead() > Math.floor(a.SECONDARY_TIMEOUT * this.wait) && this._throttledRequestHandler(), e > Math.floor(a.TIMEOUT * this.wait) && (a.warn("Request " + this._requests[0].id + " timed out, over " + Math.floor(a.TIMEOUT * this.wait) + " seconds since last activity"), this._throttledRequestHandler())
                                    }
                                }
                            },
                            _onRequestStateChange: function(b, c) {
                                if (a.debug("request id " + c.id + "." + c.sends + " state changed to " + c.xhr.readyState), c.abort) return void(c.abort = !1);
                                var d;
                                if (4 == c.xhr.readyState) {
                                    d = 0;
                                    try {
                                        d = c.xhr.status
                                    } catch (e) {}
                                    if ("undefined" == typeof d && (d = 0), this.disconnecting && d >= 400) return void this._hitError(d);
                                    var f = this._requests[0] == c,
                                        g = this._requests[1] == c;
                                    (d > 0 && 500 > d || c.sends > 5) && (this._removeRequest(c), a.debug("request id " + c.id + " should now be removed")), 200 == d ? ((g || f && this._requests.length > 0 && this._requests[0].age() > Math.floor(a.SECONDARY_TIMEOUT * this.wait)) && this._restartRequest(0), this._conn.nextValidRid(Number(c.rid) + 1), a.debug("request id " + c.id + "." + c.sends + " got 200"), b(c), this.errors = 0) : (a.error("request id " + c.id + "." + c.sends + " error " + d + " happened"), (0 === d || d >= 400 && 600 > d || d >= 12e3) && (this._hitError(d), d >= 400 && 500 > d && (this._conn._changeConnectStatus(a.Status.DISCONNECTING, null), this._conn._doDisconnect()))), d > 0 && 500 > d || c.sends > 5 || this._throttledRequestHandler()
                                }
                            },
                            _processRequest: function(b) {
                                var c = this,
                                    d = this._requests[b],
                                    e = -1;
                                try {
                                    4 == d.xhr.readyState && (e = d.xhr.status)
                                } catch (f) {
                                    a.error("caught an error in _requests[" + b + "], reqStatus: " + e)
                                }
                                if ("undefined" == typeof e && (e = -1), d.sends > this._conn.maxRetries) return void this._conn._onDisconnectTimeout();
                                var g = d.age(),
                                    h = !isNaN(g) && g > Math.floor(a.TIMEOUT * this.wait),
                                    i = null !== d.dead && d.timeDead() > Math.floor(a.SECONDARY_TIMEOUT * this.wait),
                                    j = 4 == d.xhr.readyState && (1 > e || e >= 500);
                                if ((h || i || j) && (i && a.error("Request " + this._requests[b].id + " timed out (secondary), restarting"), d.abort = !0, d.xhr.abort(), d.xhr.onreadystatechange = function() {}, this._requests[b] = new a.Request(d.xmlData, d.origFunc, d.rid, d.sends), d = this._requests[b]), 0 === d.xhr.readyState) {
                                    a.debug("request id " + d.id + "." + d.sends + " posting");
                                    try {
                                        d.xhr.open("POST", this._conn.service, this._conn.options.sync ? !1 : !0), d.xhr.setRequestHeader("Content-Type", "text/xml; charset=utf-8")
                                    } catch (k) {
                                        return a.error("XHR open failed."), this._conn.connected || this._conn._changeConnectStatus(a.Status.CONNFAIL, "bad-service"), void this._conn.disconnect()
                                    }
                                    var l = function() {
                                        if (d.date = new Date, c._conn.options.customHeaders) {
                                            var a = c._conn.options.customHeaders;
                                            for (var b in a) a.hasOwnProperty(b) && d.xhr.setRequestHeader(b, a[b])
                                        }
                                        d.xhr.send(d.data)
                                    };
                                    if (d.sends > 1) {
                                        var m = 1e3 * Math.min(Math.floor(a.TIMEOUT * this.wait), Math.pow(d.sends, 3));
                                        setTimeout(l, m)
                                    } else l();
                                    d.sends++, this._conn.xmlOutput !== a.Connection.prototype.xmlOutput && (d.xmlData.nodeName === this.strip && d.xmlData.childNodes.length ? this._conn.xmlOutput(d.xmlData.childNodes[0]) : this._conn.xmlOutput(d.xmlData)), this._conn.rawOutput !== a.Connection.prototype.rawOutput && this._conn.rawOutput(d.data)
                                } else a.debug("_processRequest: " + (0 === b ? "first" : "second") + " request has readyState of " + d.xhr.readyState)
                            },
                            _removeRequest: function(b) {
                                a.debug("removing request");
                                var c;
                                for (c = this._requests.length - 1; c >= 0; c--) b == this._requests[c] && this._requests.splice(c, 1);
                                b.xhr.onreadystatechange = function() {}, this._throttledRequestHandler()
                            },
                            _restartRequest: function(a) {
                                var b = this._requests[a];
                                null === b.dead && (b.dead = new Date), this._processRequest(a)
                            },
                            _reqToData: function(a) {
                                try {
                                    return a.getResponse()
                                } catch (b) {
                                    if ("parsererror" != b) throw b;
                                    this._conn.disconnect("strophe-parsererror")
                                }
                            },
                            _sendTerminate: function(b) {
                                a.info("_sendTerminate was called");
                                var c = this._buildBody().attrs({
                                    type: "terminate"
                                });
                                b && c.cnode(b.tree());
                                var d = new a.Request(c.tree(), this._onRequestStateChange.bind(this, this._conn._dataRecv.bind(this._conn)), c.tree().getAttribute("rid"));
                                this._requests.push(d), this._throttledRequestHandler()
                            },
                            _send: function() {
                                clearTimeout(this._conn._idleTimeout), this._throttledRequestHandler(), this._conn._idleTimeout = setTimeout(this._conn._onIdle.bind(this._conn), 100)
                            },
                            _sendRestart: function() {
                                this._throttledRequestHandler(), clearTimeout(this._conn._idleTimeout)
                            },
                            _throttledRequestHandler: function() {
                                this._requests ? a.debug("_throttledRequestHandler called with " + this._requests.length + " requests") : a.debug("_throttledRequestHandler called with undefined requests"), this._requests && 0 !== this._requests.length && (this._requests.length > 0 && this._processRequest(0), this._requests.length > 1 && Math.abs(this._requests[0].rid - this._requests[1].rid) < this.window && this._processRequest(1))
                            }
                        }, a
                    }), function(b, c) {
                        return "function" == typeof a && a.amd ? void a("strophe-websocket", ["strophe-core"], function(a) {
                            return c(a.Strophe, a.$build)
                        }) : c(Strophe, $build)
                    }(this, function(a, b) {
                        return a.Websocket = function(a) {
                            this._conn = a, this.strip = "wrapper";
                            var b = a.service;
                            if (0 !== b.indexOf("ws:") && 0 !== b.indexOf("wss:")) {
                                var c = "";
                                c += "ws" === a.options.protocol && "https:" !== window.location.protocol ? "ws" : "wss", c += "://" + window.location.host, c += 0 !== b.indexOf("/") ? window.location.pathname + b : b, a.service = c
                            }
                        }, a.Websocket.prototype = {
                            _buildStream: function() {
                                return b("open", {
                                    xmlns: a.NS.FRAMING,
                                    to: this._conn.domain,
                                    version: "1.0"
                                })
                            },
                            _check_streamerror: function(b, c) {
                                var d;
                                if (d = b.getElementsByTagNameNS ? b.getElementsByTagNameNS(a.NS.STREAM, "error") : b.getElementsByTagName("stream:error"), 0 === d.length) return !1;
                                for (var e = d[0], f = "", g = "", h = "urn:ietf:params:xml:ns:xmpp-streams", i = 0; i < e.childNodes.length; i++) {
                                    var j = e.childNodes[i];
                                    if (j.getAttribute("xmlns") !== h) break;
                                    "text" === j.nodeName ? g = j.textContent : f = j.nodeName
                                }
                                var k = "WebSocket stream error: ";
                                return k += f ? f : "unknown", g && (k += " - " + f), a.error(k), this._conn._changeConnectStatus(c, f), this._conn._doDisconnect(), !0
                            },
                            _reset: function() {},
                            _connect: function() {
                                this._closeSocket(), this.socket = new WebSocket(this._conn.service, "xmpp"), this.socket.onopen = this._onOpen.bind(this), this.socket.onerror = this._onError.bind(this), this.socket.onclose = this._onClose.bind(this), this.socket.onmessage = this._connect_cb_wrapper.bind(this)
                            },
                            _connect_cb: function(b) {
                                var c = this._check_streamerror(b, a.Status.CONNFAIL);
                                return c ? a.Status.CONNFAIL : void 0
                            },
                            _handleStreamStart: function(b) {
                                var c = !1,
                                    d = b.getAttribute("xmlns");
                                "string" != typeof d ? c = "Missing xmlns in <open />" : d !== a.NS.FRAMING && (c = "Wrong xmlns in <open />: " + d);
                                var e = b.getAttribute("version");
                                return "string" != typeof e ? c = "Missing version in <open />" : "1.0" !== e && (c = "Wrong version in <open />: " + e), c ? (this._conn._changeConnectStatus(a.Status.CONNFAIL, c), this._conn._doDisconnect(), !1) : !0
                            },
                            _connect_cb_wrapper: function(b) {
                                if (0 === b.data.indexOf("<open ") || 0 === b.data.indexOf("<?xml")) {
                                    var c = b.data.replace(/^(<\?.*?\?>\s*)*/, "");
                                    if ("" === c) return;
                                    var d = (new DOMParser).parseFromString(c, "text/xml").documentElement;
                                    this._conn.xmlInput(d), this._conn.rawInput(b.data), this._handleStreamStart(d) && this._connect_cb(d)
                                } else if (0 === b.data.indexOf("<close ")) {
                                    this._conn.rawInput(b.data), this._conn.xmlInput(b);
                                    var e = b.getAttribute("see-other-uri");
                                    e ? (this._conn._changeConnectStatus(a.Status.REDIRECT, "Received see-other-uri, resetting connection"), this._conn.reset(), this._conn.service = e, this._connect()) : (this._conn._changeConnectStatus(a.Status.CONNFAIL, "Received closing stream"), this._conn._doDisconnect())
                                } else {
                                    var f = this._streamWrap(b.data),
                                        g = (new DOMParser).parseFromString(f, "text/xml").documentElement;
                                    this.socket.onmessage = this._onMessage.bind(this), this._conn._connect_cb(g, null, b.data)
                                }
                            },
                            _disconnect: function(c) {
                                if (this.socket && this.socket.readyState !== WebSocket.CLOSED) {
                                    c && this._conn.send(c);
                                    var d = b("close", {
                                        xmlns: a.NS.FRAMING
                                    });
                                    this._conn.xmlOutput(d);
                                    var e = a.serialize(d);
                                    this._conn.rawOutput(e);
                                    try {
                                        this.socket.send(e)
                                    } catch (f) {
                                        a.info("Couldn't send <close /> tag.")
                                    }
                                }
                                this._conn._doDisconnect()
                            },
                            _doDisconnect: function() {
                                a.info("WebSockets _doDisconnect was called"), this._closeSocket()
                            },
                            _streamWrap: function(a) {
                                return "<wrapper>" + a + "</wrapper>"
                            },
                            _closeSocket: function() {
                                if (this.socket) try {
                                    this.socket.close()
                                } catch (a) {}
                                this.socket = null
                            },
                            _emptyQueue: function() {
                                return !0
                            },
                            _onClose: function() {
                                this._conn.connected && !this._conn.disconnecting ? (a.error("Websocket closed unexcectedly"), this._conn._doDisconnect()) : a.info("Websocket closed")
                            },
                            _no_auth_received: function(b) {
                                a.error("Server did not send any auth methods"), this._conn._changeConnectStatus(a.Status.CONNFAIL, "Server did not send any auth methods"), b && (b = b.bind(this._conn))(), this._conn._doDisconnect()
                            },
                            _onDisconnectTimeout: function() {},
                            _abortAllRequests: function() {},
                            _onError: function(b) {
                                a.error("Websocket error " + b), this._conn._changeConnectStatus(a.Status.CONNFAIL, "The WebSocket connection could not be established was disconnected."), this._disconnect()
                            },
                            _onIdle: function() {
                                var b = this._conn._data;
                                if (b.length > 0 && !this._conn.paused) {
                                    for (var c = 0; c < b.length; c++)
                                        if (null !== b[c]) {
                                            var d, e;
                                            d = "restart" === b[c] ? this._buildStream().tree() : b[c], e = a.serialize(d), this._conn.xmlOutput(d), this._conn.rawOutput(e), this.socket.send(e)
                                        }
                                    this._conn._data = []
                                }
                            },
                            _onMessage: function(b) {
                                var c, d, e = '<close xmlns="urn:ietf:params:xml:ns:xmpp-framing" />';
                                if (b.data === e) return this._conn.rawInput(e), this._conn.xmlInput(b), void(this._conn.disconnecting || this._conn._doDisconnect());
                                if (0 === b.data.search("<open ")) {
                                    if (c = (new DOMParser).parseFromString(b.data, "text/xml").documentElement, !this._handleStreamStart(c)) return
                                } else d = this._streamWrap(b.data), c = (new DOMParser).parseFromString(d, "text/xml").documentElement;
                                return this._check_streamerror(c, a.Status.ERROR) ? void 0 : this._conn.disconnecting && "presence" === c.firstChild.nodeName && "unavailable" === c.firstChild.getAttribute("type") ? (this._conn.xmlInput(c), void this._conn.rawInput(a.serialize(c))) : void this._conn._dataRecv(c, b.data)
                            },
                            _onOpen: function() {
                                a.info("Websocket open");
                                var b = this._buildStream();
                                this._conn.xmlOutput(b.tree());
                                var c = a.serialize(b);
                                this._conn.rawOutput(c), this.socket.send(c)
                            },
                            _reqToData: function(a) {
                                return a
                            },
                            _send: function() {
                                this._conn.flush()
                            },
                            _sendRestart: function() {
                                clearTimeout(this._conn._idleTimeout), this._conn._onIdle.bind(this._conn)()
                            }
                        }, a
                    }), function(b) {
                        "function" == typeof a && a.amd && a("strophe", ["strophe-core", "strophe-bosh", "strophe-websocket"], function(a) {
                            return a
                        })
                    }(this), c) {
                    if ("function" != typeof a || !a.amd) return c(Strophe, $build, $msg, $iq, $pres);
                    var d = c;
                    b(["strophe"], function(a) {
                        d(a.Strophe, a.$build, a.$msg, a.$iq, a.$pres)
                    })
                }
            }(function(a, b, c, d, e) {
                window.Strophe = a, window.$build = b, window.$msg = c, window.$iq = d, window.$pres = e
            })
        }, {}],
        160: [function(a, b, c) {
            function d(a, b) {
                this._id = a, this._clearFn = b
            }
            var e = a("process/browser.js").nextTick,
                f = Function.prototype.apply,
                g = Array.prototype.slice,
                h = {},
                i = 0;
            c.setTimeout = function() {
                return new d(f.call(setTimeout, window, arguments), clearTimeout)
            }, c.setInterval = function() {
                return new d(f.call(setInterval, window, arguments), clearInterval)
            }, c.clearTimeout = c.clearInterval = function(a) {
                a.close()
            }, d.prototype.unref = d.prototype.ref = function() {}, d.prototype.close = function() {
                this._clearFn.call(window, this._id)
            }, c.enroll = function(a, b) {
                clearTimeout(a._idleTimeoutId), a._idleTimeout = b
            }, c.unenroll = function(a) {
                clearTimeout(a._idleTimeoutId), a._idleTimeout = -1
            }, c._unrefActive = c.active = function(a) {
                clearTimeout(a._idleTimeoutId);
                var b = a._idleTimeout;
                b >= 0 && (a._idleTimeoutId = setTimeout(function() {
                    a._onTimeout && a._onTimeout()
                }, b))
            }, c.setImmediate = "function" == typeof setImmediate ? setImmediate : function(a) {
                var b = i++,
                    d = arguments.length < 2 ? !1 : g.call(arguments, 1);
                return h[b] = !0, e(function() {
                    h[b] && (d ? a.apply(null, d) : a.call(null), c.clearImmediate(b))
                }), b
            }, c.clearImmediate = "function" == typeof clearImmediate ? clearImmediate : function(a) {
                delete h[a]
            }
        }, {
            "process/browser.js": 145
        }],
        161: [function(a, b, c) {
            b.exports = function(a) {
                return a && "object" == typeof a && "function" == typeof a.copy && "function" == typeof a.fill && "function" == typeof a.readUInt8
            }
        }, {}],
        162: [function(a, b, c) {
            (function(b, d) {
                function e(a, b) {
                    var d = {
                        seen: [],
                        stylize: g
                    };
                    return arguments.length >= 3 && (d.depth = arguments[2]), arguments.length >= 4 && (d.colors = arguments[3]), p(b) ? d.showHidden = b : b && c._extend(d, b), v(d.showHidden) && (d.showHidden = !1), v(d.depth) && (d.depth = 2), v(d.colors) && (d.colors = !1), v(d.customInspect) && (d.customInspect = !0), d.colors && (d.stylize = f), i(d, a, d.depth)
                }

                function f(a, b) {
                    var c = e.styles[b];
                    return c ? "[" + e.colors[c][0] + "m" + a + "[" + e.colors[c][1] + "m" : a
                }

                function g(a, b) {
                    return a
                }

                function h(a) {
                    var b = {};
                    return a.forEach(function(a, c) {
                        b[a] = !0
                    }), b
                }

                function i(a, b, d) {
                    if (a.customInspect && b && A(b.inspect) && b.inspect !== c.inspect && (!b.constructor || b.constructor.prototype !== b)) {
                        var e = b.inspect(d, a);
                        return t(e) || (e = i(a, e, d)), e
                    }
                    var f = j(a, b);
                    if (f) return f;
                    var g = Object.keys(b),
                        p = h(g);
                    if (a.showHidden && (g = Object.getOwnPropertyNames(b)), z(b) && (g.indexOf("message") >= 0 || g.indexOf("description") >= 0)) return k(b);
                    if (0 === g.length) {
                        if (A(b)) {
                            var q = b.name ? ": " + b.name : "";
                            return a.stylize("[Function" + q + "]", "special")
                        }
                        if (w(b)) return a.stylize(RegExp.prototype.toString.call(b), "regexp");
                        if (y(b)) return a.stylize(Date.prototype.toString.call(b), "date");
                        if (z(b)) return k(b)
                    }
                    var r = "",
                        s = !1,
                        u = ["{", "}"];
                    if (o(b) && (s = !0, u = ["[", "]"]), A(b)) {
                        var v = b.name ? ": " + b.name : "";
                        r = " [Function" + v + "]"
                    }
                    if (w(b) && (r = " " + RegExp.prototype.toString.call(b)), y(b) && (r = " " + Date.prototype.toUTCString.call(b)), z(b) && (r = " " + k(b)), 0 === g.length && (!s || 0 == b.length)) return u[0] + r + u[1];
                    if (0 > d) return w(b) ? a.stylize(RegExp.prototype.toString.call(b), "regexp") : a.stylize("[Object]", "special");
                    a.seen.push(b);
                    var x;
                    return x = s ? l(a, b, d, p, g) : g.map(function(c) {
                        return m(a, b, d, p, c, s)
                    }), a.seen.pop(), n(x, r, u)
                }

                function j(a, b) {
                    if (v(b)) return a.stylize("undefined", "undefined");
                    if (t(b)) {
                        var c = "'" + JSON.stringify(b).replace(/^"|"$/g, "").replace(/'/g, "\\'").replace(/\\"/g, '"') + "'";
                        return a.stylize(c, "string")
                    }
                    return s(b) ? a.stylize("" + b, "number") : p(b) ? a.stylize("" + b, "boolean") : q(b) ? a.stylize("null", "null") : void 0
                }

                function k(a) {
                    return "[" + Error.prototype.toString.call(a) + "]"
                }

                function l(a, b, c, d, e) {
                    for (var f = [], g = 0, h = b.length; h > g; ++g) F(b, String(g)) ? f.push(m(a, b, c, d, String(g), !0)) : f.push("");
                    return e.forEach(function(e) {
                        e.match(/^\d+$/) || f.push(m(a, b, c, d, e, !0))
                    }), f
                }

                function m(a, b, c, d, e, f) {
                    var g, h, j;
                    if (j = Object.getOwnPropertyDescriptor(b, e) || {
                            value: b[e]
                        }, j.get ? h = j.set ? a.stylize("[Getter/Setter]", "special") : a.stylize("[Getter]", "special") : j.set && (h = a.stylize("[Setter]", "special")),
                        F(d, e) || (g = "[" + e + "]"), h || (a.seen.indexOf(j.value) < 0 ? (h = q(c) ? i(a, j.value, null) : i(a, j.value, c - 1), h.indexOf("\n") > -1 && (h = f ? h.split("\n").map(function(a) {
                            return "  " + a
                        }).join("\n").substr(2) : "\n" + h.split("\n").map(function(a) {
                            return "   " + a
                        }).join("\n"))) : h = a.stylize("[Circular]", "special")), v(g)) {
                        if (f && e.match(/^\d+$/)) return h;
                        g = JSON.stringify("" + e), g.match(/^"([a-zA-Z_][a-zA-Z_0-9]*)"$/) ? (g = g.substr(1, g.length - 2), g = a.stylize(g, "name")) : (g = g.replace(/'/g, "\\'").replace(/\\"/g, '"').replace(/(^"|"$)/g, "'"), g = a.stylize(g, "string"))
                    }
                    return g + ": " + h
                }

                function n(a, b, c) {
                    var d = 0,
                        e = a.reduce(function(a, b) {
                            return d++, b.indexOf("\n") >= 0 && d++, a + b.replace(/\u001b\[\d\d?m/g, "").length + 1
                        }, 0);
                    return e > 60 ? c[0] + ("" === b ? "" : b + "\n ") + " " + a.join(",\n  ") + " " + c[1] : c[0] + b + " " + a.join(", ") + " " + c[1]
                }

                function o(a) {
                    return Array.isArray(a)
                }

                function p(a) {
                    return "boolean" == typeof a
                }

                function q(a) {
                    return null === a
                }

                function r(a) {
                    return null == a
                }

                function s(a) {
                    return "number" == typeof a
                }

                function t(a) {
                    return "string" == typeof a
                }

                function u(a) {
                    return "symbol" == typeof a
                }

                function v(a) {
                    return void 0 === a
                }

                function w(a) {
                    return x(a) && "[object RegExp]" === C(a)
                }

                function x(a) {
                    return "object" == typeof a && null !== a
                }

                function y(a) {
                    return x(a) && "[object Date]" === C(a)
                }

                function z(a) {
                    return x(a) && ("[object Error]" === C(a) || a instanceof Error)
                }

                function A(a) {
                    return "function" == typeof a
                }

                function B(a) {
                    return null === a || "boolean" == typeof a || "number" == typeof a || "string" == typeof a || "symbol" == typeof a || "undefined" == typeof a
                }

                function C(a) {
                    return Object.prototype.toString.call(a)
                }

                function D(a) {
                    return 10 > a ? "0" + a.toString(10) : a.toString(10)
                }

                function E() {
                    var a = new Date,
                        b = [D(a.getHours()), D(a.getMinutes()), D(a.getSeconds())].join(":");
                    return [a.getDate(), J[a.getMonth()], b].join(" ")
                }

                function F(a, b) {
                    return Object.prototype.hasOwnProperty.call(a, b)
                }
                var G = /%[sdj%]/g;
                c.format = function(a) {
                    if (!t(a)) {
                        for (var b = [], c = 0; c < arguments.length; c++) b.push(e(arguments[c]));
                        return b.join(" ")
                    }
                    for (var c = 1, d = arguments, f = d.length, g = String(a).replace(G, function(a) {
                            if ("%%" === a) return "%";
                            if (c >= f) return a;
                            switch (a) {
                                case "%s":
                                    return String(d[c++]);
                                case "%d":
                                    return Number(d[c++]);
                                case "%j":
                                    try {
                                        return JSON.stringify(d[c++])
                                    } catch (b) {
                                        return "[Circular]"
                                    }
                                default:
                                    return a
                            }
                        }), h = d[c]; f > c; h = d[++c]) g += q(h) || !x(h) ? " " + h : " " + e(h);
                    return g
                }, c.deprecate = function(a, e) {
                    function f() {
                        if (!g) {
                            if (b.throwDeprecation) throw new Error(e);
                            b.traceDeprecation ? console.trace(e) : console.error(e), g = !0
                        }
                        return a.apply(this, arguments)
                    }
                    if (v(d.process)) return function() {
                        return c.deprecate(a, e).apply(this, arguments)
                    };
                    if (b.noDeprecation === !0) return a;
                    var g = !1;
                    return f
                };
                var H, I = {};
                c.debuglog = function(a) {
                    if (v(H) && (H = b.env.NODE_DEBUG || ""), a = a.toUpperCase(), !I[a])
                        if (new RegExp("\\b" + a + "\\b", "i").test(H)) {
                            var d = b.pid;
                            I[a] = function() {
                                var b = c.format.apply(c, arguments);
                                console.error("%s %d: %s", a, d, b)
                            }
                        } else I[a] = function() {};
                    return I[a]
                }, c.inspect = e, e.colors = {
                    bold: [1, 22],
                    italic: [3, 23],
                    underline: [4, 24],
                    inverse: [7, 27],
                    white: [37, 39],
                    grey: [90, 39],
                    black: [30, 39],
                    blue: [34, 39],
                    cyan: [36, 39],
                    green: [32, 39],
                    magenta: [35, 39],
                    red: [31, 39],
                    yellow: [33, 39]
                }, e.styles = {
                    special: "cyan",
                    number: "yellow",
                    "boolean": "yellow",
                    undefined: "grey",
                    "null": "bold",
                    string: "green",
                    date: "magenta",
                    regexp: "red"
                }, c.isArray = o, c.isBoolean = p, c.isNull = q, c.isNullOrUndefined = r, c.isNumber = s, c.isString = t, c.isSymbol = u, c.isUndefined = v, c.isRegExp = w, c.isObject = x, c.isDate = y, c.isError = z, c.isFunction = A, c.isPrimitive = B, c.isBuffer = a("./support/isBuffer");
                var J = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                c.log = function() {
                    console.log("%s - %s", E(), c.format.apply(c, arguments))
                }, c.inherits = a("inherits"), c._extend = function(a, b) {
                    if (!b || !x(b)) return a;
                    for (var c = Object.keys(b), d = c.length; d--;) a[c[d]] = b[c[d]];
                    return a
                }
            }).call(this, a("_process"), "undefined" != typeof global ? global : "undefined" != typeof self ? self : "undefined" != typeof window ? window : {})
        }, {
            "./support/isBuffer": 161,
            _process: 145,
            inherits: 32
        }],
        163: [function(a, b, c) {
            (function() {
                "use strict";
                var b;
                b = a("../lib/xml2js"), c.stripBOM = function(a) {
                    return "\ufeff" === a[0] ? a.substring(1) : a
                }
            }).call(this)
        }, {
            "../lib/xml2js": 165
        }],
        164: [function(a, b, c) {
            (function() {
                "use strict";
                var a;
                a = new RegExp(/(?!xmlns)^.*:/), c.normalize = function(a) {
                    return a.toLowerCase()
                }, c.firstCharLowerCase = function(a) {
                    return a.charAt(0).toLowerCase() + a.slice(1)
                }, c.stripPrefix = function(b) {
                    return b.replace(a, "")
                }, c.parseNumbers = function(a) {
                    return isNaN(a) || (a = a % 1 === 0 ? parseInt(a, 10) : parseFloat(a)), a
                }, c.parseBooleans = function(a) {
                    return /^(?:true|false)$/i.test(a) && (a = "true" === a.toLowerCase()), a
                }
            }).call(this)
        }, {}],
        165: [function(a, b, c) {
            (function() {
                "use strict";
                var b, d, e, f, g, h, i, j, k, l, m, n = function(a, b) {
                        function c() {
                            this.constructor = a
                        }
                        for (var d in b) o.call(b, d) && (a[d] = b[d]);
                        return c.prototype = b.prototype, a.prototype = new c, a.__super__ = b.prototype, a
                    },
                    o = {}.hasOwnProperty,
                    p = function(a, b) {
                        return function() {
                            return a.apply(b, arguments)
                        }
                    };
                k = a("sax"), f = a("events"), d = a("xmlbuilder"), b = a("./bom"), i = a("./processors"), l = a("timers").setImmediate, g = function(a) {
                    return "object" == typeof a && null != a && 0 === Object.keys(a).length
                }, h = function(a, b) {
                    var c, d, e;
                    for (c = 0, d = a.length; d > c; c++) e = a[c], b = e(b);
                    return b
                }, j = function(a) {
                    return a.indexOf("&") >= 0 || a.indexOf(">") >= 0 || a.indexOf("<") >= 0
                }, m = function(a) {
                    return "<![CDATA[" + e(a) + "]]>"
                }, e = function(a) {
                    return a.replace("]]>", "]]]]><![CDATA[>")
                }, c.processors = i, c.defaults = {
                    .1: {
                        explicitCharkey: !1,
                        trim: !0,
                        normalize: !0,
                        normalizeTags: !1,
                        attrkey: "@",
                        charkey: "#",
                        explicitArray: !1,
                        ignoreAttrs: !1,
                        mergeAttrs: !1,
                        explicitRoot: !1,
                        validator: null,
                        xmlns: !1,
                        explicitChildren: !1,
                        childkey: "@@",
                        charsAsChildren: !1,
                        async: !1,
                        strict: !0,
                        attrNameProcessors: null,
                        attrValueProcessors: null,
                        tagNameProcessors: null,
                        valueProcessors: null,
                        emptyTag: ""
                    },
                    .2: {
                        explicitCharkey: !1,
                        trim: !1,
                        normalize: !1,
                        normalizeTags: !1,
                        attrkey: "$",
                        charkey: "_",
                        explicitArray: !0,
                        ignoreAttrs: !1,
                        mergeAttrs: !1,
                        explicitRoot: !0,
                        validator: null,
                        xmlns: !1,
                        explicitChildren: !1,
                        preserveChildrenOrder: !1,
                        childkey: "$$",
                        charsAsChildren: !1,
                        async: !1,
                        strict: !0,
                        attrNameProcessors: null,
                        attrValueProcessors: null,
                        tagNameProcessors: null,
                        valueProcessors: null,
                        rootName: "root",
                        xmldec: {
                            version: "1.0",
                            encoding: "UTF-8",
                            standalone: !0
                        },
                        doctype: null,
                        renderOpts: {
                            pretty: !0,
                            indent: "  ",
                            newline: "\n"
                        },
                        headless: !1,
                        chunkSize: 1e4,
                        emptyTag: "",
                        cdata: !1
                    }
                }, c.ValidationError = function(a) {
                    function b(a) {
                        this.message = a
                    }
                    return n(b, a), b
                }(Error), c.Builder = function() {
                    function a(a) {
                        var b, d, e;
                        this.options = {}, d = c.defaults[.2];
                        for (b in d) o.call(d, b) && (e = d[b], this.options[b] = e);
                        for (b in a) o.call(a, b) && (e = a[b], this.options[b] = e)
                    }
                    return a.prototype.buildObject = function(a) {
                        var b, e, f, g, h;
                        return b = this.options.attrkey, e = this.options.charkey, 1 === Object.keys(a).length && this.options.rootName === c.defaults[.2].rootName ? (h = Object.keys(a)[0], a = a[h]) : h = this.options.rootName, f = function(a) {
                            return function(c, d) {
                                var g, h, i, k, l, n;
                                if ("object" != typeof d) a.options.cdata && j(d) ? c.raw(m(d)) : c.txt(d);
                                else
                                    for (l in d)
                                        if (o.call(d, l))
                                            if (h = d[l], l === b) {
                                                if ("object" == typeof h)
                                                    for (g in h) n = h[g], c = c.att(g, n)
                                            } else if (l === e) c = a.options.cdata && j(h) ? c.raw(m(h)) : c.txt(h);
                                else if (Array.isArray(h))
                                    for (k in h) o.call(h, k) && (i = h[k], c = "string" == typeof i ? a.options.cdata && j(i) ? c.ele(l).raw(m(i)).up() : c.ele(l, i).up() : f(c.ele(l), i).up());
                                else "object" == typeof h ? c = f(c.ele(l), h).up() : "string" == typeof h && a.options.cdata && j(h) ? c = c.ele(l).raw(m(h)).up() : (null == h && (h = ""), c = c.ele(l, h.toString()).up());
                                return c
                            }
                        }(this), g = d.create(h, this.options.xmldec, this.options.doctype, {
                            headless: this.options.headless,
                            allowSurrogateChars: this.options.allowSurrogateChars
                        }), f(g, a).end(this.options.renderOpts)
                    }, a
                }(), c.Parser = function(a) {
                    function d(a) {
                        this.parseString = p(this.parseString, this), this.reset = p(this.reset, this), this.assignOrPush = p(this.assignOrPush, this), this.processAsync = p(this.processAsync, this);
                        var b, d, e;
                        if (!(this instanceof c.Parser)) return new c.Parser(a);
                        this.options = {}, d = c.defaults[.2];
                        for (b in d) o.call(d, b) && (e = d[b], this.options[b] = e);
                        for (b in a) o.call(a, b) && (e = a[b], this.options[b] = e);
                        this.options.xmlns && (this.options.xmlnskey = this.options.attrkey + "ns"), this.options.normalizeTags && (this.options.tagNameProcessors || (this.options.tagNameProcessors = []), this.options.tagNameProcessors.unshift(i.normalize)), this.reset()
                    }
                    return n(d, a), d.prototype.processAsync = function() {
                        var a, b, c;
                        try {
                            return this.remaining.length <= this.options.chunkSize ? (a = this.remaining, this.remaining = "", this.saxParser = this.saxParser.write(a), this.saxParser.close()) : (a = this.remaining.substr(0, this.options.chunkSize), this.remaining = this.remaining.substr(this.options.chunkSize, this.remaining.length), this.saxParser = this.saxParser.write(a), l(this.processAsync))
                        } catch (c) {
                            if (b = c, !this.saxParser.errThrown) return this.saxParser.errThrown = !0, this.emit(b)
                        }
                    }, d.prototype.assignOrPush = function(a, b, c) {
                        return b in a ? (a[b] instanceof Array || (a[b] = [a[b]]), a[b].push(c)) : this.options.explicitArray ? a[b] = [c] : a[b] = c
                    }, d.prototype.reset = function() {
                        var a, b, c, d;
                        return this.removeAllListeners(), this.saxParser = k.parser(this.options.strict, {
                            trim: !1,
                            normalize: !1,
                            xmlns: this.options.xmlns
                        }), this.saxParser.errThrown = !1, this.saxParser.onerror = function(a) {
                            return function(b) {
                                return a.saxParser.resume(), a.saxParser.errThrown ? void 0 : (a.saxParser.errThrown = !0, a.emit("error", b))
                            }
                        }(this), this.saxParser.onend = function(a) {
                            return function() {
                                return a.saxParser.ended ? void 0 : (a.saxParser.ended = !0, a.emit("end", a.resultObject))
                            }
                        }(this), this.saxParser.ended = !1, this.EXPLICIT_CHARKEY = this.options.explicitCharkey, this.resultObject = null, d = [], a = this.options.attrkey, b = this.options.charkey, this.saxParser.onopentag = function(c) {
                            return function(e) {
                                var f, g, i, j, k;
                                if (i = {}, i[b] = "", !c.options.ignoreAttrs) {
                                    k = e.attributes;
                                    for (f in k) o.call(k, f) && (a in i || c.options.mergeAttrs || (i[a] = {}), g = c.options.attrValueProcessors ? h(c.options.attrValueProcessors, e.attributes[f]) : e.attributes[f], j = c.options.attrNameProcessors ? h(c.options.attrNameProcessors, f) : f, c.options.mergeAttrs ? c.assignOrPush(i, j, g) : i[a][j] = g)
                                }
                                return i["#name"] = c.options.tagNameProcessors ? h(c.options.tagNameProcessors, e.name) : e.name, c.options.xmlns && (i[c.options.xmlnskey] = {
                                    uri: e.uri,
                                    local: e.local
                                }), d.push(i)
                            }
                        }(this), this.saxParser.onclosetag = function(a) {
                            return function() {
                                var c, e, f, i, j, k, l, m, n, p, q, r;
                                if (m = d.pop(), l = m["#name"], a.options.explicitChildren && a.options.preserveChildrenOrder || delete m["#name"], m.cdata === !0 && (c = m.cdata, delete m.cdata), q = d[d.length - 1], m[b].match(/^\s*$/) && !c ? (e = m[b], delete m[b]) : (a.options.trim && (m[b] = m[b].trim()), a.options.normalize && (m[b] = m[b].replace(/\s{2,}/g, " ").trim()), m[b] = a.options.valueProcessors ? h(a.options.valueProcessors, m[b]) : m[b], 1 === Object.keys(m).length && b in m && !a.EXPLICIT_CHARKEY && (m = m[b])), g(m) && (m = "" !== a.options.emptyTag ? a.options.emptyTag : e), null != a.options.validator) {
                                    r = "/" + function() {
                                        var a, b, c;
                                        for (c = [], a = 0, b = d.length; b > a; a++) k = d[a], c.push(k["#name"]);
                                        return c
                                    }().concat(l).join("/");
                                    try {
                                        m = a.options.validator(r, q && q[l], m)
                                    } catch (i) {
                                        f = i, a.emit("error", f)
                                    }
                                }
                                if (a.options.explicitChildren && !a.options.mergeAttrs && "object" == typeof m)
                                    if (a.options.preserveChildrenOrder) {
                                        if (q) {
                                            q[a.options.childkey] = q[a.options.childkey] || [], n = {};
                                            for (j in m) o.call(m, j) && (n[j] = m[j]);
                                            q[a.options.childkey].push(n), delete m["#name"], 1 === Object.keys(m).length && b in m && !a.EXPLICIT_CHARKEY && (m = m[b])
                                        }
                                    } else k = {}, a.options.attrkey in m && (k[a.options.attrkey] = m[a.options.attrkey], delete m[a.options.attrkey]), !a.options.charsAsChildren && a.options.charkey in m && (k[a.options.charkey] = m[a.options.charkey], delete m[a.options.charkey]), Object.getOwnPropertyNames(m).length > 0 && (k[a.options.childkey] = m), m = k;
                                return d.length > 0 ? a.assignOrPush(q, l, m) : (a.options.explicitRoot && (p = m, m = {}, m[l] = p), a.resultObject = m, a.saxParser.ended = !0, a.emit("end", a.resultObject))
                            }
                        }(this), c = function(a) {
                            return function(c) {
                                var e, f;
                                return f = d[d.length - 1], f ? (f[b] += c, a.options.explicitChildren && a.options.preserveChildrenOrder && a.options.charsAsChildren && "" !== c.replace(/\\n/g, "").trim() && (f[a.options.childkey] = f[a.options.childkey] || [], e = {
                                    "#name": "__text__"
                                }, e[b] = c, f[a.options.childkey].push(e)), f) : void 0
                            }
                        }(this), this.saxParser.ontext = c, this.saxParser.oncdata = function(a) {
                            return function(a) {
                                var b;
                                return b = c(a), b ? b.cdata = !0 : void 0
                            }
                        }(this)
                    }, d.prototype.parseString = function(a, c) {
                        var d, e;
                        null != c && "function" == typeof c && (this.on("end", function(a) {
                            return this.reset(), c(null, a)
                        }), this.on("error", function(a) {
                            return this.reset(), c(a)
                        }));
                        try {
                            return a = a.toString(), "" === a.trim() ? (this.emit("end", null), !0) : (a = b.stripBOM(a), this.options.async ? (this.remaining = a, l(this.processAsync), this.saxParser) : this.saxParser.write(a).close())
                        } catch (e) {
                            if (d = e, !this.saxParser.errThrown && !this.saxParser.ended) return this.emit("error", d), this.saxParser.errThrown = !0;
                            if (this.saxParser.ended) throw d
                        }
                    }, d
                }(f.EventEmitter), c.parseString = function(a, b, d) {
                    var e, f, g;
                    return null != d ? ("function" == typeof d && (e = d), "object" == typeof b && (f = b)) : ("function" == typeof b && (e = b), f = {}), g = new c.Parser(f), g.parseString(a, e)
                }
            }).call(this)
        }, {
            "./bom": 163,
            "./processors": 164,
            events: 30,
            sax: 146,
            timers: 160,
            xmlbuilder: 182
        }],
        166: [function(a, b, c) {
            (function() {
                var c, d;
                d = a("lodash/create"), b.exports = c = function() {
                    function a(a, b, c) {
                        if (this.stringify = a.stringify, null == b) throw new Error("Missing attribute name of element " + a.name);
                        if (null == c) throw new Error("Missing attribute value for attribute " + b + " of element " + a.name);
                        this.name = this.stringify.attName(b), this.value = this.stringify.attValue(c)
                    }
                    return a.prototype.clone = function() {
                        return d(a.prototype, this)
                    }, a.prototype.toString = function(a, b) {
                        return " " + this.name + '="' + this.value + '"'
                    }, a
                }()
            }).call(this)
        }, {
            "lodash/create": 118
        }],
        167: [function(a, b, c) {
            (function() {
                var c, d, e, f, g;
                g = a("./XMLStringifier"), d = a("./XMLDeclaration"), e = a("./XMLDocType"), f = a("./XMLElement"), b.exports = c = function() {
                    function a(a, b) {
                        var c, d;
                        if (null == a) throw new Error("Root element needs a name");
                        null == b && (b = {}), this.options = b, this.stringify = new g(b), d = new f(this, "doc"), c = d.element(a), c.isRoot = !0, c.documentObject = this, this.rootObject = c, b.headless || (c.declaration(b), (null != b.pubID || null != b.sysID) && c.doctype(b))
                    }
                    return a.prototype.root = function() {
                        return this.rootObject
                    }, a.prototype.end = function(a) {
                        return this.toString(a)
                    }, a.prototype.toString = function(a) {
                        var b, c, d, e, f, g, h, i;
                        return e = (null != a ? a.pretty : void 0) || !1, b = null != (g = null != a ? a.indent : void 0) ? g : "  ", d = null != (h = null != a ? a.offset : void 0) ? h : 0, c = null != (i = null != a ? a.newline : void 0) ? i : "\n", f = "", null != this.xmldec && (f += this.xmldec.toString(a)), null != this.doctype && (f += this.doctype.toString(a)), f += this.rootObject.toString(a), e && f.slice(-c.length) === c && (f = f.slice(0, -c.length)), f
                    }, a
                }()
            }).call(this)
        }, {
            "./XMLDeclaration": 174,
            "./XMLDocType": 175,
            "./XMLElement": 176,
            "./XMLStringifier": 180
        }],
        168: [function(a, b, c) {
            (function() {
                var c, d, e, f = function(a, b) {
                        function c() {
                            this.constructor = a
                        }
                        for (var d in b) g.call(b, d) && (a[d] = b[d]);
                        return c.prototype = b.prototype, a.prototype = new c, a.__super__ = b.prototype, a
                    },
                    g = {}.hasOwnProperty;
                e = a("lodash/create"), d = a("./XMLNode"), b.exports = c = function(a) {
                    function b(a, c) {
                        if (b.__super__.constructor.call(this, a), null == c) throw new Error("Missing CDATA text");
                        this.text = this.stringify.cdata(c)
                    }
                    return f(b, a), b.prototype.clone = function() {
                        return e(b.prototype, this)
                    }, b.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += "<![CDATA[" + this.text + "]]>", f && (g += d), g
                    }, b
                }(d)
            }).call(this)
        }, {
            "./XMLNode": 177,
            "lodash/create": 118
        }],
        169: [function(a, b, c) {
            (function() {
                var c, d, e, f = function(a, b) {
                        function c() {
                            this.constructor = a
                        }
                        for (var d in b) g.call(b, d) && (a[d] = b[d]);
                        return c.prototype = b.prototype, a.prototype = new c, a.__super__ = b.prototype, a
                    },
                    g = {}.hasOwnProperty;
                e = a("lodash/create"), d = a("./XMLNode"), b.exports = c = function(a) {
                    function b(a, c) {
                        if (b.__super__.constructor.call(this, a), null == c) throw new Error("Missing comment text");
                        this.text = this.stringify.comment(c)
                    }
                    return f(b, a), b.prototype.clone = function() {
                        return e(b.prototype, this)
                    }, b.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += "<!-- " + this.text + " -->", f && (g += d), g
                    }, b
                }(d)
            }).call(this)
        }, {
            "./XMLNode": 177,
            "lodash/create": 118
        }],
        170: [function(a, b, c) {
            (function() {
                var c, d;
                d = a("lodash/create"), b.exports = c = function() {
                    function a(a, b, c, d, e, f) {
                        if (this.stringify = a.stringify, null == b) throw new Error("Missing DTD element name");
                        if (null == c) throw new Error("Missing DTD attribute name");
                        if (!d) throw new Error("Missing DTD attribute type");
                        if (!e) throw new Error("Missing DTD attribute default");
                        if (0 !== e.indexOf("#") && (e = "#" + e), !e.match(/^(#REQUIRED|#IMPLIED|#FIXED|#DEFAULT)$/)) throw new Error("Invalid default value type; expected: #REQUIRED, #IMPLIED, #FIXED or #DEFAULT");
                        if (f && !e.match(/^(#FIXED|#DEFAULT)$/)) throw new Error("Default value only applies to #FIXED or #DEFAULT");
                        this.elementName = this.stringify.eleName(b), this.attributeName = this.stringify.attName(c), this.attributeType = this.stringify.dtdAttType(d), this.defaultValue = this.stringify.dtdAttDefault(f), this.defaultValueType = e
                    }
                    return a.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += "<!ATTLIST " + this.elementName + " " + this.attributeName + " " + this.attributeType, "#DEFAULT" !== this.defaultValueType && (g += " " + this.defaultValueType), this.defaultValue && (g += ' "' + this.defaultValue + '"'), g += ">", f && (g += d), g
                    }, a
                }()
            }).call(this)
        }, {
            "lodash/create": 118
        }],
        171: [function(a, b, c) {
            (function() {
                var c, d;
                d = a("lodash/create"), b.exports = c = function() {
                    function a(a, b, c) {
                        if (this.stringify = a.stringify, null == b) throw new Error("Missing DTD element name");
                        c || (c = "(#PCDATA)"), Array.isArray(c) && (c = "(" + c.join(",") + ")"), this.name = this.stringify.eleName(b), this.value = this.stringify.dtdElementValue(c)
                    }
                    return a.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += "<!ELEMENT " + this.name + " " + this.value + ">", f && (g += d), g
                    }, a
                }()
            }).call(this)
        }, {
            "lodash/create": 118
        }],
        172: [function(a, b, c) {
            (function() {
                var c, d, e;
                d = a("lodash/create"), e = a("lodash/isObject"), b.exports = c = function() {
                    function a(a, b, c, d) {
                        if (this.stringify = a.stringify, null == c) throw new Error("Missing entity name");
                        if (null == d) throw new Error("Missing entity value");
                        if (this.pe = !!b, this.name = this.stringify.eleName(c), e(d)) {
                            if (!d.pubID && !d.sysID) throw new Error("Public and/or system identifiers are required for an external entity");
                            if (d.pubID && !d.sysID) throw new Error("System identifier is required for a public external entity");
                            if (null != d.pubID && (this.pubID = this.stringify.dtdPubID(d.pubID)), null != d.sysID && (this.sysID = this.stringify.dtdSysID(d.sysID)), null != d.nData && (this.nData = this.stringify.dtdNData(d.nData)), this.pe && this.nData) throw new Error("Notation declaration is not allowed in a parameter entity")
                        } else this.value = this.stringify.dtdEntityValue(d)
                    }
                    return a.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += "<!ENTITY", this.pe && (g += " %"), g += " " + this.name, this.value ? g += ' "' + this.value + '"' : (this.pubID && this.sysID ? g += ' PUBLIC "' + this.pubID + '" "' + this.sysID + '"' : this.sysID && (g += ' SYSTEM "' + this.sysID + '"'), this.nData && (g += " NDATA " + this.nData)), g += ">", f && (g += d), g
                    }, a
                }()
            }).call(this)
        }, {
            "lodash/create": 118,
            "lodash/isObject": 132
        }],
        173: [function(a, b, c) {
            (function() {
                var c, d;
                d = a("lodash/create"), b.exports = c = function() {
                    function a(a, b, c) {
                        if (this.stringify = a.stringify, null == b) throw new Error("Missing notation name");
                        if (!c.pubID && !c.sysID) throw new Error("Public or system identifiers are required for an external entity");
                        this.name = this.stringify.eleName(b), null != c.pubID && (this.pubID = this.stringify.dtdPubID(c.pubID)), null != c.sysID && (this.sysID = this.stringify.dtdSysID(c.sysID))
                    }
                    return a.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += "<!NOTATION " + this.name, this.pubID && this.sysID ? g += ' PUBLIC "' + this.pubID + '" "' + this.sysID + '"' : this.pubID ? g += ' PUBLIC "' + this.pubID + '"' : this.sysID && (g += ' SYSTEM "' + this.sysID + '"'), g += ">", f && (g += d), g
                    }, a
                }()
            }).call(this)
        }, {
            "lodash/create": 118
        }],
        174: [function(a, b, c) {
            (function() {
                var c, d, e, f, g = function(a, b) {
                        function c() {
                            this.constructor = a
                        }
                        for (var d in b) h.call(b, d) && (a[d] = b[d]);
                        return c.prototype = b.prototype, a.prototype = new c, a.__super__ = b.prototype, a
                    },
                    h = {}.hasOwnProperty;
                e = a("lodash/create"), f = a("lodash/isObject"), d = a("./XMLNode"), b.exports = c = function(a) {
                    function b(a, c, d, e) {
                        var g;
                        b.__super__.constructor.call(this, a), f(c) && (g = c, c = g.version, d = g.encoding, e = g.standalone), c || (c = "1.0"), this.version = this.stringify.xmlVersion(c), null != d && (this.encoding = this.stringify.xmlEncoding(d)), null != e && (this.standalone = this.stringify.xmlStandalone(e))
                    }
                    return g(b, a), b.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += "<?xml", g += ' version="' + this.version + '"', null != this.encoding && (g += ' encoding="' + this.encoding + '"'), null != this.standalone && (g += ' standalone="' + this.standalone + '"'), g += "?>", f && (g += d), g
                    }, b
                }(d)
            }).call(this)
        }, {
            "./XMLNode": 177,
            "lodash/create": 118,
            "lodash/isObject": 132
        }],
        175: [function(a, b, c) {
            (function() {
                var c, d, e, f, g, h, i, j, k, l;
                k = a("lodash/create"), l = a("lodash/isObject"), c = a("./XMLCData"), d = a("./XMLComment"), e = a("./XMLDTDAttList"), g = a("./XMLDTDEntity"), f = a("./XMLDTDElement"), h = a("./XMLDTDNotation"), j = a("./XMLProcessingInstruction"), b.exports = i = function() {
                    function a(a, b, c) {
                        var d, e;
                        this.documentObject = a, this.stringify = this.documentObject.stringify, this.children = [], l(b) && (d = b, b = d.pubID, c = d.sysID), null == c && (e = [b, c], c = e[0], b = e[1]), null != b && (this.pubID = this.stringify.dtdPubID(b)), null != c && (this.sysID = this.stringify.dtdSysID(c))
                    }
                    return a.prototype.element = function(a, b) {
                        var c;
                        return c = new f(this, a, b), this.children.push(c), this
                    }, a.prototype.attList = function(a, b, c, d, f) {
                        var g;
                        return g = new e(this, a, b, c, d, f), this.children.push(g), this
                    }, a.prototype.entity = function(a, b) {
                        var c;
                        return c = new g(this, !1, a, b), this.children.push(c), this
                    }, a.prototype.pEntity = function(a, b) {
                        var c;
                        return c = new g(this, !0, a, b), this.children.push(c), this
                    }, a.prototype.notation = function(a, b) {
                        var c;
                        return c = new h(this, a, b), this.children.push(c), this
                    }, a.prototype.cdata = function(a) {
                        var b;
                        return b = new c(this, a), this.children.push(b), this
                    }, a.prototype.comment = function(a) {
                        var b;
                        return b = new d(this, a), this.children.push(b), this
                    }, a.prototype.instruction = function(a, b) {
                        var c;
                        return c = new j(this, a, b), this.children.push(c), this
                    }, a.prototype.root = function() {
                        return this.documentObject.root()
                    }, a.prototype.document = function() {
                        return this.documentObject
                    }, a.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k, l, m, n, o;
                        if (i = (null != a ? a.pretty : void 0) || !1, e = null != (k = null != a ? a.indent : void 0) ? k : "  ", h = null != (l = null != a ? a.offset : void 0) ? l : 0, g = null != (m = null != a ? a.newline : void 0) ? m : "\n", b || (b = 0), o = new Array(b + h + 1).join(e), j = "", i && (j += o), j += "<!DOCTYPE " + this.root().name, this.pubID && this.sysID ? j += ' PUBLIC "' + this.pubID + '" "' + this.sysID + '"' : this.sysID && (j += ' SYSTEM "' + this.sysID + '"'), this.children.length > 0) {
                            for (j += " [", i && (j += g), n = this.children, d = 0, f = n.length; f > d; d++) c = n[d], j += c.toString(a, b + 1);
                            j += "]"
                        }
                        return j += ">", i && (j += g), j
                    }, a.prototype.ele = function(a, b) {
                        return this.element(a, b)
                    }, a.prototype.att = function(a, b, c, d, e) {
                        return this.attList(a, b, c, d, e)
                    }, a.prototype.ent = function(a, b) {
                        return this.entity(a, b)
                    }, a.prototype.pent = function(a, b) {
                        return this.pEntity(a, b)
                    }, a.prototype.not = function(a, b) {
                        return this.notation(a, b)
                    }, a.prototype.dat = function(a) {
                        return this.cdata(a)
                    }, a.prototype.com = function(a) {
                        return this.comment(a)
                    }, a.prototype.ins = function(a, b) {
                        return this.instruction(a, b)
                    }, a.prototype.up = function() {
                        return this.root()
                    }, a.prototype.doc = function() {
                        return this.document()
                    }, a
                }()
            }).call(this)
        }, {
            "./XMLCData": 168,
            "./XMLComment": 169,
            "./XMLDTDAttList": 170,
            "./XMLDTDElement": 171,
            "./XMLDTDEntity": 172,
            "./XMLDTDNotation": 173,
            "./XMLProcessingInstruction": 178,
            "lodash/create": 118,
            "lodash/isObject": 132
        }],
        176: [function(a, b, c) {
            (function() {
                var c, d, e, f, g, h, i, j, k = function(a, b) {
                        function c() {
                            this.constructor = a
                        }
                        for (var d in b) l.call(b, d) && (a[d] = b[d]);
                        return c.prototype = b.prototype, a.prototype = new c, a.__super__ = b.prototype, a
                    },
                    l = {}.hasOwnProperty;
                g = a("lodash/create"), j = a("lodash/isObject"), i = a("lodash/isFunction"), h = a("lodash/every"), e = a("./XMLNode"), c = a("./XMLAttribute"), f = a("./XMLProcessingInstruction"), b.exports = d = function(a) {
                    function b(a, c, d) {
                        if (b.__super__.constructor.call(this, a), null == c) throw new Error("Missing element name");
                        this.name = this.stringify.eleName(c), this.children = [], this.instructions = [], this.attributes = {}, null != d && this.attribute(d)
                    }
                    return k(b, a), b.prototype.clone = function() {
                        var a, c, d, e, f, h, i, j;
                        d = g(b.prototype, this), d.isRoot && (d.documentObject = null), d.attributes = {}, i = this.attributes;
                        for (c in i) l.call(i, c) && (a = i[c], d.attributes[c] = a.clone());
                        for (d.instructions = [], j = this.instructions, e = 0, f = j.length; f > e; e++) h = j[e], d.instructions.push(h.clone());
                        return d.children = [], this.children.forEach(function(a) {
                            var b;
                            return b = a.clone(), b.parent = d, d.children.push(b)
                        }), d
                    }, b.prototype.attribute = function(a, b) {
                        var d, e;
                        if (null != a && (a = a.valueOf()), j(a))
                            for (d in a) l.call(a, d) && (e = a[d], this.attribute(d, e));
                        else i(b) && (b = b.apply()), this.options.skipNullAttributes && null == b || (this.attributes[a] = new c(this, a, b));
                        return this
                    }, b.prototype.removeAttribute = function(a) {
                        var b, c, d;
                        if (null == a) throw new Error("Missing attribute name");
                        if (a = a.valueOf(), Array.isArray(a))
                            for (c = 0, d = a.length; d > c; c++) b = a[c], delete this.attributes[b];
                        else delete this.attributes[a];
                        return this
                    }, b.prototype.instruction = function(a, b) {
                        var c, d, e, g, h;
                        if (null != a && (a = a.valueOf()), null != b && (b = b.valueOf()), Array.isArray(a))
                            for (c = 0, h = a.length; h > c; c++) d = a[c], this.instruction(d);
                        else if (j(a))
                            for (d in a) l.call(a, d) && (e = a[d], this.instruction(d, e));
                        else i(b) && (b = b.apply()), g = new f(this, a, b), this.instructions.push(g);
                        return this
                    }, b.prototype.toString = function(a, b) {
                        var c, d, e, f, g, i, j, k, m, n, o, p, q, r, s, t, u, v, w, x;
                        for (p = (null != a ? a.pretty : void 0) || !1, f = null != (r = null != a ? a.indent : void 0) ? r : "  ", o = null != (s = null != a ? a.offset : void 0) ? s : 0, n = null != (t = null != a ? a.newline : void 0) ? t : "\n", b || (b = 0), x = new Array(b + o + 1).join(f), q = "", u = this.instructions, e = 0, j = u.length; j > e; e++) g = u[e], q += g.toString(a, b);
                        p && (q += x), q += "<" + this.name, v = this.attributes;
                        for (m in v) l.call(v, m) && (c = v[m], q += c.toString(a));
                        if (0 === this.children.length || h(this.children, function(a) {
                                return "" === a.value
                            })) q += "/>", p && (q += n);
                        else if (p && 1 === this.children.length && null != this.children[0].value) q += ">", q += this.children[0].value, q += "</" + this.name + ">", q += n;
                        else {
                            for (q += ">", p && (q += n), w = this.children, i = 0, k = w.length; k > i; i++) d = w[i], q += d.toString(a, b + 1);
                            p && (q += x), q += "</" + this.name + ">", p && (q += n)
                        }
                        return q
                    }, b.prototype.att = function(a, b) {
                        return this.attribute(a, b)
                    }, b.prototype.ins = function(a, b) {
                        return this.instruction(a, b)
                    }, b.prototype.a = function(a, b) {
                        return this.attribute(a, b)
                    }, b.prototype.i = function(a, b) {
                        return this.instruction(a, b)
                    }, b
                }(e)
            }).call(this)
        }, {
            "./XMLAttribute": 166,
            "./XMLNode": 177,
            "./XMLProcessingInstruction": 178,
            "lodash/create": 118,
            "lodash/every": 120,
            "lodash/isFunction": 129,
            "lodash/isObject": 132
        }],
        177: [function(a, b, c) {
            (function() {
                var c, d, e, f, g, h, i, j, k, l, m, n = {}.hasOwnProperty;
                m = a("lodash/isObject"), l = a("lodash/isFunction"), k = a("lodash/isEmpty"), g = null, c = null, d = null, e = null, f = null, i = null, j = null, b.exports = h = function() {
                    function b(b) {
                        this.parent = b, this.options = this.parent.options, this.stringify = this.parent.stringify, null === g && (g = a("./XMLElement"), c = a("./XMLCData"), d = a("./XMLComment"), e = a("./XMLDeclaration"), f = a("./XMLDocType"), i = a("./XMLRaw"), j = a("./XMLText"))
                    }
                    return b.prototype.element = function(a, b, c) {
                        var d, e, f, g, h, i, j, o, p, q;
                        if (i = null, null == b && (b = {}), b = b.valueOf(), m(b) || (p = [b, c], c = p[0], b = p[1]), null != a && (a = a.valueOf()), Array.isArray(a))
                            for (f = 0, j = a.length; j > f; f++) e = a[f], i = this.element(e);
                        else if (l(a)) i = this.element(a.apply());
                        else if (m(a)) {
                            for (h in a)
                                if (n.call(a, h))
                                    if (q = a[h], l(q) && (q = q.apply()), m(q) && k(q) && (q = null), !this.options.ignoreDecorators && this.stringify.convertAttKey && 0 === h.indexOf(this.stringify.convertAttKey)) i = this.attribute(h.substr(this.stringify.convertAttKey.length), q);
                                    else if (!this.options.ignoreDecorators && this.stringify.convertPIKey && 0 === h.indexOf(this.stringify.convertPIKey)) i = this.instruction(h.substr(this.stringify.convertPIKey.length), q);
                            else if (!this.options.separateArrayItems && Array.isArray(q))
                                for (g = 0, o = q.length; o > g; g++) e = q[g], d = {}, d[h] = e, i = this.element(d);
                            else m(q) ? (i = this.element(h), i.element(q)) : i = this.element(h, q)
                        } else i = !this.options.ignoreDecorators && this.stringify.convertTextKey && 0 === a.indexOf(this.stringify.convertTextKey) ? this.text(c) : !this.options.ignoreDecorators && this.stringify.convertCDataKey && 0 === a.indexOf(this.stringify.convertCDataKey) ? this.cdata(c) : !this.options.ignoreDecorators && this.stringify.convertCommentKey && 0 === a.indexOf(this.stringify.convertCommentKey) ? this.comment(c) : !this.options.ignoreDecorators && this.stringify.convertRawKey && 0 === a.indexOf(this.stringify.convertRawKey) ? this.raw(c) : this.node(a, b, c);
                        if (null == i) throw new Error("Could not create any elements with: " + a);
                        return i
                    }, b.prototype.insertBefore = function(a, b, c) {
                        var d, e, f;
                        if (this.isRoot) throw new Error("Cannot insert elements at root level");
                        return e = this.parent.children.indexOf(this), f = this.parent.children.splice(e), d = this.parent.element(a, b, c), Array.prototype.push.apply(this.parent.children, f), d
                    }, b.prototype.insertAfter = function(a, b, c) {
                        var d, e, f;
                        if (this.isRoot) throw new Error("Cannot insert elements at root level");
                        return e = this.parent.children.indexOf(this), f = this.parent.children.splice(e + 1), d = this.parent.element(a, b, c), Array.prototype.push.apply(this.parent.children, f), d
                    }, b.prototype.remove = function() {
                        var a, b;
                        if (this.isRoot) throw new Error("Cannot remove the root element");
                        return a = this.parent.children.indexOf(this), [].splice.apply(this.parent.children, [a, a - a + 1].concat(b = [])), b, this.parent
                    }, b.prototype.node = function(a, b, c) {
                        var d, e;
                        return null != a && (a = a.valueOf()), null == b && (b = {}), b = b.valueOf(), m(b) || (e = [b, c], c = e[0], b = e[1]), d = new g(this, a, b), null != c && d.text(c), this.children.push(d), d
                    }, b.prototype.text = function(a) {
                        var b;
                        return b = new j(this, a), this.children.push(b), this
                    }, b.prototype.cdata = function(a) {
                        var b;
                        return b = new c(this, a), this.children.push(b), this
                    }, b.prototype.comment = function(a) {
                        var b;
                        return b = new d(this, a), this.children.push(b), this
                    }, b.prototype.raw = function(a) {
                        var b;
                        return b = new i(this, a), this.children.push(b), this
                    }, b.prototype.declaration = function(a, b, c) {
                        var d, f;
                        return d = this.document(), f = new e(d, a, b, c), d.xmldec = f, d.root()
                    }, b.prototype.doctype = function(a, b) {
                        var c, d;
                        return c = this.document(), d = new f(c, a, b), c.doctype = d, d
                    }, b.prototype.up = function() {
                        if (this.isRoot) throw new Error("The root node has no parent. Use doc() if you need to get the document object.");
                        return this.parent
                    }, b.prototype.root = function() {
                        var a;
                        if (this.isRoot) return this;
                        for (a = this.parent; !a.isRoot;) a = a.parent;
                        return a
                    }, b.prototype.document = function() {
                        return this.root().documentObject
                    }, b.prototype.end = function(a) {
                        return this.document().toString(a)
                    }, b.prototype.prev = function() {
                        var a;
                        if (this.isRoot) throw new Error("Root node has no siblings");
                        if (a = this.parent.children.indexOf(this), 1 > a) throw new Error("Already at the first node");
                        return this.parent.children[a - 1]
                    }, b.prototype.next = function() {
                        var a;
                        if (this.isRoot) throw new Error("Root node has no siblings");
                        if (a = this.parent.children.indexOf(this), -1 === a || a === this.parent.children.length - 1) throw new Error("Already at the last node");
                        return this.parent.children[a + 1]
                    }, b.prototype.importXMLBuilder = function(a) {
                        var b;
                        return b = a.root().clone(), b.parent = this, b.isRoot = !1, this.children.push(b), this
                    }, b.prototype.ele = function(a, b, c) {
                        return this.element(a, b, c)
                    }, b.prototype.nod = function(a, b, c) {
                        return this.node(a, b, c)
                    }, b.prototype.txt = function(a) {
                        return this.text(a)
                    }, b.prototype.dat = function(a) {
                        return this.cdata(a)
                    }, b.prototype.com = function(a) {
                        return this.comment(a)
                    }, b.prototype.doc = function() {
                        return this.document()
                    }, b.prototype.dec = function(a, b, c) {
                        return this.declaration(a, b, c)
                    }, b.prototype.dtd = function(a, b) {
                        return this.doctype(a, b)
                    }, b.prototype.e = function(a, b, c) {
                        return this.element(a, b, c)
                    }, b.prototype.n = function(a, b, c) {
                        return this.node(a, b, c)
                    }, b.prototype.t = function(a) {
                        return this.text(a)
                    }, b.prototype.d = function(a) {
                        return this.cdata(a)
                    }, b.prototype.c = function(a) {
                        return this.comment(a)
                    }, b.prototype.r = function(a) {
                        return this.raw(a)
                    }, b.prototype.u = function() {
                        return this.up()
                    }, b
                }()
            }).call(this)
        }, {
            "./XMLCData": 168,
            "./XMLComment": 169,
            "./XMLDeclaration": 174,
            "./XMLDocType": 175,
            "./XMLElement": 176,
            "./XMLRaw": 179,
            "./XMLText": 181,
            "lodash/isEmpty": 128,
            "lodash/isFunction": 129,
            "lodash/isObject": 132
        }],
        178: [function(a, b, c) {
            (function() {
                var c, d;
                d = a("lodash/create"), b.exports = c = function() {
                    function a(a, b, c) {
                        if (this.stringify = a.stringify, null == b) throw new Error("Missing instruction target");
                        this.target = this.stringify.insTarget(b), c && (this.value = this.stringify.insValue(c))
                    }
                    return a.prototype.clone = function() {
                        return d(a.prototype, this)
                    }, a.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += "<?", g += this.target, this.value && (g += " " + this.value), g += "?>", f && (g += d), g
                    }, a
                }()
            }).call(this)
        }, {
            "lodash/create": 118
        }],
        179: [function(a, b, c) {
            (function() {
                var c, d, e, f = function(a, b) {
                        function c() {
                            this.constructor = a
                        }
                        for (var d in b) g.call(b, d) && (a[d] = b[d]);
                        return c.prototype = b.prototype, a.prototype = new c, a.__super__ = b.prototype, a
                    },
                    g = {}.hasOwnProperty;
                e = a("lodash/create"), c = a("./XMLNode"), b.exports = d = function(a) {
                    function b(a, c) {
                        if (b.__super__.constructor.call(this, a), null == c) throw new Error("Missing raw text");
                        this.value = this.stringify.raw(c)
                    }
                    return f(b, a), b.prototype.clone = function() {
                        return e(b.prototype, this)
                    }, b.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += this.value, f && (g += d), g
                    }, b
                }(c)
            }).call(this)
        }, {
            "./XMLNode": 177,
            "lodash/create": 118
        }],
        180: [function(a, b, c) {
            (function() {
                var a, c = function(a, b) {
                        return function() {
                            return a.apply(b, arguments)
                        }
                    },
                    d = {}.hasOwnProperty;
                b.exports = a = function() {
                    function a(a) {
                        this.assertLegalChar = c(this.assertLegalChar, this);
                        var b, e, f;
                        this.allowSurrogateChars = null != a ? a.allowSurrogateChars : void 0, this.noDoubleEncoding = null != a ? a.noDoubleEncoding : void 0, e = (null != a ? a.stringify : void 0) || {};
                        for (b in e) d.call(e, b) && (f = e[b], this[b] = f)
                    }
                    return a.prototype.eleName = function(a) {
                        return a = "" + a || "", this.assertLegalChar(a)
                    }, a.prototype.eleText = function(a) {
                        return a = "" + a || "", this.assertLegalChar(this.elEscape(a))
                    }, a.prototype.cdata = function(a) {
                        if (a = "" + a || "", a.match(/]]>/)) throw new Error("Invalid CDATA text: " + a);
                        return this.assertLegalChar(a)
                    }, a.prototype.comment = function(a) {
                        if (a = "" + a || "", a.match(/--/)) throw new Error("Comment text cannot contain double-hypen: " + a);
                        return this.assertLegalChar(a)
                    }, a.prototype.raw = function(a) {
                        return "" + a || ""
                    }, a.prototype.attName = function(a) {
                        return "" + a || ""
                    }, a.prototype.attValue = function(a) {
                        return a = "" + a || "", this.attEscape(a)
                    }, a.prototype.insTarget = function(a) {
                        return "" + a || ""
                    }, a.prototype.insValue = function(a) {
                        if (a = "" + a || "", a.match(/\?>/)) throw new Error("Invalid processing instruction value: " + a);
                        return a
                    }, a.prototype.xmlVersion = function(a) {
                        if (a = "" + a || "", !a.match(/1\.[0-9]+/)) throw new Error("Invalid version number: " + a);
                        return a
                    }, a.prototype.xmlEncoding = function(a) {
                        if (a = "" + a || "", !a.match(/^[A-Za-z](?:[A-Za-z0-9._-]|-)*$/)) throw new Error("Invalid encoding: " + a);
                        return a
                    }, a.prototype.xmlStandalone = function(a) {
                        return a ? "yes" : "no"
                    }, a.prototype.dtdPubID = function(a) {
                        return "" + a || ""
                    }, a.prototype.dtdSysID = function(a) {
                        return "" + a || ""
                    }, a.prototype.dtdElementValue = function(a) {
                        return "" + a || ""
                    }, a.prototype.dtdAttType = function(a) {
                        return "" + a || ""
                    }, a.prototype.dtdAttDefault = function(a) {
                        return null != a ? "" + a || "" : a
                    }, a.prototype.dtdEntityValue = function(a) {
                        return "" + a || ""
                    }, a.prototype.dtdNData = function(a) {
                        return "" + a || ""
                    }, a.prototype.convertAttKey = "@", a.prototype.convertPIKey = "?", a.prototype.convertTextKey = "#text", a.prototype.convertCDataKey = "#cdata", a.prototype.convertCommentKey = "#comment", a.prototype.convertRawKey = "#raw", a.prototype.assertLegalChar = function(a) {
                        var b, c;
                        if (b = this.allowSurrogateChars ? /[\u0000-\u0008\u000B-\u000C\u000E-\u001F\uFFFE-\uFFFF]/ : /[\u0000-\u0008\u000B-\u000C\u000E-\u001F\uD800-\uDFFF\uFFFE-\uFFFF]/, c = a.match(b)) throw new Error("Invalid character (" + c + ") in string: " + a + " at index " + c.index);
                        return a
                    }, a.prototype.elEscape = function(a) {
                        var b;
                        return b = this.noDoubleEncoding ? /(?!&\S+;)&/g : /&/g, a.replace(b, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\r/g, "&#xD;")
                    }, a.prototype.attEscape = function(a) {
                        var b;
                        return b = this.noDoubleEncoding ? /(?!&\S+;)&/g : /&/g, a.replace(b, "&amp;").replace(/</g, "&lt;").replace(/"/g, "&quot;")
                    }, a
                }()
            }).call(this)
        }, {}],
        181: [function(a, b, c) {
            (function() {
                var c, d, e, f = function(a, b) {
                        function c() {
                            this.constructor = a
                        }
                        for (var d in b) g.call(b, d) && (a[d] = b[d]);
                        return c.prototype = b.prototype, a.prototype = new c, a.__super__ = b.prototype, a
                    },
                    g = {}.hasOwnProperty;
                e = a("lodash/create"), c = a("./XMLNode"), b.exports = d = function(a) {
                    function b(a, c) {
                        if (b.__super__.constructor.call(this, a), null == c) throw new Error("Missing element text");
                        this.value = this.stringify.eleText(c)
                    }
                    return f(b, a), b.prototype.clone = function() {
                        return e(b.prototype, this)
                    }, b.prototype.toString = function(a, b) {
                        var c, d, e, f, g, h, i, j, k;
                        return f = (null != a ? a.pretty : void 0) || !1, c = null != (h = null != a ? a.indent : void 0) ? h : "  ", e = null != (i = null != a ? a.offset : void 0) ? i : 0, d = null != (j = null != a ? a.newline : void 0) ? j : "\n", b || (b = 0), k = new Array(b + e + 1).join(c), g = "", f && (g += k), g += this.value, f && (g += d), g
                    }, b
                }(c)
            }).call(this)
        }, {
            "./XMLNode": 177,
            "lodash/create": 118
        }],
        182: [function(a, b, c) {
            (function() {
                var c, d;
                d = a("lodash/assign"), c = a("./XMLBuilder"), b.exports.create = function(a, b, e, f) {
                    return f = d({}, b, e, f), new c(a, f).root()
                }
            }).call(this)
        }, {
            "./XMLBuilder": 167,
            "lodash/assign": 117
        }]
    }, {}, [16])(16)
});