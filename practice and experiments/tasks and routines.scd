(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

SynthDef(\stretchedFragments, { |out, bufnum, start, time = 1, stretch = 1, amp = 1, attack = 0.01, decay = 0.05|
    var sig = PlayBuf.ar(1, bufnum, rate: stretch.reciprocal, startPos: start), eg;
    sig = PitchShift.ar(sig, pitchRatio: stretch);
    eg = EnvGen.kr(Env.linen(attack, time, decay), sig.abs > 0, doneAction: Done.freeSelf);
    Out.ar(out, (sig * eg) ! 2)
}).add; // note add! Without this, arguments won't work
)

(
TempoClock.default.tempo = 1;

p = Pbind(
    \instrument, \stretchedFragments,
    \bufnum, b,
    \start, Pwhite(0, (b.numFrames * 0.7).asInteger, inf),
    \delta, Pexprand(0.2, 1.5, inf),
    \time, Pkey(\delta),
    \stretch, Pexprand(1.0, 4.0, inf),
    \amp, 0.5,
    \attack, 0.1,
    \decay, 0.2
).play;
)

(
Synth(\stretchedFragments, [\bufnum, b, \start, 0, \stretch, 0.9])
)
p.stop
s.boot;

p.stop;
b.free;    // be tidy! remember to clean up your Buffer

(
var a, b, c, t;
a = Pbind(\x, Pseq([1, 2, 3, 4]), \dur, 1);
b = Pbind(\x, Pseq([10, 20, 30, 40]), \dur, 0.4);
c = Ptpar([0.0, a, 1.3, b]);
t = c.asStream;
20.do({ t.next(Event.default).postln; });
)

(
var a, b;
a = Pbind(\note, Pseq([7, 4, 0], 4), \dur, Pseq([1, 0.5, 1.5], inf));
b = Pbind(\note, Pseq([5, 10, 12], 4), \dur, 1);
Ptpar([ 0.0, a, 1.3, b ]).play;
)


SystemClock.sched(5, { "hello".postln })


r = Routine({
    "abcde".yield;
    "fghij".yield;
    "klmno".yield;
    "pqrst".yield;
    "uvwxy".yield;
    "z{|}~".yield;
});

r.next;    // get the next value from the Routine
6.do({ r.next.postln });
TempoClock.default.sched(1, { rrand(1, 3).postln; });


r = Routine({
    var delta;
    loop {
        delta = rrand(1, 3) * 0.5;
        "Will wait ".post; delta.postln;
        delta.yield;
    }
});

r.next;

TempoClock.default.sched(0, r);

r.stop;



(
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf);
    Out.ar(0, sig ! 2);    // sig ! 2 is the same as [sig, sig]
}).add;

r = Routine({
    var delta;
    loop {
        delta = rrand(1, 3) * 0.5;
        Synth(\singrain, [freq: exprand(200, 800), amp: rrand(0.1, 0.5), sustain: delta * 0.8]);
        delta.yield;
    }
});
)


r.play
r.stop

(
t = Task({
    loop {
        [60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
            Synth(\singrain, [freq: midi.midicps, amp: 0.2, sustain: 0.1]);
            1.wait;
        });
    }
}).play;
)

TempoClock.default.tempo = 2

t.stop;
t.play;