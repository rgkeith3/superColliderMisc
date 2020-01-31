~a = Pbind(\instrument, \wub2, \wubPhase, Pwhite(-1), \octave, 2, \legato, Pseq([0.8, 0.8, 0.5], inf), \atk, 0.01, \rel, 0.1,\dur, Pseq([3/4, 3/4, 6.5], inf) * 2, \wubDiv, Prand([2, 3, 4, 1], inf), \clock, ~tempo, \wubAmt, 1, \degree, Pseq([1,1, 2, 1,3,1, 1,2,2,4,5,3], inf), \scale, Scale.minor, \amp, 1)
~a.play

~a[10] = \filter -> {|in, decRateDivL=1, bitsL=24, decRateDivR=1, bitsR=24| Decimator.ar(in, SampleRate.ir()/ [decRateDivL, decRateDivR], [bitsL, bitsR])}

~a[20] = \set -> Pbind(\decRateDivL, Pwhite(10, 20), \bitsL, Pwhite(2, 8), \decRateDivR, Pwhite(10, 20), \bitsR, Pwhite(2, 8), \dur, 1/2)


~a.scope

~a1 = \warp
~a1.play
~a1.set(\buf, d[\samples][\lost].choose, \amp, 0.3, \pointer, ~n, \winSize, ~n, \pan, ~n)

~a1[10] = \filter -> {|in, disL=0, disR=0| Disintegrator.ar(in, [disL, disR])}

~a1.scope

~b = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums]['Closed Hihat'].choose, \dur, Pwrand([1, Pseq([1/2], 2), Pseq([1/3], 3), Pseq([1/4], 4)], [0.7, 0.1, 0.1, 0.1], inf))
~b.play

~c = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Claps][0], \dur, 8, \amp, 1)
~c.play

~d[0]= Ptpar([2, Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Kicks][8], \dur, Pseq(f[\durFill].value(8, 1/2, 0.3), inf), \amp, 1)])

~d[10] = \filter -> {|in| RLPF.ar(in, SinOsc.kr(0.12).range(150, 500), 0.5)}
~d.play

~e = \stLoop
~e.set(\buf, d[\stereo_samples][\texture][4], \spd, ~n)
~e.play

~n = {LFNoise1.kr(0.1).range(0, 2)}

~revSnd = (~a * 0.1) + (~c * 1) + (~b* 0.2) + (~d * 0.1) + (~e * 0.5)
~revSnd.fadeTime = 2

~rev = {NHHall.ar(~revSnd.ar, 2)}

m = ProxyMixer.new(p)
~rev.play

{PulseDPW.ar(mul: 2).range(1, 0)}.plot