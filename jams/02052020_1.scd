(
~a[0] = Pbind(
	\dur, Pseq([
		Pbjorklund2(5, 8, 1) / 4,
		Pbjorklund2(7, 12, 1) / 4,
		Pbjorklund2(3, 8, 1) / 4,
		Pbjorklund2(3, 4, 1) / 4
	], inf),
	\instrument, \oneShot,
	\buf, d[\samples][\drums][\k][58],
	\amp, 1
)
)

~a.set(\rel, 2)
~a.play

(
~a[10] = \filter -> {|in|
	var clock, ramp, toggle, sig;
	clock = Impulse.kr(~tempo.kr / 32);
	ramp = Phasor.ar(clock, 1/SampleRate.ir/32);
	toggle = ToggleFF.kr(clock);
	sig = FreeVerb.ar(HPF.ar(in + Crackle.ar(LFNoise1.kr(1).range(0.5, 1.5), 0.1), 500), ramp, ramp * 5, 0);
	Select.ar(toggle, [(in * 2).distort, sig]);
}
)

~a[30] = nil
~c.stop
~a.set(\wet10, 1)
~s = {LFNoise1.kr(0.1).range(500, 1000)}


~b = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\ch].choose, \dur, 1/4)
~b.stop
~c = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\s][12], \dur, 4, \rel, 0.1, \amp, 0.5)
~c.stop
~e.stop(2)
~a.stop
s.stopRecording

8 + 12  + 8 + 4
QuadN.ar()
