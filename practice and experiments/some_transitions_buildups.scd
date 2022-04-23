(
~a = Ptpar([
	0, Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\k][0], \dur, Pbjorklund2(7, 16)/4),
	0, Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\s][0], \dur, Pbjorklund2(5, 16)/2),
	0, Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\ch][0], \dur, Pseq([Pn(0.5, 64 * 2), Pn(0.25)], inf)),
]);
~a.play;

~b = {(SinOsc.ar(18) + Crackle.ar(LFNoise1.kr(1).range(0.5, 2), 0.1)) * XLine.ar(0.01, 1, dur: p.clock.bars2beats(16) * p.clock.beatDur, doneAction: 2)};
~b.play;

// ~c = PmonoArtic(\303, \instrument, \saw, \octave, 4, \degree, Pseq([0, 0, 0, 1, 0, 8, 2, 1], inf), \dur, 1/2, \legato, Pseq([0.9, 0.9, 1, 0.9, 0.9, 1, 1, 0.9], inf), \scale, Scale.minor);
// ~c.play(fadeTime: p.clock.bars2beats(8) * p.clock.beatDur);
~rev.play(0, fadeTime: p.clock.bars2beats(16) * p.clock.beatDur);
p.clock.play({p.clock.sched(64, {~rev.stop(0);})}, p.quant);
)

p.clock.queue

(
p.clock.beats.postln;
(p.clock.nextBar * p.clock.beatDur).postln;
(p.clock.beatDur * 64).postln;
p.clock.seconds.postln;
)

p.quant - p.clock.beatInBar + 64

p.clock.elapsedBeats
p.clock.nextBar

p.clock.beatDur
p.clock.nextBar
currentEnvironment.quant
p.clock.beatsPerBar
p.clock.beats2secs(64)

p.clock.beatDur * 64
p.clock.nextTimeOnGrid(4) * p.clock.beatDur
p.clock.timeToNextBeat(4)
p.quant
TempoClock.nextBar()
~c.play


p.clock.bars2beats(16) * p.clock.beatDur
16 * 8

p.clock.bars2beats(16)
p.clock.nextTimeOnGrid(4)

p.clock.beats2bars(8)

p.clock.bars2beats(16)
~rev.stop()
~c.play
p.clock.bar
4.bar
~revSnd = ~a + ~b + ~c
~rev = {NHHall.ar(~revSnd.ar, stereo: 1)}

~a.play;

~b.play;
p.clock.beatDur * 64

~out = {SinOsc.ar(50)}
