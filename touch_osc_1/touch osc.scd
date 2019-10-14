(
SynthDef(\plucky, {
	arg freq=440, amp=0.8, pan=0, rel=5, timbre=0.5;
	var sig;
	sig = Pluck.ar(WhiteNoise.ar, maxdelaytime: freq.reciprocal, delaytime: freq.reciprocal, decaytime: rel, coef: timbre, mul: amp);
	DetectSilence.ar(sig,doneAction: 2);
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add
)

(
Pdef(\plucks,
	Pbind(
		\instrument, \plucky,
		\delta, Pdefn(\delta, Pwhite()),
		\degree, Pdefn(\degree, \),
		\octave, Pdefn(\octave, 1),
		\amp, Pdefn(\amp, 0.5),
		\pan, Pdefn(\pan, 0),
		\rel, Pdefn(\release, 5),
		\timbre, Pdefn(\timbre, 0)
	)
)
)

NetAddr.langPort
// set up key_latch listeners
(
~notes = Array.fill(12, nil);
12.do(
	{
		arg i;
		var key_number = i +1;
		OSCFunc.new({
			arg msg;
			var val, latched_keys;
			val = msg[1];
			if (val == 1, {~notes = ~notes.put(i, key_number)}, {~notes = ~notes.put(i, nil)});
			latched_keys = ~notes.inject([], {|a, b| if (b == nil, {a}, {a.add(b)})});
			if (latched_keys.isEmpty, {latched_keys = [\]});
			Pdefn(\degree, Prand(latched_keys, inf));

		}, ["/pluck/key_latch/", i+1].join.asSymbol);
	}
);

~octaves = Array.fill(10, nil);
10.do(
	{
		arg i;
		var octave_number = i + 1;
		OSCFunc.new({
			arg msg;
			var val, latched_octaves;
			val = msg[1];
				if (val == 1, {~octaves = ~octaves.put(i, octave_number)}, {~octaves = ~octaves.put(i, nil)});
				latched_octaves = ~octaves.inject([], {|a,b| if (b == nil, {a}, {a.add(b)})});
				if (latched_octaves.isEmpty, {latched_octaves = [1]});
				Pdefn(\octave, Prand(latched_octaves, inf));
		}, ["/pluck/octave/", octave_number].join.asSymbol);
	}
);

OSCFunc.new({
	arg msg;
	var val;
	val = msg[1];
	if (val == 1, {Pdef(\plucks).play}, {Pdef(\plucks).stop});
}, "/pluck/play");

~pluck_delta_min = 0.0;
~pluck_delta_max = 1.0;
OSCFunc.new({
	arg msg;
	~pluck_delta_min = msg[1].linlin(0, 1, 0.01, 1);
	Pdefn(\delta, Pwhite(~pluck_delta_min, ~pluck_delta_max));
}, "/pluck/delta/2");

OSCFunc.new({
	arg msg;
	~pluck_delta_max = msg[1].linlin(0, 1, 0.01, 1);
	Pdefn(\delta, Pwhite(~pluck_delta_min, ~pluck_delta_max));
}, "/pluck/delta/1");

~pluck_timbre_min = 0.0;
~pluck_timbre_max = 1.0;
OSCFunc.new({
	arg msg;
	~pluck_timbre_min = msg[1].linlin(0, 1, 0, 0.9);
	Pdefn(\timbre, Pwhite(~pluck_timbre_min, ~pluck_timbre_max));
}, "/pluck/timbre/1");

OSCFunc.new({
	arg msg;
	~pluck_timbre_max = msg[1].linlin(0, 1, 0, 0.9);
	Pdefn(\timbre, Pwhite(~pluck_timbre_min, ~pluck_timbre_max));
}, "/pluck/timbre/2");

~pluck_release_min = 0.0;
~pluck_release_max = 1.0;
OSCFunc.new({
	arg msg;
	~pluck_release_min = msg[1] * 5;
	Pdefn(\release, Pwhite(~pluck_release_min, ~pluck_release_max));
}, "/pluck/release/1");

OSCFunc.new({
	arg msg;
	~pluck_release_max = msg[1] * 5;
	Pdefn(\release, Pwhite(~pluck_release_min, ~pluck_release_max));
}, "/pluck/release/2");

~pluck_xy = [0, 0];
~pluck_xy_spread = 0;
OSCFunc.new({
	arg msg;
	var x, y;
	x = msg[1];
	y = msg[2];
	x = (x * 2) -1;
	~pluck_xy = [x, y];

	Pdefn(\amp, Pwhite(y - (~pluck_xy_spread / 2) ,y + (~pluck_xy_spread / 2)).clip(0, 1));
	Pdefn(\pan, Pwhite(x - ~pluck_xy_spread, x + ~pluck_xy_spread).clip(-1, 1));
}, "/pluck/xy1");

OSCFunc.new({
	arg msg;
	var val;
	val = msg[1];
	val = val.linlin(0, 1, 0.01, 1);
	~pluck_xy_spread = val.linlin(0, 1, 0.01, 1);
	#x, y = ~pluck_xy;

	Pdefn(\amp, Pwhite(x - (~pluck_xy_spread / 2) ,y + (~pluck_xy_spread / 2)).clip(0, 1));
	Pdefn(\pan, Pwhite(x - ~pluck_xy_spread, x + ~pluck_xy_spread).clip(-1, 1));
}, "/pluck/xy_width");

)