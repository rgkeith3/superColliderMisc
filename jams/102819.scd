(SynthDef(\kick, {
	|freq=440, atk=0.01, dec=0.1, pDec=0.05, pAmt=1 pan=0, out=0|
	var env, pEnv, sig;
	env = EnvGen.ar(Env.perc(atk, dec), doneAction: 2);
	pEnv = EnvGen.ar(Env.perc(0, pDec), levelScale: pAmt *freq, levelBias: freq);
	sig = SinOsc.ar(pEnv) * env;

	Out.ar(out, Pan2.ar(sig, pan));
}
).add)
s.boot


(SynthDef(\tik, {
	|dec=0.01, pan=0, out=0|
	var sig = WhiteNoise.ar() * Line.kr(1, 0, dec, doneAction: 2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add)

currentEnvironment

p =  ProxySpace.push(s)

~tik.play
p.quant_(4)
~tik = Pbind(\instrument, \tik, \pan, Pwhite(-1.0, 1), \dur, 1/8, \dec, 0.005)
~kik = Pbind(\instrument, \kick, \pAmt, 5, \dec, 0.5, \freq, 50, \pDec, 0.1, \dur, 1/2)
~bas = Pbind(\instrument, \kick, \pAmt, -5, \pDec, 0.5, \dec, 2, \degree, Pwrand([1, 5, 7], [0.8, 0.1, 0.1], inf), \octave, 3)
~bas = nil
~kik.play
~kik.stop
~a = Pbind(\dur, Pwhite(0.001, 0.1), \degree, Prand([1, 3, 5,7], inf), \scale, Scale.major.degrees, \legato, Pwhite(0.8, 2), \pan, Pwhite(-1.0))

~a.play
~a.stop

~comp = {Compander.ar(~detrv, ~kik, slopeBelow: 0.5, slopeAbove: 0.5, mul: 0.8)}

~comp.play

~arp = Pbind(\degree, Pseq([2,4, 5,9], inf), \octave, 6, \dur, 1/8, \pan, PSinOsc(0.2))
~arp.play(fadeTime: 10)

(
a = {|in| in.ar.collect {|sig| sig + AllpassL.ar(sig, 0.05, LFNoise1.kr(Rand(0.1, 0.5), 0.025, 0.0251), 0.5)}}
)

~detune = {a.value(~a).collect {|sig| PitchShift.ar(sig, pitchRatio: LFNoise1.kr(Rand(0.1, 0.5), 0.01, 1), timeDispersion: 0.5) + sig}}

SynthDef(\lpfSaw, {|freq=440, filFreq=1000, q=0.5, out=0, amp=0.1| Out.ar(out, Pan2.ar(RLPF.ar(Saw.ar(Lag.kr(freq, 0.5)), filFreq, q), LFNoise1.kr(0.2)) * amp)}).add
~saw = Pmono(\lpfSaw, \degree, Pstutter(Prand([1,2,4], inf), Prand(Scale.major.degrees, inf)), \dur, 1/4, \octave, 4, \filFreq, Pbrown(400, 10000, 10), \amp, 0.1)
~saw.play

~rev = {FreeVerb.ar(~saw.ar[0], 1, 1)}
~rev.stop(5)
p.clear
~dust = {[Dust.ar(15), Dust.ar(5)]}
~rvsnd = ~saw + ~dust;
~del = {[K2A.ar(0), AllpassN.ar(~saw.ar[1], 1/3, 1/3, 5)]}
~del.play
~saw.nodeID
~detune.stop
~rv = {NHHall.ar([~rvsnd.ar[0], ~rvsnd.ar[1]])}
~rv.play
~detrv.play(fadeTime: 5)
~detrv.fadeTime_(5)
~detrv.stop(5)
x = ~a.ar.collect({|el| 1})