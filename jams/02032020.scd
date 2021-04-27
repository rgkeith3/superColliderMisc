~ramp32 = {SawDPW.ar(~tempo.kr / 32, mul: 2).range(0.1, 4)}
s.record
~a[0] = Pbind(\instrument, \oneShot, \buf, Ptm(8, d[\stereo_samples][\Miserere], 0.1, inf), \dur, 1/4, \rel, ~ramp32, \atk, 0, \pan, Ptm(8, [-1, 0, 1], 0.1), \start, Pseg([0, 0.5], 32, repeats: inf))
~a.play(fadeTime: 20)
~a.fadeTime = 2

~a[10] = \filter -> {|in| Compander.ar(in * 2, ~b.ar * 5) }

~a[15] = \filter -> {|in| SelectX.ar(LFNoise1.kr(0.2).range(0, 1) ,[Decimator.ar(in, LFNoise1.kr(0.1).range(1, 44100), LFNoise1.kr(0.11).range(1, 24), 0.2), in])}

~a[20] = \filter -> {|in, div=1| Concat2.ar(WhiteNoise.ar(LFNoise1.kr(~tempo.kr).range(0, 1)), in, matchlength: ~tempo.kr.reciprocal / div, randscore: LFNoise1.kr(0.2).range(0, 1))}
~a[25] = \set -> Pbind(\div, Prand([32, 4, 3, 6, 16, 8], inf), \wet20, Pwrand([0, 1], [0.7, 0.3], inf))
~revSnd.fadeTime = 10
~revSnd = ~a + (~b * 0.2) + ~c + ~d + ~e + ~f;

~a.stop; ~b.stop; ~c.stop; ~d.stop; ~e.stop; ~f.stop;
~rev = {Pan2.ar(FreeVerb.ar(Mix(~revSnd.ar), 1, LFNoise1.kr(0.3).range(0, 1), LFNoise1.kr(0.2).range(0, 1)), LFNoise1.kr(0.4))}
~rev.play
~rev.fadeTime = 10
~rev.stop(10)
s.stopRecording

~b = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\k][4], \dur, Pbjorklund2(7, 16) / 4, \amp, 0.3); ~b.play;

~c[0] = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\s].choose, \dur, Pbjorklund2(9, 16) / 2)
~c.play

~c[10] = \filter -> {|in, divL=1, divR=1, decL=1, decR=1| var time = ~tempo.kr.reciprocal; [CombN.ar(in[0], time, time / divL, decL), CombN.ar(in[1], time, time / divR, decR)] + in};

~c[15] = \set -> Pbind(\divL, Prand([8,16,32, 64, 48],inf), \decL, Prand([0, 0.1, 0.5, 1, 2], inf), \divR, Prand([4,8,16,32, 48],inf), \decR, Prand([0, 0.1, 0.5, 1, 2], inf), \dur, 1/2, \wet10, Pwrand([0, 1], [0.8, 0.2], inf))
~c[10] = nil
~d = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\ch][0] ,\dur, 1/4)
~d.play


~e = {Pan2.ar(Crackle.ar(LFNoise1.kr(LFNoise1.kr(4).range(0, 10)).range(0.5, 1.8)), LFNoise1.kr(mul: 0.5), 0.2)}
~e.play(fadeTime: 4)


~f = {|freq=45, fb=0.5|SinOscFB.ar(freq, fb)!2}
~f[10] = \set -> Pbind(\degree, Pseq([1, 2, 1, 3], inf), \octave, 2, \dur, 16,\fb, ~s1, \scale, Scale.minorPentatonic)
~f.play

~f[15] = \filter -> {|in| Decimator.ar(in, LFNoise1.kr(1).range(24, 10000), LFNoise1.kr(1).range(2, 24))}


~s1 = {SinOsc.ar(~tempo.kr / 24).range(0, 1)}
128  - 96