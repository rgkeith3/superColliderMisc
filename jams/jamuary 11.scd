~a[0] = Pbind(\instrument, \beatWarp, \buf, Pwrand([d[\samples][\breaks][1], Prand(d[\samples][\breaks][0..7])], [0.7, 0.3], inf), \clock, p.clock.tempo, \beats, 4, \amp, 1, \winSize, 0.001, \start, PbeatRepeat(Array.fill(16, {|i| i/16}), Pwrand([1, 0], [0.2, 0.8], inf)), \dur, 1/4, \freqScale, 1)

~a[10] = \filterIn -> f[\stDelay]
~a[20] = \set -> Pbind(\wet10, Pwrand([0, 0.5], [0.8, 0.2], inf), \dur, 1/2, \divL, Prand([2, 4, 6, 8, 16, 32], inf), \divR, Prand([2, 4, 6, 8, 16, 32], inf))

~a[30] = \filterIn -> {|in| Concat2.ar(~concatSrc.ar, in, matchlength: p.clock.tempo.reciprocal) }
~a[35] = \set -> Pbind(\wet30, Pwrand([0, 0.5], [0.8, 0.2], inf), \dur, 1/2)
~concatSrc = {WhiteNoise.ar(LFNoise0.kr(p.clock.tempo / 2))}
~a.stop(20)

~e = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums]['Closed Hihat'].choose, \amp, 1, \dur, Pseq([0.24, 0.26], inf))
~e.stop(5)



p.clock.tempo = 165/ 60
~a.stop(5)


~b = Pbind(\instrument, \saw, \degree, Pseq([Pseq([1,3,5], 72), Pseq([2,6,8], 72)], inf), \scale, Scale.minorPentatonic, \dur, Pwrand([1/3, Pseq([1/6], 2)], [0.9, 0.1], inf), \pan, Pbrown(-1), \amp, 0.6, \cutoff, Pbrown(500, 5000, 10), \q, 0.2, \rel, Pbrown(0.01, 1))

~b.stop(10)

~revSnd = ~c +~f;

~rev = {NHHall.ar(~revSnd.ar, 1)}

~rev.play


~c = Pbind(\instrument, \flutterSaw, \degree, Psr(4, Scale.minorPentatonic.degrees, 0.2), \dur, 4, \strum, 1/4, \atk, 1, \rel, 1, \pan, [-1, -0.3, 0.3, 1], \rate, Prand([5, 15, 25, 50], inf), \scale, Scale.minorPentatonic, \amp, 0.5)
~c.play(fadeTime: 10)
~c.stop(10)


~d = Pbind(\instrument, \saw, \degree, Pstutter(3, Pseq(f[\valFill].value(6, [1,5,7]), inf)), \dur, Pbjorklund2(6, 32), \amp, Pseq([1.5, 1.5, 1, 1], inf), \q, 0.3, \scale, Scale.minorPentatonic, \octave, 2, \dur, Pseq([1/3, 1/3, 1/3, 4], inf), \rel, 0.1, \legato, 1, \sus, 0.7, \dec, 0.1, \cutoff, Pwhite(500, 2000))

~d.play

d[\samples].keys

~f = Pbind(\instrument, \oneShot, \buf, Prand(d[\samples][\kitchen], inf), \amp, Pwhite(1.5, 2), \pan, Pwhite(-1), \dur, Pwrand([1/2, Pseq([1/4], 2), Pseq([1/3], 3)], [0.6, 0.2, 0.2], inf), \rate, Pseq(f[\valFill].value(16, [1, 0.5, 2]), inf))

~f.play

~f.stop(10); ~rev.stop(10);