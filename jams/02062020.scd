~a[0] = Pbind(\instrument, \saw, \fAmt, 5, \fSpd, 5, \dur, 16, \degree, Psr(3, [1,2,3,4,5], 1), \scale, Scale.minorPentatonic, \atk, 2, \rel, 2, \strum, 0.5, \q, 0.1, \pAmt, 1, \pSpd, 5, \octave, 4, \cutoff, PSinOsc(0.001, mul: 3000, add: 4000))
~a.play(0, fadeTime: 20)
~a[15] = {Dust.ar(5!2) * 0.5}
~a[10] = \filter -> {|in| NHHall.ar(in, 0.5)}
~a.set(\wet10, 1)
~a.stop(30);~b.stop(15); ~e.stop(5)
~d.stop(4)
s.stopRecording

~b[0] = Pbind(\instrument, \pluck, \pAmt, Pwhite(-0.1, 0.1), \pTime, 0.1, \dur, 1/3, \degree, Pseq([1,2,Pwrand([3, Pseq([3,4,5,6])], [0.7, 0.3])], inf), \scale, Scale.minorPentatonic, \pan, Pbrown(-1), \dec, Pwrand([1, 3, 5], [0.6, 0.3, 0.1], inf), \timbre, Pbrown(0, 0.9), \octave, Pseq([4,5,3,6], inf).stutter(3 * 16), \amp, Pwhite(hi: 0.3))

~b[10] = \filter -> {|in| [CombC.ar(in[0], 0.2, LFNoise1.kr(0.1).range(0.1, 0.2), LFNoise1.kr(0.1).range(1, 2)), CombC.ar(in[1], 0.2, LFNoise1.kr(0.1).range(0.1, 0.2), LFNoise1.kr(0.1).range(1, 2))]}
~b.play(fadeTime: 20)
~b.stop(10)
~a.stop(5)
~a.play

~c = Pbind(\instrument, \oneShot, \dur, Pbjorklund2(5,16) /2, \buf, d[\samples][\drums][\k][59], \amp, 1)

~c.play(fadeTime: 10)

~c.stop
~d = \stLoop

~d.set(\buf, d[\stereo_samples][\texture][0])
~d.play
~d.spawn
~d.clear
~d.set(\amp, 1)
~d.set(\spd, 0.2)
~d.set(\pan, ~lfn)

~d[10] = \filter -> {|in| FreeVerb2.ar(in[0], in[1], 0.5, 0.5, 0)}
~d.play(fadeTime: 20)
s.record
~lfn = {LFNoise1.kr(0.2)}

~e = {Pan2.ar(PinkNoise.ar(), ~ePan.kr, ~eVol.kr) }
~eVol = {SinOsc.kr(0.05).range(0, 0.2)}
~ePan = {PulseDPW.kr(~tempo.kr * 16, mul: 2)}

~e.fadeTime = 5
~e.play

~f = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\s][1], \dur, Pwrand([4,Pseq([0.1, 0.1, 0.1, 3.7])], [0.7, 0.3], inf), \amp, 0.5)
~f.play(fadeTime: 5)
~f.stop
~g = Ptpar([0.5, Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\r][5], \dur, 1)])
~g.stop
~h.stop

~h = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\ch][0], \dur, Pseq([1/4, 3/4], inf))
~h.play