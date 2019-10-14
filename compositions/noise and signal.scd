// server config
(
s = Server.local;
ServerOptions.devices;
s.options.outDevice_("UMC404HD 192k");
s.options.inDevice_("UMC404HD 192k");
~numChannels = 4;
s.options.numOutputBusChannels_(~numChannels);
s.options.numInputBusChannels_(~numChannels);
s.options.memSize_(2.pow(20))
)
// init global vars
(
~out = 0;
~path = PathName(thisProcess.nowExecutingPath).parentPath ++ "buffers/";
)
// define functions to add to serverBoot/Quit/Tree
// create a dictionary of busses
// for 4 channel, we need a reverb for each out, so ~bus[\reverb] has 4 buses
(
~makeBusses = {
	~bus = Dictionary.new();
	~bus.add(\reverb -> Array.new(~numChannels));
	~numChannels.do({
		var bus;
		bus = Bus.audio(s);
		~bus[\reverb].add(bus);
	})
};

~makeNodes = {
	s.bind({
		~mainGroup = Group.new(s);
		~rhythmGroup = Group.new(s);
		~reverbGroup = Group.after(~mainGroup);
		~numChannels.do({
			arg i;
			Synth(
				\reverb,
				[
					\in, ~bus[\reverb][i].index,
					\out, i,
					\room, 0.5,
					\mix, 0.5,
					\damp, 0.5
				],
				~reverbGroup
			);
		});
	});
};

~makeBuffers = {
	~buffers = [];
	PathName(~path).entries.do{
		arg entry;
		var buf = Buffer.read(s, entry.fullPath);
		~buffers = ~buffers.add(buf);
	}
};

~makeEnvBuf = { |times|
	var env = Env([0,1,1,0], times[0], times[1]);
	Buffer.sendCollection(s, env.discretize, 1);
};


~makeGrainEnvs = {
	~grainEnvs = [];

	[
		[[0,0,1],\cub],
		[[0,0,1],\lin],
		[[1,1,1],\sin],
		[[1,0,0],\lin],
		[[1,0,0],\cub],
		[[0,1,0],\lin]
	].do({|times|
		var buf = ~makeEnvBuf.value(times);
		~grainEnvs = ~grainEnvs.add(buf);
	});
};

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerQuit.removeAll;
	ServerTree.removeAll;
};

~makeEvents = {};
)

// register functions with ServerBoot/Quit/Tree
(
ServerBoot.add(~makeBusses, s);
ServerBoot.add(~makeBuffers, s);
ServerBoot.add(~makeGrainEnvs, s);

ServerQuit.add(~cleanup, s);
)

// boot server
(
s.waitForBoot({
	s.sync;
	SynthDef(\reverb, {
		arg in=0,
		out=0,
		room=1,
		mix=0.5,
		damp=0.3;

		var sig = In.ar(in);
		Out.ar(out, FreeVerb.ar(sig, mix, room, damp));
	}).add;

	SynthDef(\ambiFlutterWorm, {
		arg
		out=0,
		atk=10,
		sus=0,
		rel=10,
		amp=1,
		freq=75,
		filter_freq=1000,
		filter_q=0.5,
		flutter_freq=15,
		flutter_filter_freq=5000,
		flutter_filter_q=0.5,
		flutter_mix=0.5,
		flutter_mix_chaos_depth=0,
		flutter_mix_chaos_speed=1,
		sig_chaos_depth=0.01,
		sig_chaos_speed=1,
		pos=0,
		pos_chaos_depth=0.01,
		pos_chaos_speed=1;

		var sig, noise, env, sig_chaos, noise_chaos, mix_chaos, pos_chaos;

		env = EnvGen.kr(
			Env.new(
				levels: [0, 1, 1, 0],
				times: [atk, sus, rel]
		), doneAction: 2);

		sig_chaos = LFNoise2.kr(sig_chaos_speed, freq * sig_chaos_depth);
		noise_chaos = LFNoise2.kr(
			sig_chaos_speed,
			flutter_freq * sig_chaos_depth
		);
		sig = SawDPW.ar(freq + sig_chaos);
		noise = PinkNoise.ar(Saw.ar(flutter_freq + noise_chaos).unipolar);
		noise = RHPF.ar(noise, flutter_filter_freq, flutter_filter_q);
		sig = RLPF.ar(sig, filter_freq, filter_q);
		mix_chaos = LFNoise2.kr(
			flutter_mix_chaos_speed,
			flutter_mix_chaos_depth
		);
		sig = XFade2.ar(
			sig,
			noise,
			((flutter_mix * 2) - 1) + mix_chaos,
			env * amp
		);

		pos_chaos = LFNoise2.kr(pos_chaos_speed, pos_chaos_depth);
		sig = PanAz.ar(~numChannels, sig, (pos_chaos + pos).wrap(0,2));

		Out.ar(out, sig);
	}).add;

	SynthDef(\plucky, {
		arg out=0, freq=440, rel=1, timbre=0.5, pan=0, amp=1;
		var sig;
		sig = Pluck.ar(
			WhiteNoise.ar(amp),
			maxdelaytime: freq.reciprocal,
			delaytime: freq.reciprocal,
			decaytime: rel,
			coef: timbre
		);
		DetectSilence.ar(sig, doneAction: 2);
		sig = PanAz.ar(~numChannels, sig, pan);
		Out.ar(out, sig);
	}).add;

	SynthDef(\grainSampler, {
		arg bufnum=0,
		out=0,
		pan=0,
		panSpread=0,
		atk=1,
		sus=1,
		amp=1,
		rel=1,
		grainEnv=(-1),
		grainSize=0.1,
		windowRate=1,
		windowPosNoise=0,
		startPos=0,
		grainPitchRatio=1,
		trigRate=100,
		trigNoise=0;

		var windowPos, sig, env, trig, pos, playRate;
		env = EnvGen.kr(Env([0,amp,amp,0], [atk, sus, rel], \sqr));
		trig = GaussTrig.ar(trigRate, trigNoise);
		pos = WhiteNoise.kr(panSpread) + pan;
		playRate = windowRate * BufDur.kr(bufnum).reciprocal;
		windowPos =
		LFSaw.ar(playRate, 1, 0.5, 0.5) + LFNoise0.ar(mul:windowPosNoise) + startPos;
		sig = GrainBuf.ar(
			~numChannels,
			trig,
			grainSize,
			bufnum,
			grainPitchRatio,
			windowPos,
			pan: pos,
			envbufnum: grainEnv,
			mul: env
		);

		DetectSilence.ar(sig, doneAction: 2);
		Out.ar(out, sig);
	}).add;
	s.sync;

	ServerTree.add(~makeNodes, s);
	s.freeAll;

	s.sync;
	"done".postln;
	s.meter;
	s.scope;
});
)



// anything else requiring a booted server
// I need to really break the piece into events of patterns that will be created during ~makeEvents and then to play, I can just play the events

(
Pdef(
	\noise_and_sig,
	Pbind(
		\instrument, \ambiFlutterWorm,
		\dur, 1/12,
		\atk, 0,
		\sus, Pwrand([0.04, 0.5],[0.9, 0.1], inf),
		\rel, 0,
		\amp, Pwhite(hi: 0.3),
		\freq, Pwrand([3, 8] * 12, [0.99, 0.01], inf).midicps,
		\filter_freq, Pwrand([7, 10] * 12, [0.5, 0.5], inf).midicps,
		\filter_q, Pwhite(),
		\flutter_freq, Pwrand([20, 25], [0.9, 0.1], inf),
		// NOTE: experiment with appropriate flutter filter freqs, some go bonkers
		\flutter_filter_freq, Pwrand([10000, 1000, 500], [0.8, 0.1, 0.1], inf),
		\flutter_filter_q, 0.01,
		\flutter_mix, 0.5,
		\flutter_mix_chaos_depth, 0,
		\flutter_mix_chaos_speed, 0,
		\sig_chaos_depth, 0,
		\sig_chaos_speed, 0.1,
		\pos, Pwhite(-1.0, 1.0),
		\pos_chaos_depth, 1,
		\pos_chaos_speed, 1,
		\group, ~mainGroup,
		\out, Pseq([~bus[\reverb][0].index, ~out], inf);
	)
).play;
)

(
Pdef(
	\bass,
	Pbind(
		\instrument, \ambiFlutterWorm,
		\dur, Prand([8, 12], inf),
		\atk, 1,
		\sus, Pkey(\dur, inf) / 3,
		\rel, 1,
		\amp, 0.8,
		\freq, Prand([36, 38], inf).midicps,
		\filter_freq, 250,
		\filter_q, Pwhite(0.1, 0.5),
		\flutter_freq, Pwhite(5, 15),
		\flutter_mix, Pwhite(hi: 0.2),
		\flutter_mix_chaos_depth, 0.3,
		\sig_chaos_depth, 0,
		\pos, Pwhite(-1.0, 1.0),
		\pos_chaos_depth, 1,
		\pos_chaos_speed, 0.1,
		\out, ~bus[\reverb][0].index
	)
).play
)

(
Pdef(\reverbs,
	Pbind(
		\type, \set,
		\id, ~reverbGroup.nodeID,
		\args, [\room, \mix, \damp],
		\dur, 0.1,
		\room, 10,
		\mix, 0.5,
		\damp, 0.5
	)
).stop
)

~reverbGroup.set(\room, 0.5);
~reverbGroup.set(\mix, 0.3);
~reverbGroup.set(\damp, 1);

~reverbGroup.nodeID

(
Pdef(
	\beep,
	Pbind(
		\instrument, \ambiFlutterWorm,
		\dur, 0.1,
		\atk, 0.001,
		\sus, Pwrand([0.05, 0.5],[0.9, 0.1], inf),
		\rel, 0.001,
		\amp, Pwhite(0.01,0.2),
		\freq, Prand([9, 10] * 12, inf).midicps,
		\filter_freq, 10000,
		\filter_q,  0.1,
		\flutter_mix, 0,
		\flutter_mix_chaos_depth, 0,
		\sig_chaos_depth, 0,
		\pos, Pwhite(-1.0, 1.0)!2,
		\pos_chaos_depth, 1,
		\pos_chaos_speed, 1
	)
).play
)

Pdef(\beep).stop

(
Pdef(\beet,
	Pbind(
		\instrument, \ambiFlutterWorm,
		\delta, Pwrand(
			[4, Pseq([1/3, 1/3, 1/3, 3])],
			[0.9, 0.1],
			inf),
		\atk, 0,
		\sus, 0,
		\rel, 0.2,
		\amp, 1,
		\freq, 50,
		\filter_freq, 75,
		\filter_q, 0.1,
		\amp, 5,
		\flutter_mix, 0.01,
		\flutter_mix_chaos_depth, 0.01,
		\pos, Pwhite(-0.5, 0.5),
		\pos_chaos_depth, 0,
	)
).play
)

(
Pdef(\plucks,
	Pbind(
		\instrument, \plucky,
		\delta, Pwhite(hi: 0.1),
		\degree, Prand(Scale.majorPentatonic.degrees, inf),
		/*\dur, Pwrand([0.1, Pseq([0.01], 10)], [0.9, 0.1], inf),
		\freq, Prand([
			Prand([60, 64, 67, 71], 48).midicps,
			Prand([62, 65, 69], 48).midicps,
			Prand([64, 65, 69, 71], 48).midicps,
			Prand([62, 64, 67, 65], 48).midicps
		], inf),*/
		\rel, Pwrand([1, 3],[0.8, 0.2], inf),
		\timbre, 0.5,
		\out, Prand([~bus[\reverb][0].index, ~out], inf),
		\pan, Pwhite(-1.0, 1.0),
		\amp, 0.5
	)
).play
)

(
Pdef(\grains,
	Pbind(
		\instrument, \grainSampler,
		\delta, 1/3,
		\out, Prand([~out, ~bus[\reverb][0].index],inf),
		\bufnum, ~buffers[1],
		\grainEnv, ~grainEnvs[0],
		\startPos, 0,
		\windowPosNoise, 0,
		\windowRate, 1,
		\atk, 0,
		\sus, 0,
		\grainPitchRatio, 1,
		\rel, Pwrand([0.1, 1], [0.9, 0.1], inf),
		\amp, 2,
		\trigRate, 500,
		\trigNoise, 1,
		\grainSize, 0.01,
		\panSpread, 1,
	)
).play(t)
)
Pdef(\grains).stop
(
SynthDef(\help_dwgbowed, { |out=0, freq=440, amp=0.5,force=1, gate=1,pos=0.07,c1=0.25,c3=31,pan=0|
    var vib = Gendy1.kr(1,1,1,1,0.1, 4,mul:0.003,add:1);
    var son = DWGBowedSimple.ar(freq*vib, amp,force, gate,pos,0.5,c1,c3);
    son = DWGSoundBoard.ar(son);
    son = BPF.ar(son,118,1)+son;
    son = BPF.ar(son,430,1)+son;
    son = BPF.ar(son,490,1)+son;
    son = LPF.ar(son,6000);
    Out.ar(out, Pan2.ar(son * 0.1, pan));
}).add;
)
~bus
//Use it.
(

Pbind(
    \instrument, \help_dwgbowed,
    \dur , 1,
    \degree, Pseq([-11,5,7+3], inf),
    \amp , Pseq([0.9,0.7,0.5],inf),
	\force, 0.5,
	\pos, 0.2,
	\c1, 0,
	\out, ~bus[\reverb][0].index
).play;
)
