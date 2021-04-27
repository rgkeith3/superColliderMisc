~a[0] = Pbind(\instrument, \beatWarp, \buf, d[\samples][\breaks][4], \beats, 4, \clock, ~tempo, \dur, 1/4, \start, PbeatRepeat(Array.fill(16, {|i| i/16}).scramble, Pwrand([0, 1], [0.7, 0.1], inf)), \winSize, Pwrand([0.001, Pwhite(0.0001, 0.1, 1)], [0.7, 0.3], inf), \pan, Pwhite(-1), \amp, 1)
~a[10] = \filter -> {|in| HPF.ar(in, 150)}
~a.play

~a[20] = \filter -> {|in, divL=1, divR=1, decL=1, decR=1| var time = ~tempo.kr.reciprocal; CombN.ar(in, time, time / [divL, divR], [decL, decR])}
~a[25] = \set -> Pbind(\wet20, Pwrand([0, 1], [0.7, 0.3], inf), \divL, Prand([1,2,3,4,6,8,16,32], inf), \divR, Prand([1,2,3,4,6,8,16,32], inf), \decL, Prand([0, 0.5, 1, 2], inf), \decL, Prand([0, 0.5, 1, 2], inf), \dur, Prand([1, 1/2], inf))

p.clock.tempo = 195 / 60

~a.play(fadeTime: 10)
~a.stop(15)

~b = Pbind(\instrument, \flutterSaw, \degree, Pseq([[1,3,4], [2,4,7]],inf), \amp, ~slicer, \dur, Pseq([12, 4], inf), \legato, 1, \cutoff, ~l1, \scale, Scale.minorPentatonic, \q, 0.4, \amt, 1, \rate, Prand([5, 15, 10], inf), \pan, [-1, 0, 1])

~b[10] = \filter -> {|in, room=5, damp=0.5| FreeVerb.ar(in, 0.3, room, damp)}

~b[20] = \set -> Pbind(\room, Prand([1,3,5,0.1, 0.5], inf), \damp, Pwhite())
~b.play
~b.stop
~slicer = 0.5
~slicer = {|div=1| PulseDPW.ar(~tempo.kr * div, add: 0.5)}
~slicer[10] = \set -> Pbind(\div, Prand([1, 2, 3, 4, 8, 16], inf), \dur, 1)


~l1 = {SinOsc.kr(0.03).range(500, 5000)}
~l2 = {SinOsc.kr(0.04).range(0.2, 0.6)}
~l3 = {SinOsc.kr(0.03) + WhiteNoise.kr(0.1)}

~c.play
~c[0] = Pbind(\instrument, \wub2, \clock, ~tempo, \wubDiv, Prand([1,0.5, 1/3], inf), \octave, 3, \scale, Scale.minorPentatonic, \amp, 1, \dur, Pseq([12, 4, 8, 2, 4], inf), \degree, Pseq([1,2,3,7,1], inf), \wubAmt, 1.5, \wubPhase, 1)
~c[10] = nil
~c.stop(5)
~c[20] = nil


~e.play
SynthDef(\sin1, {|freq=50, gate=1, pan=0| Pan2.ar(SinOsc.ar(freq) * gate, pan)}).add
~e = Pbind(\instrument, \sin1, \octave, 2, \scale, Scale.minorPentatonic, \dur, Pbjorklund(5, 8) / 2)
~e.play
~e[10] = \filter -> {|in, smpRateL=44100, bitsL=24, smpRateR=44100, bitsR=24| Decimator.ar(in, [smpRateL, smpRateR], [bitsL, bitsR])}

~e[20] = \set -> Pbind(\smpRateL, Pwhite(hi: 44100), \smpRateR, Pwhite(hi: 44100), \bitsL, Pwhite(hi: 24), \bitsL, Pwhite(hi: 24), \dur, 1/2)
~e[30] = \filter -> {|in, amp=1| in * amp}
~e[35] = \set -> Pbind(\amp, Pbjorklund(5, 8), \dur, Pbjorklund2(5, 8) / 4)

~f = {|div=4, pan=0| Pan2.ar(Impulse.ar(~tempo.kr * div), pan)}
~f[10] = \set -> Pbind(\div, 4, \pan, Pwhite(-1))
~f.play
~d = Pbind(\instrument, \pluck, \dur, 1/4, \dec, Pwrand([1, 5], [0.8, 0.2], inf), \amp, 1, \pAmt, Pwhite(), \pTime, 0.01, \timbre, Pwrand([~l2, 0.9], [0.8, 0.2], inf), \scale, Scale.minorPentatonic, \pan, Pwhite(-1), \octave, Pwrand([3,4,5,6], [0.1, 0.4, 0.4, 0.1], inf), \degree, Pdefn(\pluckDegree, Prand([1,3,4, 6], inf)))
~d.play

~d[10] = \filter -> {|in, concatSrc=0.1, divL=1, divR=1, rand| Concat2.ar(WhiteNoise.ar(concatSrc), in, matchlength: ~tempo.kr.reciprocal / [divL, divR], randscore: rand)}

~d[15] = \set -> Pbind(\concatSrc, Pwhite(), \divL, Prand([1,2,3,4,8], inf), \divR, Prand([1,2,3,4,8], inf), \wet10, Prand([1, 0], inf), \dur, Prand([1,2], inf))

Tdef(\pluckDeg, {
	var counter = 0;

	loop {
		if (counter.even) {
			Pdefn(\pluckDegree, Prand([1,3,4,6], inf));
		} {
			Pdefn(\pluckDegree, Prand([2,4,7,9], inf));
		};

		32.wait;
	}
})

Tdef(\pluckDeg).play

~revSnd = (~c * 0.1) + ~d + ~b

~b.stop
s.record

~rev[0] = {NHHall.ar(~revSnd.ar, 10) * 0.5}

~rev[10] = \filter -> {|in, concatSrc=0.1, divL=1, divR=1, rand| Concat2.ar(WhiteNoise.ar(concatSrc), in, matchlength: ~tempo.kr.reciprocal / [divL, divR], randscore: rand)}

~rev[15] = \set -> Pbind(\concatSrc, Pwhite(), \divL, Prand([3,4,8, 16, 32, 64], inf), \divR, Prand([3,4,8, 16, 32, 64], inf), \dur, Prand([1,2, 1/2, 1/4], inf))
s.scope
~rev.set(\wet10, 1)

~c.stop


~rev.fadeTime_(4)
~rev.play
~rev.scope
s.stopRecording
~rev[20] = \filter -> {|in| Disintegrator.ar(in, MouseY.kr())}

~g = {GravityGrid.ar(Impulse.kr(0.01), MouseX.kr(0, 1), LFNoise1.kr(1), LFNoise1.kr(1), bufnum: -1)}
~g.clear
