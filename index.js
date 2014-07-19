require('coffee-script');

if (module != null){
	module.exports = require('./lib/quanta');
} else if (window != null){
	window.Quantum = require('./lib/quantum');
}
