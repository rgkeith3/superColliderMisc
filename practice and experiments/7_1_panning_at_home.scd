(~a = {
	var sig, chan1, chan2, chan3, chan4, chan5, chan6, chan7;
	sig = Saw.ar(50);
	[sig, PanAz.ar(7, sig, SawDPW.ar(1, mul: 2), width: 3)].flatten;
})

(~a[0] = {
	var first, last, buf, sig;
	first = d[\samples][\zap2].first.bufnum;
	last = d[\samples][\zap2].last.bufnum;
	buf = LFNoise1.kr(1).range(first, last);
	sig = GrainBuf.ar(7, Dust.kr(LFNoise1.kr(0.5).range(1, 25)), dur: LFNoise1.kr(5).range(0,1), sndbuf: buf, rate: BufRateScale.kr(buf) * Select.kr(LFNoise1.kr(5).range(0,5), [1, 1.333, 1.5, 2, 0.5, 4]), pos: 0, pan: LFNoise1.kr(0.5), envbufnum: e[\perc]);
	sig
})
~a.scope
~a[10] = nil
~a[10] = {SinOsc.ar(50, mul: 0.2)}
~a[5] = \filter -> {|in| CombN.ar(in, 1, 1, decaytime: 1)}
~a[10] =nil
~a.set(\wet10, 0.5)
~a[10] = \filter -> {|in| FreeVerb.ar(in, 1, 2, 0.1)}
~a[10] = \filter -> {|in| [NHHall.ar(in[0..1], 2), NHHall.ar(in[2..3], 2), NHHall.ar(in[4..5], 2), NHHall.ar([in[6], in[0]], 2)].flatten}
~a[1] = \filter -> {|in| [in[6], in[1], in[0], Mix(in), in[5], in[2], in[4], in[3]]}


~a[0] = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\k][5], \amp, 1, \pan, Pwhite(-1), \dur, Pseq(f[\durFill].value(), inf))

~a[0] = Pbind(\instrument, \flutterSaw, \pan, Pbrown(-1), \amt, Pwrand([0.01, 1, 2], [0.5, 0.25, 0.25],inf), \rate, 5, \q, 0.1, \filter_freq, Pbrown(500, 5000, 100), \degree, Pdefn(\deg, Prand([1,3,5,7,9,11], inf)), \octave, Pwrand([3,4,5,6], [0.1, 0.1, 0.6, 0.2], inf), \dur, Pseq(f[\durFill].value(), inf), \rel, Pwrand([0.1, 1, 3, 5], [0.3, 0.3, 0.2, 0.2], inf))

~a[0] = Pbind(\instrument, \pluck, \degree, Pdefn(\deg), \pAmt, 0,  \dec, Pwrand([0.1, 1, 3], [0.2, 0.6, 0.2], inf), \timbre, Pbrown(step: 0.0125), \pan, Pwhite(-1), \dur, Pwhite(0.05, 0.2), \octave, Prand([3,4,5,6],inf), \amp, Pwhite(0.5))

Pdefn(\deg, Prand([1,3,5,7,9,11], inf))
[1,2,3][0..1]

~a.play

~a[10] = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\s].choose, \dur, Pseq([4, Pseq([8], inf)]), \amp, 1)
~a[10] = nil

~a.play

~a.scope
e
d[\samples][\zap2].first.numChannels
d[\samples].keys


~b = {GrainBuf.ar(7, Dust.kr(5), sndbuf: LFNoise1.kr(1).range(d[\samples][\vox].first.bufnum, d[\samples][\vox].last.bufnum), pos: WhiteNoise.ar().range(0,1), pan: WhiteNoise.ar())}

~b = {PanAz.ar(7, Warp1.ar(1, LFNoise1.kr(0.1).range(d[\samples][\vox].first.bufnum, d[\samples][\vox].last.bufnum), LFNoise1.kr(0.1).range(0,1), overlaps: 8, windowRandRatio: LFNoise1.kr(0.1).range(0,0.1)), LFNoise1.kr(0.1))}
~b.scope

~b[1] = \filter -> {|in| [in[6], in[1], in[0], Mix(in), in[5], in[2], in[4], in[3]]}
~b.play

~c = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\k][16], \pan, Pwhite(-1), \dur, Pseq([1/4, 1/4, 1/4, 1/4, 3, 3, 1/3, 1/3, 1/3], inf), \amp, 1, \spd, 1)
~c[10] = \filter -> {|in| in.softclip}
~c.play
~a.stop
~c.mold(8)

~d = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\ch].choose, \pan, Pbrown(-1), \dur, 1/4, \amp, Pwhite(0.8), \rel, 0.1, \width, Pbrown(1, 3))
~d[1] = \filter -> {|in| [in[6], in[1], in[0], Mix(in), in[5], in[2], in[4], in[3]]}
~d.play
~d.mold(8)
d[\samples][\drums][\k]

~c[1] = \filter -> {|in| [in[6], in[1], in[0], Mix(in), in[5], in[2], in[4], in[3]]}

~b.mold(8)
~a.mold(8)

~b.play
~revSnd = ~b + ~d
~rev = {FreeVerb.ar(~revSnd.ar, 1, 1)}
~rev.play