let Language = {};

const BotEditor = (new function BotEditor() {
	const DEBUG				= true;
	const VERSION			= '1.0.0-Beta';
	const InputDeviceKeys	= {
		IDK_F1:		112,
		IDK_F2:		113,
		IDK_F3:		114,
		IDK_F4:		115,
		IDK_F5:		116,
		IDK_F6:		117,
		IDK_F7:		118,
		IDK_F8:		119,
		IDK_F9:		120,
		IDK_F10:	121,
		IDK_F11:	122,
		IDK_F12:	123
	};
	let _language = 'en_US';
	
	this.__constructor = function __constructor() {
		console.log('Init BotEditor UI (v' + VERSION + ') by https://github.com/Bizarrus.');
		
		this.bindMouseEvents();
		this.bindKeyboardEvents();
	};
	
	this.bindKeyboardEvents = function() {
		document.body.addEventListener('mousedown', function onMouseDown(event) {
			if(!event) {
				event = window.event;
			}
			
			var parent = Utils.getClosest(event.target, '[data-action]');
			
			if([
				'INPUT'
			].indexOf(event.target.nodeName) >= 0) {
				if(DEBUG) {
					console.warn('Parent is an form element!', parent);
				}
				
				return;
			}
			
			if(typeof(parent) == 'undefined') {
				if(DEBUG) {
					console.warn('Parent is undefined', parent);
				}
				
				return;
			}
			
			if(DEBUG) {
				console.log('CLICK', parent.dataset.action);
			}
			
			switch(parent.dataset.action) {
				/* Exit */
				case 'close':
					WebUI.Call('DispatchEventLocal', 'UI_Toggle');
				break;
				
				/* Sumbit Forms */
				case 'submit':
					let form	= Utils.getClosest(event.target, 'ui-view').querySelector('[data-type="form"]');
					let action	= form.dataset.action;
					let data	= {};
					
					[].map.call(form.querySelectorAll('input[type="text"], input[type="password"]'), function onInputEntry(input) {
						data[input.name] = input.value;
					});
					
					WebUI.Call('DispatchEventLocal', action, JSON.stringify(data));
				break;
				
				/* Bots */
				case 'bot_spawn_default':
					count = document.querySelector('[data-action="bot_spawn_default"] input[type="number"]');
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'bot_spawn_default',
						value:	count.value
					}));
					count.value = 1;
				break;
				case 'bot_spawn_random':
					count = document.querySelector('[data-action="bot_spawn_random"] input[type="number"]');
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'bot_spawn_random',
						value:	count.value
					}));
					count.value = 1;
				break;
				case 'bot_kick_all':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'bot_kick_all'
					}));
				break;
				case 'bot_respawn':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'bot_respawn'
					}));
				break;
				
				/* Trace */
				case 'trace_toggle':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_toggle'
					}));
				break;
				case 'trace_clear_current':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_clear_current'
					}));
				break;
				case 'trace_reset_all':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_reset_all'
					}));
				break;
				case 'trace_save':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_save'
					}));
				break;
				case 'trace_reload':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_reload'
					}));
				break;
				case 'trace_show':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_show'
					}));
				break;
				
				/* Settings */
				case 'request_settings':
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'request_settings'
					}));
				break;
			}
		}.bind(this));
	};
	
	this.bindMouseEvents = function() {
		document.body.addEventListener('keydown', function onMouseDown(event) {
			let count;
			
			switch(event.keyCode || event.which) {
				/* Bots */
				case InputDeviceKeys.IDK_F1:
					count = document.querySelector('[data-action="bot_spawn_default"] input[type="number"]');
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'bot_spawn_default',
						value:	count.value
					}));
					count.value = 1;
				break;
				case InputDeviceKeys.IDK_F2:
					count = document.querySelector('[data-action="bot_spawn_random"] input[type="number"]');
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'bot_spawn_random',
						value:	count.value
					}));
					count.value = 1;
				break;
				case InputDeviceKeys.IDK_F3:
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'bot_kick_all'
					}));
				break;
				case InputDeviceKeys.IDK_F4:
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'bot_respawn'
					}));
				break;
				
				/* Trace */
				case InputDeviceKeys.IDK_F5:
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_toggle'
					}));
				break;
				case InputDeviceKeys.IDK_F7:
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_clear_current'
					}));
				break;
				case InputDeviceKeys.IDK_F8:
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_reset_all'
					}));
				break;
				case InputDeviceKeys.IDK_F9:
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_save'
					}));
				break;
				case InputDeviceKeys.IDK_F11:
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'trace_reload'
					}));
				break;
				
				/* Settings */
				case InputDeviceKeys.IDK_F10:
					WebUI.Call('DispatchEventLocal', 'BotEditor', JSON.stringify({
						action:	'request_settings'
					}));
				break;
				
				/* Exit */
				case InputDeviceKeys.IDK_F12:
					WebUI.Call('DispatchEventLocal', 'UI_Toggle');
				break;
			}
		});
	};
	
	/* Translate */
	this.loadLanguage = function loadLanguage(string) {
		if(DEBUG) {
			console.log('Trying to loading language file:', string);
		}
		
		let script	= document.createElement('script');
		script.type	= 'text/javascript';
		script.src	= 'languages/' + string + '.js';
		
		script.onload = function onLoad() {
			if(DEBUG) {
				console.log('Language file was loaded:', string);
			}
			
			_language = string;
			
			this.reloadLanguageStrings();
		}.bind(this);
		
		script.onerror = function onError() {
			if(DEBUG) {
				console.log('Language file was not exists:', string);
			}
		};
		
		document.body.appendChild(script);
	};
	
	this.reloadLanguageStrings = function reloadLanguageStrings() {
		[].map.call(document.querySelectorAll('[data-lang]'), function(element) {
			element.innerHTML = this.I18N(element.innerHTML);
		}.bind(this));
	};
	
	this.I18N = function I18N(string) {
		if(DEBUG) {
			let translated = null;
			
			try {
				translated = Language[_language][string];
			} catch(e){}
			
			console.log('[Translate]', _language, '=', string, 'to', translated);
		}
		
		/* If Language exists */
		if(typeof(Language[_language]) !== 'undefined') {
			/* If translation exists */
			if(typeof(Language[_language][string]) !== 'undefined') {
				return Language[_language][string];
			}
		}
		
		return string;
	};
	
	this.toggleTraceRun = function toggleTraceRun(state) {
		let menu	= document.querySelector('[data-lang="Start Trace"]');
		let string	= 'Start Trace';
		
		if(state) {
			string = 'Stop Trace';
		}
		
		menu.innerHTML = this.I18N(string);
	};
	
	this.getView = function getView(name) {
		return document.querySelector('ui-view[data-name="' + name + '"]');
	};
	
	this.show = function show(name) {
		if(DEBUG) {
			console.log('Show View: ', name);
		}
		
		let view = this.getView(name);
		
		switch(name) {
			/* Reset Error-Messages & Password field on opening */
			case 'password':
				view.querySelector('ui-error').innerHTML				= '';
				let password		= view.querySelector('input[type="password"]');
				password.value		= '';
				password.focus();
			break;
		}
		
		view.dataset.show = true;
		view.setAttribute('data-show', 'true');
	};
	
	this.hide = function hide(name) {
		if(DEBUG) {
			console.log('Hide View: ', name);
		}
		
		let view = this.getView(name);
		
		view.dataset.show = false;
		view.setAttribute('data-show', 'false');
	};
	
	this.error = function error(name, text) {
		if(DEBUG) {
			console.log('Error View: ', name);
		}
		
		this.getView(name).querySelector('ui-error').innerHTML = text;
	};
	
	this.__constructor.apply(this, arguments);
}());