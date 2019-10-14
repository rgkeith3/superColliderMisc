(
SynthDef.new(\reverb, {
	arg in, out=0, room=0.5, mix=0.5;
	var sig = In.ar(in, 2);
	var rev = FreeVerb2.ar(sig[0], sig[1], mix: mix, room: room);
	Out.ar(out, rev);
}).add
)

(
SynthDef.new(\pluck, {
	arg in, out;
	var trig = In.ar(in);
	var pan = Demand.ar(trig, 0, [
		Dwhite(-1, 1),
	]);
	var pluck = Pluck.ar(
		in: PinkNoise.ar(),
		trig: In.ar(in),
		delaytime: Latch.kr(MouseX.kr(0.0001, 0.03), trig),
		decaytime: 10,
		mul: 0.2
	);
	var sig = Pan2.ar(pluck, pos: pan);
	Out.ar(out, sig);
}).add
)

(
SynthDef.new(\pluck_cloud, {
	arg channel1, channel2, channel3, channel4;
	var dust = Dust.ar(MouseY.kr() * 20);
	var trigChannel = Demand.ar(dust, 0, Dseq([channel1, channel2, channel3, channel4], inf));
	Out.ar(trigChannel, K2A.ar(1));
}).add
)

(

~reverbBus = Bus.audio(s, 2);
~grainBus = Bus.audio(s, 2);
~pluckBus1 = Bus.audio(s);
~pluckBus2 = Bus.audio(s);
~pluckBus3 = Bus.audio(s);
~pluckBus4 = Bus.audio(s);


Synth(\reverb, [in: ~reverbBus]);

Synth(\pluck, [in: ~pluckBus1, out: ~reverbBus]);
Synth(\pluck, [in: ~pluckBus2, out: ~reverbBus]);
Synth(\pluck, [in: ~pluckBus3, out: ~reverbBus]);
Synth(\pluck, [in: ~pluckBus4, out: ~reverbBus]);

Synth(\pluck_cloud, [\channel1, ~pluckBus1, \channel2, ~pluckBus2, \channel3, ~pluckBus3, \channel4, ~pluckBus4 ]);
)
