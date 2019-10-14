(
s = Server.local;
ServerOptions.devices;
// s.options.outDevice_("UMC404HD 192k");
// s.options.inDevice_("UMC404HD 192k");
~numChannels = 2;
s.options.numOutputBusChannels_(~numChannels);
s.options.numInputBusChannels_(~numChannels);
s.options.memSize_(2.pow(20))
)

// init global vars
(
~out = 0;
~path = PathName(thisProcess.nowExecutingPath).parentPath ++ "buffs/";
)


(
~makeBuffer = {
	~buff = Buffer.readChannel(s, PathName(~path).entries[0].fullPath, channels: 1);
};

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
		~reverbGroup = Group.after(~mainGroup);
		~numChannels.do({
			arg i;
			Synth(
				\binScrambleReverb,
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

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerQuit.removeAll;
	ServerTree.removeAll;
};
)

(
ServerBoot.add(~makeBusses, s);
ServerBoot.add(~makeBuffer, s);



ServerQuit.add(~cleanup, s);
)


(
s.waitForBoot({
	s.sync;
	SynthDef(\binScrambleReverb, {
		arg in=2, out=0, mix=0.5, room=1, damp=0.5, wipe=0, width=0, t_trig=0;
		var buf, sig, chain;
		buf = LocalBuf.new(2.pow(10));
		sig = In.ar(in);
		sig = FreeVerb.ar(sig, mix, room, damp);
		chain = FFT(buf, sig);
		chain = PV_BinScramble(chain, wipe, width, t_trig);
		Out.ar(out, IFFT(chain));
	}).add;

	SynthDef.new(\grain, {
		arg out=0,
		bufnum,
		startPos=0,
		startPosSpread=0,
		atk=0,
		rel=1,
		envCurve=0,
		pan=0,
		panEnv=0,
		pitchEnv=0,
		pitchOffset=1,
		freq=1000,
		res=1,
		amp=1;
		var env, sig, panLine, bufFrames;
		bufFrames = BufFrames.kr(bufnum);
		env = EnvGen.ar(Env(times: [atk, rel], curve: envCurve), doneAction: 2);
		sig = PlayBuf.ar(
			1,
			bufnum,
			(env * pitchEnv) + (pitchOffset - pitchEnv),
			startPos: (bufFrames * startPos) + (Rand(startPosSpread * -1, startPosSpread) * bufFrames)
		);
		sig = BPF.ar(sig, freq, res) * env * amp;
		panLine = Line.ar(pan, panEnv, atk + rel);
		sig = Pan2.ar(sig, panLine);
		Out.ar(out, sig);
	}).add;

	ServerTree.add(~makeNodes, s);
	s.freeAll;

	s.sync;
	"done".postln;
	s.meter;
	s.scope;
});
)

// change pitch env to be aline and not just use the env;

(
Pbindef(\drops,
	\instrument, \grain,
	\delta, Pdefn(\delta, 1),
	\bufnum, ~buff,
	\startPos, Pdefn(\startPos, Pseg([0, 1], 12 * 60, repeats: inf)),
	\startPosSpread, Pdefn(\startPosSpread, 0),
	\atk, Pdefn(\atk, 1),
	\rel, Pdefn(\rel, 1),
	\envCurve, Pdefn(\envCurve, 0),
	\amp, Pdefn(\amp, 1),
	\pan, Pdefn(\pan, Pseg([-1, 1, 0], 25, repeats: inf)),
	\panEnv, Pdefn(\panEnv, 0),
	\pitchEnv, Pdefn(\pitchEnv, 0),
	\pitchOffset, Pdefn(\pitchOffset, 1),
	\res, Pdefn(\res, 10),
	\degree, Pdefn(\degree, 1),
	\octave, Pdefn(\octave, 5),
	\out, Pdefn(\out, 0)
).play
)

Pdefn(\atk, 0.01);
Pdefn(\rel, 1);
Pdefn(\envCurve, 0);
Pdefn(\delta, 0.1);
Pdefn(\startPosSpread, 0.0001);
Pdefn(\startPos, 0.6);
Pdefn(\amp, 0.7);
Pdefn(\pitchEnv, 0);
Pdefn(\pitchOffset, Pwrand([1, 1.5, 0.75, 2], [0.6, 0.1, 0.2, 0.1], inf));
Pdefn(\pan, Pwhite(-1.0, 1.0));
Pdefn(\panEnv, Pwhite(-1.0, 1.0));
Pdefn(\out, ~bus[\reverb][0]);
Pdefn(\degree, Prand([1,5,7], inf));
Pdefn(\res, Pwrand([0.1, 0.5, 1], [0.9, 0.07, 0.03], inf));

Pdefn(\atk, 1);
Pdefn(\rel, 1);
Pdefn(\envCurve, 0);
Pdefn(\delta, Pwhite(0.01, 0.5));
Pdefn(\startPosSpread, 0.001);
Pdefn(\startPos, 1.0.rand().postln);
Pdefn(\amp, 1);
Pdefn(\pitchEnv, 0);
Pdefn(\pitchOffset, 1);
Pdefn(\pan, 0);
Pdefn(\panEnv, Pwhite(-1.0, 1.0));
Pdefn(\out, ~bus[\reverb][0]);
Pdefn(\degree, Prand([1,5,7], inf));
Pdefn(\res, 10)

~reverbGroup.set(\wipe, 0.1);
~reverbGroup.set(\width, 0.5);
~reverbGroup.set(\mix, 0.5);
~reverbGroup.set(\damp, 0.1);
~reverbGroup.set(\room, 1);
~reverbGroup.set(\t_trig, 1);

(
Pbindef(\reverb,
	\type, \set,
	\delta, 0.1,
	\id, ~reverbGroup.nodeID,
	\args, [\wipe, \width, \mix, \damp, \room, \t_trig],
	\wipe, 0.1,
	\width, 0.1,
	\mix, 1,
	\damp, 0.5,
	\room, 1,
	\t_trig, 0
).play
)


({
	loop {
		Pdefn(\degree, Prand(Scale.major.degrees.scramble[0..3], inf));
		[16,32].choose.yield;
	}
}.fork)

(
Tdef(\startPos, {
	var i = 0;
	var startTimes = [[16, 0.33], [12, 0.6], [4, 0.23], [32, 0.36]];
	loop {
		Pdefn(\startPos, startTimes[i][1]);
		if (i == 3, {
			i = 0;
		}, {
			i = i + 1;
		});
		startTimes[i][0].yield;
	}
}).play
)

(
Tdef(\startPos, {
	loop {
		Pdefn(\startPos, 1.0.rand);
		16.yeild;
	}
}).play
)

Tdef(\startPos).stop
