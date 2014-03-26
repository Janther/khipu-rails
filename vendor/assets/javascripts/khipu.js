/**
 * Created by Alejandro Vera @ khipu SpA on 2/7/14.
 * Contact at alejandro.vera@khipu.com
 *
 */
var kh = jQuery.noConflict();

KhipuAtmosphere = {}

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
                document.location.href = message.location
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
}

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
            KhipuLib.defaultMobile();
            return;
        }

        var isInstalled = KhipuLib.isInstalled();
        if (isInstalled) {
            KhipuAtmosphere.statusServer.socket = atmosphere;
            KhipuAtmosphere.statusServer.subscribe({url: KhipuSettings.serverUrl + 'atm/payment/status/' + KhipuLib.options.paymentId});
            if (KhipuLib.options.onSuccess != null) {
                KhipuLib.options.onSuccess();
            } else {
                KhipuLib.defaultOnSuccess();
            }
        } else {
            if (KhipuLib.options.onNotInstalled) {
                KhipuLib.options.onNotInstalled(KhipuLib.installUrl + '/' + KhipuLib.options.paymentId + '?returnUrl=' + encodeURIComponent(KhipuLib.options.returnUrl));
            } else {
                KhipuLib.defaultOnNotInstalled();
            }
        }
        return isInstalled;
    },
    defaultMobile: function () {
        if (KhipuLib.options.elementId != null) {
            var element = kh('#' + KhipuLib.options.elementId);
            element.click(function () {
                document.location.href = KhipuSettings.serverUrl + 'payment/show/' + KhipuLib.options.paymentId;
            });
            element.prop('disabled', false);
        }
    },
    defaultOnNotInstalled: function () {
        if (KhipuLib.options.elementId != null) {
            var element = kh('#' + KhipuLib.options.elementId);
            element.click(function () {
                KhipuLib.showNotInstalledModal();
            });
            element.prop('disabled', false);
        }
    },
    goToKhipu: function () {
        document.location.href = KhipuLib.installUrl + '/' + KhipuLib.options.paymentId + '?returnUrl=' + encodeURIComponent(KhipuLib.options.returnUrl);
    },
    showWaitAppModal: function () {
        KhipuLib.showModal({
            html: 'Espere mientras se levanta el terminal del pagos khipu...',
            okCallBack: KhipuLib.goToKhipu,
            height: 100,
            width: 460,
            classes: 'khipu-wait-app-modal',
            closeOnClick: false
        });
    },
    showNotInstalledModal: function () {
        KhipuLib.showModal({
            html: '<iframe width="100%" height="345px" scrolling="no" frameBorder="0" src="https://khipu.com/page/instalar-en-khipu?layout=minimal"></iframe>',
            okLabel: 'Ir a instalar khipu',
            okCallBack: KhipuLib.goToKhipu,
            height: 450,
            width: 600
        });
    },
    hideWaitAppModal: function () {
        kh('.khipu-wait-app-modal').remove();
        kh('.khipu-wait-app-modal-overlay').remove();
    },
    appNotInstalled: function () {
        KhipuLib.hideWaitAppModal();
        KhipuLib.showModal({
            html: '<iframe width="100%" height="345px" scrolling="no" frameBorder="0" src="https://khipu.com/page/instalar-en-khipu?layout=minimal"></iframe>',
            okLabel: 'Ir a instalar khipu',
            okCallBack: KhipuLib.goToKhipu,
            height: 450,
            width: 600
        });
    },
    showModal: function (options) {
        var modalName = 'khipu-modal-window-' + KhipuLib.makeId();
        kh('head').append('<style>.khipu-clearfix:after { content: " "; visibility: hidden; display: block; height: 0; clear: both;}</style>');
        var overlay = document.createElement('div');
        overlay.id = modalName + 'overlay';
        kh(overlay).css({width: '100%', height: '100%', top: 0, left: 0, position: 'fixed', 'opacity': '0.8', 'background-color': '#000000', 'z-index': 500});
        var closeOnClick = typeof options.closeOnClick == 'undefined' ? true : options.closeOnClick;
        if (closeOnClick) {
            kh(overlay).click(function () {
                KhipuLib.closeModal(modalName);
            });
        }
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

        if (options.okLabel) {
            var button = document.createElement('button');
            kh(button).text(options.okLabel);
            if (options.okCallBack) {
                kh(button).click(options.okCallBack);
            }
            kh(button).css({
                'background': 'transparent',
                'background-color': '#3c2c70',
                'border-color': '#32255e',
                'display': 'inline-block',
                'float': 'right',
                'border': 'none',
                'width': 'auto',
                'overflow': 'visible',
                'color': '#FFF',
                'padding': '6px 12px',
                'border-radius': '4px',
                '-webkit-border-radius': '4px',
                '-moz-border-radius': '4px',
                'font-weight': 'normal',
                'font-size': '14px',
                'line-height': '1.428571429',
                'text-align': 'center',
                'text-decoration': 'none',
                'cursor': 'pointer',
                'text-shadow': '0 1px 0 rgba(0,0,0,0.4)',
                'vertical-align': ' middle',
                'background-image': ' none',
                'font-family': ' "Helvetica Neue",Helvetica,Arial,sans-serif',
                '-webkit-user-select': ' none',
                '-moz-user-select': ' none',
                '-ms-user-select': ' none',
                '-o-user-select': ' none',
                'margin': '0 5px 10px'
            });

            var closeLink = document.createElement('a');
            kh(closeLink).html('Cerrar');
            kh(closeLink).click(function () {
                KhipuLib.closeModal(modalName);
            });
            kh(closeLink).attr('href', 'javascript:void(0)');
            var buttons = document.createElement('div');
            buttons.id = 'buttons-wrapper';
            kh(buttons).addClass('khipu-clearfix');
            kh(buttons).css({'font-family': '"Helvetica Neue", "Helvetica", "Arial", "sans-serif"'})
            buttons.appendChild(button);
            buttons.appendChild(closeLink);

            modalWrapper.appendChild(buttons);
        }

        kh('#' + modalName + ' iframe').css('overflow', 'hidden');
        kh('#' + modalName + ' .modal-header h2').css({
            'background-color': '#e3e3e3',
            'color': '#444',
            'font-size': '2em',
            'font-weight': '700',
            'margin': '3px',
            'text-shadow': '1px 1px 0'
        });
        if (options.okLabel) {
            kh(buttons).css({
                width: '100%',
                'margin-top': '10px',
                'height': '50px'
            });
            kh(closeLink).css({
                'margin-right': '10px',
                'background-color': 'transparent',
                'background': 'transparent',
                'background-image': 'none',
                'border-radius': '0',
                'border': '1px solid transparent',
                'box-shadow': 'none',
                'color': '#2cbbe8',
                'cursor': 'pointer',
                'display': 'inline-block',
                'float': 'right',
                'font-family': ' "Helvetica Neue",Helvetica,Arial,sans-serif',
                'font-size': '14px',
                'font-weight': 'normal',
                'line-height': '1.428571429',
                'margin-bottom': '0',
                'padding': '6px 12px',
                'text-align': 'center',
                'text-decoration': 'none',
                'text-shadow': 'none',
                'user-select': 'none',
                'white-space': 'nowrap',
                'vertical-align': 'middle',
                '-moz-user-select': 'none',
                '-ms-user-select': 'none',
                '-o-user-select': 'none',
                '-webkit-box-shadow': 'none',
                '-webkit-user-select': 'none'
            });
        }
        kh(overlay).fadeIn();
        kh(modal).fadeIn();

    },
    closeModal: function (modalName) {
        kh('#' + modalName + 'overlay').fadeOut("fast", function () {
            kh('#' + modalName + 'overlay').remove()
        });
        kh('#' + modalName).fadeOut("fast", function () {
            kh('#' + modalName).remove()
        });
    },
    defaultOnSuccess: function () {
        if (KhipuLib.options.elementId != null) {
            var element = document.getElementById(KhipuLib.options.elementId);
            if (element != null) {
                var paymentId = KhipuLib.options.paymentId;
                element.onclick = function () {
                    KhipuLib.startKhipu(paymentId);
                };
                if (element.disabled) {
                    element.disabled = false;
                }
            }
        }
    },
    startKhipu: function (paymentId) {
        if (KhipuLib.isChrome()) {
            KhipuLib.sendEvent('startKhipuEvent', paymentId + '|' + false)
            KhipuLib.showWaitAppModal();
            KhipuLib.verifyKhipuInstalled = setTimeout(KhipuLib.appNotInstalled, 10000);
        } else {
            var khPlugin = document.getElementById('khPlugin');
            khPlugin.callKH(KhipuSettings.serverUrl + 'payment/getPaymentData/' + paymentId)
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
