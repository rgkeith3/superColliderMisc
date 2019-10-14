s.boot

(
SynthDef("help-GaussTrig", { arg out=0;
    Out.ar(out,
        Ringz.ar(
            WhiteNoise.ar(
                Decay.kr(
                    Impulse.kr(10.dup),
                    0.02,
                    0.2
                )
            ),
            2000,
            0.05
        ).fold2(0.2)
    )
}).play;
)

(

// gonna make an allpurpose synthdef that's just whitenoise into ringz with var out, and freq, and rel
// then an array of reverbs in a group with different room size and damp

SynthDef(\pft, {
	arg out=0, freq=440, dec=0.1, pan=0;
	var sig = WhiteNoise.ar() * EnvGen.ar(Env.perc(0, dec, curve: -10), doneAction: 2);
	sig = Ringz.ar(sig, freq, dec, 0.1);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\verb, {
	arg in=0, out=0, room=0.5, damp=0.5;
	var sig = In.ar(in, 2);
	Out.ar(out, FreeVerb2.ar(sig[0], sig[1], 0.5, room, damp));
}).add;

)
(
~verbBusses = Array.new(4);

4.do({
	var bus = Bus.audio(s, 2);
	~verbBusses.add(bus);
});

~verbGroup = Group.new(s, \addToTail);
~verbs = Array.new(4);

~verbBusses.do({
	arg bus;
	var synth = Synth(\verb, [\in, bus.index, \room, rrand(0.0, 1.0), \damp, rrand(0.0, 1.0)], ~verbGroup);
	~verbs.add(synth);
});

)

(
p = Pbind(
	\instrument, \pft,
	\dur, 0.1,
	\out, Prand(~verbBusses.do({|b| b.index}), inf),
	\pan, Pwhite(-1.0, 1.0),
	\degree, Prand([12, 48, 77], inf),
	\dec, Prand([0.1, 0.01, 0.5], inf)
).play
)
p.stop

~verbs[0].set(\room, 1);
~verbs[1].set(\damp, 1);
~verbs[2].set(\room, 0.2);
~verbs[3].set(\room, 0.01);

// fun to mess with multiple reverb busses etc
// new things to do:
// work with sequencing reverbs?
// just make reverbs easier to control
// probably would be good with reverb gui
// could be cool with ambisonic and making the reverb more static -> far reverb bigger tail, close reverb smaller room, idk play around.
// probably to do this, would want to change \verb synthDef to be a mono reverb, but use the ambisonic tools to move it around?