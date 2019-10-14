s.boot;

(
a = Routine.new({
	"abc".yield;
	"def".yield;
	"ghi".yield;
	"jkl".yield;
});
)

a.next

(
b = Routine({
	var delta;
	loop {
		delta = rrand(1, 3) * 0.5;
		"will wait ".post; delta.postln;
		delta.yield;
	}
});
)

b.next

TempoClock.default.sched(0, b);

b.stop;

(
a = Routine({
	var delta = TempoClock.default.beatDur / 4, i = 0, step_number;
	loop {
		Synth(\aKick, [\freq, 500]);
		if (i % 4 == 0) {Synth(\aKick)} {};
		if (i % 6 == 0) {Synth(\aKick, [\freq, 50, \rel, 1])} {};
		if (i == 7){
			Pbind(
				\instrument, \aKick,
				\freq, 1000,
				\dur, Pseq([0.1],3)
			).play
		} {};
		i = i + 1 % 16;
		delta.yield;
	}
});
)
TempoClock.default.sched(2, a);
s.boot;
(
Tdef(\main_rydim, {
	var delta = 0.25, i =0;
	loop {
		// fires every step
		Synth(\aKick, [\freq, 5000, \pitch_rel, 0.001]);
		// fires on every 4th step
		if (i % 4 == 0) {
			Pbind(
				\instrument, \aKick,
				\dur, Pwrand([1, Pseq([0.1], 3)], [0.8, 0.2]),
				\freq, Prand([75, 50], 3),
			).play
		} {};
		if (i == 7) {
			Synth(\aKick, [\freq, 50, \crush, 5]);
		} {};

		i = i + 1 % 16;
		delta.yield;
	}
})
)

Tdef(\main_rydim).play

