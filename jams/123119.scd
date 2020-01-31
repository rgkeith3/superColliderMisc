p.clock.tempo = 165 / 60

~h = Pbind(\instrument, \oneShot, \buf, Pseq(d[\samples][\Drums]['Rides'][4..5], inf), \dur, 1/2, \amp, 1, \rel, 1, \rate, 0.8)
~k[0] = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Kicks][13], #[\dur, \pan], Pwrand([Pseq([[1, 0]], 1), Pseq([[1/2, 1], [1/2, -1], [1/2, 1], [1/2, 0]])], [0.8, 0.2], inf), \amp, 2, \rel, 1)

~k[10] = \filterIn -> {|in| (in * 10).softclip}
~k.play
~k.stop(5)
~h.stop;
~h.play;

~s = Ptpar([4, Pbind(\instrument, \oneShot, \buf, Prand(d[\samples][\Drums][\Snares][5..9], inf), \dur, Pseq(f[\durFill].value(16, 1/4, 0.15), inf), \amp, 1, \pan, 0)])
~s.play
~s.stop(5)


~c[0] = Ptpar([4, Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Claps].choose, \dur, Pwrand([8, Pseq([1/3, 1/3, 1/3 + 7])], [0.8, 0.2], inf), \amp, 3, \pan, Pwhite(-0.5, 0.5))])

~c[10] = \filterIn -> {|in| FreeVerb.ar(in, 0.3, 0.5)}

~c.stop

~b.stop(5)
(
~b[0] = Pbind(\instrument, \beatWarp, \buf, Prand(d[\samples][\breaks][0..7], inf), \start, Pseq(Array.fill(16, {|i| i/16}).scramble, inf), \clock, p.clock.tempo, \beats, 4, \dur, 1/2, \envBuf, e[\trap], \winSize, 0.001, \overlaps, 2, \freqScale, 0.5, \atk, 0.001, \rel, 0.01, \legato, 1, \pan, Pseq(f[\valFill].value(16, [0, -0.5, 0.5], 0.5), inf), \amp, 1)
)
~concatControl = {WhiteNoise.ar(LFNoise0.kr(p.clock.tempo))}
~b[10] = \filterIn -> {|in, rand=0.1, div=4| Concat2.ar(~concatControl.ar, in, matchlength: p.clock.tempo.reciprocal / div, randscore: rand)}
~b[15] = \set -> Pbind(\rand, Pwrand([0, 0.2, 0.5], [0.7, 0.2, 0.1], inf), \div, Prand([4, 2, 1, 8],inf), \dur, 1/2, \wet10, Pwrand([0, 1], [0.8, 0.2], inf))

~b[16].clear

~b[20] = \filterIn -> {|in, divL=4, divR=4, frzL=0, frzR=0| var time = p.clock.tempo.reciprocal; [Select.ar(frzL, [in[0], CombN.ar(in[0], time, time/divL)]), Select.ar(frzR, [in[1], CombN.ar(in[1], time, time/divR)])]}

~b[25] = \set -> Pbind(\divL, Prand([2, 4,3], inf), \divR, Prand([2,4,3], inf), \frzL, Pwrand([0, 1], [0.8, 0.2], inf), \frzR, Pwrand([0, 1], [0.8, 0.2], inf), \dur, 1/2)

~b[30] = \filterIn -> {|in, pitch=1, pDur=0.5, pSize=0.1| var time = p.clock.tempo.reciprocal; PitchShift.ar(in, pSize, Slew.kr(pitch, time * pDur, time * pDur))}

~b[35] = \set -> Pbind(\pitch, Prand([4, 1/2, 6, 2, 1/4, 1/6], inf), \pDur, Prand([1, 0.5, 0.25, 2], inf), \wet30, Prand([0, 1], inf), \pSize, Prand([0.1, 0.2, 0.5, 0.01, 1], inf), \dur, 1/2)

~b[40] = \filterIn -> {|in| (in * 2).distort}
~b[45] = \set -> Pbind(\wet40, Pwrand([0, 1], [0.8, 0.2], inf), \dur, 4)

~b.set(\amp, 2)


~b.play(fadeTime: 5)
~b.stop(5)


~mel1 = Pbind(\instrument, \flutterSaw, \degree, Psr(4, Scale.minorPentatonic.degrees, 1), \dur, 8, \atk, 1, \rel, 1, \pan, [-1, -0.25, 0.25, 1], \amp, 1, \rate, [5, 15, 25, 50], \amt, 1, \ctranspose, 3, \strum, 2)
~mel1.play(fadeTime: 10)

~bas[0] = Pbind(\instrument, \saw, \dur, Pseq(f[\durFillSize].value(16, 1, 0.2, 8), inf), \degree, Pseq(f[\valFill].value(8, Scale.minorPentatonic.degrees, 0.3), inf), \octave, 3, \amp, 3, \ctranspose, 5, \legato, Pseq(f[\valFill].value(8, [0.5, 0.7, 0.1], 0.3), inf), \fFreq, 1000, \q, 0.5, \fAmt, 0, \pAmt, 1, \pSpd, 1)

~bas[10] = \filterIn -> {|in| [AllpassN.ar(in[0], 0.1, LFNoise1.kr(1).range(0, 0.01), 0.2), AllpassN.ar(in[1], 0.1, LFNoise1.kr(1).range(0, 0.01), 0.2)] + in}
~bas[20] = \filterIn -> {|in| (in * 5).distort}

~bas.stop(25)
~bas.play

~mel2[0] = Pbind(\instrument, \saw, \dur, 1/3, \degree, Pseq(Scale.minorPentatonic.degrees[2..4],inf),\ctranspose,5, \amp, 1, \fFreq, Pbrown(3000, 5000, 25), \pan, Pwhite(-1), \q, 0.1, \rel, 1, \atk, 0 , \legato, 1, \amp, 0.8, \octave, Pwrand([5, 6, 7], [0.6, 0.3, 0.1], inf))

~mel2[10] = \filterIn -> {|in, divL=4, divR=1.5, slew=1, decL=1, decR=1| var time = p.clock.tempo.reciprocal; [CombN.ar(in[0], time, time / Slew.kr(divL, slew, slew), decL), CombN.ar(in[1], time, time / Slew.kr(divR, slew, slew), decR)] + in}

~mel2.set(\divL, 1, \divR, 5, \slew, 5, \decL, 5, \decR, 5);
~mel2.set(\divL, 7, \divR,3)
~mel2.set(\decL, 1, \decR, 1)
~mel2.set(\slew, 1)
~mel2.set(\amp, 0.5)


~mel2.play(fadeTime: 10)


~mel1.stop(5)

~revSnd = ~bas;
~rev[0] = {NHHall.ar(~revSnd.ar, 1, 0.1)}
~rev.play

~rev.stop(10)

~rev[10] = nil

p.clock.tempo_(165/60)
