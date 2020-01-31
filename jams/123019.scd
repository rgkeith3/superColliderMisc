~h = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums]['Closed Hihat'].choose, \dur, 1/4, \amp, 1)
~h.play

~k[0] = Pbind(\instrument, \beatPlay, \clock, p.clock.tempo, \buf, d[\samples][\breaks][5], \beats, 4, \dur, Pseq(f[\durFillSize].value(8, 1/4, 0.5, 16), inf), \rel, 0.01, \atk, 0.01, \start, Pseq(f[\valFill].value(16, [0, 0.125, 0.25, 0.5, 0.625, 0.75]), inf), \amp, 1, \dec, 0.05)
~k[10] = \filterIn -> {|in| CompanderD.ar(in * 5).softclip}
~k[20] = \filterIn -> {|in| Concat2.ar(WhiteNoise.ar(LFNoise0.kr(p.clock.tempo / 2)), in, randscore: 0.5)}

~k[25] = \set -> Pbind(\wet20, Pwrand([0, 0.5, 1], [0.6, 0.3, 0.1], inf))

~k[30] = \filterIn -> {|in, freezeL=0, divL = 4, freezeR, divR = 2| var beatTime = p.clock.tempo.reciprocal; [CombN.ar(in[0], beatTime, beatTime / divL, 5 * freezeL, freezeL), CombN.ar(in[1], beatTime, beatTime / divR, 5 * freezeR, freezeR)] + in}

~k[35] = \set -> Pbind(\freezeL, Prand([0, 1], inf), \freezeR, Prand([0, 1], inf), \divL, Prand([4, 2, 8, 6, 3],inf), \divL, Prand([4, 2, 8, 6, 3],inf))

~k.play
~k.set(\wet20, 0.5);

~k2 = Pbind(\instrument, \oneShot, \buf, Ptm(4, d[\samples][\Drums][\Kicks][2..5]), \dur, Pseq(f[\durFill].value(8, 1/4, 0.5), inf), \amp, Pwhite(0.8))
~k2.play

~s = Pbind(\instrument, \oneShot, \buf, Ptm(4, d[\samples][\Drums][\Snares][2..5]), \dur, Pseq(f[\durFill].value(16, 1/4, 0.5), inf), \amp, Pwhite(0.8))
~s.play

~c2 = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Claps].choose, \dur, Prand([8, Pseq([1/4, 1/4, 1/4, 1/4 + 7])], inf), \amp, 4)
~c2.play


~b = Pbind(\instrument, \flutterSaw, \degree, Psr(4, Scale.majorPentatonic.degrees, 0.2), \dur, 2, \amp, 1, \octave, 6, \amt, 1, \rate, Psr(4, [5, 10, 15,25], 0.5), \ffreq, ~sinLfo, \q, 0.3, \atk, 1, \rel, 1, \pan, Pwhite(-1))

~b.play
~b.stop(20)
~sinLfo = {SinOsc.kr(0.1).range(500, 5000)}
~sinLfo1 = {SinOsc.kr(0.2)}
~sinLfo2 = {SinOsc.kr(0.1).range(250, 5000)}

~lfN1 = {LFNoise1.kr(0.1).range(0, 1)}

~c[0] = Pbind(\instrument, \saw, \degree, Ptm(3, Scale.minorPentatonic.degrees, 0.7), \dur, 1/4, \amp, 1, \pan, Pbrown(-1.0), \fFreq, ~sinLfo2, \legato, 0.1, \rel, Pwhite(), \q, 0.1)

~c[10] = \filterIn -> {|in| var beatTime = p.clock.tempo.reciprocal; [CombL.ar(in[0], beatTime, LFNoise1.kr(0.1).range(0.0001, beatTime), LFNoise1.kr(0.2).range(0, 3)), CombL.ar(in[1], beatTime, LFNoise1.kr(0.2).range(0.0001, beatTime), LFNoise1.kr(0.3).range(0, 3))]}

~c[20] = \filterIn -> {|in| GrainIn.ar(2, Dust.kr(15), dur: WhiteNoise.kr().range(0.01, 1), in: in, pan: WhiteNoise.kr(), envbufnum: e[\saw])}

~c.set(\wet10, 1)

~c.stop

~revSnd = ~c2 * 0.6;

~rev = {|dec=1|NHHall.ar(~revSnd.ar, dec)}

~rev.play
~rev.set(\dec, ~lfN1)




Scale.directory
~k.play