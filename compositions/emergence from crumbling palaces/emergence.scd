// emergence from crumbling palaces - working title
// memories of places and times melt away and take on new life in their atomized pieces.

// supercollider / touchdesigner performance

// starts with 360 video of a place, flipping to different videos. the particles are crossfaded out.
// slowly displacement starts to fade in as the audio drone gets more detuned (i want to use something like the flutter saw again, with essentially an ar env that can move around the space on it's own)

//vocal samples are granulated, but more or less intelligible, and center panned.

// a swell rises, and the drone gets more detuned, then bang, the drones all start detuning quickly and disperse as the displacement on the hdri goes crazy into a muddled mess.
// the vocal samples are all discombobulated and move in space with the flock

// occasionally a full vocal sample plays un granulated and un moving in space -> triggers flock trails in TD
// a bell or karp or something will ring out as a 360 video is clearly introduced into the hdri displacement

s.quit

b = Buffer.alloc(s, 44100*4)



//
n = NetAddr("127.0.0.1", 10000)

(
SynthDef(\vosc3Drone, {|out=0, bufNumSt, bufNumEnd, vSpd=1, atk=0.01, rel=1, pan=0, pAmt=1, pSpd=1, freq=440, fAmt=50, fSpd=1, amp=1, aAmt=0.5, aSpd=1|
	var sig;
	sig = VOsc.ar(LFNoise1.kr(vSpd).range(bufNumSt, bufNumEnd), LFNoise1.kr(fSpd, fAmt, freq), mul: LFNoise1.kr(aSpd, aAmt, amp));
	sig = sig * EnvGen.ar(Env([0, 1, 0], [atk, rel]), doneAction: 2);
	sig = Pan2.ar(sig, LFNoise1.kr(pSpd, pAmt, pan));
	Out.ar(out, sig);
}).add
)


~x = {|chaosL=1.5, chaosR=1.5| Crackle.ar([chaosL, chaosR])}
~x.play

Pbindef(\x, \type, \set, \id, ~x.nodeID, \args, [\chaosL, \chaosR], \chaosL, Pseq([1.5, 0.5], inf), \chaosR, Pseq([0.5, 1.5], inf), \dur, 1/16, \netAddr, n, \bgTop, Prand([0,1,2,3,4],inf)).play


(~v = {
	BufWr.ar(SoundIn.ar, b, Phasor.ar(end: 44100 * 4));

	GrainBuf.ar(2, Dust.ar(150), WhiteNoise.kr.range(0.001, 1), b, Select.kr(WhiteNoise.kr.range(0, 4), [1, 0.5, 2, 1.5, 1.334]), WhiteNoise.ar(1), pan: WhiteNoise.ar(1), envbufnum: e[\perc]);
})
~v.play
Pbindef(\v).stop
Pbindef(\v, \type, \set, \id, ~v.nodeID, \args, [\readSpray, \pan], \pan, Pwhite(-1), \readSpray, Pwhite(), \oscArgs, [\posX, \posY, \posZ, \turb], \posX, Pkey(\pan), \posY, Pwhite(-1), \posZ, Pwhite(-1), \turb, Pkey(\readSpray)).play



~v.nodeID

~a = Pbind(\instrument, \vosc3Drone, \degree, Pseq([0,2,4,6], inf), \octave, Prand([4,3,5], inf), \fAmt, 1, \dur, 1/2, \bufNumSt, 100, \bufNumEnd, 120, \vSpd, 1, \amp, 1, \aAmt, 0.5, \aSpd, 1, \atk, 0, \rel, Pwrand([0.5, 5], [0.8, 0.2], inf), \fSpd, 10, \pSpd, 1, \pAmt, 1, \pan, Pbrown(-1))
~a.play;
~a.stop

~b = {Pan2.ar(RLPF.ar(Saw.ar(50), Saw.kr(SinOsc.kr(0.3).range(0, 5), 1.75).range(0,5000),0.1), LFNoise1.kr(0.1))}
~b.clear
~b.play
~revSnd = ~a + ~v

~rev = {NHHall.ar(~revSnd.ar, 2)}

~rev.play