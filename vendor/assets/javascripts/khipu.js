/**
 * Created by Alejandro Vera @ khipu SpA on 2/7/14.
 * Contact at alejandro.vera@khipu.com
 *
 */
var kh = jQuery.noConflict();

KhipuAtmosphere = {};

KhipuAtmosphere.statusServer = {
    socket: null,
    subscription: null,
    transport: null,
    onMessageCallback: null,
    subscribe: function (options) {
        var defaults = {
            type: '',
            contentType: 'application/json',
            shared: false,
            transport: 'websocket',
            reconnect: true,
            fallbackTransport: 'long-polling',
            enableProtocol: true,
            trackMessageLength: true
        };
        var statusRequest = kh.extend({}, defaults, options);
        KhipuAtmosphere.statusServer.onMessageCallback = options.onMessageCallback;
        statusRequest.onOpen = function (response) {
        };
        statusRequest.onReconnect = function (request, response) {
        };
        statusRequest.onMessage = function (response) {
            var message = JSON.parse(response.responseBody);
            if (message.lastEvent == 'notified-ok') {
                document.location.href = message.location;
            } else if (message.lastEvent == 'automaton-downloaded') {
                KhipuLib.hideWaitAppModal();
                clearTimeout(KhipuLib.verifyKhipuInstalled);
            }
        };
        statusRequest.onError = function (response) {
        };
        statusRequest.onTransportFailure = function (errorMsg, request) {
        };
        statusRequest.onClose = function (response) {
        };
        KhipuAtmosphere.statusServer.subscription = KhipuAtmosphere.statusServer.socket.subscribe(statusRequest);
    },
    unsubscribe: function () {
        KhipuAtmosphere.statusServer.socket.unsubscribe();
    }
};

KhipuSettings = {
    serverUrl: 'https://khipu.com/'
};

KhipuLib = {
    verifyKhipuInstalled: 0,
    isChrome: function () {
        return window.chrome;
    },
    isIE: function () {
        return navigator.appName == 'Microsoft Internet Explorer';
    },
    installUrl: KhipuSettings.serverUrl + 'installer/tryInstalled',
    isMobile: function () {
        return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Mini/i.test(navigator.userAgent);
    },
    isInstalled: function () {
        if (window.chrome) {
            return document.querySelector('div#extension-kmmojbkhfhninkelnlcnliacgncnnikf-installed') != null;
        }
        if (KhipuLib.isIE()) {
            var wrapper = document.createElement('div');
            wrapper.id = 'khipu-plugin-wrapper';
            document.documentElement.appendChild(wrapper);
            document.getElementById('khipu-plugin-wrapper').innerHTML = '<object id="khPlugin" type="application/x-KHPlugin" width="0" height="0"><param name="onload" value="pluginLoaded"/></object>';
            navigator.plugins.refresh(false);
        } else {
            navigator.plugins.refresh(false);
            var emb = document.createElement('embed');
            emb.id = 'khPlugin';
            emb.type = 'application/x-KHPlugin';
            emb.width = 0;
            emb.height = 0;
            document.documentElement.appendChild(emb);
            navigator.plugins.refresh(false);
        }
        var khPlugin = document.getElementById('khPlugin');
        return khPlugin != null && khPlugin.callKH != undefined && khPlugin.callKH != null;
    },
    options: { },
    onLoad: function (params) {
        if (document.getElementById('khipu-chrome-extension-div') != null) {
            document.getElementById('khipu-chrome-extension-div').style.display = 'none';
        }
        for (var property in params) {
            if (params.hasOwnProperty(property)) {
                KhipuLib.options[property] = params[property];
            }
        }
        if (KhipuLib.isMobile()) {
            KhipuLib.onIsMobile();
            return;
        }

        if (KhipuLib.isInstalled()) {
            KhipuAtmosphere.statusServer.socket = atmosphere;
            KhipuAtmosphere.statusServer.subscribe({url: KhipuSettings.serverUrl + 'atm/payment/status/' + KhipuLib.options.data.id});
            KhipuLib.onInstalled();
        } else {
            KhipuLib.onNotInstalled();
        }
    },
    onIsMobile: function () {
        if (KhipuLib.options.elementId != null) {
            var element = kh('#' + KhipuLib.options.elementId);
            element.click(function () {
                document.location.href = KhipuLib.options.data.url;
            });
            element.prop('disabled', false);
        } else {
            document.location.href = KhipuLib.options.data.url;
        }
    },
    onNotInstalled: function () {
        if (KhipuLib.options.elementId != null) {
            var element = kh('#' + KhipuLib.options.elementId);
            element.click(function () {
                document.location.href = KhipuLib.options.data.url;
            });
            element.prop('disabled', false);
        } else {
            document.location.href = KhipuLib.options.data.url;
        }
    },
    sendToKhipu: function () {
        if (KhipuLib.options.data) {
            document.location.href = KhipuLib.options.data.url;
        }
    },
    showWaitAppModal: function () {
        KhipuLib.showModal({
            html: 'Espere mientras se levanta el terminal del pagos khipu...',
            height: 100,
            width: 460,
            classes: 'khipu-wait-app-modal'
        });
    },
    hideWaitAppModal: function () {
        kh('.khipu-wait-app-modal').remove();
        kh('.khipu-wait-app-modal-overlay').remove();
    },
    showModal: function (options) {
        var modalName = 'khipu-modal-window-' + KhipuLib.makeId();
        var overlay = document.createElement('div');
        overlay.id = modalName + 'overlay';
        kh(overlay).css({width: '100%', height: '100%', top: 0, left: 0, position: 'fixed', 'opacity': '0.8', 'background-color': '#000000', 'z-index': 500});
        document.body.appendChild(overlay);
        var modal = document.createElement('div');
        modal.id = modalName;
        if (options.classes) {
            kh(modal).addClass(options.classes);
            kh(overlay).addClass(options.classes + '-overlay');
        }
        kh(modal).css({'display': 'none',
            'width': options.width + 'px',
            'height': options.height + 'px',
            'background-color': '#ffffff',
            'position': 'fixed',
            'z-index': 10000,
            'left': Math.max(0, ((kh(window).width() - options.width) / 2) + kh(window).scrollLeft()) + "px",
            'top': Math.max(0, ((kh(window).height() - options.height) / 2) + kh(window).scrollTop()) + "px",
            'border-radius': '5px',
            'box-shadow': '0px 0px 4px rgba(0,0,0,0.7)',
            'color': '#333333',
            'padding': '0'
        });

        var modalWrapper = document.createElement('div');
        kh(modalWrapper).css({'padding': '30px'});
        modal.appendChild(modalWrapper);

        document.body.appendChild(modal);

        var contentWrapper = document.createElement('div');
        kh(contentWrapper).html(options.html);
        modalWrapper.appendChild(contentWrapper);

        kh(overlay).fadeIn();
        kh(modal).fadeIn();
    },
    onInstalled: function () {
        if (KhipuLib.options.data != null) {
            if (!KhipuLib.options.data['ready-for-terminal']) {
                document.location.href = KhipuLib.options.data.url;
                return;
            }
            if (KhipuLib.options.elementId != null) {
                var element = kh('#' + KhipuLib.options.elementId);
                kh(element).click(function () {
                    KhipuLib.startKhipu();
                });
                if (element.disabled) {
                    element.disabled = false;
                }
            } else {
                KhipuLib.startKhipu();
            }
        }
    },
    startKhipu: function () {
        if (KhipuLib.isChrome()) {
            KhipuLib.sendEvent('startKhipuEvent', KhipuLib.options.data.id + '|' + false);
            KhipuLib.showWaitAppModal();
            KhipuLib.verifyKhipuInstalled = setTimeout(KhipuLib.sendToKhipu, 10000);
        } else {
            var khPlugin = document.getElementById('khPlugin');
            khPlugin.callKH(KhipuSettings.serverUrl + 'payment/getPaymentData/' + KhipuLib.options.data.id);
        }
    },
    sendEvent: function (type, data) {
        var event = document.createEvent('Event');
        event.initEvent(type, true, true);
        var eventDiv = document.getElementById('khipu-chrome-extension-div');
        eventDiv.innerText = data;
        eventDiv.dispatchEvent(event);
    },
    makeId: function () {
        var ret = '';
        var pallete = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        for (var i = 0; i < 10; i++) {
            ret += pallete.charAt(Math.floor(Math.random() * pallete.length));
        }
        return ret;
    }
};
