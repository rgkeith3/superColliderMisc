~a = {GrainBuf.ar(2, Impulse.ar(MouseX.kr(50, 0)), sndbuf: d[\samples][\drums][\s][0], pan: WhiteNoise.ar, envbufnum: e[\perc])}

~a.play
~a.clear
d[\samples][\drums][\s].size

{GrainBuf.ar(2, Impulse.ar(MouseX.kr(50, 0)), sndbuf: d[\samples][\drums][\s][0], envbufnum: e[\perc])}.play

(SynthDef(\bRat, {|out=0, gate=1, buf, pStart=(-1), pEnd=1, rStart=50, rEnd=1, rLength=1|
	var sig, env;
	env = Line.ar(dur: rLength, doneAction: 2);
	sig = GrainBuf.ar(2, Impulse.ar(env.linlin(0, 1, rStart, rEnd)), sndbuf: buf, pan: env.linlin(0, 1, pStart, pEnd), envbufnum: e[\perc]);

	Out.ar(out, sig);
}).load)


~a[0] = Pbind(\instrument, \bRat, \buf, Prand(d[\samples][\drums][\s], inf), \dur, 1, \pStart, Pwhite(-1), \pEnd, Pwhite(-1), \rStart, 0,\rEnd, 0, \rLength, Pwhite(hi: 4))
~a[10] = \filter -> {|in| in * 0.2}

~a.play
{Impulse.ar(0)}.plot

// synthdefs for drums samples
// a oneshot, most simple
// a warp, whenever 'stretch' key is present, is greater than 1 use the warp
// a grainbuf for ratcheting.

(
SynthDef(\bOne, {|out=0, buf, rate=1, pan=0, amp=0.8|
	var sig;
	sig = PlayBuf.ar(1, buf, rate, doneAction: 2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).load;

SynthDef(\bWarp, {|out=0, buf, rate=1, pan=0, amp=0.8, stretch=1|
	var sig, pointer;
	pointer = Line.ar(dur: BufDur.ir(buf) * stretch, doneAction: 2);
	sig = Warp1.ar(1, buf, pointer, rate);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).load;
)

Event.addEventType(\bDrum, {
	if (~stretch > 1, {
		~instrument = \bWarp;
	}, {
		~instrument = \bOne;
	});

	~type = \note;
	currentEnvironment.play;
})


~a = Pbind(\type, \bDrum, \buf, Prand(d[\samples][\drums][\s], inf), \dur, 1/2, \amp, 1, \stretch, Prand([0.5, 2], inf))
~a.play