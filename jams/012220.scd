
~a = Pbind(\instrument, \wub2, \octave, 3, \clock, ~tempo, \wubDiv, Prand([1, 1/2, 1/3], inf), \wubPhase, Pwhite(), \wubAmt, Pwhite(hi: 1.5), \amp, 1, \pan, Pwhite(-1), \atk, 0, \rel, 1, \legato, 0.5)
~a.play

~a[10] = \filter -> {|in, drateDiv=1, bits=24| Decimator.ar(in, SampleRate.ir()/ drateDiv, bits)}

~a[15] = \set -> Pbind(\drateDiv, Prand([1,2,4,8,16,32,64], inf), \bits, Pwhite(8, 24), \dur, 1/4)
s.scope

~b.clear
~b.play