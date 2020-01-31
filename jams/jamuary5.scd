~a = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Kicks][8], \dur, Pseq(f[\durFillSize].value(16, 1/4, 0.45, 16), inf), \amp, 1, \pan, Pseq([Pseq([0], 12), Pseq([-1, 1, -1, 1])], inf))
~a.play

~b = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums]['Closed Hihat'].choose, \dur, Pseq([0.26, 0.25], inf), \pan, Pbrown(-1), \amp, Pwhite(0.8))
~b.play

~c[0] = Ptpar([4, Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Claps][9], \dur, 8, \amp, 2)])

~c[10] = \filterIn -> {|in| FreeVerb.ar(in, 1, 1)}
~c.set(\wet10, 0.3)
~c.play

~d[0] = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Snares][4], \dur, Pseq(f[\durFill].value(16, 1/4, 0.3), inf), \amp, Pwhite(0.5, 0.8))

~d[10] = \filterIn -> {|in, divL=4, divR=4, decL=1, decR=1| var time = p.clock.tempo.reciprocal; [CombN.ar(in[0], time, time/divL, decL), CombN.ar(in[1], time, time/divR, decR)]}
~d.set(\wet10, 0.2)

~d[20] = \set -> Pbind(\divL, Prand([2, 4, 8, 16, 32, 64], inf), \divR, Prand([2, 4, 8, 16, 32, 64], inf), \decL, Prand([1, 2, 0.5, 0.1], inf), \decR, Prand([1, 2, 0.5, 0.1], inf))
~d.play

~e = \stLoop
~e.spawn
~e.set(\buf, d[\stereo_samples][\texture][4], \amp, 1, \rate, 1)

~e.play


~f = Pbind(\instrument, \henonDrum, \degree, 1, \octave, 3, \dur, 1/4, \q, 0.01, \cutoff, 1000, \amp, 0.8, \rel, 0.3, \atk, 0, \pan, Pbrown(-1))

~f.play(fadeTime: 5)


~g = Pbind(\instrument, \noizSpr, \degree, Pwrand([1, 3], [0.8, 0.2], inf), \octave, 2, \dur, 8, \tilt, Pwhite(), \amp, 0.8, \atk, 0.5, \rel, 1, \res, 0.8, \sprTm, 8, \pAmt, 10)

~g[10] = \filterIn -> {|in| [CombC.ar(in[0], 0.01, LFNoise0.ar(p.clock.tempo.reciprocal).range(0, 0.01), 0.1), CombC.ar(in[1], 0.01, LFNoise0.ar(p.clock.tempo.reciprocal).range(0, 0.01), 0.1)]}

~g.set(\wet10, 0.5)
~g.play


~t = Task({
	var nodes = [~a, ~b, ~c, ~d, ~e, ~f, ~g];
	loop {
		var node = nodes.choose;
		if (node.isMonitoring) {
			node.stop;
		} { node.play };
		8.yield;
	}
})

~t.play