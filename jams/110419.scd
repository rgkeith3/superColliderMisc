~a[0] = Pbindef(\a, \instrument, \oneShot, \buf, d[\samples][\zaps].choose, \dur, Pseq(f[\durFill].value(8, 1/4, 0.3), inf))
Pbindef(\a, \rel, 0.5, \amp, 0.5)


~a[10] = \filterIn -> {|in| DFM1.ar(in, l[\sin].value(p.clock.tempo, 1/32, 250, 5000), 0.8)}

~a[15] = \filterIn -> {|in| CombC.ar(in, 0.01, SinOsc.kr(0.01, mul: 0.005, add: 0.0051), 0.1)}

~a[17] = \filterIn -> {|in| CompanderD.ar(in) * 0.2}

~a[20] = \filterIn -> {|in, divR=1, divL=1| var b = p.clock.tempo.reciprocal; [CombN.ar(in[0], b*4, b*divR, 5), CombN.ar(in[1], b*4, b*divR, 5)] + in}

~a.set(\divL, 1/2)

~a.set(\wet20, 0.2)
~a.set(\wet10, 0.3)


~b[0] = Pbindef(\b, \instrument, \oneShot, \buf, d[\samples][\Drums][\Kicks][5], \dur, Pwrand([1, Pseq([3/4, 1/4])], [0.8, 0.2], inf), \rel, 1)

Pbindef(\b, \buf, d[\samples][\Drums][\Kicks].choose)
Pbindef(\b, \dur, Pwrand([1, Pseq([3/4, 1/4])])

~b[10] = \filterIn -> {|in| CompanderD.ar((~b * 0.5), slopeBelow: 0.9)}
~b.play

~c[0] = Pbindef(\c, \instrument, \oneShot, \buf, d[\samples][\Drums][\Claps].choose, \dur, Prand([8, Pseq([3/4, 3/4, 3/4, 23/4])], inf))
Pbindef(\c, \amp, Pwhite(0.8))
~c.play

~d[0] = {|freq=1, pan=0| Pan2.ar(Impulse.ar(freq * p.clock.tempo), pan)}
~d[5] = \set -> Pbind(\pan, Pwhite(-1.0, 1.0))
~d[7] = \filterIn -> {|in| Ringz.ar(in, 10000, 0.01)}
~d[10] = \filterIn -> {|in| [CombN.ar(in[0], 0.1, LFNoise1.kr(0.5, 0.05, 0.05), ), CombN.ar(in[1], 0.1, LFNoise1.kr(0.1, 0.05, 0.05), 1)] + in}
~d.set(\wet10, 0.2)
~a.getSynchronous
~d.play

~revSnd = ~c
~rev = {NHHall.ar([~revSnd.ar[0], ~revSnd.ar[1]], 2)}

~e[0] = \stWarp

~e.set(\buf, d[\stereo_samples][\texture].choose)
~e.set(\windowSize, 0.3)
~e.set(\windRand, 0.2)
~e.set(\freqScale, 1.1)
~e.set(\overlaps, 4)

~a.play;~b.play;~d.play;~c.play
~a.stop;~b.stop;~d.stop;~c.stop
~a.play

~t1 = Task {
	loop {
		var trak = [~a, ~b, ~c, ~d, ~e].choose;
		if (trak.isMonitoring) {
			trak.stop;
		} { trak.play; };
		64.yield
	}
}

~e.play


~f[0] = Pbindef(\f, \instrument, \beatPlay, \clock, p.clock.tempo, \beats, 8, \dur, 8, \buf, d[\samples][\breaks][7], \legato, 1)

Pbindef(\f, \start, PbeatRepeat(f[\valFill].value(16, 1/4, 0.3, 8), Pwrand([1, 0], [0.2, 0.8], inf), inf), \dur, 1/2, \beats, 8)
Pbindef(\f, \dur, Pseq(f[\durFillSize].value(16, 1, 0.3, 8), inf), \start, Pseq(f[\valFill].value(8, Array.series(16, 0, 1/16)), inf))


~f[10]= \filterIn -> {|in| CompanderD.ar(in * 5)}
~f.play


~l1 = {l[\sin].value(p.clock.tempo, 1/5)}
~l2 = {l[\sh1].value(p.clock.tempo, 1/5, 0, 1)}

~e.play