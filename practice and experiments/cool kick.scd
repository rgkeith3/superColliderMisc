p = ProxySpace.push(s.boot)


SynthDef(\kic, {|out=0, pan=0, q=0.1, pAmt=10, freq=50, pTime=0.1, filt=1500, bitStart=1, bitEnd=4|
	Out.ar(out, Pan2.ar(EnvGen.ar(Env.perc(), doneAction: 2) * Decimator.ar(RLPF.ar(Saw.ar(XLine.ar(freq* pAmt, freq, pTime)), filt, q), bits: XLine.ar(bitStart, bitEnd)), pan));
}).add

~a = Pbind(\instrument, \kic, \dur, Pseq([2, 1, Pseq([1/6], 4), 1/3], inf) / 2, \octave, 2, \q, 0.05, \pan, Pbrown(-1), \pAmt, 10, \pTime, 0.1, \filt, Prand([500, 1500, 250], inf), \bitStart, 1, \bitEnd, 4)

~a.scope