s.reboot

HOABinaural.loadHeadphoneCorrections;
HOABinaural.loadbinauralIRs;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
// sound distance attenuation
// SPL2​=SPL1​−20log(r2/r1​),
// lets say point 1 is always 1 meter away from the sound source
// and 1 meter away from the sound source is always 1.0
// point 2 is our listener
// r2 is distance from listener

// doppler effect
//f = (f0​ * (v+vr​))/(v + vs)
// f = freq observed
// f0 = freq emitted
// v = velocity of waves = 343.2 m/s
// vr = velocity of observer
// vs = velocity of source
// f = (f0 * (343.2 + vr))/(343.2 + vs)
// velocity = distance / time
// distance is always in meters
// time will be in seconds
{
	var sig, radius, gain, dradius, vel, freq, observed_freq, cart, s_radius;
	s_radius = 2;
	cart = Cartesian(LFNoise2.kr(2, 15), LFNoise2.kr(2, 15), LFNoise2.kr(2, 15));
	radius = max(cart.rho, s_radius);
	dradius = DelayN.kr(radius, ControlDur.ir, ControlDur.ir);
	vel = (radius - dradius)/ControlDur.ir;
	freq = 1;
	observed_freq = (freq * (343.2))/(343.2 + vel);
	gain = (0 - (20 * log(radius/1)));
	// sig = Saw.ar(K2A.ar(observed_freq)) * gain.dbamp;
	// sig = PlayBuf.ar(1, b.bufnum, observed_freq, loop: 2) * gain.dbamp;
	sig = Warp1.ar(1, b.bufnum, MouseX.kr, observed_freq) * gain.dbamp;
	sig = HOAEncoder.ar(3, sig, cart.theta, cart.phi, plane_spherical: 0, radius: radius, speaker_radius: s_radius);
	HOABinaural.ar(3, sig, headphoneCorrection: nil);
}.play)

~ambiBus = Bus.audio(s, HOA.o2c(3))
(SynthDef(\vecSaw, {|freq=440, st_x=(-1), st_y=(-1), st_z=(-1), en_x=1, en_y=1, en_z=1, wander=0.1, spd=1, s_rad=2, dop_amt=1, gate=1, atk=0.1, rel=0.1|
	var x, y, z, rad, drad, vel, dop, gain, cart, sig, env;
	x = Line.kr(st_x, en_x, spd) + LFNoise1.kr(1, wander);
	y = Line.kr(st_y, en_y, spd) + LFNoise1.kr(1, wander);
	z = Line.kr(st_z, en_z, spd) + LFNoise1.kr(1, wander);
	cart = Cartesian(x, y, z);
	rad = max(cart.rho, s_rad);
	drad = DelayN.kr(rad, ControlDur.ir, ControlDur.ir);
	vel = (rad - drad)/ControlDur.ir;
	dop = 343.2/(343.2 + (vel* dop_amt));
	gain = (0 - (20 * log(rad/1)));
	env = EnvGen.ar(Env.asr(atk, 1, rel),gate,doneAction: 2);

	sig = LPF.ar(Saw.ar(freq * dop, gain.dbamp) * env, 2000);
	sig = HOAEncoder.ar(3, sig, cart.theta, cart.phi, radius: rad, speaker_radius: s_rad);
	Out.ar(~ambiBus, sig);
}).load)



(SynthDef(\binDec, {|rev=0.5, room=1, damp=1, del=0.5, del_time=0.25, del_tim_rand=0, del_dec=1, del_spd=0.5|
	var sig = In.ar(~ambiBus, HOA.o2c(3));
	sig = FreeVerb.ar(sig, rev, room, damp);
	sig = SelectX.ar(del, [sig, AllpassC.ar(sig, 1, del_time + LFNoise2.kr(del_spd!HOA.o2c(3), del_time * del_tim_rand), del_dec)]);
	sig = HOABinaural.ar(3, sig, headphoneCorrection: nil);
	sig = Limiter.ar(sig);
	Out.ar(0, sig);
}).load)
Pbindef(\saws).stop
Pbindef(\saws).play
Pbindef(\saws, \instrument, \vecSaw, \dur, Pwhite(0.01, 0.1), \sustain, 1, \st_x, 15, \st_y, Pwhite(-15, 15.0), \st_z, Pwhite(-15, 15.0), \en_x, -15, \en_y,  Pkey(\st_y), \en_z, Pkey(\st_z), \degree, Pdefn(\degree, Prand([0,2,4,6], inf)), \octave, Prand([3,4,5,6], inf), \spd, Pwhite(0.5, 2), \wander, 0, \dop_amt, 0.25)

Pdefn(\degree, Prand(([0,2,4,6] + 8.rand).wrap(0, 8), inf))
x = Synth(\binDec, addAction: \addToTail)
x.free
x.set(\del_tim_rand, 0.8)
x.set(\del_time, 1/2.pow(8))
x.set(\del_spd, 10)
x.set(\del_dec, 0.01)
x.set(\rev, 0.5)
x.set(\room, 1)
x.set(\damp, 0)
x.set(\del, 0.25)

0.125 / 2.pow(3)