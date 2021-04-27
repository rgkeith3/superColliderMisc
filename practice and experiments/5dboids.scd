// 5d boids
// a flock of agents flying through space, time and some other dimension

s.options.numBuffers = 2.pow(14);

s.options.memSize = 2.pow(20);

s.boot

a = Buffer.readChannel(s, "/Users/greykeith/superCollider/utils/stereo_samples/Miserere/Miserere-01.wav", channels: 1);

b = Bus.audio(s, 4);
b.scope

(SynthDef(\ndboid, {|rho=0, theta=0, phi=0, playhead=0, binwipe=0, out=0|
	var sig, closeness, chain, ambi;
	closeness = rho.linlin(0, 707, 1, 0);
	sig = Warp1.ar(1, a, playhead, overlaps: 4, windowRandRatio: 0.1);
	sig = LPF.ar(sig, closeness.linlin(0,1,1, 10000), closeness);
	chain = FFT(LocalBuf(1024), sig);
	chain = PV_RandComb(chain, binwipe);
	sig = IFFT(chain);
	ambi = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni());
	ambi = FoaFocus.ar(sig, pi/2, theta, phi);
	Out.ar(out, ambi);
}).add)

(SynthDef(\ambiFreeverb, {|room=0.5, damp=0.5|
	ReplaceOut.ar(b, FreeVerb.ar(In.ar(b, 4), room: room, damp: damp));
}).add)

(SynthDef(\monitor, {
	var sig = FoaDecode.ar(In.ar(b, 4), FoaDecoderMatrix.newStereo());
	Out.ar(0, sig);
}).add)

f = BoidsND.new(5, 15, 0.1);

~boids = Array.fill(15, {
	Synth(\ndboid, [\out, b]);
});

r = fork {
	loop {
		f.moveFlock({|flock|
			flock.boids.do {|boid, i|
				var spherical = boid.pos.asCartesian.asSpherical;
				~boids[i].set(\rho, spherical.rho, \theta, spherical.theta, \phi, spherical.phi, \playhead, boid.pos[3].linlin(-500, 500, 0, 1), \binwipe, boid.pos[4].linlin(-500, 500, 0,0.5));
			}
		});
		0.1.wait;
	};
};

y.set(\damp, 0)
y = Synth(\ambiFreeverb, addAction: 'addToTail');
x = Synth(\monitor, [\in, b], addAction: 'addToTail');
x.free

f.visualizer([0,1])
f.visualizer([0,2])
f.visualizer([0,3])
f.visualizer([0,4])

f.addTarget([0,0,0,0,0], 2)
f.editTarget(0, nil, 0.1)
f.centerInstinct = 1
f.innerDistance = 1
f.minSpace = 50
f.bounds
f.wrap = false
f.matchVelocity = 0.1
f.maxVelocity = 150