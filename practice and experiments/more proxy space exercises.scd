p = ProxySpace.push(s.boot)

(
SynthDef(\test, {|freq=440|
	Out.ar(0, SinOsc.ar(freq) * EnvGen.ar(Env.perc(), doneAction: 2));
}).add
)

~sin = {SinOsc.kr(10, mul: 5, add: 50)}


~x = {|freq=440| SawDPW.ar(freq)}

~x.play
~x.set(\freq, ~sin)

~x = Pbind(\instrument, \test, \freq, ~sin)


~sin.bus

~y = {SinOsc.ar([50, 51])}
~y.play
~y.stop