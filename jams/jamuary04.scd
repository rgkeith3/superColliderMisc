~a = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Kicks][10], \amp, Pseg([1, 0.1], 2, repeats: inf), \dur, Pbjorklund2(7, 12) / 4, \pan, Pseg([-1, 1, -1], 8, repeats: inf), \rel, 1)

~a[10] = \filterIn -> {|in| (CompanderD.ar(in * 2) * 2).softclip}

~a.play

~b = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums]['Closed Hihat'][5], \amp, Pseq([1, 0.8], inf), \dur, Pwrand([Pseq([0.26, 0.24], 12), Pseq([1/6], 3)], [0.8, 0.2], inf), \pan, Pwhite(-0.5, 0.5))
~b.play
~b.stop(10)

~c = Pbind(\instrument, \oneShot, \buf, Prand(d[\samples][\zaps][8..12], inf), #[\p,\amp,\rate], Plorenz(20, 48).trace * [1, 2, 2], \pan, Pkey(\p) * 2 -1, \atk, 0, \rel, 0.5, \dur, 1/4)
~c.play(fadeTime: 10)


~c.stop(5)
~c[10] = \filterIn -> {|in| [CombC.ar(in[0], 0.01, LFNoise1.kr(2).range(0.0001, 0.01), 0.01) ,CombC.ar(in[1], 0.01, LFNoise1.kr(2).range(0.0001, 0.01), 0.01)]}

~c[20] = \filterIn -> {|in, divL=4, divR=6, decL=1, decR=1| var time = p.clock.tempo.reciprocal * 4; [CombN.ar(in[0], time, time/divL, decL), CombN.ar(in[1], time, time/divR, decR)] + in}

~c[25] = \set -> Pbind(\divL, Prand([2, 4, 6, 16, 32], inf), \decL, Pwhite(1, 3), \divL, Prand([2, 4, 6, 16, 32], inf), \decL, Pwhite(1, 3), \dur, Prand([1,2,4,8],inf))

~c.set(\wet20, 0.5)
~c.set(\wet10, 0.6)

~c.play


~d = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Snares][5], \dur, Pwrand([4, Pseq([1/2, 1/2, 3])], [0.7, 0.3], inf), \amp, 1)
~d.play

~d[10] = \filter -> {|in, div=4, dec=1| var time = p.clock.tempo.reciprocal; CombC.ar(in, time, time/ div, dec)}

~d[15] = \set -> Pbind(\div, Prand([1, 2,3,4,5], inf), \dec, Prand([1, 5]), \dur, 4)

~e = Pbind(\instrument, \saw, \degree, Psr(4, Scale.minor.degrees, 1), \dur, 8, \fFreq, 5000, \q, 0.1, \strum, 1, \rel, 1, \atk, 1, \scale, Scale.minor, \pan, [-1, 1, 0.3, -0.3])
~e.play
~e.stop(10)

~f = Pbind(\instrument, \saw, \degree, Pseq([Pseq([1,3,5], 48), Pseq([2,4,6], 48)], inf), \dur, 1/6, \fFreq, ~lfo1, \q, 0.1, \pan, Pwhite(-1), \amp, Pwhite(0.3, 0.8), \scale, Scale.minor)

~lfo1 = {LFNoise1.kr(1).range(5000, 10000)}

~f.play
~d.stop(5)


~revSnd

~rev[0] = {NHHall.ar(~revSnd.ar, lowFreq: 50, lowRatio: 1)}

~rev[10] = \filterIn -> {|in| in * Amplitude.kr(~a.ar * 2, releaseTime: 0.1).range(1, 0)}

~rev.play(fadeTime: 15)
~rev.stop(10)