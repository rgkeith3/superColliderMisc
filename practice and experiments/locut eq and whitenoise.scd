~a = Pbind(\instrument, \ringDrum, \dur, Pseq(f[\durFillSize].value(16, 1/2, 0.3, 16), inf), \legato, 1, \rel, 0.01, \bounce, Pwrand([1, 2, 6], [0.8, 0.1, 0.1], inf), \octave, 2, \amp, 1, \clock, ~tempo, \degree, Pseq(f[\valFill].value(16, [1,2,3,4,5]), inf), \scale, Scale.minorPentatonic)

~a.play

~b = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums]['Closed Hihat'].choose, \dur, Pseq([0.51, 0.49], inf))
~b.play

~c = Pbind(\instrument, \wub, \dur, Pseq(f[\durFillSize].value(16, 1/2, 0.3, 16), inf) * 2, \degree, Prand([1,2, 5], inf), \scale, Scale.minorPentatonic, \octave, 3, \bufPosStart, w.first.bufnum, \bufPosEnd, w.last.bufnum, \wubDiv, 2/3, \clock, ~tempo, \q, 0.3)
~c.play

~out = ~a + ~b + ~c

~out.play; ~a.stop; ~b.stop; ~c.stop

~out[10] = \filterIn -> {|in, lo=1 | LPF.ar(in, 250) * lo + HPF.ar(in, 250)}

~out[15] = \filterIn -> {|in, whiteNoiseGate=0, clock=1| var sig, env; sig = HPF.ar(WhiteNoise.ar(0.2), 5000); env = EnvGen.ar(Env(times: [clock.reciprocal * 32, clock.reciprocal * 16], curve: ['cub', 'exp']), whiteNoiseGate); in + (sig * env);}

~out[20] = \set -> Pbind(\lo, Pseq([1, 0], inf), \dur, 32, \whiteNoiseGate, Pseq([0, 1],inf).trace, \clock, ~tempo)