(
SynthDef(\lpfSaw, {
	|freq=440, atk=0.01, dec=0.1, sus=0.8, rel=0.1, filtFreq=440, q=1, pan=0, gate=1, amp=1, out=0|
	var env, sig;
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);

	sig = RLPF.ar(SawDPW.ar(freq), filtFreq, q) * env;

	sig = Pan2.ar(sig, pan);

	Out.ar(out, sig);
}).add
)
s.boot

p = ProxySpace.push()

~a = Pbindef(\lpfArp, \instrument, \lpfSaw, \dur, 1/9, \pan, ~lfo1, \octave, Pstutter(Prand([45, 81], inf), Prand([3,4,5,6], inf)), \degree, Pseq([1,3,5,7], inf), \q, 0.1, \filtFreq, 500)

Pbindef(\lpfArp, \dur, Pwhite(0.1, 2.5), \legato, Pwhite(0.5, 2))

~a.fadeTime = 10

currentEnvironment


Pbindef(\lpfArp, \filtFreq, Pwhite(500, 1000))


~lfo1 = {SinOsc.kr(0.03)}
~lfo3 = {SinOsc.kr(0.1, mul: 2, add: 2.5)}
StageLimiter.activate
~a.stop(5)
~a.play(fadeTime: 5)
~verbSend.stop
~verbSend = ~a * 0.3
~c = {NHHall.ar(~verbSend.ar(), ~lfo3)}
~c = {FreeVerb.ar(~verbSend, 1, 1)}
~a.fadeTime = 0
~c.play(fadeTime: 10)
~c.stop
~c.fadeTime = 3