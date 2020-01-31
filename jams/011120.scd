(
~a = Pbind(\instrument, \wub, \bufPosStart, w.first.bufnum, \bufPosEnd, w.last.bufnum, \degree, Pseq(f[\valFill].value(12, [1,5,7]), inf), \octave, 2, \dur, Pseq(f[\durFillSize].value(32, 1, 0.3, 12), inf), \legato, Pseq(f[\valFill].value(12, [0.1, 0.5, 1]), inf), \wubDiv, Prand([1, 2, 3], inf), \clock, ~tempo, \bufPos, Pwhite(), \loCutoff, 0, \hiCutoff, 500, \q, 0.5, \wubPhase, 0)
)

p.clock.tempo = 165 /60

~a[10] = \filterIn -> {|in, div=1| RLPF.ar(in, SinOsc.kr(~tempo.kr/div).range(50, 500), 0.5)}
\
~a.play

~a[20] = \set -> Pbind(\div, Prand([8], inf), \dur, Prand([1/2, 1/4],inf))

~a[30] = \filter -> {|in| FreeVerb.ar(in, 1, 0.1, 0.1)}
~a.set(\wet30, 0.3)
~a.stop

pi

p.clock.tempo = 165 /60


~b = Pbind(\instrument, \henonDrum, \amp, 1, \atk, 0, \cutoff, 50, \octave, 4, \pAmt, 100, \pDec, 0.01, \q, 0.1, \dur, Pseq(f[\durFill].value(8, 1/2), inf), \rel, Pkey(\dur))

(~c[0] = {|amt=1, freq=50|
	Ringz.ar(Impulse.ar(amt), freq, amt.reciprocal)
})

~c[10]=\set -> Pbind(\amt, Prand([1, 2, 3, 4, 6, 8], inf), \degree, Prand([1,3,5,7], inf), \octave, 3)
~c.stop

~b.play
w.first.bufnum

~c = Pbind(\instrument, \ringDrum, \bounce, Prand([1, 2,5,8],inf), \octave,3, \legato, 1, \rel, 0.01, \atk, 0, \clock, ~tempo)
~c.play