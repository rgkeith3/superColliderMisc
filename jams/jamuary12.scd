~a = Pbind(\instrument, \ringDrum, \dur, Pbjorklund2(12, 32), \degree, Pseq([1,1,2,1,3,2], inf), \scale, Scale.minorPentatonic, \octave, 3, \bounce, Pwrand([1,3,2], [0.7, 0.2, 0.1], inf), \amp, 1, \clock, ~tempo)

~a.clear
~b.clear
~b[0] = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Claps].choose, \dur, Pseq(f[\durFill].value(32, 1, 0.2), inf), \amp, 1)

~b[10] = \filter -> f[\stDelay]
~b.set(\wet10, 0.5)

~b[15] = \set -> Pbind(\divL, Prand([1, 2, 3, 4, 5], inf), \divR, Prand([1, 2, 3, 4, 5], inf), \decL, Prand([0.1, 0.5, 1, 2], inf), \decR, Prand([0.1, 0.5, 1, 2], inf), \dur, 8)

~b[20] = \filter -> {|in| FreeVerb.ar(in, 1, 0.1, 0.5)}
~b.set(\wet20, 0.5)

~c = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums]['Closed Hihat'].choose, \dur, 1/4, \amp, Pwhite(0.8), \pan, Pbrown(-1))
~c[10] = \filter -> f[\stDelay]

~c[20] = \set -> Pbind(\divL, Prand([8, 16, 32], inf), \divR, Prand([8, 16, 32], inf), \decL, Prand([0.1, 0.5, 1, 2], inf), \decR, Prand([0.1, 0.5, 1, 2], inf), \dur, 4)

~d[0] = Pbind(\instrument, \beatWarp, \buf, d[\samples][\breaks][2], \dur, 1/2, \beats, 4, \clock, ~tempo, \amp, 1.5, \winSize, 0.001, \start, PbeatRepeat(Array.fill(16, {|i| i/16}), Pwrand([1, 0], [0.2, 0.8], inf)), \freqScale, 1, \legato, 1, \atk, 0.001, \rel, 0.001, \pan, Pwrand([0, Pseq([-0.5, 0.5], 2)], [0.7, 0.3], inf))

~d[10] = \filter ->  {|in| (in * 5).distort}
~d[20] = \filter ->  {|in, ccDiv=1, contAmt=0.1| var cont = WhiteNoise.ar(contAmt); Concat2.ar(cont, in, matchlength: ~tempo.kr.reciprocal / ccDiv)}
~d[30] = \set -> Pbind(\contAmt, Pwhite(), \ccDiv, Prand([1,2,3,4,6,8, 16, 32], inf), \dur, Prand([1, 1/2, 1/4, 2],inf), \wet20, Pwrand([1, 0], [0.2, 0.8], inf))



~e[0] = Pbind(\instrument, \wub, \dur, Pseq([3, 7, 6], inf), \amp, 1, \degree, Pseq([3, 1, 1, 2, 1, 4],inf), \legato, Pseq([1, 0.5, 0.5],inf), \wubDiv, Pwrand([1, 2, 1/3], [0.8, 0.1, 0.1], inf), \bufPosStart, w.first.bufnum, \bufPosEnd, w.last.bufnum, \octave, 2, \scale, Scale.minorPentatonic, \q, 0.3, \bufPos, Pwhite(), \clock, ~tempo)

~e[10] = \filter ->  {|in| (in * 5).softclip}
~e.play

~f = Pbind(\instrument, \flutterSaw, \dur, 16, \degree, Psr(4, [1,2,3,4,5]), \octave, 6, \rate, Prand([5, 15, 50], inf), \atk, 1, \rel, 1, \amp, 0.6, \q, 0.2, \scale, Scale.minorPentatonic)

~f[10] = \filter -> {|in| FreeVerb.ar(in, 0.5, 1, 1)}

~out = ~b + ~c + ~d + ~e + ~f

~out.play; ~b.stop; ~c.stop;~d.stop;~e.stop;~f.stop
~out[10] = \filter -> {|in, lo=1, hi=1, cutoff=250| LPF.ar(in, cutoff, lo) + HPF.ar(in, cutoff, hi)}
~out.play
~out.set(\lo, 1)
~out.set(\cutoff, 5000)

~delSnd = ~b + ~c + ~d + ~e + ~f

~del = {CombC.ar(~delSnd.ar, 0.01, LFNoise1.kr(0.1).range(0.1, 0.001), 0.1)}
~del.play(fadeTime: 12)

~del.stop(5)

~g[0] = Pbind(\instrument, \saw, \degree, Prand([2,3], inf), \scale, Scale.minorPentatonic, \cutoff, Pbrown(500, 10000, 100), \rel, Pwrand([0.01, 1], [0.9, 0.1],inf), \dur, Pwhite(0.01, 0.1), \amp, Pwhite(0.8, 1), \q, 0.1, \pan, Pbrown(-1), \atk, 0)

~g.stop(25)
~g.play(fadeTime: 5)

~d.play
~e.stop
~f.stop
~c.stop

~out.stop; ~c.play; ~d.play; ~e.play; ~f.play;
~out.clear

~g[10] = \filter -> {|in| FreeVerb.ar(in, 1, 1)}
~g.set(\wet10, 0.5)
~c.stop







~t = Task({
	var count = p.clock.tempo * 60;
	loop {
		count = count + 1;
		if (count < 165) {
			p.clock.tempo = count / 60;
		};
		64.wait;
	}
})