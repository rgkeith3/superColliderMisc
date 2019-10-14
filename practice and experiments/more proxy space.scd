x = NodeProxy.control(s, 1)
x.source = {Pulse.ar(y, mul: 50, add: 500)}
x.play
y = NodeProxy.control(s, 1)
y.source = {LFNoise0.kr(1, 15, 16)}

Pbind(\freq, x).play