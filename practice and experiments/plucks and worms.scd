// so the way we do quad reverb in this file is we basically create a reverb bus for each out, and instead of sending sig direct to outs, they go to reverbs first.
s.boot

(
~reverbBusses = Array.new(4);
4.do({
	var bus;
	bus = Bus.audio(s);
	~reverbBusses.add(bus);
})
)

~reverbBusses[0].index

(
SynthDef(\verb, {
	arg out=0, in=0, room=0.5, mix=0.5, damp=0.5;
	var sig = In.ar(in);
	Out.ar(out, FreeVerb.ar(sig, mix, room, damp));
}).add
)

(
SynthDef(\pluck, {
	arg freq=440, dec=1, pan=0, room=0.5, verbMix=0.5, channelOffset=0;
	var sig = Pluck.ar(WhiteNoise.ar(), delaytime: freq.reciprocal, decaytime: dec);
	EnvGen.kr(Env.perc(releaseTime: dec), doneAction: 2);
	Out.ar(channelOffset, PanAz.ar(4, sig, pan));
}).add
)

(
~reverbGroup = Group.new(s, \addToTail);
4.do({
	arg i;
	i.postln;
	Synth(
		\verb, [
			\out, i,
			\in, ~reverbBusses[i].index
		],
		~reverbGroup,
	)
})
)


(
Synth(\pluck, [
	\freq, rrand(250, 500),
	\dec, rrand(0.1, 4.0),
	\pan, rrand(0.0, 2.0),
	\channelOffset, 8
])
)

(
p = Pbind(
	\instrument, \pluck,
	\dur, Pwrand([0.2, Pseq([0.2/3], 3)], [0.9, 0.1], inf),
	\freq, Prand([48.midicps, 52.midicps, 64.midicps, 66.midicps], inf),
	\channelOffset, 8,
	\pan, Pwhite(0.0, 2.0),
	\dec, Pwhite(0.2, 4.0)
).play
)
p.stop;

~reverbGroup.set(\room, 1);
~reverbGroup.set(\mix, 0.5);
~reverbGroup.set(\damp, 0.3);

(
SynthDef(\wormy, {
	arg freq=440,
	filt_freq=200,
	filt_q=1, amp=1,
	channelOffset=0,
	movement=0.2,
	pitch_chaos=10;
	var sig = SawDPW.ar(LFBrownNoise2.kr(movement, mul: pitch_chaos) + freq);
	var filt = RLPF.ar(sig, filt_freq, filt_q, amp);
	Out.ar(
		channelOffset,
		PanAz.ar(4, filt, LFBrownNoise2.kr(movement).range(-4, 4).wrap(0,2))
	)
}).add
)
(
x = Synth(\wormy, [
	\freq, 329,
	\filt_freq, 6000,
	\filt_q, 0.01,
	\amp, 0.03
])
)
x.free

(
~wormyGroup = Group.new(s);

4.do({
	Synth(\wormy, [
		\freq, ([0, 4].choose + 40).midicps,
		\filt_freq, 6000,
		\filt_q, rrand(0.2, 0.8),
		\amp, 0.1,
		\movement, rrand(0.2, 2),
		\channelOffset, 8
	], ~wormyGroup)
})
)

~wormyGroup.set(\filt_q, 0.1);
~wormyGroup.set(\filt_freq, 10000);
~wormyGroup.set(\movement, 0.2);
~wormyGroup.set(\freq, 28.midicps);
~wormyGroup.set(\pitch_chaos, 5);
~wormyGroup.set(\channelOffset, 8);
~wormyGroup.set(\amp, 0.3);
~wormyGroup.free;
s.quit;
// dang this is cool, notes for the future, need to learn how PBindDef works so I can change patterns without stopping and starting.
// probably would make \wormy gated or have a long decay env so I can use it with patterns too.
// also need to make some drum sounds and adding a consistent drum beat would be sweet
